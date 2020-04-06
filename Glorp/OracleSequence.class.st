"
This supports Oracle sequence using select nextval from sys.allObjects. It also supports getting multiple sequence numbers at once. Going against AllObjects seemed to work much better than going against any real table.

Instance Variables:
	accessProtect	<RecursionLock | Semaphore>	Mutual exclusion on our sequence allocation, since we may need to protect our cache of already-allocated numbers, and prevent two different processes from going to the database simultaneously. This might want to be pushed up to a superclass so it can be shared.
	count	<Number>	How many identifiers have we gotten in a row without going to the database.
	sequenceIncrement	<SmallInteger>	By how much does the sequence in the database increment on each nextVal call.


"
Class {
	#name : #OracleSequence,
	#superclass : #NamedSequence,
	#instVars : [
		'count',
		'sequenceIncrement',
		'accessProtect'
	],
	#category : 'Glorp-Database'
}

{ #category : #testing }
OracleSequence >> alwaysGetFromDb [
	^sequenceIncrement = 1
]

{ #category : #private }
OracleSequence >> backupReserveCommand: anInteger in: aSession [
	| command stream |
	stream := WriteStream on: (String new: 200).
	stream nextPutAll: 'select '.
	stream nextPutAll: self qualifiedName.
	stream nextPutAll: '.nextval from SYS.ALL_OBJECTS '.
	stream nextPutAll: ' WHERE rownum <= '.
	stream
		nextPutAll:
			(aSession useBinding ifTrue: ['?'] ifFalse: [anInteger printString]).
	command := SQLStringSelectCommand new.
	command setSQLString: stream contents.
	command parameters: (Array with: anInteger).
	command session: aSession.
	^command.
]

{ #category : #public }
OracleSequence >> creationString [
	^self sequenceIncrement > 1
		ifFalse: ['create sequence ', self qualifiedName]
		ifTrue: ['create sequence ', self qualifiedName, ' increment by ', self sequenceIncrement printString]
]

{ #category : #public }
OracleSequence >> getSequenceValueFromDatabaseFor: aField in: aRow using: anAccessor [ 
	aRow at: aField put: (self nextSequenceNumber: anAccessor)
]

{ #category : #'initalize-release' }
OracleSequence >> initialize [
	super initialize.
	count := 0.
	sequenceIncrement := 1.
	accessProtect := Semaphore forMutualExclusion
]

{ #category : #accessing }
OracleSequence >> name: aString [
	name := aString copyFrom: 1 to: (aString size min: OraclePlatform new maximumLengthOfTableName).
]

{ #category : #private }
OracleSequence >> nextSequenceNumber: anAccessor [ 
	accessProtect critical: 
			[count := count + 1.
			^(self alwaysGetFromDb or: [count \\ sequenceIncrement = 1]) 
				ifTrue: 
					[count := (anAccessor 
								executeSQLString: self nextSequenceNumberSelectString) first 
								first]
				ifFalse: [count]]
]

{ #category : #private }
OracleSequence >> nextSequenceNumberSelectString [
	^'SELECT ' , self qualifiedName , '.NEXTVAL FROM DUAL'
]

{ #category : #public }
OracleSequence >> postWriteAssignSequenceValueFor: aField in: aRow using: anAccessor [
]

{ #category : #private }
OracleSequence >> reserveViaBackupMechanism: anInteger in: aSession [
	"The regular mechanism didn't work, (probably because there weren't enough rows in the table), try a different technique. Oracle doesn't repeatedly evaluate nextval if we do it multiple times on a line, so instead guess at a table we know should have lots of rows in Oracle and use it"

	| rows command |
	command := self backupReserveCommand: anInteger in: aSession.
	command blockFactor: anInteger.
	rows := aSession accessor executeCommand: command.
	rows do: [:each | self reservedNumbers add: each first].
]

{ #category : #private }
OracleSequence >> reserveViaTableSelect: anInteger in: aSession for: aTable [
	"In Oracle, there can be performance issues selecting against our tables, which we don't seem to get if we just use SYS.ALLOBJECTS. I'm suspicious the problem is if we have fragmentation of the file containing the table, but regardless, ALLOBJECTS seems consistently fast, so always use it"
	self reserveViaBackupMechanism: anInteger in: aSession.

"	| rows command |
	command := self
		tableSelectCommandFor: aTable
		in: aSession
		reserving: anInteger.
	command parameters: (Array with: anInteger).
	rows := aSession accessor executeCommand: command.
	rows do: [:each | self reservedNumbers add: each first]."
]

{ #category : #accessing }
OracleSequence >> sequenceIncrement [
	^sequenceIncrement
]

{ #category : #accessing }
OracleSequence >> sequenceIncrement: aNumber [ 
	sequenceIncrement := aNumber
]

{ #category : #SQL }
OracleSequence >> tableSelectCommandFor: aTable in: aSession reserving: anInteger [
	| stream |
	(tableSelectCommand notNil and: [tableSelectCommand parameters includes: anInteger]) ifFalse:
			[stream := WriteStream on: (String new: 200).
			stream nextPutAll: 'select '.
			stream nextPutAll: self qualifiedName.
			stream nextPutAll: '.nextval from '.
			stream nextPutAll: aTable name.
			stream nextPutAll: ' WHERE rownum <= '.
			stream nextPutAll: (aSession useBinding ifTrue: ['?'] ifFalse: [anInteger printString]).
			tableSelectCommand := SQLStringSelectCommand new.
			tableSelectCommand parameters: (Array with: anInteger).
			tableSelectCommand setSQLString: stream contents.
			tableSelectCommand blockFactor: anInteger.
			tableSelectCommand session: aSession].
	^tableSelectCommand.
]
