"
Abstract superclass reifying a constraint on a value in a column or between values in columns.

"
Abstract superclass reifying a constraint on a value in a column or between values in columns.

AbstractClass {
	#name : #DatabaseTableConstraint,
	#superclass : #Object,
	#instVars : [
		'name',
		'table',
		'shouldCreateInDatabase',
		'fields'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
AbstractClass class >> forTable: aDatabaseTable [
	^ self new
		  forTable: aDatabaseTable;
		  yourself
]

{ #category : #'*Glorp' }
AbstractClass class >> new [
	^super new initialize.
]

{ #category : #printing }
AbstractClass >> creationString [
	^(self creationStringFor: self table platform) first.
]

{ #category : #printing }
AbstractClass >> creationStringFor: aPlatform [
	^self subclassResponsibility
]

{ #category : #printing }
AbstractClass >> dropString [
	^self dropStringFor:  self table platform
]

{ #category : #printing }
AbstractClass >> dropStringFor: aPlatform [
	^aPlatform createConstraintDropStatement: self
]

{ #category : #accessing }
AbstractClass >> fields [
	^fields
]

{ #category : #accessing }
AbstractClass >> fields: anObject [
	fields := anObject
]

{ #category : #initialization }
AbstractClass >> forTable: aTable [
	table := aTable
]

{ #category : #accessing }
AbstractClass >> generateName [
	^self subclassResponsibility
]

{ #category : #initialization }
AbstractClass >> initialize [
	shouldCreateInDatabase := true.
]

{ #category : #testing }
AbstractClass >> isForeignKeyConstraint [
	^ false
]

{ #category : #testing }
AbstractClass >> isPrimaryKeyConstraint [
	^ false
]

{ #category : #testing }
AbstractClass >> isUniqueConstraint [
	^ false
]

{ #category : #accessing }
AbstractClass >> name [
	name isNil ifTrue: [ name := self generateName ].
	^ name
]

{ #category : #accessing }
AbstractClass >> name: aString [
	name := aString
]

{ #category : #printing }
AbstractClass >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
AbstractClass >> shouldCreateInDatabase [
	^ shouldCreateInDatabase ifNil: [ true ]
]

{ #category : #accessing }
AbstractClass >> shouldCreateInDatabase: aBoolean [
	"If false, then this is a constraint that we use for in-memory ordering, but it should not be created in the database, possibly for performance, or because it might cause a cycle"
	shouldCreateInDatabase := aBoolean
]

{ #category : #accessing }
AbstractClass >> table [
	^ table
]

{ #category : #accessing }
AbstractClass >> table: anObject [
	table := anObject
]
