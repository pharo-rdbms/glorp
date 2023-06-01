"
This is our internal representation of a table in the database. It holds onto enough information for us to both map to the table, and to create it in the database if required.

Instance Variables
	fields	<(Collection of: DatabaseField)>	The columns in the table.
	foreignKeyConstraints	<(Collection of: ForeignKeyConstraint)>	The foreign key constraints between this table and others.
	indexes	<(Collection of: DatabaseIndex)>	The indexes on this table.
	isImaginary	<Boolean>	We allow ""imaginary"" tables, which don't really exist in the database. This is most useful in connection with embedded mappings. For example, we can have a Currency object which maps to a CURRENCY table, but there is no currency table in the database, and instead we have a number of embedded mappings that put those fields inside another table.
	lockKeyFields	<Collection of: DatabaseField>	Which fields (which should also be in our field list) are checked when doing optimistic locking
	name	<String>	The name of the table.
	parent	<DatabaseTable | nil>	For a normal table, this is nil. When we create an aliased table we remember who the original table was using this field.
	primaryKeyFields	<(SequenceableCollection of: (DatabaseField))>	Which fields (which should also be in our field list) are primary keys.
	replacementSubSelect	<CompoundQuery | SimpleQuery>	I honestly don't remember at the moment what this does, but it seems to be used when we're traversing relationships that are in imaginary tables in order to figure out what the actual join has to be. And maybe the join needs to be done in a subselect rather than as a simple join in certain cases.
	schema	<String>	What is the name of the schema in which this table exists. This is used when printing the qualified name of the table. 
	uniqueConstraints	<(Collection of: UniqueConstraint)>	The unique constraints for this table

