"
This holds onto the Glorp metadata. Each session will have a DescriptorSystem associated with it, which describes the tables, descriptors, and class models that are to be made persistent.

Subclasses must implement the following messages:
	accessing
		allTableNames
		constructAllClasses

Instance Variables:
	allClasses	<Collection of: Behavior>	The classes we have metadata for.
	cachePolicy	<CachePolicy>	The default cache policy to use. Descriptors can override this.
	classModels	<Dictionary from: Behavior to: GlorpClassModel>	Our class models, indexed by class.
	descriptors	<Dictionary from: Behavior to: Descriptor>	Our descriptors, indexed by class.
	platform	<DatabasePlatform>	The platform for which we will be used. This is required because the table definitions will refer to the platform in order to get the appropriate types for fields.
	sequences	<Dictionary from: String to: DatabaseSequence>	The sequences that we have available, indexed by name asUppercase.
	session	<GlorpSession>	The session we provide metadata to.
	tables	<Dictionary from: String to: DatabaseTable>	Our database tables, indexed by name asUppercase.
	typeResolvers	<Dictionary from: Behavior to: TypeResolver>	The type resolvers that we will use for inheritance, indexed by class.
	useDirectAccessForMapping	<Boolean>	By default, should we use direct instance variable access (instVarAt:) or send get/set messages. Individual attributes can override this.
	useJoinsForAnySatisfy	<Boolean>	By default, should we use joins for anySatisfy and similar queries, or should we use EXISTS subselects.


"
Class {
	#name : #DescriptorSystem,
	#superclass : #Object,
	#instVars : [
		'session',
		'platform',
		'descriptors',
		'tables',
		'sequences',
		'typeResolvers',
		'cachePolicy',
		'allClasses',
		'useDirectAccessForMapping',
		'classModels',
		'useJoinsForAnySatisfy',
		'queryClass'
	],
	#classInstVars : [
		'validateDescriptorSystem'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #utilities }
DescriptorSystem class >> createTablesFor: aLogin [
	"Create the tables for this descriptor system in the given database. This will fail if the tables already exist. Use recreateTables for that."

	| session |
	session := self sessionForLogin: aLogin.
	session login.
	[ session createTables ] ensure: [ session logout ]
]

