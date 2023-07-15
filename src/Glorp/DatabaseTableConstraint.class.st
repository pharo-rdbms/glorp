"
Abstract superclass reifying a constraint on a value in a column or between values in columns.

"
Class {
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
DatabaseTableConstraint class >> forTable: aDatabaseTable [

	^ self new
		  forTable: aDatabaseTable;
		  yourself
]

{ #category : #testing }
DatabaseTableConstraint class >> isAbstract [

	^ self == DatabaseTableConstraint
]

{ #category : #accessing }
DatabaseTableConstraint >> creationString [

	^ (self creationStringFor: self table platform) first
]

{ #category : #printing }
DatabaseTableConstraint >> creationStringFor: aPlatform [

	^self subclassResponsibility
]

{ #category : #printing }
DatabaseTableConstraint >> dropString [

	^ self dropStringFor:  self table platform
]

{ #category : #printing }
DatabaseTableConstraint >> dropStringFor: aPlatform [

	^ aPlatform createConstraintDropStatement: self
]

{ #category : #accessing }
DatabaseTableConstraint >> fields [

	^ fields
]

{ #category : #accessing }
DatabaseTableConstraint >> fields: anObject [

	fields := anObject
]

{ #category : #accessing }
DatabaseTableConstraint >> forTable: aTable [

	table := aTable
]

{ #category : #accessing }
DatabaseTableConstraint >> generateName [

	^ self subclassResponsibility
]

{ #category : #initialization }
DatabaseTableConstraint >> initialize [

	shouldCreateInDatabase := true.
]

{ #category : #testing }
DatabaseTableConstraint >> isForeignKeyConstraint [

	^ false
]

{ #category : #testing }
DatabaseTableConstraint >> isPrimaryKeyConstraint [

	^ false
]

{ #category : #testing }
DatabaseTableConstraint >> isUniqueConstraint [

	^ false
]

{ #category : #accessing }
DatabaseTableConstraint >> name [

	name ifNil: [ name := self generateName ].
	^ name
]

{ #category : #accessing }
DatabaseTableConstraint >> name: aString [

	name := aString
]

{ #category : #printing }
DatabaseTableConstraint >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
DatabaseTableConstraint >> shouldCreateInDatabase [

	^ shouldCreateInDatabase ifNil: [ true ]
]

{ #category : #accessing }
DatabaseTableConstraint >> shouldCreateInDatabase: aBoolean [
	"If false, then this is a constraint that we use for in-memory ordering, but it should not be created in the database, possibly for performance, or because it might cause a cycle"

	shouldCreateInDatabase := aBoolean
]

{ #category : #accessing }
DatabaseTableConstraint >> table [

	^ table
]

{ #category : #accessing }
DatabaseTableConstraint >> table: anObject [

	table := anObject
]