"
Class {
	#name : #DatabaseTable,
	#superclass : #Object,
	#instVars : [
		'name',
		'schema',
		'fields',
		'foreignKeyConstraints',
		'indexes',
		'parent',
		'lockKeyFields',
		'primaryKeyFields',
		'isImaginary',
		'replacementSubSelect',
		'uniqueConstraints'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
DatabaseTable class >> named: aString [

	^self new name: aString.
]

{ #category : #'*Glorp' }
DatabaseTable class >> new [

	^super new initialize.
]

{ #category : #comparing }
DatabaseTable >> <= aTable [
	^self qualifiedName <= aTable qualifiedName.
]

{ #category : #'private/fields' }
DatabaseTable >> addAsLockKeyField: aField [ 

	lockKeyFields add: aField
]

{ #category : #'private/fields' }
DatabaseTable >> addAsPrimaryKeyField: aField [

	(fields includes: aField) ifFalse: [self error: 'Primary key field not part of the table'].
	aField isPrimaryKey ifFalse: ["Somebody is calling this as API, since there's an example out on the net that does it that way - just do the right thing instead"
		^aField bePrimaryKey].
	(primaryKeyFields notNil and: [primaryKeyFields includes: aField]) ifTrue: [^self].
	primaryKeyFields := primaryKeyFields isNil ifTrue: [Array with: aField] ifFalse: [primaryKeyFields, (Array with: aField)].
]

{ #category : #fields }
DatabaseTable >> addField: aField [

	fields add: aField.
	aField isPrimaryKey ifTrue: [
		self addAsPrimaryKeyField: aField].
	aField table: self.
	aField position: fields size.
	^aField.
]

{ #category : #obsolete }
DatabaseTable >> addFields: aCollection fromAccessor: aDatabaseAccessor [
	| stream |
	aCollection
		do:
			[:each | 
			aDatabaseAccessor
				execute:
					[stream := WriteStream on: String new.
					stream
						nextPutAll: 'ALTER TABLE ';
						nextPutAll: self name;
						nextPutAll: ' ADD ';
						nextPutAll: self platform startColumnAddString.
					self platform printColumn: each on: stream.
					stream nextPutAll: self platform endColumnAddString.
					aDatabaseAccessor executeSQLStringNoResult: stream contents]
				ifError: [:ex | ex pass]].
]

{ #category : #fields }
DatabaseTable >> addForeignKeyFrom: sourceField to: targetField [
	^self
		addForeignKeyFrom: sourceField
		to: targetField
		suffixExpression: nil.
]

{ #category : #fields }
DatabaseTable >> addForeignKeyFrom: sourceField to: targetField from: sourceField2 to: targetField2 [
	^self
		addForeignKeyFromAll: (Array with: sourceField with: sourceField2)
		toAll: (Array with: targetField with: targetField2)
		suffixExpression: nil.
]

{ #category : #fields }
DatabaseTable >> addForeignKeyFrom: sourceField to: targetField from: sourceField2 to: targetField2 from: sourceField3 to: targetField3 [
	^self
		addForeignKeyFromAll: (Array with: sourceField with: sourceField2 with: sourceField3)
		toAll: (Array with: targetField with: targetField2 with: targetField3)
		suffixExpression: nil.
]

{ #category : #fields }
DatabaseTable >> addForeignKeyFrom: sourceField to: targetField suffixExpression: suffixExpression [
	| newFK |
	newFK := ForeignKeyConstraint
					sourceField: sourceField
					targetField: targetField
					suffixExpression: suffixExpression.
	newFK name: (newFK name , (foreignKeyConstraints size + 1) printString).
	foreignKeyConstraints add: newFK.
	^newFK.
]

{ #category : #deprecated }
DatabaseTable >> addForeignKeyFrom: sourceField toField: targetField [

	self deprecated: 'Use #addForeignKeyFrom:to: instead'.	
	^self addForeignKeyFrom: sourceField to: targetField
]

{ #category : #fields }
DatabaseTable >> addForeignKeyFrom: sourceField toTable: targetTable [
	^self
		addForeignKeyFrom: sourceField
		to: (targetTable fieldNamed: 'ID' ifAbsent: [^nil])
]

{ #category : #fields }
DatabaseTable >> addForeignKeyFromAll: sourceFields toAll: targetFields [
	^self addForeignKeyFromAll: sourceFields toAll: targetFields suffixExpression: nil.
]

{ #category : #fields }
DatabaseTable >> addForeignKeyFromAll: sourceFields toAll: targetFields suffixExpression: suffixExpression [
	| newFK |
	newFK := ForeignKeyConstraint
					sourceFields: sourceFields
					targetFields: targetFields
					suffixExpression: suffixExpression.
	newFK name: (newFK name , (foreignKeyConstraints size + 1) printString).
	^foreignKeyConstraints add: newFK.
]

{ #category : #indexes }
DatabaseTable >> addIndex: aDatabaseIndex [
	^indexes add: aDatabaseIndex.
]

{ #category : #indexes }
DatabaseTable >> addIndexForField: aField [
	^indexes add: (DatabaseIndex forField: aField).
]

{ #category : #indexes }
DatabaseTable >> addIndexForField: aField and: anotherField [
	^self addIndexForFields: (Array with: aField with: anotherField).
]

{ #category : #indexes }
DatabaseTable >> addIndexForField: aField and: anotherField and: thirdField [
	^self addIndexForFields: (Array with: aField with: anotherField with: thirdField).
]

{ #category : #indexes }
DatabaseTable >> addIndexForFields: aFieldCollection [
	^indexes add: (DatabaseIndex forFields: aFieldCollection).
]

{ #category : #fields }
DatabaseTable >> addUniqueConstraintFor: sourceFields [

	| newConstraint |
	newConstraint := UniqueConstraint
		forTable: self
		fields: sourceFields.
	^uniqueConstraints add: newConstraint
]

{ #category : #accessing }
DatabaseTable >> allSequences [
	"Return a dictionary of all the sequences associated with this table, indexed by name."

	| result |
	result := Dictionary new.
	self fields do: [:eachField | 
 		eachField type hasSequence ifTrue:
			[result at: eachField type sequence name put: eachField type sequence]].
	^result.
]

{ #category : #fields }
DatabaseTable >> createFieldNamed: aString type: dbType [

	| existingField |
	existingField := fields detect: [:each | each name = aString] ifNone: [nil].
	(existingField notNil)
	ifTrue: [self error: 'field ', aString, ' already exists'].
	^self addField: (DatabaseField named: aString type: dbType)
]

{ #category : #accessing }
DatabaseTable >> creator [
	^self schema
]

{ #category : #accessing }
DatabaseTable >> creator: aString [
	"For backward-compatibility. Use schema: instead."
	self schema: aString.
]

{ #category : #obsolete }
DatabaseTable >> dropFields: aCollection fromAccessor: aDatabaseAccessor [
	aCollection
		do:
			[:each | 
			aDatabaseAccessor
				execute:
					[aDatabaseAccessor
						executeSQLStringNoResult:
							'ALTER TABLE ' , self name , ' DROP COLUMN ' , each name]
				ifError: [:ex | ex pass]].
]

{ #category : #obsolete }
DatabaseTable >> dropForeignKeyConstraintsFromAccessor: aDatabaseAccessor [ 
	self foreignKeyConstraints 
		do: [:each | aDatabaseAccessor dropConstraint: each]
]

{ #category : #'create/delete in db' }
DatabaseTable >> dropFromAccessor: aDatabaseAccessor [
	aDatabaseAccessor platform supportsConstraints
		ifTrue: [self dropPrimaryKeyConstraintsFromAccessor: aDatabaseAccessor].
	aDatabaseAccessor dropTableNamed: self name.
]

{ #category : #obsolete }
DatabaseTable >> dropPrimaryKeyConstraintsFromAccessor: aDatabaseAccessor [
	(self primaryKeyFields isEmpty not and: [self platform usesPrimaryKeyUniqueConstraintNames])
		ifTrue: [
			aDatabaseAccessor	execute:
				[aDatabaseAccessor
						executeSQLStringNoResult:
							'ALTER TABLE ' , self name , ' DROP '
								, self platform nameForPrimaryKeyConstraintsWhenDropping , ' '
								, self primaryKeyUniqueConstraintName]
				ifError:
					[:ex | 
					Transcript show: ex messageText.
					ex return: nil].
		aDatabaseAccessor execute: [
			aDatabaseAccessor executeSQLStringNoResult:
					'ALTER TABLE ' , self name , ' DROP '
						, self platform nameForPrimaryKeyConstraintsWhenDropping , ' '
						, self primaryKeyConstraintName]
			ifError: [:ex | 
				Transcript show: ex messageText.
				ex return: nil]].
]

{ #category : #fields }
DatabaseTable >> fieldNamed: aString [

	^self fieldNamed: aString ifAbsent: [self error: 'No field ', aString, ' in ', self name].
]

{ #category : #fields }
DatabaseTable >> fieldNamed: aString ifAbsent: aBlock [

	^self fieldNamed: aString ifAbsent: aBlock caseSensitive: false.
]

{ #category : #fields }
DatabaseTable >> fieldNamed: aString ifAbsent: aBlock caseSensitive: aBoolean [
	| fieldName |
	fieldName := aBoolean ifTrue: [aString asString] ifFalse: [aString asUppercase].
	^fields
		detect:
			[:each | (aBoolean ifTrue: [each name] ifFalse: [each name asUppercase]) = fieldName]
		ifNone: aBlock.
]

{ #category : #accessing }
DatabaseTable >> fields [

	^fields
]

{ #category : #accessing }
DatabaseTable >> foreignKeyConstraints [
	"Private - Answer the value of the receiver's ''foreignKeyConstraints'' instance variable."

	^foreignKeyConstraints
]

{ #category : #accessing }
DatabaseTable >> foreignKeyConstraintsForCreation [
	"Return the foreign key constraints that should actually be created in the database. Omit those that refer to imaginary tables"
	^foreignKeyConstraints select: [:each |
		each isImaginary not and: [each shouldCreateInDatabase]].
]

{ #category : #constraints }
DatabaseTable >> foreignKeyConstraintsForField: aField [
	^self foreignKeyConstraints select: [:each | each sourceFields includes: aField].
]

{ #category : #'private/fields' }
DatabaseTable >> foreignKeyFields [
	"Answer the receiver's fields which are part of any foreign key constraints.  (This was called by DatabaseRow>>canUpdateRow:, now discarded as a needless check for a never-naturally-occurring condition, but is left as a utility method.)"

	^self foreignKeyConstraints
		inject: IdentitySet new
		into: [:sum :eachConstraint |
			sum addAll: eachConstraint sourceFields.
			sum]
]

{ #category : #testing }
DatabaseTable >> hasCompositePrimaryKey [

	^primaryKeyFields size > 1.
]

{ #category : #testing }
DatabaseTable >> hasConstraints [
	^self hasForeignKeyConstraints or: [self hasPrimaryKeyConstraints or: [self hasUniqueConstraints]]
]

{ #category : #testing }
DatabaseTable >> hasConstraintsTo: aTable [
	self foreignKeyConstraints
		do: [:each | (each refersToTable: aTable) ifTrue: [^true]].
	^false.
]

{ #category : #testing }
DatabaseTable >> hasConstraintsToAnyOf: aCollectionOfTables [
	aCollectionOfTables do: [:each |
		(self hasConstraintsTo: each) ifTrue: [^true]].
	^false.
]

{ #category : #testing }
DatabaseTable >> hasFieldNamed: aString [

	^(self fieldNamed: aString ifAbsent: [nil] caseSensitive: false) notNil.
]

{ #category : #testing }
DatabaseTable >> hasForeignKeyConstraintMatching: aConstraint [
	^self foreignKeyConstraints
		anySatisfy: [:each | (each matchesForeignKeyConstraint: aConstraint)].
]

{ #category : #testing }
DatabaseTable >> hasForeignKeyConstraintTheSameAs: aConstraint [

	^self foreignKeyConstraints anySatisfy: [:each | (each isTheSameAs: aConstraint)].
]

{ #category : #testing }
DatabaseTable >> hasForeignKeyConstraints [
	^foreignKeyConstraints isEmpty not
]

{ #category : #constraints }
DatabaseTable >> hasForeignKeyConstraintsForField: aField [
	^self foreignKeyConstraints anySatisfy: [:each | each sourceFields includes: aField].
]

{ #category : #constraints }
DatabaseTable >> hasForeignKeyConstraintsForTargetField: aField [
	^self foreignKeyConstraints anySatisfy: [:each | each targetFields includes: aField].
]

{ #category : #indexes }
DatabaseTable >> hasIndexForField: aField [
	^(indexes detect: [:each | each indexesField: aField] ifNone: [nil]) notNil.
]

{ #category : #testing }
DatabaseTable >> hasIndexNamed: aString [

	^indexes contains: [:each | each name = aString]
]

{ #category : #testing }
DatabaseTable >> hasPrimaryKeyConstraints [
	^self primaryKeyFields isEmpty not.
]

{ #category : #testing }
DatabaseTable >> hasUniqueConstraintMatching: aConstraint [
	
	^self uniqueConstraints anySatisfy: [:each | each matchesUniqueConstraint: aConstraint]
]

{ #category : #testing }
DatabaseTable >> hasUniqueConstraints [
	^uniqueConstraints isEmpty not
]

{ #category : #printing }
DatabaseTable >> imaginaryReplacementName [
	| stream |
	stream := WriteStream on: (String new: 100).
	stream nextPut: $(.
	stream nextPutAll: (replacementSubSelect sqlWith: #()) sqlString.
	stream nextPutAll: ') '.
	^stream contents.
]

{ #category : #indexes }
DatabaseTable >> indexes [
	^indexes.
]

{ #category : #initialization }
DatabaseTable >> initialize [

	schema := ''.
	fields := OrderedCollection new.
	foreignKeyConstraints := OrderedCollection new: 4.
	uniqueConstraints := OrderedCollection new.
	lockKeyFields := OrderedCollection new.
	indexes := OrderedCollection new.
	isImaginary := false.
]

{ #category : #accessing }
DatabaseTable >> isAliased [
	^parent notNil.
]

{ #category : #testing }
DatabaseTable >> isEmpty [
	^fields isEmpty.
]

{ #category : #accessing }
DatabaseTable >> isImaginary [
	^isImaginary.
]

{ #category : #accessing }
DatabaseTable >> isImaginary: aBoolean [
	isImaginary := aBoolean.
]

{ #category : #comparing }
DatabaseTable >> isTheSameAs: aDatabaseTable [
	"Validate that two tables are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aDatabaseTable name asUppercase ifFalse: [^false].
	"For the test purposes, we won't worry about schema right now."
"	self schema = aDatabaseTable schema ifFalse: [^false]."
	self fields size = aDatabaseTable fields size ifFalse: [^false].
	self fields asSortedCollection with: aDatabaseTable fields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self foreignKeyConstraints size = aDatabaseTable foreignKeyConstraints size ifFalse: [^false].
	self foreignKeyConstraints with: aDatabaseTable foreignKeyConstraints do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self indexes with: aDatabaseTable indexes do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self lockKeyFields with: aDatabaseTable lockKeyFields do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self primaryKeyFields size = aDatabaseTable primaryKeyFields size ifFalse: [^false].
	self primaryKeyFields asSortedCollection with: aDatabaseTable primaryKeyFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self isImaginary = aDatabaseTable isImaginary ifFalse: [^false].
	^true.
	"Note, we ignore parent and replacementSubselect"
]

{ #category : #accessing }
DatabaseTable >> lockKeyFields [

	^lockKeyFields
]

{ #category : #accessing }
DatabaseTable >> name [

	^name
]

{ #category : #accessing }
DatabaseTable >> name: anObject [

	name := anObject
]

{ #category : #fields }
DatabaseTable >> newFieldNamed: aString [

	^self error: 'use #createFieldNamed:type:'
]

{ #category : #accessing }
DatabaseTable >> nonPrimaryKeyFields [

	^self fields reject: [:each | each isPrimaryKey].
]

{ #category : #accessing }
DatabaseTable >> parent [

	^parent.
]

{ #category : #accessing }
DatabaseTable >> parent: aDatabaseTable [

	parent := aDatabaseTable.
]

{ #category : #accessing }
DatabaseTable >> platform [
	fields do: [:each | ^each type platform].
	^nil.
]

{ #category : #initialization }
DatabaseTable >> postInitializeIn: aDescriptorSystem [
	"Any initialization that happens after all the fields have been added"
	1 to: fields size do: [:i |
		| each | 
		"If fields were read from the database, set their position now"
		each := fields at: i.
		each table: self.
		each position: i.
		each postInitializeIn: aDescriptorSystem].
]

{ #category : #obsolete }
DatabaseTable >> primaryKeyConstraintName [

	^self name, '_PK'.
]

{ #category : #accessing }
DatabaseTable >> primaryKeyConstraints [
	"Answer the value of the receiver's ''PrimaryKeyConstraints'' instance variable."
	^self hasPrimaryKeyConstraints
		ifTrue: [ PrimaryKeyConstraint forTable: self ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
DatabaseTable >> primaryKeyFields [

	primaryKeyFields isNil ifTrue: [primaryKeyFields := fields select: [:each | each isPrimaryKey yourSelf "might be a proxy"]].
	^primaryKeyFields.
]

{ #category : #obsolete }
DatabaseTable >> primaryKeyUniqueConstraintName [
	^self platform usesPrimaryKeyUniqueConstraintNames ifTrue: [self name, '_UNIQ'] ifFalse: [''].
]

{ #category : #obsolete }
DatabaseTable >> printAddPrimaryKeyConstraintsOn: aStream for: aDatabaseAccessor [ 
	self primaryKeyFields isEmpty ifTrue: [^self].
	aStream nextPutAll: 'ALTER TABLE ' , self name.
	aStream nextPutAll: ' ADD CONSTRAINT '.
	aStream nextPutAll: self primaryKeyConstraintName.
	aStream nextPutAll: ' PRIMARY KEY  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: self primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $).

	aStream
		nextPutAll: ',';
		cr.

	aStream nextPutAll: ' ADD CONSTRAINT '.
	aStream nextPutAll: self primaryKeyUniqueConstraintName.
	aStream nextPutAll: ' UNIQUE  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: self primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $)
]

{ #category : #obsolete }
DatabaseTable >> printDelimiterOn: aStream [
	
	aStream
		nextPut: $,;
		cr
]

{ #category : #printing }
DatabaseTable >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: ((schema isNil or: [schema isEmpty]) ifTrue: [''] ifFalse: [schema, '.']);
		nextPutAll: (name isNil ifTrue: [''] ifFalse: [name]);
		nextPutAll: ')'.
]

{ #category : #obsolete }
DatabaseTable >> printPrimaryKeyConstraintsOn: aStream for: aDatabaseAccessor [ 
	self primaryKeyFields isEmpty ifTrue: [^self].
	aStream nextPutAll: 'CONSTRAINT '.
	aStream nextPutAll: self primaryKeyConstraintName.
	aStream nextPutAll: ' PRIMARY KEY  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: self primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $).

	aStream
		nextPutAll: ',';
		cr.

	aStream nextPutAll: 'CONSTRAINT '.
	aStream nextPutAll: self primaryKeyUniqueConstraintName.
	aStream nextPutAll: ' UNIQUE  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: self primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $)
]

{ #category : #printing }
DatabaseTable >> printSQLOn: aWriteStream withParameters: aDictionary [
	aWriteStream nextPutAll: self qualifiedName
]

{ #category : #accessing }
DatabaseTable >> qualifiedName [

	^(schema isNil or: [schema isEmpty]) ifTrue: [name] ifFalse: [schema, '.', name].
]

{ #category : #fields }
DatabaseTable >> removeFieldNamed: aString [
	^self removeFieldNamed: aString ifAbsent: [self error: 'No such field'].
]

{ #category : #fields }
DatabaseTable >> removeFieldNamed: aString ifAbsent: aBlock [
	
	fields remove: (self fieldNamed: aString ifAbsent: aBlock).
	1 to: fields size do: [:i | (fields at: i) position: i].
]

{ #category : #accessing }
DatabaseTable >> replacementSubSelect: aQuery [
	replacementSubSelect := aQuery.
]

{ #category : #accessing }
DatabaseTable >> schema [
	^schema
]

{ #category : #accessing }
DatabaseTable >> schema: aString [

	schema := aString.
	parent isNil ifTrue: [
		self sequences do: [:each | each schema: aString]].
]

{ #category : #accessing }
DatabaseTable >> sequences [
	"Return a collection (which is likely either empty or of size 1) of all the sequences we use."
	| sequences |
	sequences := OrderedCollection new: 2.
	self primaryKeyFields do: [:each | each type hasSequence ifTrue: [sequences add: each type sequence]].
	^sequences.
]

{ #category : #accessing }
DatabaseTable >> shouldBeWritten [
	^isImaginary not.
]

{ #category : #printing }
DatabaseTable >> sqlString [

	^name.
]

{ #category : #printing }
DatabaseTable >> sqlTableName [
	"Our name, as appropriate for the list of tables in a SQL statement. Take into account aliasing"

	^parent isNil
		ifTrue:
			[self isImaginary
				ifTrue: [self imaginaryReplacementName]
				ifFalse: [self qualifiedName]]
		ifFalse: [parent sqlTableName , ' ' , self qualifiedName].
]

{ #category : #accessing }
DatabaseTable >> uniqueConstraints [
	"Private - Answer the value of the receiver's ''uniqueConstraints'' instance variable."

	^uniqueConstraints
]

{ #category : #printing }
DatabaseTable >> unqualifiedSqlTableName [
	"Our name, as appropriate for the list of tables in a SQL statement. Take into account aliasing"

	^parent isNil
		ifTrue:
			[self isImaginary
				ifTrue: [self imaginaryReplacementName]
				ifFalse: [self qualifiedName]]
		ifFalse: [parent sqlTableName].
]

{ #category : #validation }
DatabaseTable >> validateIn: aDescriptorSystem [
	"Do any tests we can to make sure that this definition makes sense in this context"
]