{ #category : #configuration }
DescriptorSystem class >> databaseTableClass [

	^ DatabaseTable
]

{ #category : #validation }
DescriptorSystem class >> defaultValidateValue [
	"Subclasses can define this not answer #always, and to set it to be things like #firstTime, #never, etc."

	^ #always
]

{ #category : #utilities }
DescriptorSystem class >> dropTablesFor: aLogin [
	"Drop the tables for this descriptor system in the given database."

	| session |
	session := self sessionForLogin: aLogin.
	session login.
	[ session dropTables ] ensure: [ session logout ]
]

{ #category : #'instance creation' }
DescriptorSystem class >> forPlatform: dbPlatform [

	^ super new
		  initialize;
		  platform: dbPlatform
]

{ #category : #configuration }
DescriptorSystem class >> includeAllClassesWithDescriptorMethods [
	"If this is true, the descriptor system will automatically include all classes that define the #glorpSetupDescriptor:forSystem: method on the class side. If false, it will only include classes which have descriptor methods defined in this class, or those explicitly added in the #constructAllClasses method."

	^ false
]

{ #category : #'instance creation' }
DescriptorSystem class >> new [

	^ super new initialize
]

{ #category : #utilities }
DescriptorSystem class >> recreateTablesFor: aLogin [
	"Drop and recreate the tables for this descriptor system in the given database."

	| session |
	session := self sessionForLogin: aLogin.
	session login.
	[ session recreateTables ] ensure: [ session logout ]
]

{ #category : #'instance creation' }
DescriptorSystem class >> sessionForAccessor: aDatabaseAccesor [.
	"Create a session associated with the given accessor, and using us as a descriptor system. 
	This is the easiest way to get a full blown session going."
	
	^ (GlorpSession forSystem: (self forPlatform: aDatabaseAccesor platform))
		accessor: aDatabaseAccesor;
		yourself

]

{ #category : #'instance creation' }
DescriptorSystem class >> sessionForLogin: aGlorpLogin [
	"Create a session associated with the given login, and using us as a descriptor system. This is the easiest way to get a full blown session going."

	| system session |
	system := self forPlatform: aGlorpLogin database.
	session := GlorpSession new.
	session accessor: (DatabaseAccessor forLogin: aGlorpLogin).
	session system: system.
	^session
]

{ #category : #validation }
DescriptorSystem class >> validateDescriptorSystem [
	"Subclasses can define this to do other things, and add their own behavior to do things like only first time, never, etc."

	validateDescriptorSystem isNil ifTrue: [
		self validateDescriptorSystem: self defaultValidateValue ].
	^ validateDescriptorSystem == #always
]

{ #category : #validation }
DescriptorSystem class >> validateDescriptorSystem: aSymbol [
	"Typical values are #always and #never"

	validateDescriptorSystem := aSymbol
]

{ #category : #api }
DescriptorSystem >> addClassModelFor: aClass [

	^ classModels
		  at: aClass
		  ifAbsentPut: [ self newClassModelFor: aClass ]
]

{ #category : #'initialize-release' }
DescriptorSystem >> addClassesFromDescriptorMethodsFor: aClass [

	| match |
	match := 'descriptorFor'.
	Dialect selectorsFor: aClass do:
			[:each |
			(each copyFrom: 1 to: (match size min: each size)) = match
				ifTrue:
					[| className actualClass |
					className := each copyFrom: match size + 1 to: each size - 1.
					actualClass := Dialect
						lookupClassNamed: className
						inContextOf: self class
						ifAbsent: [nil].
					actualClass isNil ifFalse: [allClasses add: actualClass]]]
]

{ #category : #'initialize-release' }
DescriptorSystem >> addTablesFromInitializeMethodsFor: aClass [

	| match |
	match := 'tableFor'.
	Dialect selectorsFor: aClass do: [ :each |
		(each copyFrom: 1 to: (match size min: each size)) = match ifTrue: [
			| tableName |
			tableName := each copyFrom: match size + 1 to: each size - 1.
			self tableNamed: tableName ] ]
]

{ #category : #callbacks }
DescriptorSystem >> additionalRelatedRowsFor: aRow in: aRowMap [
	"This method serves as a hook. It is called when sorting rows before writing to the database, and can be used to return a list of additional related rows that aren't found by the normal foreign key constraints. These rows will act as an ordering constraint, and will have to be written before aRow."

	^ nil
]

{ #category : #accessing }
DescriptorSystem >> allClassModels [
	^self allClasses collect: [:each |
		self classModelFor: each]
]

{ #category : #accessing }
DescriptorSystem >> allClasses [

	allClasses isEmpty ifTrue: [ allClasses := self constructAllClasses ].
	^ allClasses
]

{ #category : #accessing }
DescriptorSystem >> allDescriptors [

	^ self allClasses collect: [ :each | self descriptorFor: each ]
]

{ #category : #accessing }
DescriptorSystem >> allSequences [

	sequences isEmpty ifFalse: [ ^ sequences ].
	sequences := self allSequencesFor: self allTables.
	^ sequences
]

{ #category : #accessing }
DescriptorSystem >> allSequencesFor: aCollection [
	"Find all the sequences associated with aCollectionOfTables"

	| result |
	result := Dictionary new.
	aCollection do: [ :each |
		each allSequences keysAndValuesDo: [ :eachName :eachSequence |
			result at: eachName put: eachSequence ] ].
	^ result
]

{ #category : #accessing }
DescriptorSystem >> allTableNames [
	"Return a list of all the table names that this system uses."

	^ #(  )
]

{ #category : #accessing }
DescriptorSystem >> allTables [

	tables isEmpty ifTrue: [ self constructAllTables ].
	^ tables
]

{ #category : #accessing }
DescriptorSystem >> cachePolicy [
	"Return the default cache policy that will be used for descriptors that don't specify their own policy"

	cachePolicy isNil ifTrue: [ cachePolicy := CachePolicy default ].
	^ cachePolicy
]

{ #category : #accessing }
DescriptorSystem >> cachePolicy: aCachePolicy [

	cachePolicy := aCachePolicy
]

{ #category : #testing }
DescriptorSystem >> canUseGroupedWrites [
	"We can use grouped writes as long as there are no identity columns in use"

	self platform usesIdentityColumns ifFalse: [ ^ true ].
	^ (self allTables anySatisfy: [ :each |
		   each primaryKeyFields anySatisfy: [ :eachField |
			   eachField type isSerial and: [
				   eachField type sequence isIdentityColumn ] ] ]) not
]

{ #category : #testing }
DescriptorSystem >> canUseGroupedWritesFor: aTable [
	"We can use grouped writes as long as there are no identity columns in use"

	self platform usesIdentityColumns ifFalse: [ ^ true ].
	^ (aTable primaryKeyFields anySatisfy: [ :eachField |
		   eachField type isSerial and: [
			   eachField type sequence isIdentityColumn ] ]) not
]

{ #category : #api }
DescriptorSystem >> classModelFor: aClass [
	(self allClasses includes: aClass) ifFalse: [^nil].
	^classModels
		at: aClass
		ifAbsentPut: [self newClassModelFor: aClass]
]

{ #category : #initialization }
DescriptorSystem >> constructAllClasses [
	"Subclasses can override this method to add classes. But by default we also look for all descriptor methods in our system, and add them to the class list, so if the methods are written there, then we don't need to do anything further. If the descriptor methods are defined on the classes themselves, then we'll still have to construct the class list manually."

	self constructClassesFromDescriptorMethods.
	^allClasses.
]

{ #category : #initialization }
DescriptorSystem >> constructAllTables [
	"Subclasses can override this method to add tables to the list. But by default we also look for all table methods in our system, and add them to the class list, so if the methods are written there, then we don't need to do anything further. If the table methods are defined on the classes themselves, then we'll still have to construct the list manually."
	self allTableNames do: [:each | 
		self tableNamed: each asString].
	self constructTablesFromInitializeMethods.
	^tables.
]

{ #category : #initialization }
DescriptorSystem >> constructClassesFromDescriptorMethods [
	self withAllSuperclassesDo: [:aClass | self addClassesFromDescriptorMethodsFor: aClass].

	self class includeAllClassesWithDescriptorMethods
		ifTrue:
			[Object withAllSubclasses
				do:
					[:each | 
					(each class
						compiledMethodAt: #glorpSetupDescriptor:forSystem:
						ifAbsent: [nil]) isNil ifFalse: [allClasses add: each]]].
]

{ #category : #initialization }
DescriptorSystem >> constructTablesFromInitializeMethods [
	self withAllSuperclassesDo: [:aClass | self addTablesFromInitializeMethodsFor: aClass].
]

{ #category : #private }
DescriptorSystem >> converterBetweenStType: aClass andField: aField [ 
	| selector |
	selector := ('converterBetween' , aClass name , 'AndField:') asSymbol.
	(self respondsTo: selector) ifTrue: [^self perform: selector with: aField].
	^aField converterForStType: aClass
]

{ #category : #private }
DescriptorSystem >> createMappingIn: aDescriptor fromClassModelForAttributeNamed: aSymbol [ 
	| attribute referenceModel |
	attribute := aDescriptor classModel attributeNamed: aSymbol.
	referenceModel := self classModelFor: attribute type.
	referenceModel isNil 
		ifTrue: 
			[^(aDescriptor newMapping: DirectMapping) from: aSymbol
				to: (aDescriptor table 
						fieldNamed: (self fieldNameForAttributeName: aSymbol))]
		ifFalse: 
			[attribute isCollectionAttribute 
				ifTrue: [^(aDescriptor newMapping: ToManyMapping) attributeName: aSymbol]
				ifFalse: [^(aDescriptor newMapping: OneToOneMapping) attributeName: aSymbol]]
]

{ #category : #api }
DescriptorSystem >> createMappingsFromClassModelIn: aDescriptor [ 
	aDescriptor classModel attributesDo: 
			[:each | 
			(aDescriptor mappingForAttributeNamed: each name) isNil 
				ifTrue: 
					[self createMappingIn: aDescriptor
						fromClassModelForAttributeNamed: each name]]
]

{ #category : #api }
DescriptorSystem >> databaseIdentitySequenceNamed: aString [

	^self databaseSequenceNamed: aString
]

{ #category : #accessing }
DescriptorSystem >> databaseSchema [
	"See deferentialSetSchema: for states in which this will DNU."

	^self session schema
]

{ #category : #api }
DescriptorSystem >> databaseSequenceNamed: aString [

	^sequences at: aString asUppercase ifAbsentPut: [platform newDatabaseSequenceNamed: aString].
]

{ #category : #api }
DescriptorSystem >> databaseSequenceNamed: aString ifAbsentPut: aBlock [

	^sequences at: aString asUppercase ifAbsentPut: aBlock
]

{ #category : #api }
DescriptorSystem >> databaseTableClass [

	^self class databaseTableClass
]

{ #category : #accessing }
DescriptorSystem >> defaultTracing [

	^Tracing new
]

{ #category : #private }
DescriptorSystem >> deferentialSetSchema: newTable [
	"If the table already has a schema, do not overwrite it.  Avoiding an ill-constructed login setting a schema to nil.  (DatabaseTable initializes schema to the empty string, not nil, although its code allows for nil schemas so making this convenient rather than essential)."

	| temp |
	newTable schema isEmpty ifFalse: [^self].
	(temp := self session) isNil ifTrue: [^self].
	(temp := temp accessor) isNil ifTrue: [^self].
	(temp := temp currentLogin) isNil ifTrue: [^self].
	(temp := temp schema) isNil ifTrue: [^self].
	newTable schema: temp.
]

{ #category : #api }
DescriptorSystem >> descriptorFor: aClassOrObject [ 
	| theClass newDescriptor |
	aClassOrObject == Proxy ifTrue: [self error: 'Cannot find descriptor for the class Proxy. Pass in the instance'].
	theClass := aClassOrObject glorpCanHaveDescriptorDirectly 
				ifTrue: [aClassOrObject]
				ifFalse: [aClassOrObject isGlorpProxy 
							ifTrue: [aClassOrObject getValue class]
							ifFalse: [aClassOrObject class]].
	^descriptors
		at: theClass
		ifAbsent: [
			(self allClasses includes: theClass) ifTrue: [
				newDescriptor := self newDescriptorFor: theClass.
				descriptors at: theClass put: newDescriptor.
				self initializeDescriptor: newDescriptor.
				newDescriptor.
			]]
]

{ #category : #api }
DescriptorSystem >> descriptorForTable: aTable [
	"Return a descriptor that uses aTable. If there is more than one, the choice is random."
	^descriptors detect: [:each | each tables includes: aTable] ifNone: [nil]
]

{ #category : #api }
DescriptorSystem >> descriptorsForTable: aTable [
	"Return all descriptors that use aTable."
	^descriptors select: [:each | each tables includes: aTable]
]

{ #category : #api }
DescriptorSystem >> existingTableNamed: aString [

	^tables at: aString asUppercase ifAbsent: [self error: 'missing table']
]

{ #category : #callbacks }
DescriptorSystem >> fieldNameForAttributeName: aSymbol [ 
	^aSymbol asString asUppercase
]

{ #category : #api }
DescriptorSystem >> findDescriptorForTable: aTable [
	"Return a descriptor that uses aTable. If there is more than one, the choice is random."

	^descriptors detect: [:each | each tables includes: aTable] ifNone: [nil].
]

{ #category : #api }
DescriptorSystem >> findDescriptorsForTable: aTable [
	"Return all descriptors that use aTable."

	^descriptors select: [:each | each tables includes: aTable].
]

{ #category : #api }
DescriptorSystem >> flushAllClasses [
	allClasses := OrderedCollection new
]

{ #category : #api }
DescriptorSystem >> hasDescriptorFor: aClassOrObject [ 

	^(self descriptorFor: aClassOrObject) notNil
]

{ #category : #initialization }
DescriptorSystem >> initialize [
	descriptors := Dictionary new.
	tables := Dictionary new.
	classModels := Dictionary new.
	typeResolvers := Dictionary new.
	sequences := Dictionary new.
	useDirectAccessForMapping := true.
	allClasses := OrderedCollection new.
	queryClass := SimpleQuery
]

{ #category : #private }
DescriptorSystem >> initializeClassModel: aClassModel [
	| selector |
	selector := ('classModelFor' , aClassModel describedClass name , ':')
		asSymbol.
	(self respondsTo: selector)
		ifTrue: [^self perform: selector with: aClassModel].
	(aClassModel describedClass respondsTo: #glorpSetupClassModel:forSystem:)
		ifTrue:
			[^aClassModel describedClass
				glorpSetupClassModel: aClassModel
				forSystem: self].
	"Otherwise, just initialize it dynamically, so that old code with only descriptors will still work"
	^aClassModel
]

{ #category : #private }
DescriptorSystem >> initializeDescriptor: aDescriptor [ 
	| selector |
	selector := ('descriptorFor' , aDescriptor describedClass name , ':') asSymbol.
	(self respondsTo: selector) 
		ifTrue: [self perform: selector with: aDescriptor]
		ifFalse: [
			(aDescriptor describedClass respondsTo: #glorpSetupDescriptor:forSystem:)
				ifTrue: [aDescriptor describedClass
								glorpSetupDescriptor: aDescriptor
								forSystem: self]
				ifFalse: [self noDescriptorInitializerFound: aDescriptor]]
]

{ #category : #validation }
DescriptorSystem >> initializeRuntimeMappings [

	session isNil ifFalse: [session system == self ifFalse: [InvalidSessionSetup signal: 'Invalid session setup']].
	self allTables.
	self allDescriptors do: [:each | each initializeRuntimeMappings]
]

{ #category : #private }
DescriptorSystem >> initializeTable: newTable [
	| initializerName |
	initializerName := ('tableFor' , (newTable name asUppercase) , ':') asSymbol.
	(self respondsTo: initializerName)
		ifTrue: [self perform: initializerName with: newTable]
		ifFalse: [self noTableInitializerFound: newTable].
	newTable postInitializeIn: self.
	self deferentialSetSchema: newTable.
]

{ #category : #callbacks }
DescriptorSystem >> joinFor: aMapping toTables: toTables fromConstraints: fromConstraints toConstraints: toConstraints [
	"Return the join to be used for aMapping. The set of tables we expect this to be related to, and the constraints from this table, and to this table are provided as possibly useful input."
	| numberOfConstraints |
	numberOfConstraints := (Set new addAll: toConstraints; addAll: fromConstraints; yourself) size.
	numberOfConstraints = 0 ifTrue: [
		CannotAutomaticallyDetermineJoin new 
			tables: toTables;
			constraints: (toConstraints, fromConstraints);
			signal: 'Cannot automatically determine join, no constraints found.'].
	numberOfConstraints > 1 ifTrue: [
		| prefix toC frC |
		prefix := (self inflector underscore: aMapping attributeName) copyUpTo: $_.
		frC := fromConstraints select: [ :ea | 
			(ea sourceFields anySatisfy: [ :field | field name beginsWith: prefix ]) or:
			[ ea targetFields anySatisfy: [ :field | field name beginsWith: prefix ] ] ].
		toC := toConstraints select: [ :ea | 
			(ea sourceFields anySatisfy: [ :field | field name beginsWith: prefix ]) or:
			[ ea targetFields anySatisfy: [ :field | field name beginsWith: prefix ] ] ].
		numberOfConstraints := (Set new addAll: toC; addAll: frC; yourself) size.
		numberOfConstraints = 1 
			ifTrue: [ ^toC isEmpty ifTrue: [ frC first asReverseJoin ] ifFalse: [ toC first asJoin ] ].
		CannotAutomaticallyDetermineJoin new
			tables: toTables;
			constraints: (toConstraints, fromConstraints);
			signal: 'Cannot automatically determine join, too many constraints found.'].
	^toConstraints isEmpty ifTrue: [fromConstraints first asReverseJoin] ifFalse: [toConstraints first asJoin]
]

{ #category : #'optimization parameters' }
DescriptorSystem >> maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows [
	"If we are going to group write, how many rows of this collection should we do it for at once. Normally we delegate this to the platform, but we allow the system to intervene if desired"
	^platform maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows
]

{ #category : #private }
DescriptorSystem >> newClassModelFor: aClass [

	| newClassModel |
	newClassModel := GlorpClassModel new.
	newClassModel system: self.
	newClassModel describedClass: aClass.
	self initializeClassModel: newClassModel.
	^newClassModel
]

{ #category : #private }
DescriptorSystem >> newDescriptorFor: aClass [

	| newDescriptor |
	(self allClasses includes: aClass) ifFalse: [^nil].
	newDescriptor := Descriptor new.
	newDescriptor system: self.
	newDescriptor classModel: (self classModelFor: aClass).
	^newDescriptor
]

{ #category : #private }
DescriptorSystem >> newTypeResolverFor: aClass [ 
	| selector |
	(self allClasses includes: aClass) ifFalse: [^nil].
	selector := ('typeResolverFor' , aClass name) asSymbol.
	^(self respondsTo: selector) 
		ifTrue: [self perform: selector]
		ifFalse: [aClass glorpTypeResolver]
]

{ #category : #validation }
DescriptorSystem >> noDescriptorInitializerFound: aDescriptor [
	self error: 'No descriptor initializer found for ', aDescriptor printString
]

{ #category : #validation }
DescriptorSystem >> noTableInitializerFound: aDatabaseTable [
	self error: 'No table initializer found for ', aDatabaseTable printString
]

{ #category : #accessing }
DescriptorSystem >> platform [

	^platform
]

{ #category : #accessing }
DescriptorSystem >> platform: dbPlatform [

	platform := dbPlatform
]

{ #category : #private }
DescriptorSystem >> privateAndBasicAddDescriptorFor: anObject as: aDescriptor [
	"Just add the descriptor and don't try to validate. anObject may not actually even be a class. Assume the descriptor is already properly initialized"
	descriptors at: anObject put: aDescriptor.
	aDescriptor system: self
]

{ #category : #accessing }
DescriptorSystem >> queryClass [
	^queryClass
]

{ #category : #accessing }
DescriptorSystem >> queryClass: aClass [
	queryClass := aClass
]

{ #category : #sequences }
DescriptorSystem >> sequenceNameForField: aDatabaseField [
	"Return the name of the sequence we will use for a field. Subclasses can override to use different naming conventions."
	^(aDatabaseField table sqlString), '_', (aDatabaseField name), '_seq'
]

{ #category : #api }
DescriptorSystem >> sequenceTypeNamed: aString [
	"Return a sequence type whose sequence has the given name."
	^self platform sequence sequence: (self databaseSequenceNamed: aString)
]

{ #category : #accessing }
DescriptorSystem >> session [
	^session
]

{ #category : #accessing }
DescriptorSystem >> session: anObject [
	session := anObject
]

{ #category : #'session creation' }
DescriptorSystem >> sessionForLogin: aGlorpLogin [
	"Create a session associated with the given login, and using us as a descriptor system. This is the easiest way to get a full blown session going."

	| newSession |
	platform isNil ifTrue: [self platform: aGlorpLogin database].
	aGlorpLogin database class = self platform class ifFalse: [self error: 'Login is incompatible with the database specified in the descriptor system'].
	session isNil ifFalse: [InvalidSessionSetup signal: 'DescriptorSystem already has a session; resume this error if this was intended.'].
	newSession := GlorpSession new.
	newSession accessor: (DatabaseAccessor forLogin: aGlorpLogin).
	newSession system: self.
	^newSession
]

{ #category : #initialization }
DescriptorSystem >> setUpDefaults [
	"For systems that are configurable, set them up for testing configuration"
]

{ #category : #settings }
DescriptorSystem >> shouldForeignKeyValueBeTreatedAsNull: aValue [
	"Return true if this foreign key value should be treated as null, meaning there's no relationship. Normally this means just nil, but descriptor systems can override if they have special values which they use (e.g. 0) that indicate a missing relationship. This can improve performance by avoiding unnecessary queries to the database for things we know will never return a result"
	^aValue isNil
]

{ #category : #settings }
DescriptorSystem >> shouldResetExpiryTimeForObjectOfClass: aClass readFrom: aQuery [
	"Return true if, when an object is read from a query, even if it's not refreshing. we 'touch' it, resetting its expiry time. By default, we do this if the cache policy for that type of object will remove from the cache. The rationale is that this means we're using the object. Removing an object in use is a very bad thing, and can cause loss of identity and other bad things. However, if expiry only indicates a need to refresh, we don't need to touch the object. Subclasses can override to provide different behaviour."

	aQuery shouldRefresh ifTrue: [^true].
	aQuery returnProxies ifTrue: [^false].
	^(self session cacheForClass: aClass)  willRemoveItems
]

{ #category : #'optimization parameters' }
DescriptorSystem >> shouldUpdateOnlyChangedFieldsFor: aRow [
	"Return true if we should write only changed fields out in an update statement, or if we should write all of them. The tradeoff is that writing only the changed ones will produce less SQL, but make more variations of the statement, and require us to keep more prepared statements around if we're using binding. By default, use this option only if we're not using binding by default"
	^aRow useBinding not
]

{ #category : #api }
DescriptorSystem >> tableNamed: aString [

	^self tableNamed: aString ifNone: [NoTableFound new parameter: aString; signal]
]

{ #category : #api }
DescriptorSystem >> tableNamed: aString ifNone: aBlock [

	^tables at: aString asString asUppercase
		ifAbsent: 
			[| newTable |
			newTable := self databaseTableClass new.
			newTable name: aString.
			tables at: aString asUppercase put: newTable.
			self initializeTable: newTable.
			newTable isEmpty
				ifTrue: 
					[tables removeKey: aString asUppercase.
					^aBlock value].
			newTable]
]

{ #category : #'internal/writing' }
DescriptorSystem >> tablesInCommitOrder [

	^(TableSorter for: self allTables) sort
]

{ #category : #api }
DescriptorSystem >> typeResolverFor: aClassOrObject [ 

	| theClass |
	aClassOrObject == Proxy ifTrue: [self error: 'Cannot find type resolver for the class Proxy. Pass in the instance'].
	theClass := aClassOrObject glorpCanHaveDescriptorDirectly 
				ifTrue: [aClassOrObject]
				ifFalse: [aClassOrObject isGlorpProxy ifTrue: [aClassOrObject getValue class] ifFalse: [aClassOrObject class]].
	^typeResolvers at: theClass ifAbsentPut: [self newTypeResolverFor: theClass]
]

{ #category : #validation }
DescriptorSystem >> unmappedInstanceVariables [
	"Return a list, for all of our classes, of instance variables with no mappings. This can be used by inspection to see if we're missing mappings we think we ought to have."
	"self unmappedInstanceVariables"

	| unmapped |
	unmapped := Dictionary new.
	self allClasses do: [:eachClass |
		eachClass allInstVarNames do: [:eachInstVarName |
			((self descriptorFor: eachClass) mappingForAttributeNamed: eachInstVarName asSymbol)
				isNil ifTrue: [
					(unmapped at: eachClass ifAbsentPut: [OrderedCollection new])
						add: eachInstVarName]]].
	^unmapped
]

{ #category : #accessing }
DescriptorSystem >> useDirectAccessForMapping [
	^useDirectAccessForMapping
]

{ #category : #accessing }
DescriptorSystem >> useDirectAccessForMapping: anObject [
	useDirectAccessForMapping := anObject
]

{ #category : #settings }
DescriptorSystem >> useJoinsForAnySatisfy [
	useJoinsForAnySatisfy isNil ifTrue: [useJoinsForAnySatisfy := false].
	^useJoinsForAnySatisfy.
]

{ #category : #settings }
DescriptorSystem >> useJoinsForAnySatisfy: aBoolean [
	useJoinsForAnySatisfy := aBoolean
]

{ #category : #validation }
DescriptorSystem >> validate [
	session isNil ifFalse: [session system == self ifFalse: [InvalidSessionSetup signal: 'Invalid session setup']].
	self allTables do: [:each | each validateIn: self].
	self allClassModels do: [:each | each validateIn: self].
	self allDescriptors do: [:each | each validate].
]

{ #category : #validation }
DescriptorSystem >> validateDescriptor: aDescriptor [
	"Validate aDescriptor in the context of this system, doing any specific validations that need the full environment information or rely on subclass-specific information here."
]

{ #category : #accessing }
DescriptorSystem >> validateDescriptorSystem [

	^self class validateDescriptorSystem
]

{ #category : #validation }
DescriptorSystem >> validateRows: aUnitOfWork [
	"This is a hook to allow the system to do application-specific validation of the rows to be written. I suppose it's also possible to modify the rows here. Subclasses can override if they have useful work to do here. This will be called after the rows are generated, pre-write notification has been sent, rows have been sorted for writing, and and just before sequence numbers (if pre-write) are assigned, and writing starts"
]

{ #category : #validation }
DescriptorSystem >> validateRowsPostWrite: aUnitOfWork [
	"Validate after writing. This is a bit late, but some things may not be catchable ahead of time"
]

{ #category : #'initialize-release' }
DescriptorSystem >> withAllSuperclassesDo: aBlock [
	| currentClass |
	currentClass := self class.
	[currentClass == Object]
		whileFalse:
			[aBlock value: currentClass.
			currentClass := currentClass superclass]
]
