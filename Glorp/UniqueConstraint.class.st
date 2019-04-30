"
UniqueConstraint implementation has not been finished

Instance Variables:
	isForPrimaryKey	<Boolean>	description of isForPrimaryKey


"
Class {
	#name : #UniqueConstraint,
	#superclass : #DatabaseTableConstraint,
	#category : 'Glorp-Database'
}

{ #category : #'*Glorp' }
UniqueConstraint class >> forTable: aTable fields: aCollectionOfFields [

	| instance |
	instance := self new.
	instance forTable: aTable fields: aCollectionOfFields.
	^instance
]

{ #category : #printing }
UniqueConstraint >> creationStringFor: aPlatform [

	^aPlatform createUniqueConstraintAddStatement: self
]

{ #category : #'instance creation' }
UniqueConstraint >> forTable: aTable fields: aCollectionOfFields [

	self table: aTable.
	self fields: aCollectionOfFields
]

{ #category : #accessing }
UniqueConstraint >> generateName [
	| stream maxLength tableLength roomToBeVerbose shortTableLength longTableLength |
	(self fields isNil or: [self fields isEmpty]) ifTrue: [^'INVALID CONSTRAINT'].
	"Figure out if we have room for verbose separators or if we should maximize the space for the table/field names"
	maxLength := self fields first table platform maximumLengthOfTableName.
	shortTableLength := ((maxLength - 7) // 2) min: 10.
	longTableLength := (maxLength - 7).
	roomToBeVerbose := shortTableLength >= 10.
	tableLength := roomToBeVerbose ifTrue: [longTableLength] ifFalse: [shortTableLength].

	stream := WriteStream on: (String new: 100).
	self printForConstraintNames: self fields on: stream maxLength: tableLength.
	stream nextPutAll: (roomToBeVerbose ifTrue: ['_UNIQ'] ifFalse: ['U']).
	^stream contents.
]

{ #category : #testing }
UniqueConstraint >> isUniqueConstraint [

	^true
]

{ #category : #testing }
UniqueConstraint >> matchesUniqueConstraint: aConstraint [
	
	name asUppercase = aConstraint name asUppercase ifFalse: [^false].
	self fields size ~= aConstraint fields size ifTrue: [^false].
	self fields with: aConstraint fields do: [:each :other | (each matchesField: other) ifFalse: [^false]].
	^true
]

{ #category : #printing }
UniqueConstraint >> printForConstraintNames: aCollection on: aStream maxLength: maxLength [ 
	| constraintName |
	constraintName := self table name.
	aCollection do:
		[:each | constraintName := constraintName, each name].
	constraintName size > maxLength 
		ifTrue: [constraintName := constraintName copyFrom: 1 to: maxLength].
	aStream nextPutAll: constraintName
]
