"
This is the main class for communicating between the user and Glorp. It acts as a broker for reading queries, and as the main point for registering objects for modification.

A note about the distinction between #begin/rollback/commitUnitOfWork and #begin/rollback/commitTransaction is in order. There are two basic scenarios. In the first scenario, you wrap your updates in a UnitOfWork using #beginUnitOfWork, doing the updates, and then #commitUnitOfWork. Method #commitUnitOfWork privately sends #beginTransaction, writes all the data to disk, and then sends #commitTransaction. So, the UnitOfWork itself keeps track of all the updates, and if commited, it sends them on to the database within a private Transaction.

In the second scenario, you control the Transaction, starting with #beginTransaction. If you then wrap your updates inside a UnitOfWork, you get the same behavior as before--the UnitOfWork won't send to disk until you say #commitUnitOfWork. But this time, your UnitOfWork will notice that you have an ongoing Transaction so it sends neither #beginTransaction nor #commitTransaction. Instead, it expects you to send #commitTransaction later. In short, it won't touch the Transaction control since you own it. This scenario can be used to execute a series of operations, each in a separate UnitOfWork, where all can be committed or rolled back downstream.

Of course, a UnitOfWork is optional, likewise a Transaction, but their use is much recommended.

Instance Variables

	system	<DescriptorSystem>	The definition of our tables, classes, and the relationships between them.
	currentUnitOfWork	<UnitOfWork | nil>	If we have an active unit of work, this will hold it. All modifications are tracked through the unit of work.
	cache	<CacheManager>	Our cache of objects that we've already read.
	accessor	<DatabaseAccessor>	Our connection to the database.
	application	<?>	application-specific data
	reaper <TimedProxyReaper> If we are using TimedProxy for some of our relationships, this holds the reaper which will expire them on timeout.
	errorAction <Block> What block should we evaluate when there's an error.
	modificationTracker <GlorpVWWriteBarrierTracker> VisualWorks-specific. This holds the GlorpVWWriteBarrierTracker in use for this session. This uses immutability to keep track of objects which are changed.

"
Class {
	#name : #GlorpSession,
	#superclass : #Object,
	#instVars : [
		'system',
		'currentUnitOfWork',
		'cache',
		'accessor',
		'applicationData',
		'reaper',
		'errorAction',
		'modificationTracker'
	],
	#category : #'Glorp-Core'
}

