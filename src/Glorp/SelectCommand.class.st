"
This represents a SELECT query to the database. This can either be based on a GLORP query, or on a hard-coded SQL string.

Subclasses must implement the following messages:
	accessing
		printSQL

Instance Variables:
	blockFactor	<SmallInteger>	The blocking factor to use for this query. This is most likely to make a difference for these kind of operations, and so is directly settable here.
	parameters	<Dictionary from: DatabaseField to: Object>	The parameters to the query.


"
Class {
	#name : #SelectCommand,
	#superclass : #DatabaseCommand,
	#instVars : [
		'parameters',
		'blockFactor',
		'query'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
SelectCommand class >> forQuery: aQuery parameters: aDictionary [

	^ self new
		  query: aQuery;
		  parameters: aDictionary;
		  yourself
]

{ #category : #'*Glorp' }
SelectCommand class >> forQuery: aQuery parameters: aDictionary useBinding: aBoolean session: aSession [

	^ self new
		  query: aQuery;
		  parameters: aDictionary;
		  useBinding: aBoolean;
		  session: aSession;
		  yourself
]

{ #category : #accessing }
SelectCommand >> blockFactor: anInteger [

	blockFactor := anInteger
]

{ #category : #testing }
SelectCommand >> canBind: aValue to: aType [

	aValue isNil ifTrue: [ ^ false ].
	^ super canBind: aValue to: aType
]

{ #category : #testing }
SelectCommand >> isReadCommand [

	^ true
]

{ #category : #accessing }
SelectCommand >> parameterTypeSignature [

	| result |
	result := WriteStream on: String new.
	self bindings do: [ :each | result nextPutAll: each class name ].
	^ result contents
]

{ #category : #accessing }
SelectCommand >> parameters [

	^ parameters
]

{ #category : #accessing }
SelectCommand >> parameters: aDictionary [

	parameters := aDictionary
]

{ #category : #printing }
SelectCommand >> printSQL [

	self subclassResponsibility
]

{ #category : #testing }
SelectCommand >> succeeded [

	^ true
]
