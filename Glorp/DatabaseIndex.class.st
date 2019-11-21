"
This describes an index in the database. Glorp doesn't use it internally, other than when creating tables in the database.

Instance Variables:
	fields	<(SequenceableCollection of: DatabaseField)>	The set of fields that are to be indexed.
	name	<String>	The name of the index. We will try and generate one based on the table if one is not supplied.


"
Class {
	#name : #DatabaseIndex,
	#superclass : #Object,
	#instVars : [
		'name',
		'fields'
	],
	#category : 'Glorp-Database'
}

{ #category : #'*Glorp' }
DatabaseIndex class >> forField: aField [
	^(self new initialize)
		addField: aField;
		yourself
]

{ #category : #'*Glorp' }
DatabaseIndex class >> forFields: aCollection [
	^(self new)
		addFields: aCollection;
		yourself
]

{ #category : #'*Glorp' }
DatabaseIndex class >> new [
	^super new initialize.
]

{ #category : #'initialize-release' }
DatabaseIndex >> addField: aField [
	^fields add: aField
]

{ #category : #initializing }
DatabaseIndex >> addFields: aCollection [
	fields addAll: aCollection
]

{ #category : #accessing }
DatabaseIndex >> fields [
	^fields.
]

{ #category : #printing }
DatabaseIndex >> generateName [
	"Generate a name for this index that will fit within the size limits of the database. This only takes into account the first field being used. If there's more than one that has multiple columns and the same first one, then the user will have to manually provide a name"

	| stream maxLength tableLength roomToBeVerbose minTableLength maxTableLength |
	maxLength := fields first table platform maximumLengthOfTableName.
	minTableLength := ((maxLength - 8) // 2) min: 10.
	maxTableLength := (maxLength // 2) - 1.
	roomToBeVerbose := minTableLength >= 10.
	tableLength := roomToBeVerbose ifTrue: [maxTableLength] ifFalse: [minTableLength].

	stream := WriteStream on: (String new: 100).
	stream nextPutAll: (fields first table name copyFrom: 1 to: ((fields first table name size) min: tableLength)).
	stream nextPutAll: '_'.
	stream nextPutAll: (fields first name copyFrom: 1 to: ((fields first name size) min: tableLength)).
	stream nextPutAll: (maxLength - stream position >= 4 ifTrue: ['_IDX'] ifFalse: ['X']).
	^stream contents.
]

{ #category : #testing }
DatabaseIndex >> indexesField: aField [
	^fields includes: aField.
]

{ #category : #initializing }
DatabaseIndex >> initialize [
	fields := OrderedCollection new: 2.
]

{ #category : #comparing }
DatabaseIndex >> isTheSameAs: aDatabaseIndex [
	"Validate that two indexes are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aDatabaseIndex name asUppercase ifFalse: [^false].
	self fields with: aDatabaseIndex fields  do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	^true.
]

{ #category : #accessing }
DatabaseIndex >> name [
	name isNil ifTrue: [name := self generateName].
	^name.
]

{ #category : #accessing }
DatabaseIndex >> name: aString [
	name := aString.
]

{ #category : #printing }
DatabaseIndex >> printStatementOn: aStream [
	aStream nextPut: $(.
	fields do: [ :f | aStream nextPutAll: f name; nextPut: $, ].
	aStream skip: -1; nextPut: $)
]

{ #category : #printing }
DatabaseIndex >> printStatementOn: aStream platform: aPlatform [
	"Some platforms need to quote some column names."

	aStream nextPut: $(.
	fields do: [ :f | aStream nextPutAll: (aPlatform nameForColumn: f name); nextPut: $, ].
	aStream skip: -1; nextPut: $)
]
