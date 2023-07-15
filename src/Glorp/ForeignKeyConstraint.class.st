"
This represents a foreign key constraint in the database. It's used during table creation, but more important it's used when calculating the order in which we need to write rows. Also, if joins aren't specified on a relationship, we will try to infer them from the foreign key constraints.

Instance Variables:
	name	<Object>	The name of the constraint.
	shouldCreateInDatabase	<Boolean>	We may have table definitions that we don't want to create in the database, either because we know they're already there, or because they are for ""imaginary"" tables.
	sourceFields	<(SequenceableCollection of: DatabaseField)>	The fields we constrain from. The order is fairly arbitrary, but at least we use it consistently.
	suffixExpression	<String>	A bit of a hack to allow us to append some extra text to the constraint. In particular, added to suppor the ability to append ""ON DELETE CASCADE"".
	targetFields	<(SequenceableCollection of: DatabaseField)>	The fields we constraint to.


"
Class {
	#name : #ForeignKeyConstraint,
	#superclass : #DatabaseTableConstraint,
	#instVars : [
		'suffixExpression',
		'sourceFields',
		'targetFields'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
ForeignKeyConstraint class >> sourceField: aDatabaseField targetField: anotherDatabaseField [

	^ self
		  sourceField: aDatabaseField
		  targetField: anotherDatabaseField
		  suffixExpression: nil
]

{ #category : #'*Glorp' }
ForeignKeyConstraint class >> sourceField: aDatabaseField targetField: anotherDatabaseField suffixExpression: suffixExpression [

	^ self new
		  sourceField: aDatabaseField
		  targetField: anotherDatabaseField
		  suffixExpression: suffixExpression;
		  yourself
]

{ #category : #'*Glorp' }
ForeignKeyConstraint class >> sourceFields: sourceFields targetFields: targetFields [

	^ self
		  sourceFields: sourceFields
		  targetFields: targetFields
		  suffixExpression: nil
]

{ #category : #'*Glorp' }
ForeignKeyConstraint class >> sourceFields: sourceFields targetFields: targetFields suffixExpression: suffixExpression [

	^ self new
		  sourceFields: sourceFields
		  targetFields: targetFields
		  suffixExpression: suffixExpression;
		  yourself
]

{ #category : #accessing }
ForeignKeyConstraint >> addSourceField: aField [

	(self sourceFields allSatisfy: [ :each | aField table = each table ])
		ifFalse: [
			self error:
				'Fields in foreign key constraints must all have the same source table' ].
	self sourceFields add: aField
]

{ #category : #accessing }
ForeignKeyConstraint >> addTargetField: aField [

	(self targetFields allSatisfy: [ :each | aField table = each table ])
		ifFalse: [
			self error:
				'Fields in foreign key constraints must all have the same target table' ].
	self targetFields add: aField
]

{ #category : #converting }
ForeignKeyConstraint >> asJoin [

	^ Join fromAll: self sourceFields toAll: self targetFields
]

{ #category : #converting }
ForeignKeyConstraint >> asReverseJoin [

	^ Join fromAll: self targetFields toAll: self sourceFields
]

{ #category : #printing }
ForeignKeyConstraint >> creationStringFor: aPlatform [

	^ aPlatform createForeignKeyConstraintAddStatement: self
]

{ #category : #accessing }
ForeignKeyConstraint >> generateName [

	| stream maxLength tableLength roomToBeVerbose shortTableLength longTableLength |
	self sourceFields isEmpty ifTrue: [^'INVALID CONSTRAINT'].
	"Figure out if we have room for verbose separators or if we should maximize the space for the table/field names"
	maxLength := self sourceFields first table platform maximumLengthOfTableName.
	shortTableLength := ((maxLength - 8) // 2) min: 10.
	longTableLength := (maxLength // 2) - 1.
	roomToBeVerbose := shortTableLength >= 10.
	tableLength := roomToBeVerbose ifTrue: [shortTableLength] ifFalse: [longTableLength].

	stream := WriteStream on: (String new: 100).
	self printForConstraintName: self sourceFields first on: stream maxLength: tableLength.
	roomToBeVerbose ifTrue: [stream nextPutAll: '_TO_'].
	self printForConstraintName: self targetFields first on: stream maxLength: tableLength.
	stream nextPutAll: (roomToBeVerbose ifTrue: ['_REF'] ifFalse: ['R']).
	^ stream contents
]

{ #category : #initialization }
ForeignKeyConstraint >> initialize [

	super initialize.
	self sourceFields: (OrderedCollection new: 2).
	targetFields := OrderedCollection new: 2
]

{ #category : #testing }
ForeignKeyConstraint >> isForeignKeyConstraint [

	^ true
]

{ #category : #testing }
ForeignKeyConstraint >> isImaginary [

	^ self targetTable isImaginary or: [ self sourceTable isImaginary ]
]

{ #category : #testing }
ForeignKeyConstraint >> isSimilarForeignKeyConstraint: aConstraint [

	self sourceFields size ~= aConstraint sourceFields size ifTrue: [^false].
	self sourceFields asSortedCollection with: aConstraint sourceFields asSortedCollection do: [:field1 :field2 |
		(field1 matchesField: field2) ifFalse: [^false]].

	self targetFields size ~= aConstraint targetFields size ifTrue: [^false].
	self targetFields asSortedCollection with: aConstraint targetFields asSortedCollection do: [:field1 :field2 |
		(field1 matchesField: field2) ifFalse: [^false]].

	^ true
]

{ #category : #comparing }
ForeignKeyConstraint >> isTheSameAs: aForeignKeyConstraint [

	"Validate that two constraints are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aForeignKeyConstraint name asUppercase ifFalse: [^false].
	self suffixExpression = aForeignKeyConstraint suffixExpression ifFalse: [^false].
	self sourceFields size ~= aForeignKeyConstraint sourceFields size ifTrue: [^false].
	self sourceFields asSortedCollection with: aForeignKeyConstraint sourceFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self targetFields size ~= aForeignKeyConstraint targetFields size ifTrue: [^false].
	self targetFields asSortedCollection with: aForeignKeyConstraint targetFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self shouldCreateInDatabase = aForeignKeyConstraint shouldCreateInDatabase ifFalse: [^false].

	^ true
]

{ #category : #testing }
ForeignKeyConstraint >> matchesForeignKeyConstraint: aConstraint [

	name asUppercase = aConstraint name asUppercase ifFalse: [^false].
	self sourceFields size ~= aConstraint sourceFields size ifTrue: [^false].
	self sourceFields with: aConstraint sourceFields do: [:field1 :field2 |
		(field1 matchesField: field2) ifFalse: [^false]].

	self targetFields size ~= aConstraint targetFields size ifTrue: [^false].
	self targetFields with: aConstraint targetFields do: [:field1 :field2 |
		(field1 matchesField: field2) ifFalse: [^false]].

	^ true
]

{ #category : #printing }
ForeignKeyConstraint >> printForConstraintName: aField on: aStream maxLength: maxLength [

	| constraintName |
	constraintName := aField table name , '_' , aField name.
	constraintName size > maxLength ifTrue: [
		constraintName := constraintName copyFrom: 1 to: maxLength ].
	aStream nextPutAll: constraintName
]

{ #category : #testing }
ForeignKeyConstraint >> refersToTable: aTable [

	^ self targetTable yourself == aTable
]

{ #category : #relationships }
ForeignKeyConstraint >> rowsRelatedTo: aRow [

	| myWrapper relatedRows sourceField targetField allWrappers |
	"Note that we don't care which field, as presumably all of them must point the same place for a composite key, so grab the first pair"
	sourceField := self sourceFields first.
	targetField := self targetFields first.
	myWrapper := aRow wrapperAt: sourceField ifAbsent: [ nil ].
	myWrapper ifNil: [ ^ #(  ) ].
	relatedRows := Set new: 5.
	allWrappers := OrderedCollection with: myWrapper.
	allWrappers addAll: myWrapper allInnerWrappers.
	allWrappers do: [ :eachWrapper |
		(eachWrapper containedBy
			 glorpAtIdentity: targetField
			 ifAbsent: [ #(  ) ]) do: [ :eachRow |
			eachRow == aRow ifFalse: [ relatedRows add: eachRow ] ] ].
	^ relatedRows
]

{ #category : #accessing }
ForeignKeyConstraint >> someSourceField [
	"Return any one of our source fields"

	^ self sourceFields first
]

{ #category : #accessing }
ForeignKeyConstraint >> sourceField: aField [

	self sourceFields isEmpty ifFalse: [self error: 'Adding a field to a non-empty constraint'].
	self sourceFields add: aField
]

{ #category : #initialization }
ForeignKeyConstraint >> sourceField: aDatabaseField targetField: anotherDatabaseField [

	self
		sourceField: aDatabaseField
		targetField: anotherDatabaseField
		suffixExpression: nil
]

{ #category : #initialization }
ForeignKeyConstraint >> sourceField: aDatabaseField targetField: anotherDatabaseField suffixExpression: suffixExpressionString [

	self
		sourceField: aDatabaseField;
		targetField: anotherDatabaseField;
		suffixExpression: suffixExpressionString
]

{ #category : #accessing }
ForeignKeyConstraint >> sourceFields [

	^ sourceFields
]

{ #category : #accessing }
ForeignKeyConstraint >> sourceFields: aCollection [

	sourceFields := aCollection
]

{ #category : #initialization }
ForeignKeyConstraint >> sourceFields: sourceFieldCollection targetFields: targetFieldCollection suffixExpression: suffixExpressionString [

	self
		sourceFields: sourceFieldCollection;
		targetFields: targetFieldCollection;
		suffixExpression: suffixExpressionString
]

{ #category : #accessing }
ForeignKeyConstraint >> sourceTable [
	"All the source fields have to come from the same table, so just pick one"

	^ self sourceFields first table
]

{ #category : #accessing }
ForeignKeyConstraint >> suffixExpression [

	^ suffixExpression
]

{ #category : #accessing }
ForeignKeyConstraint >> suffixExpression: anObject [

	suffixExpression := anObject
]

{ #category : #accessing }
ForeignKeyConstraint >> table [

	^ self sourceTable
]

{ #category : #accessing }
ForeignKeyConstraint >> targetField: aField [

	self targetFields isEmpty ifFalse: [self error: 'Adding a field to a non-empty constraint'].
	self targetFields add: aField
]

{ #category : #accessing }
ForeignKeyConstraint >> targetFields [

	^ targetFields
]

{ #category : #accessing }
ForeignKeyConstraint >> targetFields: aCollection [

	targetFields := aCollection
]

{ #category : #accessing }
ForeignKeyConstraint >> targetTable [
	"All the target fields have to come from the same table, so just pick one"

	^ self targetFields isEmpty ifTrue: [nil] ifFalse: [self targetFields first table]
]
