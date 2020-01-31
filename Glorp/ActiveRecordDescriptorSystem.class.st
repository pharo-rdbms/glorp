"
I am a Glorp DescriptorSystem that infers and builds the class hierarchy and descriptor mappings from the database schema.  I expect the database schema to conform to Rails ActiveRecord naming conventions.
"
Class {
	#name : #ActiveRecordDescriptorSystem,
	#superclass : #DynamicDescriptorSystem,
	#instVars : [
		'rootClass',
		'inflector',
		'classesWereModified',
		'sortingFieldNames'
	],
	#category : #'Glorp-ActiveRecord'
}

{ #category : #'instance creation' }
ActiveRecordDescriptorSystem class >> sessionForAccessor: aDatabaseAccesor [.
	"Create a session associated with the given accesseor, and using us as a descriptor system. 
	This is the easiest way to get a full blown session going."
	
	^(ActiveRecordSession forSystem: (self forPlatform: aDatabaseAccesor platform))
		accessor: aDatabaseAccesor;
		yourself

]

{ #category : #'instance creation' }
ActiveRecordDescriptorSystem class >> sessionForLogin: aGlorpLogin [
	"Create a session associated with the given login, and using us as a descriptor system. This is the easiest way to get a full blown session going."
	| system session |
	system := self forPlatform: aGlorpLogin database.
	session := ActiveRecordSession new.
	session accessor: (DatabaseAccessor forLogin: aGlorpLogin).
	session system: system.
	^session
]

{ #category : #adding }
ActiveRecordDescriptorSystem >> addToManyRelationshipNamed: aName inDescriptor: aDescriptor toClass: aClass [
	| ivars realFromClass package |
	package := ((Array with: self rootClass package name), self rootClass tags) joinUsing: '-'.
	realFromClass := self tableClassForClass: aDescriptor describedClass.
	realFromClass methodDictionary at: aName asSymbol ifAbsent: [ 
		"We need to stick in an ivar and accessor for the relationship proxy"
		ivars := realFromClass instVarNames.
		(ivars includes: aName asSymbol) ifFalse: [
			classesWereModified := true.
			ivars := ivars copyWith: aName.
			realFromClass superclass
				subclass: realFromClass name
				instanceVariableNames: (ivars joinUsing: ' ')
				classVariableNames: realFromClass classVariablesString
				package: package.
				
				(RBCreateAccessorsForVariableRefactoring
					variable: aName asSymbol
					class: realFromClass
					classVariable: false) execute ]
		].
	"Set up the descriptor"
	aDescriptor mappings
		detect: [ :m | m attribute name = aName ]
		ifNone: [ 
			(aDescriptor newMapping: ToManyMapping)
				attributeName: aName;
				referenceClass: (self tableClassForClass: aClass) ]
]

{ #category : #adding }
ActiveRecordDescriptorSystem >> addToManyRelationshipNamed: aName inDescriptor: aDescriptor toClass: aClass join: aJoin [
	| ivars realFromClass package |
	package := ((Array with: self rootClass package name), self rootClass tags) joinUsing: '-'.
	realFromClass := self tableClassForClass: aDescriptor describedClass.
	realFromClass methodDictionary at: aName asSymbol ifAbsent: [ 
		"We need to stick in an ivar and accessor for the relationship proxy"
		ivars := realFromClass instVarNames.
		(ivars includes: aName asSymbol) ifFalse: [
			classesWereModified := true.
			ivars := ivars copyWith: aName.
			realFromClass superclass
				subclass: realFromClass name
				instanceVariableNames: (ivars joinUsing: ' ')
				classVariableNames: realFromClass classVariablesString
				package: package.
				
				(RBCreateAccessorsForVariableRefactoring
					variable: aName asSymbol
					class: realFromClass
					classVariable: false) execute ]
		].
	"Set up the descriptor"
	aDescriptor mappings
		detect: [ :m | m attribute name = aName ]
		ifNone: [ 
			(aDescriptor newMapping: ManyToManyMapping)
				attributeName: aName;
				referenceClass: (self tableClassForClass: aClass) ]
]

{ #category : #adding }
ActiveRecordDescriptorSystem >> addToOneRelationshipNamed: aName inDescriptor: aDescriptor toClass: aClass [
	| ivars realFromClass package |
	package := ((Array with: self rootClass package name), self rootClass tags) joinUsing: '-'.
	realFromClass := self tableClassForClass: aDescriptor describedClass.
	realFromClass methodDictionary at: aName asSymbol ifAbsent: [  
		"We need to stick in an ivar and accessor for the relationship proxy"
		ivars := realFromClass instVarNames.
		(ivars includes: aName asSymbol) ifFalse: [ 
			classesWereModified := true.
			ivars := ivars copyWith: aName.
			realFromClass superclass
				subclass: realFromClass name
				instanceVariableNames: (ivars joinUsing: ' ')
				classVariableNames: realFromClass classVariablesString
				package: package 
		].
					
			(RBCreateAccessorsForVariableRefactoring
				variable: aName asSymbol
				class: realFromClass
				classVariable: false) execute 
	].
	"Set up the descriptor"
	aDescriptor mappings
		detect: [ :m | m attribute name = aName ]
		ifNone: [ 
			(aDescriptor newMapping: OneToOneMapping)
				attributeName: aName asSymbol;
				referenceClass: (self tableClassForClass: aClass)].
	
		
]

{ #category : #initialization }
ActiveRecordDescriptorSystem >> allClasses [ 
	^allClasses 
		ifEmpty: [ self constructAllClasses ] 
		ifNotEmpty: [ allClasses ]
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> allDescriptors [
	descriptors ifEmpty: [ 
		classesWereModified := false.
		self constructAllDescriptors.
		"Check if we had to reshape any classes - if we did then our descriptor inst var offsets are wrong.  
		Build them again. This should only happen during development when making changes."
		classesWereModified ifTrue: [ 
			descriptors := Dictionary new.
			classesWereModified := false. 
			self constructAllDescriptors.
			classesWereModified ifTrue: [self error: 'There is a bug here!'] ] ].
	^super allDescriptors.
]

{ #category : #private }
ActiveRecordDescriptorSystem >> classCommentForClass: aClass table: aTable [ 
	| fields |
	fields := ((String streamContents: 
		[ :attrs | self platform printColumnsSpecificationFor: aTable on: attrs]) 
			substrings: ',') collect: [:s | s trimmed].
	
	^aClass superclass = self rootClass 
	ifTrue: [  
		String streamContents: [ :s | s
		nextPutAll: 'I am an ActiveRecord generated by the Glorp ActiveRecordDescriptorSystem.'; cr;  
		nextPutAll: 'I am derived from the following database table: '; cr; cr;
		nextPutAll: aTable name; cr.	
		fields do: [ :f | s nextPutAll: '    '; nextPutAll: f; cr ] ] ]
	ifFalse: [ 
		String streamContents: [ :s | s
		nextPutAll: 'I am an ActiveRecord generated by the Glorp ActiveRecordDescriptorSystem.'; cr;  
		nextPutAll: 'I am mapped to the following database table which I share with all subclasses of '; 
		nextPutAll: (self tableClassForClass: aClass) name; nextPut: $:; cr; cr;
		nextPutAll: aTable name; cr.
		fields do: [ :f | s nextPutAll: '    '; nextPutAll: f; cr] ] ]
]

{ #category : #initialization }
ActiveRecordDescriptorSystem >> constructAllClasses [
	"Subclasses can override this method to add classes. But by default we also look for all descriptor methods in our system, and add them to the class list, so if the methods are written there, then we don't need to do anything further. If the descriptor methods are defined on the classes themselves, then we'll still have to construct the class list manually."
	| package |
	package := ((Array with: self rootClass package name), self rootClass tags) joinUsing: '-'.
	self mappedTables 
		do: [ :table || cls classname subclasses ivars cvars needsUpdate |
			needsUpdate := false.
			classname := inflector modulize: (inflector classify: table name).
			cls := inflector constantize: classname.
			cls
				ifNil: [ 
					needsUpdate := true. 
					ivars := OrderedCollection new.
					cvars := OrderedCollection new ]
				ifNotNil: [ 
					ivars := (cls instVarNames collect: [ :v | v asString ]) asOrderedCollection.
					cvars := (cls classVarNames collect: [:v | v asString ]) asOrderedCollection ].
			"Add missing fields"
			table fields
				do: [ :f || var |
					var := inflector camelize: f name capitalized: false.
					(ivars includes: var)
						ifFalse: [ needsUpdate := true. ivars add: var ] ].
			ivars remove: 'type' ifAbsent: [  ].
			allClasses
				add:
					(needsUpdate ifTrue: [ 
						classesWereModified := true. 
						cls := self rootClass
							subclass: classname
							instanceVariableNames: (ivars joinUsing: ' ')
							classVariableNames: (cvars joinUsing: ' ')
							package: package ] ifFalse: [ cls ]).
			needsUpdate ifTrue: [ cls comment: (self classCommentForClass: cls table: table) ].
			"Construct accessors"
			ivars
				do: [ :var | 
					(RBCreateAccessorsForVariableRefactoring
						variable: var asSymbol
						class: cls
						classVariable: false) execute ].
			"Create subclasses if a field named type is found"
			(table fields detect: [ :f | f name = 'type' ] ifNone: [  ])
				ifNotNil: [ 
					subclasses := self session accessor 
						executeSQLString: (String streamContents: 
							[:s | s nextPutAll: 'select distinct type from '; nextPutAll: table name]).
					(subclasses reject: [ :s | s isNil or: [s first isNil] ])
						do: [ :sub || subName subclass |
							subName := (inflector classify: (inflector modulize: sub first)) asSymbol.
							allClasses
								add:
									(subclass := (inflector constantize: subName) ifNil: [
										classesWereModified := true.
										cls
											subclass: subName 
											instanceVariableNames: ''
											classVariableNames: ''
											package: package]).
							needsUpdate ifTrue: [ subclass comment: (self classCommentForClass: subclass table: table) ].
						 ] 
					]
				].
	^ allClasses
]

{ #category : #private }
ActiveRecordDescriptorSystem >> constructAllDescriptors [
	self postInitializeAllDescriptors.
]

{ #category : #initialization }
ActiveRecordDescriptorSystem >> constructAllTables [
	| tableNames accessor |
	accessor := self session accessor.
	accessor isLoggedIn ifFalse: [ accessor login ].
	tables := Dictionary new.
	tableNames := self session accessor listTableNamesInSchemaNamed: self session accessor schema.
	tableNames do: [:aTableName | self tableNamed: aTableName ].
	self constructTableForeignKeys
]

{ #category : #private }
ActiveRecordDescriptorSystem >> constructTableForeignKeys [
	tables keysAndValuesDo: [ :key :table | 
		| foreignKeys |
		foreignKeys := table fields select: [ :field | field name endsWith: '_id' ].
		foreignKeys do: [ :fk |
			| ownerTable | 
			ownerTable := self likelyTableForForeignKeyNamed: fk name.
			ownerTable ifNotNil: [ table addForeignKeyFrom: fk to: (ownerTable fieldNamed: 'id') ] 
			]
		].
	^tables
	
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> inflector [
	^ inflector
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> inflector: anObject [
	inflector := anObject
]

{ #category : #initialization }
ActiveRecordDescriptorSystem >> initialize [ 
	super initialize.
	inflector := ActiveRecordInflector new.
	classesWereModified := false.
	sortingFieldNames := #(position sequence_no seq_no sequence_num seq_num sort_no display_position display_order order sort_value sort_key sort).
	queryClass := ActiveRecordQuery.
	Query delegateTo: ActiveRecordQuery
]

{ #category : #private }
ActiveRecordDescriptorSystem >> initializeDescriptor: aDescriptor [
	| table directFields foreignKeys typeField |

	"Locate the real table for this class - might be participating in single table inheritance"
	table := self tableForClass: aDescriptor describedClass.
	aDescriptor table: table.
	directFields := table fields
		reject: [ :field | field name = 'type' or: [ field name endsWith: '_id' ] ].
	foreignKeys := table fields
		select: [ :field | field name endsWith: '_id' ].
	typeField := table fields
		detect: [ :field | field name = 'type' ]
		ifNone: [  ].
		
	(directFields, foreignKeys) 
		do: [ :field | 
			(aDescriptor newMapping: DirectMapping)
				from: (inflector accessor: field name)
				to: field ].
			
	typeField
		ifNotNil: [ | resolver |
			resolver := FilteredTypeResolver forRootClass: (self tableClassForClass: aDescriptor describedClass).
			resolver
				register: aDescriptor
				keyedBy: (inflector classKey: aDescriptor describedClass)
				field: typeField ].
			
	^ aDescriptor
]

{ #category : #private }
ActiveRecordDescriptorSystem >> initializeTable: newTable [
	"fill in the definition from the database
	          name           |       type        | length | nullable |     default_value     | pk 
-------------------------+-------------------+--------+----------+-----------------------+----
 id                      | character varying |    255 |        0 | ''::character varying |  1 
 effective_date          | date              |        |        1 |                       |  0 
	"
	| columns databasePlatform |
	
	databasePlatform := self platform.
	columns := self session accessor
		listColumnsInTableNamed: newTable name
		schemaNamed: self session accessor schema.
	columns
		do: [ :row | 
			| column type name dbType length isNullable defaultValue isPrimaryKey |
			name := row first.
			dbType := row second.
			length := row third.
			isNullable := row fourth = 1.
			defaultValue := row fifth.
			isPrimaryKey := row sixth = 1.
			type := (length
				ifNil: [ | sel |
					sel := inflector accessor: dbType.
					(databasePlatform respondsTo: sel) 
						ifTrue: [ databasePlatform perform: sel asSymbol ]
						ifFalse: [ databasePlatform perform: sel asLowercase asSymbol ]]
				ifNotNil: [ databasePlatform
						perform: (inflector mutator: dbType)
						with: length ]).
			
			(name = 'created_at' and: [ dbType asLowercase beginsWith: 'timestamp' ]) 
				ifTrue: [ 
						type := 
							(databasePlatform versionFieldFor: type) generatesOverExistingValues: false.
					].
				
			(name = 'updated_at' and: [ dbType asLowercase beginsWith: 'timestamp' ]) 
				ifTrue: [ 
						type := (databasePlatform versionFieldFor: type) 
							generatesOverExistingValues: true.
					].
			
			(name = 'id' and: [isPrimaryKey and: [type isStringType]]) 
				ifTrue: [ 
					type := (databasePlatform generatorFor: type 
						withBlock: [UUIDGenerator next asString]) 
					generatesOverExistingValues: false ].
				
			(name = 'id' and: [isPrimaryKey and: [type typeString = #uuid]]) 
				ifTrue: [ 
					type := (databasePlatform generatorFor: type 
						withBlock: [UUIDGenerator next]) 
					generatesOverExistingValues: false ].
				
			column := (newTable createFieldNamed: name type: type)
				beNullable: isNullable;
				defaultValue: defaultValue.

			isPrimaryKey
				ifTrue: [ column bePrimaryKey ] 
		].
			
	newTable postInitializeIn: self.
	self deferentialSetSchema: newTable
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> isLinkTable: aTable [
	"Assumption is link tables have compound primary keys of foreign keys or is composed of only foreign keys, timestamps, 
	and maybe a primary key, and maybe a single integer field used for ordering."

	| primaryKeys foreignKeys timestamps other |
	primaryKeys := aTable primaryKeyFields.
	foreignKeys := aTable fields
		select: [ :field | 
			| table |
			table := self likelyTableForForeignKeyNamed: field name.
			"Ignore recursive links"
			table notNil and: [ table ~= aTable ] ].
	timestamps := aTable fields
		select:
			[ :field | self isTimestampField: field name asSymbol ].
	other := aTable fields
		reject: [ :ea | 
			(primaryKeys includes: ea)
				or: [ (foreignKeys includes: ea) or: [ timestamps includes: ea ] ] ].
	^ foreignKeys size = 2
		and: [ other size < 2
				and: [ other isEmpty
						or: [ other first type isIntegerType
								and: [ self isSortingField: other first ] ] ] ]
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> isSortingField: aFieldOrName [
	| realName |
	realName := aFieldOrName isString 
		ifTrue: [ aFieldOrName asSymbol ] 
		ifFalse: [ aFieldOrName name asSymbol ].
		
	^sortingFieldNames includes: realName
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> isTimestampField: aFieldOrName [
	| realName |
	realName := aFieldOrName isString 
		ifTrue: [ aFieldOrName asSymbol ] 
		ifFalse: [ aFieldOrName name asSymbol ].
		
	^#(created_at updated_at deleted_at) includes: realName
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> likelyClassForForeignKeyNamed: aKey [
	| parts key cls |
	parts := (aKey substrings: '_').
	parts := parts copyUpToLast: parts last.
	cls := nil.
	[ cls isNil and: [parts notEmpty]] whileTrue: [ 
		key := inflector classify: (parts joinUsing: '_').
		cls := allClasses 
			detect: [ :ea | ea name = key ] 
			ifNone: [ parts := parts copyWithoutFirst. nil]].
		
	^cls
	
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> likelyTableForForeignKeyNamed: aKey [
	| key table |
	key := aKey asUppercase copyUpToLast: $_.
	inflector pluralizeTableNames ifTrue: [ key := (inflector pluralize: key) asUppercase ].
	table := nil.
	[ table isNil and: [key notEmpty]] whileTrue: [ 
		table := tables 
			at: key
			ifAbsent: [ key := key copyAfter: $_. nil]].
	table ifNil: [ | candidates |
		key := aKey asUppercase copyUpToLast: $_.
		inflector pluralizeTableNames ifTrue: [ key := (inflector pluralize: key) asUppercase ].
		candidates := tables keys select: [ :ea | ea endsWith: key ].
		candidates ifNotEmpty: [ 
			candidates sort: [ :a :b | (a size) < (b size) ].
			table := tables at: candidates first.
			] ].
	^table
	
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> linkTables [
	"Assumption is link tables have compound primary keys of foreign keys or is composed of only foreign keys, timestamps, 
	and maybe a primary key, and maybe a single integer field used for ordering."
	^self allTables values select: [ :table | self isLinkTable: table ]
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> mappedTables [
	"Assumption is link tables have compound primary keys of foreign keys or is composed of only foreign keys, timestamps, 
	and maybe a primary key, and maybe a single integer field used for ordering."
	^self allTables values reject: [ :table | self isLinkTable: table ]
]

{ #category : #private }
ActiveRecordDescriptorSystem >> postInitializeAllDescriptors [
	super allDescriptors do: [ :ea | self postInitializeDescriptor: ea ].
	self linkTables do: [ :linkTable |
		linkTable foreignKeyConstraints do: [ :fromConstraint || descriptor fromClass join |
			fromClass := inflector constantize: (inflector classify: fromConstraint targetFields first table name).
			descriptor := self descriptorFor: fromClass.
			join := fromConstraint asReverseJoin.
			(linkTable foreignKeyConstraints reject: [ :ea | ea = fromConstraint ]) 
				do: [ :toConstraint || toClass attributeName | 
					toClass := inflector constantize: (inflector classify: toConstraint targetFields first table name).
					attributeName := (inflector pluralize: (inflector demodulize: toClass name)) uncapitalized asSymbol.
					fromClass withAllSubclassesDo: [ :cls | 
						self addToManyRelationshipNamed: attributeName 
							inDescriptor: descriptor 
							toClass: toClass 
							join: join. 
						]
					]
			 ]
		 ]
]

{ #category : #private }
ActiveRecordDescriptorSystem >> postInitializeDescriptor: aDescriptor [
	| table foreignKeys reverseRelationshipName |

	"Locate the real table for this class - might be participating in single table inheritance"
	table := aDescriptor table.
	foreignKeys := table fields
		select: [ :field | field name endsWith: '_id' ].
					
	foreignKeys
		do: [ :field | 
			| otherClass attrName |
			attrName := inflector camelize: (field name copyUpToLast: $_) capitalized: false.
			otherClass := self likelyClassForForeignKeyNamed: field name.
			
			otherClass
				ifNotNil: [ 
					self addToOneRelationshipNamed: attrName 
						inDescriptor: aDescriptor 
						toClass: otherClass. 
					reverseRelationshipName := inflector pluralize: (inflector camelize: table name capitalized: false).
					(otherClass = (self tableClassForClass: aDescriptor describedClass)) ifFalse: [  
						otherClass withAllSubclassesDo:[:other | 
							| otherDescriptor |
							otherDescriptor := self descriptorFor: other.
							self
								addToManyRelationshipNamed: reverseRelationshipName 
								inDescriptor: otherDescriptor 
								toClass: (self tableClassForClass: aDescriptor describedClass).
							] 
						]
					]
				].
	^ aDescriptor
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> prefix [
	^inflector prefix
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> prefix: aString [
	inflector prefix: aString
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> rootClass [
	^rootClass ifNil: [ ActiveRecordModel ]
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> rootClass: anObject [
	rootClass := anObject
]

{ #category : #'session creation' }
ActiveRecordDescriptorSystem >> sessionForAccessor: aDatabaseAccesor [
	"Create a session associated with the given accesseor, and using us as a descriptor system. 
	This is the easiest way to get a full blown session going."
	
	^(ActiveRecordSession forSystem: (self forPlatform: aDatabaseAccesor platform))
		accessor: aDatabaseAccesor;
		yourself

]

{ #category : #'session creation' }
ActiveRecordDescriptorSystem >> sessionForLogin: aGlorpLogin [
	"Create a session associated with the given login, and using us as a descriptor system. This is the easiest way to get a full blown session going."

	| newSession |
	platform isNil ifTrue: [self platform: aGlorpLogin database].
	aGlorpLogin database class = self platform class ifFalse: [self error: 'Login is incompatible with the database specified in the descriptor system'].
	session isNil ifFalse: [InvalidSessionSetup signal: 'DescriptorSystem already has a session; resume this error if this was intended.'].
	newSession := ActiveRecordSession new.
	newSession accessor: (DatabaseAccessor forLogin: aGlorpLogin).
	newSession system: self.
	^newSession
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> sortingFieldNames [
	^ sortingFieldNames
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> sortingFieldNames: anObject [
	sortingFieldNames := anObject
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> tableClassForClass: aClass [ 
	| className |
	className := (inflector classify: (self tableForClass: aClass) name) asSymbol.
"	className := (inflector singularize: (self tableForClass: aClass) name toCamelCase capitalized asSymbol).
"	^allClasses detect: [:ea | ea name = className] ifNone: [ self error: 'No table found for class ', aClass name ]
	
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> tableForClass: aClass [ 
	| table tableClass |
	table := nil.
	tableClass := aClass.
	[ table ]
		whileNil: [ table := tables
				at: (inflector tableize: tableClass name) asUppercase
				ifAbsent: [ tableClass := tableClass superclass. nil ] ].
	^table
	
]
