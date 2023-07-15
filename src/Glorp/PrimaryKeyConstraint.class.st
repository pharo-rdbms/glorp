"
This is a class representing non-foreign key database constraints. It's not actually used for very much, but is mostly so we can model the metadata in the database's information_schema to get information we need about primary keys and other information that may be represented as constraints rather than field attributes.
"
Class {
	#name : #PrimaryKeyConstraint,
	#superclass : #DatabaseTableConstraint,
	#instVars : [
		'tableName',
		'type'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
PrimaryKeyConstraint class >> forTable: aDatabaseTable fields: collDatabaseFields [
	^self new
		forTable: aDatabaseTable  fields: collDatabaseFields;
		yourself
]

{ #category : #printing }
PrimaryKeyConstraint >> creationStringFor: aPlatform [

	^ aPlatform createPrimaryKeyConstraintAddStatement: self
]

{ #category : #accessing }
PrimaryKeyConstraint >> forTable: aTable [

	super forTable: aTable.
	name := self primaryKeyConstraintName.
	self primaryKeyFields:  table primaryKeyFields
]

{ #category : #initialization }
PrimaryKeyConstraint >> forTable: aDatabaseTable fields: collDatabaseFields [

	self forTable: aDatabaseTable.
	self primaryKeyFields: collDatabaseFields
]

{ #category : #accessing }
PrimaryKeyConstraint >> generateName [

	^ self table name, '_PK'
]

{ #category : #testing }
PrimaryKeyConstraint >> isPrimaryKeyConstraint [

	^ true
]

{ #category : #comparing }
PrimaryKeyConstraint >> isTheSameAs: aPrimaryKeyConstraint [
	"Validate that two constraints are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."

	self name asUppercase = aPrimaryKeyConstraint name asUppercase ifFalse: [^false].
	self primaryKeyFields size = aPrimaryKeyConstraint primaryKeyFields size ifFalse: [^false].
	self primaryKeyFields asSortedCollection with: aPrimaryKeyConstraint primaryKeyFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self shouldCreateInDatabase = aPrimaryKeyConstraint shouldCreateInDatabase ifFalse: [^false].
	^ true
]

{ #category : #testing }
PrimaryKeyConstraint >> matchesPrimaryKeyConstraint: aConstraint [

	name = aConstraint name ifFalse: [^false].
	self primaryKeyFields size ~= aConstraint primaryKeyFields size ifTrue: [^false].
	self primaryKeyFields with: aConstraint primaryKeyFields do: [ :field1 :field2 |
		(field1 matchesField: field2) ifFalse: [^false]].
	^ true
]

{ #category : #accessing }
PrimaryKeyConstraint >> primaryKeyConstraintName [

	^ self table name, '_PK'
]

{ #category : #accessing }
PrimaryKeyConstraint >> primaryKeyFields [

	^ fields
]

{ #category : #accessing }
PrimaryKeyConstraint >> primaryKeyFields: aCollection [

	fields := aCollection
]
