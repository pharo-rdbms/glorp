"
This is a database sequence that is identified by name.

Subclasses must implement the following messages:
	SQL
		tableSelectCommandFor:in:reserving:

Instance Variables:
	name	<String>	The name of the sequence
	schema	<String>	The schema that contains the sequence. Subclasses should set this up appropriately.
	tableSelectCommand	<SQLStringSelectCommand>	The command to execute to get the next value. 


"
Class {
	#name : #NamedSequence,
	#superclass : #DatabaseSequence,
	#instVars : [
		'name',
		'tableSelectCommand',
		'schema'
	],
	#category : #'Glorp-Database'
}

{ #category : #SQL }
NamedSequence >> availableReservedNumbers [

	^ self reservedNumbers size
]

{ #category : #sequencing }
NamedSequence >> dropString [

	^ 'Drop sequence ' , self qualifiedName
]

{ #category : #SQL }
NamedSequence >> maximumToReserveAtOnce [

	^ 1000
]

{ #category : #accessing }
NamedSequence >> name [

	^ name
]

{ #category : #accessing }
NamedSequence >> name: aString [

	name := aString
]

{ #category : #printing }
NamedSequence >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (name isNil ifTrue: ['unnamed'] ifFalse: [name]);
		nextPut: $)
]

{ #category : #accessing }
NamedSequence >> qualifiedName [

	^(schema isNil or: [schema isEmpty]) ifTrue: [name] ifFalse: [schema, '.', name]
]

{ #category : #sequencing }
NamedSequence >> reserveSequenceNumbers: anInteger in: aSession for: aTable [
	| numberNeeded numberToReserve |
	numberNeeded := anInteger - self availableReservedNumbers.
	numberNeeded <= 0 ifTrue: [^self].
	self
		reserveViaTableSelect: numberNeeded
		in: aSession
		for: aTable.
	[anInteger - self availableReservedNumbers >0 ] whileTrue: [
		numberToReserve := (anInteger - self availableReservedNumbers) min: (self maximumToReserveAtOnce).
		self reserveViaBackupMechanism: numberToReserve in: aSession]
]

{ #category : #SQL }
NamedSequence >> reserveViaTableSelect: anInteger in: aSession for: aTable [

	| rows command |
	command := self
		tableSelectCommandFor: (self tableToSelectFromIn: aSession for: aTable)
		in: aSession
		reserving: anInteger.
	command parameters: (Array with: anInteger).
	rows := aSession accessor executeCommand: command.
	rows do: [:each | self reservedNumbers add: each first]
]

{ #category : #accessing }
NamedSequence >> schema [

	^ schema
]

{ #category : #accessing }
NamedSequence >> schema: aString [

	schema := aString
]

{ #category : #SQL }
NamedSequence >> tableSelectCommandFor: aTable in: aSession reserving: anObject [

	self subclassResponsibility
]

{ #category : #SQL }
NamedSequence >> tableToSelectFromFor: aTable [
	"Sometimes it's inefficient to select sequence values against our own table and we can use a database-specific system table instead to be much faster. Subclasses can override where this is the case"

	^ aTable
]
