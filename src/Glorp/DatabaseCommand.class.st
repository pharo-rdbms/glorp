"
A DatabaseCommand is what a query uses to actually generate its SQL and to execute it. A command wraps a stream, into which the SQL is written, but with knowledge of the platform for which it's being written, and potentially details about how it should execute.

Subclasses must implement the following messages:
	accessing
		arrayBoundFields
		bindings
		bindingTypes
		parameterTypeSignature
	executing
		printSQL
	testing
		succeeded

Instance Variables:
	platform	<DatabasePlatform>	The database for which we're to generate/execute SQL.
	sqlString	<String>	The resulting SQL.
	stream	<Stream>	The stream into which we generate the SQL. Once we've finished and got sqlString this isn't necessary any more.
	useBinding	<Boolean>	Should we use binding, or print parameters directly into the string.


"
Class {
	#name : #DatabaseCommand,
	#superclass : #Object,
	#instVars : [
		'useBinding',
		'stream',
		'sqlString',
		'session'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
DatabaseCommand class >> new [
	^super new initialize.
]

{ #category : #accessing }
DatabaseCommand >> arrayBoundFields [

	self subclassResponsibility
]

{ #category : #accessing }
DatabaseCommand >> bindingTypes [

	self subclassResponsibility
]

{ #category : #accessing }
DatabaseCommand >> bindings [

	self subclassResponsibility
]

{ #category : #accessing }
DatabaseCommand >> blockFactor [

	^ 5 "A reasonable default if we don't know"
]

{ #category : #testing }
DatabaseCommand >> canBind: aValue to: aType [

	useBinding ifFalse: [ ^ false ].
	^ self platform canBind: aValue to: aType underlyingType
]

{ #category : #'stream behaviour' }
DatabaseCommand >> contents [

	^ stream contents
]

{ #category : #'stream behaviour' }
DatabaseCommand >> cr [

	stream cr
]

{ #category : #executing }
DatabaseCommand >> executeBoundIn: anAccessor [

	^ anAccessor executeCommandBound: self
]

{ #category : #executing }
DatabaseCommand >> executeUnboundIn: anAccessor [

	^ anAccessor executeCommandUnbound: self
]

{ #category : #testing }
DatabaseCommand >> hasMultipleRows [

	^ false
]

{ #category : #initialization }
DatabaseCommand >> initialize [

	useBinding := true.
	stream := WriteStream on: (String new: 100)
]

{ #category : #testing }
DatabaseCommand >> isDeleteCommand [

	^ false
]

{ #category : #testing }
DatabaseCommand >> isReadCommand [

	^ false
]

{ #category : #accessing }
DatabaseCommand >> maximumLobSizeToRetrieveDirectly [

	^ 32768
]

{ #category : #testing }
DatabaseCommand >> needsRowCount [

	^ false
]

{ #category : #'stream behaviour' }
DatabaseCommand >> nextPut: aCharacter [

	^ stream nextPut: aCharacter
]

{ #category : #'stream behaviour' }
DatabaseCommand >> nextPutAll: aString [

	^ stream nextPutAll: aString
]

{ #category : #'stream behaviour' }
DatabaseCommand >> nextPutString: aString [

	^ self nextPutAll: aString
]

{ #category : #accessing }
DatabaseCommand >> parameterTypeSignature [

	self subclassResponsibility
]

{ #category : #'As yet unclassified' }
DatabaseCommand >> platform [

	self session isNil ifTrue: [ ^ nil ].
	^ self session platform
]

{ #category : #accessing }
DatabaseCommand >> platform: aDatabasePlatform [

	self error: 'This API is obsolete. Pass the session instead'
]

{ #category : #'stream behaviour' }
DatabaseCommand >> policy [

	^ stream policy
]

{ #category : #'stream behaviour' }
DatabaseCommand >> print: anObject [

	anObject printOn: self
]

{ #category : #printing }
DatabaseCommand >> printSQL [

	self subclassResponsibility
]

{ #category : #accessing }
DatabaseCommand >> query [

	^ nil
]

{ #category : #accessing }
DatabaseCommand >> session [

	^ session
]

{ #category : #'As yet unclassified' }
DatabaseCommand >> session: aGlorpSession [

	session := aGlorpSession
]

{ #category : #testing }
DatabaseCommand >> shouldUseGroupWriting [

	^ self hasMultipleRows and: [
		  self platform supportsGroupWritingFor: self ]
]

{ #category : #accessing }
DatabaseCommand >> signature [

	^ self sqlString , self parameterTypeSignature
]

{ #category : #'stream behaviour' }
DatabaseCommand >> space [

	stream space
]

{ #category : #accessing }
DatabaseCommand >> sqlString [

	sqlString isNil ifTrue: [
		stream isNil ifTrue: [ stream := WriteStream on: (String new: 100) ].
		self printSQL.
		sqlString := stream contents.
		stream := nil ].
	^ sqlString
]

{ #category : #testing }
DatabaseCommand >> succeeded [

	^ self subclassResponsibility
]

{ #category : #accessing }
DatabaseCommand >> system [

	self session isNil ifTrue: [ ^ nil ].
	^ self session system
]

{ #category : #reporting }
DatabaseCommand >> tables [
	"Return a list of the tables we will affect"

	^ self subclassResponsibility
]

{ #category : #accessing }
DatabaseCommand >> useBinding [

	^ useBinding
]

{ #category : #accessing }
DatabaseCommand >> useBinding: aBoolean [

	useBinding := aBoolean
]
