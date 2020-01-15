Class {
	#name : #ActiveRecordDescriptorSystem,
	#superclass : #DynamicDescriptorSystem,
	#instVars : [
		'rootClass'
	],
	#category : #'Glorp-Mappings'
}

{ #category : #adding }
ActiveRecordDescriptorSystem >> addToManyRelationshipNamed: aName inDescriptor: aDescriptor toClass: aClass join: aJoin [
	| ivars table realFromClass |
	realFromClass := self tableClassForClass: aDescriptor describedClass.
	realFromClass methodDictionary at: aName asSymbol ifAbsent: [ 
		"We need to stick in an ivar and accessor for the relationship proxy"
		ivars := realFromClass instVarNames.
		(ivars includes: aName asSymbol) ifFalse: [
			ivars := ivars copyWith: aName.
			realFromClass superclass
				subclass: realFromClass name
				instanceVariableNames: (ivars joinUsing: ' ')
				classVariableNames: realFromClass classVariablesString
				package: realFromClass package name.
				
				(RBCreateAccessorsForVariableRefactoring
					variable: aName asSymbol
					class: realFromClass
					classVariable: false) execute ]
		].
	"Set up the descriptor"
	table := self tableForClass: aClass.
	aDescriptor mappings
		detect: [ :m | m attribute name = aName ]
		ifNone: [ (aDescriptor newMapping: ToManyMapping)
				attributeName: aName;
				referenceClass: (self tableClassForClass: aClass)";
				mappingCriteria: aJoin;
				orderBy: [ :each | (each getTable: table name asUppercase) getField: (aName toCamelCase, '_id') ]" ]
]

{ #category : #adding }
ActiveRecordDescriptorSystem >> addToOneRelationshipNamed: aName inDescriptor: aDescriptor toClass: aClass join: aJoin [
	| ivars realFromClass |
	realFromClass := self tableClassForClass: aDescriptor describedClass.
	realFromClass methodDictionary at: aName asSymbol ifAbsent: [  
		"We need to stick in an ivar and accessor for the relationship proxy"
		ivars := realFromClass instVarNames.
		(ivars includes: aName asSymbol) ifFalse: [ 
			ivars := ivars copyWith: aName.
			realFromClass superclass
				subclass: realFromClass name
				instanceVariableNames: (ivars joinUsing: ' ')
				classVariableNames: realFromClass classVariablesString
				package: realFromClass package name 
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
				referenceClass: (self tableClassForClass: aClass);
				"mappingCriteria: aJoin;"
				"proxyAction: [ :owner :target | target ifNotNil: [owner perform: (aName,':')asSymbol with: target] ];"
				debugRead: (aClass = HowYouHeard and: [ aName asSymbol = #channels]);
				debugWrite: (aClass = HowYouHeard and: [ aName asSymbol = #channels])].
	
		
]

{ #category : #initialization }
ActiveRecordDescriptorSystem >> allClasses [ 
	^allClasses 
		ifEmpty: [ self constructAllClasses ] 
		ifNotEmpty: [ allClasses ]
]

{ #category : #accessing }
ActiveRecordDescriptorSystem >> allDescriptors [
	descriptors ifEmpty: [ self constructAllDescriptors ].
	^super allDescriptors.
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> attributeNameForFieldName: fieldname [
	^fieldname toCamelCase uncapitalized
	
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> classNameForTableName: tableName [
	^self prefixedClassName: tableName toCamelCase capitalized
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> classPrefix [
	^''
]

{ #category : #initialization }
ActiveRecordDescriptorSystem >> constructAllClasses [
	"Subclasses can override this method to add classes. But by default we also look for all descriptor methods in our system, and add them to the class list, so if the methods are written there, then we don't need to do anything further. If the descriptor methods are defined on the classes themselves, then we'll still have to construct the class list manually."

	self allTables
		valuesDo: [ :ea | 
			| cls classname subclasses ivars |
			ea primaryKeyFields size = 1
				ifTrue: [ classname := self classNameForTableName: ea name.
					cls := Smalltalk at: classname asSymbol ifAbsent: [ nil ].
					ivars := (cls
						ifNil: [ #() ]
						ifNotNil: [ cls instVarNames collect: [ :v | v asString ] ])
						asOrderedCollection.
					"Add missing fields"
					ea fields
						do: [ :f | 
							(ivars includes: f name toCamelCase)
								ifFalse: [ ivars add: f name toCamelCase ] ].
					ivars remove: 'type' ifAbsent: [  ].
					
					allClasses
						add:
							(cls := self rootClass
								subclass: classname
								instanceVariableNames: (ivars joinUsing: ' ')
								classVariableNames: ''
								package: self rootClass package name).
								
					"Construct accessors"
					ivars
						do: [ :var | 
							(RBCreateAccessorsForVariableRefactoring
								variable: var asSymbol
								class: cls
								classVariable: false) execute ].
					"Create subclasses if a field named type is found"
					(ea fields detect: [ :f | f name = 'type' ] ifNone: [  ])
						ifNotNil: [ subclasses := self session accessor
								executeSQLString: 'select distinct type from ' , ea name.
							subclasses
								do: [ :sub | 
									allClasses
										add:
											(cls
												subclass: sub first asSymbol
												instanceVariableNames: ''
												classVariableNames: ''
												package: cls package name) ] ] ] ].
	^ allClasses
]

{ #category : #private }
ActiveRecordDescriptorSystem >> constructAllDescriptors [
	self postInitializeAllDescriptors.
]

{ #category : #initialization }
ActiveRecordDescriptorSystem >> constructAllTables [
	| tableNames |
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
				from: field name toCamelCase asSymbol
				to: field ].
			
	typeField
		ifNotNil: [ | resolver |
			resolver := FilteredTypeResolver forRootClass: (self tableClassForClass: aDescriptor describedClass).
			resolver
				register: aDescriptor
				keyedBy: aDescriptor describedClass name asString
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
					sel := dbType toCamelCase.
					(databasePlatform respondsTo: sel asSymbol) 
						ifTrue: [ databasePlatform perform: sel asSymbol ]
						ifFalse: [ databasePlatform perform: sel asLowercase asSymbol ]]
				ifNotNil: [ databasePlatform
						perform: (dbType toCamelCase , ':') asSymbol
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
						withBlock: [UUIDGenerator next asString copyWithout: $-]) 
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

{ #category : #'as yet unclassified' }
ActiveRecordDescriptorSystem >> isTableClass: aClass [ 
	^(self tableForClass: aClass) name toCamelCase capitalized asSymbol = aClass name
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> likelyClassForForeignKeyNamed: aKey [
	| parts key cls |
	parts := (aKey substrings: '_').
	parts := parts copyUpToLast: parts last.
	cls := nil.
	[ cls isNil and: [parts notEmpty]] whileTrue: [ 
		key := (parts joinUsing: '_') toCamelCase capitalized.
		cls := allClasses 
			detect: [ :ea | ea name = key ] 
			ifNone: [ parts := parts copyWithoutFirst. nil]].
		
	^cls
	
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> likelyTableForForeignKeyNamed: aKey [
	| key table |
	key := aKey asUppercase copyUpToLast: $_.
	table := nil.
	[ table isNil and: [key notEmpty]] whileTrue: [ 
		table := tables 
			at: key
			ifAbsent: [ key := key copyAfter: $_. nil]].
		
	^table
	
]

{ #category : #private }
ActiveRecordDescriptorSystem >> postInitializeAllDescriptors [
	super allDescriptors do: [ :ea | self postInitializeDescriptor: ea ]
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
			attrName := (field name copyUpToLast: $_) toCamelCase.
			otherClass := self likelyClassForForeignKeyNamed: field name.
			
			otherClass
				ifNotNil: [ | join inverseJoin |
					join := Join from: field to: ((self tableForClass: otherClass) primaryKeyFields first).
					inverseJoin := join inverseJoin.
					self addToOneRelationshipNamed: attrName 
						inDescriptor: aDescriptor 
						toClass: otherClass 
						join: join. 
					reverseRelationshipName := table name toCamelCase pluralize uncapitalized.
					(otherClass = (self tableClassForClass: aDescriptor describedClass)) ifFalse: [  
						otherClass withAllSubclassesDo:[:other | 
							| otherDescriptor |
							otherDescriptor := self descriptorFor: other.
							self
								addToManyRelationshipNamed: reverseRelationshipName 
								inDescriptor: otherDescriptor 
								toClass: (self tableClassForClass: aDescriptor describedClass)
								join: inverseJoin. 
							] 
						]
					]
				].
	^ aDescriptor
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> prefixedClassName: classname [
	^self classPrefix ifNotEmpty: [
		(classname beginsWith: self classPrefix) 
			ifTrue: [ classname ]
			ifFalse: [ self classPrefix , classname ]]
		ifEmpty: [ classname ]
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
ActiveRecordDescriptorSystem >> sessionForLogin: aGlorpLogin [
	"Create a session associated with the given login, and using us as a descriptor system. This is the easiest way to get a full blown session going."

	| newSession |
	platform isNil ifTrue: [self platform: aGlorpLogin database].
	aGlorpLogin database class = self platform class ifFalse: [self error: 'Login is incompatible with the database specified in the descriptor system'].
	session isNil ifFalse: [InvalidSessionSetup signal: 'DescriptorSystem already has a session; resume this error if this was intended.'].
	newSession := GlorpSession new.
	newSession accessor: (DatabaseAccessor forLogin: aGlorpLogin).
	newSession accessor login.
	newSession system: self.
	^newSession
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> tableClassForClass: aClass [ 
	| className |
	className := (self tableForClass: aClass) name toCamelCase capitalized asSymbol.
	^allClasses detect: [:ea | ea name = className] ifNone: [ self error: 'No table found for class ', aClass name ]
	
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> tableForClass: aClass [ 
	| table tableClass |
	table := nil.
	tableClass := aClass.
	[ table ]
		whileNil: [ table := tables
				at: (self tableNameForClassName: tableClass name) asUppercase
				ifAbsent: [ tableClass := tableClass superclass. nil ] ].
	^table
	
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> tableNameForClassName: classname [
	^(self unprefixedClassName: classname) toSnakeCase
]

{ #category : #naming }
ActiveRecordDescriptorSystem >> unprefixedClassName: baseClassname [
	^ self classPrefix
		ifNotEmpty: [ (baseClassname beginsWith: self classPrefix)
				ifTrue: [ baseClassname
						copyFrom: self classPrefix size + 1
						to: baseClassname size ]
				ifFalse: [ baseClassname ] ]
		ifEmpty: [ baseClassname ]
]