{ #category : #'instance creation' }
GlorpSession class >> forSystem: aSystem [ 
	^self new system: aSystem
]

{ #category : #'instance creation' }
GlorpSession class >> new [

	^super new initialize.
]

{ #category : #accessing }
GlorpSession >> accessor [
	^accessor
]

{ #category : #accessing }
GlorpSession >> accessor: aDatabaseAccessor [ 
	accessor := aDatabaseAccessor.
	system isNil ifFalse: [system platform: (accessor platform)]
]

{ #category : #accessing }
GlorpSession >> addToReaper: aProxy [

	aProxy class == TimedProxy ifFalse: [^self].
	self reaper add: aProxy
]

{ #category : #accessing }
GlorpSession >> applicationData [
	^applicationData
]

{ #category : #accessing }
GlorpSession >> applicationData: anObject [	
	applicationData := anObject
]

{ #category : #'api/transactions' }
GlorpSession >> beginTransaction [
	"Start a database transaction, to be in sole control of when and whether data is saved to the database."

	accessor beginTransaction.
]

{ #category : #'api/transactions' }
GlorpSession >> beginUnitOfWork [
	"Start a UnitOfWork, to organize your updates."

	self hasUnitOfWork ifTrue: [self error: 'Cannot nest units of work yet'].
	currentUnitOfWork := UnitOfWork new.
	currentUnitOfWork session: self.
]

{ #category : #caching }
GlorpSession >> cacheAt: aKey  forClass: aClass ifNone: failureBlock [

	^cache lookupClass: aClass key: aKey ifAbsent: failureBlock
]

{ #category : #caching }
GlorpSession >> cacheAt: keyObject put: valueObject [ 
	^cache at: keyObject insert: valueObject
]

{ #category : #caching }
GlorpSession >> cacheContainsObject: anObject [
	| descriptor key |
	(descriptor := self descriptorFor: anObject) isNil ifTrue: [^false].
	(key := descriptor primaryKeyFor: anObject) isNil ifTrue: [^false].
	^[self cacheContainsObject: anObject key: key] on: DuplicatePrimaryKeyException do: [:ex | false]
]

{ #category : #caching }
GlorpSession >> cacheContainsObject: anObject key: aKey [ 
	"Just test containment, don't return the result or trigger anything due to expiration"
	aKey isNil ifTrue: [^false].
	^cache
		containsObject: anObject
		key: aKey
]

{ #category : #caching }
GlorpSession >> cacheContainsObjectForClass: aClass key: aKey [ 
	"Just test containment, don't return the result or trigger anything due to expiration"
	aKey isNil ifTrue: [^false].
	^cache
		containsObjectForClass: aClass
		key: aKey
]

{ #category : #caching }
GlorpSession >> cacheContainsObjectForRow: aDatabaseRow [
	^self 
		cacheContainsObjectForClass: aDatabaseRow owner class
		key: aDatabaseRow primaryKey
]

{ #category : #accessing }
GlorpSession >> cacheFor: anObject [
	^cache cacheFor: anObject
]

{ #category : #accessing }
GlorpSession >> cacheForClass: aClass [
	^cache cacheForClass: aClass
]

{ #category : #caching }
GlorpSession >> cacheLookupForClass: aClass key: aKey [ 
	^self 
		cacheAt: aKey
		forClass: aClass
		ifNone: [nil]
]

{ #category : #caching }
GlorpSession >> cacheLookupObjectForRow: aDatabaseRow [
	^self 
		cacheLookupForClass: aDatabaseRow owner class
		key: aDatabaseRow primaryKey
]

{ #category : #caching }
GlorpSession >> cacheRemoveObject: anObject [
	| key |
	key := (self descriptorFor: anObject) primaryKeyFor: anObject.
	cache removeClass: anObject class key: key ifAbsent: []
]

{ #category : #'internal/writing' }
GlorpSession >> commandForHomogeneousRows: aCollectionOfDatabaseRows [
	"Create the command for this set of rows. These are assumed to be homogeneous, in that they are all for the same table, and are all the same type of operation (i.e. all insert or all update)"
	| representativeRow |
	representativeRow := aCollectionOfDatabaseRows first.
	representativeRow forDeletion ifTrue: [self error: 'invalid way of handling deletes (this should never happen)'].
	^(self shouldInsert: representativeRow)
		ifTrue: [InsertCommand forRows: aCollectionOfDatabaseRows useBinding: self useBinding session: self]
		ifFalse: [UpdateCommand forRows: aCollectionOfDatabaseRows useBinding: self useBinding session: self]
]

{ #category : #'internal/writing' }
GlorpSession >> commandForRow: aDatabaseRow [ 
	
	(aDatabaseRow forDeletion) ifTrue: [^DeleteCommand forRow: aDatabaseRow useBinding: self useBinding session: self].
	^(self shouldInsert: aDatabaseRow)
		ifTrue: [^InsertCommand forRow: aDatabaseRow useBinding: self useBinding session: self]
		ifFalse: [^UpdateCommand forRow: aDatabaseRow useBinding: self useBinding session: self]
]

{ #category : #'api/transactions' }
GlorpSession >> commitTransaction [
	"Commit the current database connection transaction."

	accessor commitTransaction.
]

{ #category : #'api/transactions' }
GlorpSession >> commitUnitOfWork [
	"Send updates to the database, in an already-existing Transaction if present, otherwise in a newly-created one. A newly-created Transaction is committed.  An existing Transaction is left for the surrounding code (i.e. that created it) to commit or rollback."

	[self isInTransaction
		ifTrue: [currentUnitOfWork commit]
		ifFalse: [self inTransactionDo: [currentUnitOfWork commit]]] 
	ifCurtailed: [self rollbackUnitOfWork].
	currentUnitOfWork := nil.
]

{ #category : #'api/transactions' }
GlorpSession >> commitUnitOfWorkAndContinue [
	"Commit the current unit of work, but then keep going with the same set of registered objects, with their state updated to reflect current values."
	| registeredObjects |	
	currentUnitOfWork isNil ifTrue: [^self error: 'Not in unit of work'].
	registeredObjects := currentUnitOfWork registeredObjects.
	currentUnitOfWork deletedObjects do: [:each | registeredObjects remove: each].
	self commitUnitOfWork.
	self beginUnitOfWork.
	self registerAll: registeredObjects.
]

{ #category : #copying }
GlorpSession >> copy [

	^self shallowCopy postCopy
]

{ #category : #'api/queries' }
GlorpSession >> count: aClass [
	^self execute: (self queryClass count: aClass)
]

{ #category : #'api/queries' }
GlorpSession >> count: aClass where: anExpression [
	^self execute: (self queryClass count: aClass where: anExpression)
]

{ #category : #'internal/writing' }
GlorpSession >> createDeleteRowsFor: anObject in: rowMap [
	"Create records for rows that require deletion"

	(self descriptorFor: anObject) createDeleteRowsFor: anObject in: rowMap
]

{ #category : #'internal/writing' }
GlorpSession >> createRowsFor: anObject in: rowMap [
	| descriptor |
	(descriptor := self descriptorFor: anObject class) isNil
		ifFalse: [descriptor createRowsFor: anObject in: rowMap]
]

{ #category : #'table creation' }
GlorpSession >> createTables [
	"Create the tables for our descriptor system. This will fail if the tables already exist. Use recreateTables for that."

	self createTables: system allTables.
]

{ #category : #'table creation' }
GlorpSession >> createTables: aCollection [
	"Create the tables for our descriptor system. This will fail if the tables already exist. Use recreateTables for that."

	| sequences |
	system platform areSequencesExplicitlyCreated
		ifTrue:
			[sequences := self system allSequencesFor: aCollection.
			sequences do: [:each | accessor createSequence: each ifError: [:ex | ex signal]]].
	aCollection do: [:each | accessor createTable: each ifError: [:ex | ex signal ]].
	aCollection do: [:each | accessor createTableIndexes: each ifError: [:ex | ex signal]].
	self platform supportsConstraints ifTrue: [aCollection do: [:each | accessor createTableFKConstraints: each ifError: [:ex | ex signal]]]
]

{ #category : #accessing }
GlorpSession >> currentLogin [
	^accessor currentLogin
]

{ #category : #accessing }
GlorpSession >> currentServerUTCTimestampOrNil [
	"This is kind of ugly, but it is Smalltalk Dialect neutral"

	| sqlString result |
	sqlString := [self platform sqlTextCurrentServerUTCTimestamp]
		on: Dialect error
		do:  [:exception | exception return: nil].
	sqlString == nil ifTrue: [^nil].
	result := [self accessor executeSQLString: sqlString]
		on: Dialect error
		do:  [:exception | exception return: nil].
	^result == nil
		ifTrue: [nil]
		ifFalse: 
			[(result first isEmpty or: [(result first first isKindOf: Dialect timestampClass) not])
				ifTrue: [nil]
				ifFalse: [result first first]]
]

{ #category : #accessing }
GlorpSession >> databaseTableClass [

	^system databaseTableClass
]

{ #category : #'api/queries' }
GlorpSession >> delete: anObject [
	| realObject |
	"Get the real object, instantiating if necessary"
	realObject := anObject glorpRealObject.
	self hasUnitOfWork
		ifTrue: [currentUnitOfWork delete: realObject]
		ifFalse:
			[self inUnitOfWorkDo: [
				currentUnitOfWork delete: realObject]]
]

{ #category : #'api/queries' }
GlorpSession >> delete: aClass where: aBlock [
	"Delete all instances in the database satisfying the query block."
	
	"DELETE THEM FROM THE CACHE AS WELL, OR ELSE HAVE VERY LARGE WARNING THAT YOU'RE NOT GOING TO"
	| q |
	q := self queryClass readOneOf: aClass where: aBlock.
	^self deleteAllSatisfying: q.
]

{ #category : #'api/queries' }
GlorpSession >> deleteAll: aCollection [

 	aCollection do: [:each | self delete: each]
]

{ #category : #'api/queries' }
GlorpSession >> deleteAllSatisfying: aQuery [
	^aQuery deleteWithParameters: #() in: self.
]

{ #category : #api }
GlorpSession >> descriptorFor: aClassOrInstance [
	"If the parameter is a class that my DescriptorSystem includes, but its descriptor doesn't exist yet, an initial descriptor for it will be created.  If my DescriptorSystem has neither descriptor nor class, I return nil."

	^system descriptorFor: aClassOrInstance
]

{ #category : #'api/transactions' }
GlorpSession >> doDDLOperation: aBlock [
	"Execute DDL SQL - something which creates/drops/modifies tables or other schema information. The main reason for this method is that some databases require a transaction, while others don't require it, and still others don't allow it. Try to do the right thing."
	
	^self accessor doDDLOperation: aBlock
]

{ #category : #initialize }
GlorpSession >> dontUseModificationTracker [
	modificationTracker release.
	modificationTracker := nil.
]

{ #category : #'table creation' }
GlorpSession >> dropTables [
	"Drop the tables for our descriptor system, and their associated sequences."

	self dropTables: system allTables.
]

{ #category : #'table creation' }
GlorpSession >> dropTables: aCollection [
	"Drop the tables for our descriptor system, and their associated sequences."

	| sequences |
	accessor dropTables: (TableSorter for: aCollection) sort reversed.
	system platform areSequencesExplicitlyCreated
		ifTrue: [ 
			sequences := system allSequencesFor: aCollection.
			accessor dropSequences: sequences ]
]

{ #category : #private }
GlorpSession >> embeddedObjectsFor: anObject [
	"Return all the objects embedded into this one"
	| embedded descriptor |
	descriptor := self descriptorFor: anObject.
	descriptor isNil ifTrue: [^#()].
	embedded := OrderedCollection new: 3.
	descriptor mappings do: [:each |
		(each class == EmbeddedValueOneToOneMapping) ifTrue: [
			embedded add: (each getValueFrom: anObject)]].
	^embedded
]

{ #category : #accessing }
GlorpSession >> errorAction [
	^errorAction
]

{ #category : #accessing }
GlorpSession >> errorAction: aThreeArgumentBlockExceptionSessionCommand [
	errorAction := aThreeArgumentBlockExceptionSessionCommand
]

{ #category : #'api/queries' }
GlorpSession >> execute: aQuery [
	^aQuery executeWithParameters: #() in: self
]

{ #category : #private }
GlorpSession >> expiredInstanceOf: aClass key: key [

	^cache expiredInstanceOf: aClass key: key
]

{ #category : #'read/write' }
GlorpSession >> filterDeletionFrom: anObject [

	self hasUnitOfWork ifFalse: [^anObject].
	currentUnitOfWork shouldFilterDeletions ifFalse: [^anObject].
	(currentUnitOfWork willDelete: anObject)
		ifTrue: [^nil].
	^anObject
]

{ #category : #api }
GlorpSession >> forceSaveOf: anObject [ 
	"This is the same as registering an object, but it tells us to disregard whether/how the object has changed and to save all of its fields. This is useful if we need to register an object after changes have occurred, and can be used to implement something more like an object by object save facility. Still somewhat experimental."
	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^self].
	
	self inUnitOfWorkDo: [currentUnitOfWork registerAsNew: realObject]
]

{ #category : #'read/write' }
GlorpSession >> groupWrite: aCollectionOfDatabaseRows [
	| command |
	aCollectionOfDatabaseRows
		do: [:each | each preWriteAssignSequencesUsing: self].
	command := self commandForHomogeneousRows: aCollectionOfDatabaseRows.
	accessor executeCommand: command.
	^command succeeded
		ifTrue: [true]
		ifFalse:
			[((GlorpWriteFailure new)
				command: command;
				object: (aCollectionOfDatabaseRows collect: [:each | each owner]))
				signal].
]

{ #category : #api }
GlorpSession >> hasDescriptorFor: aClass [
	"This returns false only if my DescriptorSystem has neither the requested descriptor nor the requesting class.  (If the parameter is a class that my DescriptorSystem includes, but its descriptor doesn't exist yet, an initial descriptor for it will be created and true returned.)"

	^system hasDescriptorFor: aClass
]

{ #category : #'api/queries' }
GlorpSession >> hasExpired: anObject [ 
	^cache hasExpired: anObject
]

{ #category : #caching }
GlorpSession >> hasExpired: aClass key: key [
	^cache hasExpired: aClass key: key
]

{ #category : #caching }
GlorpSession >> hasObjectExpiredOfClass: aClass withKey: key [
	^cache hasObjectExpiredOfClass: aClass withKey: key
]

{ #category : #'api/transactions' }
GlorpSession >> hasUnitOfWork [

	^currentUnitOfWork notNil
]

{ #category : #'api/transactions' }
GlorpSession >> inTransactionDo: aBlock [
	"Execute aBlock in a database transaction. If one is already in progress, evaluate aBlock and return. If not, start a transaction, evaluate aBlock and commit or rollback the transaction before returning."

	^self accessor inTransactionDo: aBlock
]

{ #category : #'api/transactions' }
GlorpSession >> inUnitOfWorkDo: aBlock [
	"Evaluate aBlock within a UnitOfWork. This method will only commit or rollback a unit of work that it creates. If there is an ongoing unit of work, the sender must commit or rollback. Likewise, if there is an ongoing transaction, the sender must commit or rollback the transaction. See the class comment for more details."

	| result myUnitOfWork |
	[myUnitOfWork := self hasUnitOfWork not.
	myUnitOfWork ifTrue: [self beginUnitOfWork].
	result := aBlock numArgs = 1 ifTrue: [aBlock value: self] ifFalse: [aBlock value].
	myUnitOfWork ifTrue: [self commitUnitOfWork]]
		ifCurtailed:
			[myUnitOfWork ifTrue: [self rollbackUnitOfWork]].
	^result
]

{ #category : #initialize }
GlorpSession >> initialize [
	
	self initializeCache.
]

{ #category : #initialize }
GlorpSession >> initializeCache [

	cache release.
	cache := CacheManager forSession: self.
]

{ #category : #initialize }
GlorpSession >> initializeReaper [

	self releaseReaper.
	reaper := TimedProxyReaper new.
]

{ #category : #'api/transactions' }
GlorpSession >> isInTransaction [
	^accessor isInTransaction
]

{ #category : #login }
GlorpSession >> isLoggedIn [
	^accessor isLoggedIn
]

{ #category : #testing }
GlorpSession >> isNew: anObject [ 
	"When registering, do we need to add this object to the collection of new objects? New objects are treated specially when computing what needs to be written, since we don't have their previous state"

	| key descriptor |
	(currentUnitOfWork notNil and: [currentUnitOfWork isRegistered: anObject]) ifTrue: [^false].
	descriptor := self descriptorFor: anObject.
	descriptor isNil ifTrue: [^false].
	"For embedded values we assume that they are not new. This appears to work. I can't really justify it."
	self needsWork: 'cross your fingers'.
	descriptor mapsPrimaryKeys ifFalse: [^false].

	key := descriptor primaryKeyFor: anObject.
	key isNil ifTrue: [^true].
	"If the cache contains the object, but the existing entry is due to be deleted, then count this entry as a new one being added with the same primary key (ick) as the old one"
	^[(self cacheContainsObject: anObject key: key) not]
		on: DuplicatePrimaryKeyException
		do: [:ex |
			(currentUnitOfWork notNil and: [currentUnitOfWork willDelete: ex existingObject]) 
				ifTrue: [
					self cacheRemoveObject: ex existingObject.
					ex return: true]
				ifFalse: [ex pass]].
]

{ #category : #caching }
GlorpSession >> isRegistered: anObject [

	currentUnitOfWork isNil ifTrue: [^false].
	^currentUnitOfWork isRegistered: anObject
]

{ #category : #testing }
GlorpSession >> isUninstantiatedProxy: anObject [
	^anObject isGlorpProxy and: [anObject isInstantiated not]
]

{ #category : #login }
GlorpSession >> login [
	self isLoggedIn ifTrue: [^nil].
	^self loginIfError: [:ex | ex pass]
]

{ #category : #login }
GlorpSession >> loginIfError: aBlock [
	| result |
	result := self accessor loginIfError: aBlock.
	system platform characterEncoding: accessor encoding.
	^result
]

{ #category : #login }
GlorpSession >> logout [
	^self accessor logout
]

{ #category : #caching }
GlorpSession >> lookupRootClassFor: aClass [
	| descriptor |
	descriptor := self system descriptorFor: aClass.
	^descriptor notNil
			ifTrue: [ descriptor typeMappingRootDescriptor describedClass ]
			ifFalse: [ aClass ]
]

{ #category : #private }
GlorpSession >> markAsCurrentOfClass: aClass key: key [

	cache markAsCurrentOfClass: aClass key: key
]

{ #category : #'table creation' }
GlorpSession >> migrateFromSystem: from toSystem: to [
	| fromTables toTables toDelete toAdd toModify newVersion |
	fromTables := from allTables copy.
	toTables := to allTables copy.
	toDelete := fromTables reject: [:each | 
		toTables anySatisfy: [:otherTable | otherTable sqlString sameAs: each sqlString]].
	toAdd := toTables reject: [:each | 
		fromTables anySatisfy: [:otherTable | otherTable sqlString sameAs: each sqlString]].
	toModify := fromTables reject: [:each | (toDelete includes: each) or: [toAdd includes: each]].
	self doDDLOperation: [
		self createTables: toAdd.
		self dropTables: toDelete.
		toModify do: [:each | 
			newVersion := to tableNamed: each sqlString.
			self updateTableFrom: each to: newVersion]]
]

{ #category : #'table creation' }
GlorpSession >> migrateFromVersion: fromVersionNumber toVersion: toVersionNumber [ 
	self halt.
	"Get the class name of our system, strip off version number, replace with to and from, create systems for them."
]

{ #category : #accessing }
GlorpSession >> modificationTracker [
	"If we killed off the tracker due to a session reset, then bring it back again."
	modificationTracker == #needed ifTrue: [self useModificationTracker].
	^modificationTracker
]

{ #category : #accessing }
GlorpSession >> modificationTracker: aGlorpModificationTrackingPolicy [
	modificationTracker := aGlorpModificationTrackingPolicy
]

{ #category : #'api/transactions' }
GlorpSession >> modify: anObject in: aBlock [
	"Evaluate aBlock inside a unit of work. Start a database transaction at the beginning and commit it at the end. If we don't terminate normally, roll everything back. Register anObject before starting. Explicitly circumvent the registration of  the block result at the end, because that can cause problems if we're doing things like delete and re-insert and end up returning e.g. the deleted object"
	| result |
	self transact: [
		self register: anObject.
		result := aBlock value.
		nil].
	^result
]

{ #category : #accessing }
GlorpSession >> platform [
	^self system platform
]

{ #category : #copying }
GlorpSession >> postCopy [

	super postCopy.
	self initializeCache.
	currentUnitOfWork := nil.
	accessor := accessor copy.
]

{ #category : #private }
GlorpSession >> privateGetCache [

	^cache
]

{ #category : #private }
GlorpSession >> privateGetCurrentUnitOfWork [

	^currentUnitOfWork
]

{ #category : #private }
GlorpSession >> privateRegisterAsNew: anObject [ 
	"Register the object as one which is not already in cache. Private! Normally just use the register: operation."
	currentUnitOfWork isNil ifTrue: [^self].
	currentUnitOfWork registerAsNew: anObject
]

{ #category : #private }
GlorpSession >> privateRegisterAsOld: anObject [ 
	"Register the object as something we already read from the database, skipping the isNew: test. Private! Normally you would just use register:"
	| realObject |
	currentUnitOfWork isNil ifTrue: [^self].
	realObject := self realObjectFor: anObject ifNone: [^self].

	currentUnitOfWork register: realObject
]

{ #category : #'api/queries' }
GlorpSession >> queryClass [ 
	^system queryClass
]

{ #category : #'api/queries' }
GlorpSession >> read: aClass [
	"Return an array of instances of aClass, each one from a row of its corresponding database table."

	^self execute: (self queryClass read: aClass)
]

{ #category : #'api/queries' }
GlorpSession >> read: aClass limit: anInteger [
	"Return an array of not more than anInteger of instances of aClass, each one from a row of its corresponding database table."

	^self execute: (self queryClass read: aClass limit: anInteger)
]

{ #category : #'api/queries' }
GlorpSession >> read: aClass orderBy: aCriteria [
	"aCriteria can be a block, such as [:each | each id], or a symbol (that Glorp can translate into such a block), such as #id."

	| query |
	query := self queryClass read: aClass.
	query orderBy: aCriteria.
	^self execute: query
]

{ #category : #'api/queries' }
GlorpSession >> read: aClass where: aBlock [
	"aBlock should return a boolean, for example, [:each | each lastname = 'Doe']."

	^self execute: (self queryClass read: aClass where: aBlock)
]

{ #category : #'api/queries' }
GlorpSession >> read: aClass where: aBlock limit: anInteger [
	"Return an array of up to anInteger instances of aClass for which aBlock returns true, each from a row from its table."

	^self execute:
		(self queryClass
			read: aClass
			where: aBlock
			limit: anInteger)
]

{ #category : #'api/queries' }
GlorpSession >> readManyOf: aClass [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read: instead'.
	^self read: aClass
]

{ #category : #'api/queries' }
GlorpSession >> readManyOf: aClass limit: anInteger [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read: instead'.
	^self read: aClass limit: anInteger
]

{ #category : #'api/queries' }
GlorpSession >> readManyOf: aClass orderBy: aCriteria [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:orderBy: instead'.
	^self read: aClass orderBy: aCriteria
]

{ #category : #'api/queries' }
GlorpSession >> readManyOf: aClass where: aBlock [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'.
	^self read: aClass where: aBlock
]

{ #category : #'api/queries' }
GlorpSession >> readManyOf: aClass where: aBlock limit: anInteger [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where:limit: instead'.
	^self read: aClass where: aBlock limit: anInteger
]

{ #category : #'api/queries' }
GlorpSession >> readOneOf: aClass [
	"Return a single instance of aClass from a row of its table."

	^self execute: (self queryClass readOneOf: aClass)
]

{ #category : #'api/queries' }
GlorpSession >> readOneOf: aClass where: aBlock [
	"aBlock should return a boolean, for example, [:each | each title='Report']."

	^self execute: (self queryClass readOneOf: aClass where: aBlock)
]

{ #category : #private }
GlorpSession >> realObjectFor: anObject [ 
	"If this is a proxy, return the contents (if available). Otherwise, return nil"
	
	^self realObjectFor: anObject ifNone: [nil]
]

{ #category : #private }
GlorpSession >> realObjectFor: anObject ifNone: aBlock [
	"If this is a proxy, return the contents (if available). Otherwise, evalute the block"
	^anObject isGlorpProxy 
		ifTrue: [anObject isInstantiated ifTrue: [anObject getValue] ifFalse: [aBlock value]]
		ifFalse: [anObject]
]

{ #category : #accessing }
GlorpSession >> reaper [

	reaper isNil ifTrue: [self initializeReaper].
	^reaper.
]

{ #category : #'table creation' }
GlorpSession >> recreateTables [
	"Drop and re-create the tables for our descriptor system, and their associated sequences."

	self recreateTables: system allTables.
]

{ #category : #'table creation' }
GlorpSession >> recreateTables: aCollection [
	"Drop the tables for our descriptor system, and their associated sequences."

	| sequences |
	accessor dropTables: (TableSorter for: aCollection) sort reverse.
	system platform areSequencesExplicitlyCreated
		ifTrue:
			[
			sequences := self system allSequencesFor: aCollection.
			accessor dropSequences: sequences.
			sequences
				do: [:each | accessor createSequence: each ifError: [:ex | self halt]]].
	aCollection do: [:each | accessor createTable: each ifError: [:ex | self halt]].
	aCollection do: [:each | accessor createTableIndexes: each ifError: [:ex | self halt]].
	self platform supportsConstraints ifTrue: [aCollection do: [:each | accessor createTableFKConstraints: each ifError: [:ex | self halt]]]
]

{ #category : #'table creation' }
GlorpSession >> recreateTables: aCollection ifError: aBlock [
	"Drop the tables for our descriptor system, and their associated sequences."

	(TableSorter for: aCollection) sort reverse
		do: [ :table | accessor dropTable: table ifError: [ :ex | ex "so we can insert a breakpoint"] ].

	system platform areSequencesExplicitlyCreated
		ifTrue: [(self system allSequencesFor: aCollection)
					do: [:each | 
						accessor dropSequence: each ifAbsent: [:ex | ex "so we can insert a breakpoint" ].
						accessor createSequence: each ifError: [:ex | ^aBlock value: ex ]]].

	aCollection do: [:each | accessor createTable: each ifError: [:ex | ^aBlock value: ex]].
	aCollection do: [:each | accessor createTableIndexes: each ifError: [:ex | ^aBlock value: ex ]].
	self platform supportsConstraints ifTrue: [aCollection do: [:each | accessor createTableFKConstraints: each ifError: [:ex | ^aBlock value: ex]]]
]

{ #category : #'table creation' }
GlorpSession >> recreateTablesIfError: aBlock [
	"Drop and re-create the tables for our descriptor system, and their associated sequences."

	self recreateTables: system allTables ifError: aBlock 
]

{ #category : #'api/queries' }
GlorpSession >> refresh: anObject [
	"Reload anObject from the corresponding row of its table. Return the refreshed instance."

	| exp query realObject descriptor |
	realObject := self realObjectFor: anObject ifNone: [^self].
	descriptor := self descriptorFor: realObject.
	descriptor isNil
		ifTrue: [self error: 'Cannot refresh an object with no descriptor'].
	exp := descriptor
				primaryKeyExpressionFor: realObject
				basedOn: (BaseExpression new  descriptor: (self descriptorFor: realObject class))
				relation: #=.
	query := self queryClass readOneOf: realObject class where: exp.
	query shouldRefresh: true.
	^self execute: query
]

{ #category : #api }
GlorpSession >> register: anObject [
	"Register the object with our current unit of work. We need to do this *before* making changes to the object.  (If an object is read from the database, changed and then registered, and later written back to the database, the pre-registration change may be lost.)"

	| realObject |
	currentUnitOfWork isNil ifTrue: [^self].
	realObject := self realObjectFor: anObject ifNone: [^self].

	(self isNew: realObject) 
		ifTrue: [currentUnitOfWork registerAsNew: realObject]
		ifFalse: [currentUnitOfWork register: realObject].
]

{ #category : #api }
GlorpSession >> registerAll: aCollection [
	aCollection do: [:ea | self register: ea]
]

{ #category : #api }
GlorpSession >> registerForDelete: anObject [ 
	"Register the object with our current unit of work, with intent to delete it."
	| realObject |
	currentUnitOfWork isNil ifTrue: [^self].
	realObject := self realObjectFor: anObject ifNone: [^self].

	currentUnitOfWork registerForDelete: realObject
]

{ #category : #initialize }
GlorpSession >> releaseReaper [

	reaper release.
]

{ #category : #'api/transactions' }
GlorpSession >> requireUnitOfWork [
	"Start a unit of work if there isn't one already."
	self hasUnitOfWork ifFalse: [self beginUnitOfWork].
]

{ #category : #initialize }
GlorpSession >> reset [
	self initializeCache.
	self releaseReaper.
	accessor reset.
	currentUnitOfWork := nil.
	modificationTracker release.
	modificationTracker isNil ifFalse: [modificationTracker := #needed].
]

{ #category : #initialize }
GlorpSession >> resetPermissions [
	accessor isNil ifFalse: [accessor resetPermissions].
]

{ #category : #testing }
GlorpSession >> reusePreparedStatements [
	^accessor reusePreparedStatements
]

{ #category : #accessing }
GlorpSession >> reusePreparedStatements: aBoolean [
	accessor reusePreparedStatements: aBoolean
]

{ #category : #'api/transactions' }
GlorpSession >> rollbackTransaction [
	"Rollback the current database connection transaction."

	accessor execute: [accessor rollbackTransaction].
]

{ #category : #'api/transactions' }
GlorpSession >> rollbackUnitOfWork [

	currentUnitOfWork isNil ifTrue: [^self].
	currentUnitOfWork abort.
	currentUnitOfWork := nil.
]

{ #category : #'api/transactions' }
GlorpSession >> rollbackUnitOfWorkFor: anObject [
	currentUnitOfWork abort: anObject
]

{ #category : #'api/transactions' }
GlorpSession >> save: anObject [ 
	"Make sure anObject will be written to the database by starting a unit of work if we aren't already in one, and registering the object. This is in most ways the same as just registering an object, but it tells us to disregard whether/how the object has changed and to save all of its fields. This is useful if we need to register an object *after* changes have occurred, and can be used to implement something more like an object by object save facility. Still somewhat experimental."
	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^self].
	
	self hasUnitOfWork
		ifTrue:	[currentUnitOfWork registerAsNew: realObject]
		ifFalse:
			[self inUnitOfWorkDo: [
				currentUnitOfWork registerAsNew: realObject]]
]

{ #category : #'api/transactions' }
GlorpSession >> saveAndContinue [
	"A shorter synonym"
	^self commitUnitOfWorkAndContinue
]

{ #category : #accessing }
GlorpSession >> schema [

	^ self accessor schema
]

{ #category : #events }
GlorpSession >> sendPostFetchEventTo: anObject [
	^anObject glorpPostFetch: self
]

{ #category : #events }
GlorpSession >> sendPostFetchValidateEventTo: anObject [
	^anObject glorpPostFetchValidate: self
]

{ #category : #events }
GlorpSession >> sendPostWriteEventTo: anObject [
	anObject glorpPostWrite: self
]

{ #category : #events }
GlorpSession >> sendPreWriteEventTo: anObject [
	anObject glorpPreWrite: self
]

{ #category : #'internal/writing' }
GlorpSession >> shouldInsert: aDatabaseRow [

	"We may have forced this to explicitly be an update"
	| isMappedObjectRow |
	(currentUnitOfWork notNil and: [currentUnitOfWork forcesUpdateFor: aDatabaseRow]) ifTrue: [^false].

	"If this is for a mapped object, so not a link table, then we are an insert if there is no corresponding row in the cache that we read from the database, and an update if there is such a row." 
	isMappedObjectRow := (RowMap new isRowMapKey: aDatabaseRow owner) not.
	isMappedObjectRow ifTrue: [
		^(self cacheContainsObjectForRow: aDatabaseRow) not].

	"This is a link table row. If the relationship existed before registration, then this will have an old version and we should update it. If there's no old version, then it's an insert."

	^aDatabaseRow hasOldVersion not
]

{ #category : #initialize }
GlorpSession >> shouldUseModificationTracker: aBoolean [
	aBoolean
		ifTrue: [modificationTracker isNil ifTrue: [self useModificationTracker]]
		ifFalse: [modificationTracker := nil].
]

{ #category : #accessing }
GlorpSession >> system [
	^system
]

{ #category : #api }
GlorpSession >> system: aDescriptorSystem [
	"Why the on:do:? Because when loading over an old version, the method 
	#validateDescriptorSystem may not yet be in the system, so we send it carefully"

	aDescriptorSystem session: self.
	accessor isNil ifFalse: [aDescriptorSystem platform: accessor currentLogin database].
	system := aDescriptorSystem.
	([system validateDescriptorSystem]
		on: Error
		do: [:exception | exception return: true])
			ifTrue: [system validate]
			ifFalse: [system initializeRuntimeMappings]
]

{ #category : #'internal/writing' }
GlorpSession >> tablesInCommitOrder [

	^system tablesInCommitOrder.
]

{ #category : #'api/transactions' }
GlorpSession >> transact: aBlock [
	"Evaluate aBlock inside a transaction and inside a unit of work. This could be called inUnitOfWorkInsideTransactionDo: (but that's too verbose) because we start both a transaction and/or a unit of work if we are not in either or both already.  We commit or rollback only what we started. Otherwise, the sender controls commit/rollback. (Comparing this method with #inUnitOfWorkDo:, in the latter, if there is not already an ongoing transaction a transaction will not get started until the UnitOfWork commits.)"

	| alreadyInTransaction alreadyInUnitOfWork result |
	[[alreadyInUnitOfWork := false.
	alreadyInTransaction := self isInTransaction.
	alreadyInTransaction ifFalse: [self beginTransaction].
	alreadyInUnitOfWork := self hasUnitOfWork.
	alreadyInUnitOfWork ifFalse: [self beginUnitOfWork].
	result := aBlock numArgs = 1 ifTrue: [aBlock value: self] ifFalse: [aBlock value].
	self register: result.
	alreadyInUnitOfWork ifFalse: [self commitUnitOfWork].
	alreadyInTransaction ifFalse: [self commitTransaction]]
		ifCurtailed: [alreadyInUnitOfWork ifFalse: [self rollbackUnitOfWork]]]
			ifCurtailed: [alreadyInTransaction ifFalse: [self rollbackTransaction]].
	^result
]

{ #category : #'api/queries' }
GlorpSession >> undelete: anObject [
	self undelete: anObject ifNotDeleted: [self error: 'Trying to undelete something that was not deleted'].
]

{ #category : #'api/queries' }
GlorpSession >> undelete: anObject ifNotDeleted: aBlock [
	| realObject |
	"Get the real object, instantiating if necessary"
	realObject := anObject glorpRealObject.
	self hasUnitOfWork
		ifTrue: [currentUnitOfWork undelete: realObject ifNotDeleted: aBlock]
		ifFalse:
			[self error: 'Can only undelete while the unit of work is in progress'].
]

{ #category : #'table creation' }
GlorpSession >> updateTableFrom: aTable to: newTable [
	"Update the given table based on the metadata."
	
	| newFields deletedFields modifiedFields newFKConstraints deletedFKConstraints newUniqueConstraints deletedUniqueConstraints |
	newFKConstraints := newTable foreignKeyConstraints reject: 
		[:each | aTable hasForeignKeyConstraintMatching: each].
	deletedFKConstraints := aTable foreignKeyConstraints reject: 
		[:each | newTable hasForeignKeyConstraintMatching: each].
	newUniqueConstraints := newTable uniqueConstraints reject: 
		[:each | aTable hasUniqueConstraintMatching: each].
	deletedUniqueConstraints := aTable uniqueConstraints reject: 
		[:each | newTable hasUniqueConstraintMatching: each].
	"So far, we just handle adding and deleting fields, not changing them."
	newFields := newTable fields reject: 
		[:each | aTable hasFieldNamed: each name].
	deletedFields := aTable fields reject: 
		[:each | newTable hasFieldNamed: each name].
	modifiedFields := newTable fields reject: 
		[:each | newFields includes: each].
	modifiedFields := modifiedFields reject: 
		[:each | (aTable fieldNamed: each name) isTheSameAs: each].	
	"Cheap version, for modified fields, drop and re-add them."
	newFields addAll: modifiedFields.
	deletedFields addAll: modifiedFields.
	deletedFKConstraints do: [:each | accessor dropConstraint: each].
	deletedUniqueConstraints do: [:each | accessor dropConstraint: each].
	accessor dropFields: deletedFields.
	accessor addFields: newFields.
	newFKConstraints do: [:each | accessor addConstraint: each].
	newUniqueConstraints do: [:each | accessor addConstraint: each]
]

{ #category : #testing }
GlorpSession >> useBinding [
	self accessor isNil ifTrue: [^false].
	^self accessor useBinding.
]

{ #category : #'initialize-release' }
GlorpSession >> useModificationTracker [

	^self
]

{ #category : #'virtual collections' }
GlorpSession >> virtualCollectionOf: aClass [
	^GlorpVirtualCollection on: aClass in: self.
]

{ #category : #'read/write' }
GlorpSession >> writeHomogeneousRows: aCollectionOfDatabaseRows [
	"Write out a collection of rows belonging to a single table"

	| representativeRow succeeded maximumSize start |

	aCollectionOfDatabaseRows isEmpty ifTrue: [^true].
	representativeRow := aCollectionOfDatabaseRows first.
	representativeRow shouldBeWritten ifFalse: [^true].
	succeeded := true.
	maximumSize := self system maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows.
	start := 1.
	[start > aCollectionOfDatabaseRows size] whileFalse: [
		| end |
		end := (start + maximumSize - 1) min: aCollectionOfDatabaseRows size.
		succeeded := succeeded
			& (self writeHomogeneousRows: aCollectionOfDatabaseRows from: start to: end).
		start := end + 1].
	^succeeded.
]

{ #category : #'read/write' }
GlorpSession >> writeHomogeneousRows: aCollectionOfDatabaseRows from: startIndex to: endIndex [
	"Write out the specified range from a collection of rows belonging to a single table"

	| succeeded |
	succeeded := true.
	^(self system 	
			canUseGroupedWritesFor: (aCollectionOfDatabaseRows at: startIndex) table)
		ifTrue: [self groupWrite: (aCollectionOfDatabaseRows copyFrom: startIndex to: endIndex)]
		ifFalse:
			[startIndex to: endIndex do: [:i |
				 |eachRow rowSucceeded |
				eachRow := aCollectionOfDatabaseRows at: i.
				rowSucceeded := self writeRow: eachRow.
				succeeded := succeeded & rowSucceeded].
			succeeded].
]

{ #category : #'read/write' }
GlorpSession >> writeRow: aDatabaseRow [
	| command success |
	aDatabaseRow shouldBeWritten ifFalse: [^true].
	aDatabaseRow preWriteAssignSequencesUsing: self.
	command := self commandForRow: aDatabaseRow.
	accessor executeCommand: command.
	success := true.
	command succeeded
		ifFalse:
			[success := (GlorpWriteFailure new)
				command: command;
				object: (Array with: aDatabaseRow owner);
				signal].
	^success.
]
