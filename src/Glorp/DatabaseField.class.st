"
This represents a field in a database table. See also DatabaseTable. Glorp relies heavily on identity of fields for comparison purposes, so be careful when copying these.

Instance Variables:
	defaultValue	<Object>	What is the default value of this field, if unspecified in the creation statement.
	isLockKey	<Boolean>	Is this field part of an optimistic lock key. If so, then on update we will generate an update statement that checks that this value hasn't changed since the object wasn't read.
	isNullable	<Boolean>	Is this field allowed to be null?
	isPrimaryKey	<Boolean>	Is this field part of the primary key?
	isUnique	<Boolean>	Does this field have a unique constraint in the database?
	name	<String>	The name of the field.
	position	<Object | ProtoObject>	description of position
	table	<DatabaseTable>	The table that contains this field.
	type	<GlorpDatabaseType>	The type of  data that this field contains.


"
Class {
	#name : #DatabaseField,
	#superclass : #Object,
	#instVars : [
		'table',
		'name',
		'isPrimaryKey',
		'position',
		'type',
		'isNullable',
		'isUnique',
		'isLockKey',
		'defaultValue'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
DatabaseField class >> named: aString [

	^self error: 'type needed'
]

{ #category : #'*Glorp' }
DatabaseField class >> named: aString type: dbType [

	^super new initialize
		name: aString;
		type: dbType
]

{ #category : #'*Glorp' }
DatabaseField class >> new [

	^self error: 'dbType needed'
]

{ #category : #comparing }
DatabaseField >> <= aField [

	^ self name <= aField name
]

{ #category : #obsolete }
DatabaseField >> asConstraintReferenceString [

	^ table name , ' (' , self name , ')'
]

{ #category : #converting }
DatabaseField >> asDistinctFieldOn: anExpression [

	^ (anExpression getField: self) asDistinctFieldOn: anExpression
]

{ #category : #converting }
DatabaseField >> asField [

	^ self
]

{ #category : #converting }
DatabaseField >> asGlorpExpression [

	^ ParameterExpression forField: self basedOn: nil
]

{ #category : #converting }
DatabaseField >> asGlorpExpressionOn: anExpression [

	^ ParameterExpression forField: self basedOn: anExpression
]

{ #category : #configuring }
DatabaseField >> beIndexed [

	self table addIndex: (DatabaseIndex forField: self)
]

{ #category : #configuring }
DatabaseField >> beLockKey [

	isLockKey := true.
	self table isNil ifFalse: [ self table addAsLockKeyField: self ]
]

{ #category : #configuring }
DatabaseField >> beNullable: aBoolean [

	self isPrimaryKey ifFalse: [ isNullable := aBoolean ]
]

{ #category : #configuring }
DatabaseField >> bePrimaryKey [

	isPrimaryKey := true.
	isNullable := false.
	self table isNil ifFalse: [ self table addAsPrimaryKeyField: self ]
]

{ #category : #converting }
DatabaseField >> converterForStType: aClass [

	^ self type converterForStType: (aClass isBehavior
			   ifTrue: [ aClass ]
			   ifFalse: [ aClass class ])
]

{ #category : #accessing }
DatabaseField >> defaultValue [

	^ defaultValue
]

{ #category : #configuring }
DatabaseField >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #accessing }
DatabaseField >> foreignKeyConstraints [

	^ self table foreignKeyConstraints select: [ :each |
		  each sourceFields includes: self ]
]

{ #category : #accessing }
DatabaseField >> impliedSmalltalkType [
	"Return the default Smalltalk type corresponding to our database type"

	^ self type impliedSmalltalkType
]

{ #category : #initialization }
DatabaseField >> initialize [

	isPrimaryKey := false.
	isNullable := true.
	isUnique := false.
	isLockKey := false
]

{ #category : #testing }
DatabaseField >> isDistinct [

	^ false
]

{ #category : #testing }
DatabaseField >> isGenerated [

	^ type isGenerated or: [ defaultValue notNil ]
]

{ #category : #testing }
DatabaseField >> isIndexed [

	^ self table hasIndexForField: self
]

{ #category : #testing }
DatabaseField >> isLockKey [

	isLockKey isNil ifTrue: [ isLockKey := false ].
	^ isLockKey
]

{ #category : #testing }
DatabaseField >> isMappable [
	"Return true if we're something that can be returned in a select statement. Always true for fields"

	^ true
]

{ #category : #testing }
DatabaseField >> isNullable [

	^ isNullable
]

{ #category : #testing }
DatabaseField >> isPrimaryKey [
	"Private - Answer the value of the receiver's ''isPrimaryKey'' instance variable."

	^ isPrimaryKey yourSelf
]

{ #category : #copying }
DatabaseField >> isSameAliasedFieldAs: aField [
	"Return true if we are the same as another aliased field. For non-aliased fields, identity is assured, so this is redundant. Note that we == the string. This will work because we know these must both be shallow copies of the same thing"

	self class == aField class ifFalse: [ ^ false ].
	^ self table == aField table and: [ self name == aField name ]
]

{ #category : #comparing }
DatabaseField >> isTheSameAs: aDatabaseField [
	"Validate that two fields are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."

	self name asUppercase = aDatabaseField name asUppercase ifFalse: [^false].
	self isPrimaryKey = aDatabaseField isPrimaryKey ifFalse: [^false].
	(self isTheSameTypeAs: aDatabaseField) ifFalse: [^false].
	self isNullable = aDatabaseField isNullable ifFalse: [^false].
	self isUnique = aDatabaseField isUnique ifFalse: [^false].
	self isLockKey = aDatabaseField isLockKey ifFalse: [^false].
	self defaultValue = aDatabaseField defaultValue ifFalse: [^false].
	^ true
]

{ #category : #comparing }
DatabaseField >> isTheSameTypeAs: aDatabaseField [
	| myType aType |
	self isPrimaryKey
		ifTrue:
		   [myType := self type.
		   aType := aDatabaseField type.
		   ^(myType = aType
				or: [(myType isSerial or: [aType isSerial ])
					and: [myType impliedSmalltalkType = aType impliedSmalltalkType ]]) ].

	^ self type = aDatabaseField type
]

{ #category : #testing }
DatabaseField >> isUnique [

	isUnique isNil ifTrue: [ isUnique := false ].
	^ isUnique
]

{ #category : #configuring }
DatabaseField >> isUnique: aBoolean [

	isUnique := aBoolean
]

{ #category : #testing }
DatabaseField >> matchesField: aField [
	table name = aField table name ifFalse: [^false].
	name = aField name ifFalse: [^false].
	isNullable = aField isNullable ifFalse: [^false].
	isPrimaryKey = aField isPrimaryKey ifFalse: [^false].
	isUnique = aField isUnique ifFalse: [^false].
	
	^true
]

{ #category : #accessing }
DatabaseField >> name [
	"Private - Answer the value of the receiver's ''name'' instance variable."

	^ name
]

{ #category : #accessing }
DatabaseField >> name: aString [
	"Private - Set the value of the receiver's ''name'' instance variable to the argument, anObject."

	name := aString asString
]

{ #category : #accessing }
DatabaseField >> platform [

	^ self type platform
]

{ #category : #accessing }
DatabaseField >> position [

	^ position
]

{ #category : #accessing }
DatabaseField >> position: anObject [

	position := anObject
]

{ #category : #initialization }
DatabaseField >> postInitializeIn: aDescriptorSystem [
	"Any initialization that has to be delayed until we're in the table"

	type initializeForField: self in: aDescriptorSystem
]

{ #category : #obsolete }
DatabaseField >> printForConstraintNameOn: aStream maxLength: maxLength [

	| constraintName |
	constraintName := table name , '_' , name.
	constraintName size > maxLength ifTrue: [
		constraintName := constraintName copyFrom: 1 to: maxLength ].
	aStream nextPutAll: constraintName
]

{ #category : #obsolete }
DatabaseField >> printNameOn: aStream withParameters: anArray [

	aStream nextPutAll: self name
]

{ #category : #printing }
DatabaseField >> printOn: aStream [

	aStream nextPutAll: 'Field'.
	aStream
		nextPutAll: '(';
		nextPutAll: (table isNil ifTrue: [''] ifFalse: [table name]);
		nextPutAll: '.';
		nextPutAll: name;
		nextPutAll: ')'
]

{ #category : #obsolete }
DatabaseField >> printQualifiedSQLOn: aStream withParameters: aDictionary [

	aStream nextPutAll: self qualifiedName
]

{ #category : #printing }
DatabaseField >> printSQLOn: aStream withParameters: anArray [

	aStream nextPutAll: self quotedQualifiedName
]

{ #category : #printing }
DatabaseField >> printSelectSQLOn: aStream withParameters: anArray [

	self printSQLOn: aStream withParameters: anArray
]

{ #category : #printing }
DatabaseField >> printUnqualifiedSQLOn: aStream withParameters: anArray [

	aStream nextPutAll: self name
]

{ #category : #querying }
DatabaseField >> qualifiedName [

	^ table isNil
		  ifTrue: [ self name ]
		  ifFalse: [ self table qualifiedName , '.' , self name ]
]

{ #category : #querying }
DatabaseField >> quotedQualifiedName [

	| basicName |
	basicName := self platform nameForColumn: self name.
	^ table isNil
		  ifTrue: [ basicName ]
		  ifFalse: [ self table qualifiedName , '.' , basicName ]
]

{ #category : #accessing }
DatabaseField >> table [

	^ table
]

{ #category : #accessing }
DatabaseField >> table: anObject [

	table := anObject
]

{ #category : #accessing }
DatabaseField >> tablesToPrint [

	^ Array with: table
]

{ #category : #accessing }
DatabaseField >> type [

	^ type
]

{ #category : #configuring }
DatabaseField >> type: aDatabaseType [

	type := aDatabaseType.
	(type notNil and: [ type isSerial ]) ifTrue: [ self bePrimaryKey ]
]

{ #category : #database }
DatabaseField >> typeString [

	^ type typeString
]

{ #category : #copying }
DatabaseField >> withTable: aTable [
	"Return a copy of ourselves, with the table set to aTable. Presumably aTable is an aliased version of our table"

	^ self copy table: aTable
]
