"
This implements postgresql sequences using nextVal. The mechanism is similar to Oracle sequences, but we don't have to give it a table to select against when all we want is a bunch of numbers, so the implementation is simpler.
"
Class {
	#name : #PGSequence,
	#superclass : #NamedSequence,
	#category : #'Glorp-Database'
}

{ #category : #private }
PGSequence >> backupReserveCommand: anInteger in: aSession [

	| stream command |
	stream := WriteStream on: (String new: 200).
	stream nextPutAll: 'select '.
	GlorpHelper
		print: [:i | 'nextval(''' , self qualifiedName , ''')']
		on: stream
		for: (1 to: anInteger)
		separatedBy: ','.
	command := SQLStringSelectCommand new.
	command setSQLString: stream contents.
	command parameters: (Array with: anInteger).
	command session: aSession.
	^command
]

{ #category : #sequencing }
PGSequence >> getSequenceValueFromDatabaseFor: aDatabaseField in: aDatabaseRow using: anAccessor [

	| statement rows pk |

	"this could be made smarter by aggregating keys to fetch into a single sql query - maybe later -tb"
	statement := 'select nextval(''',  self qualifiedName, ''')'.

	rows := anAccessor executeSQLString: statement.
	pk := rows first first.

	aDatabaseRow at: aDatabaseField put: pk
]

{ #category : #sequencing }
PGSequence >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [

"No-op;  for user information, we show, commented, the code that was provided here circa Glorp 0.2.*.
	aDatabaseRow at: aDatabaseField
		put: (aSession accessor
				executeSQLString: 'SELECT CURRVAL(' , self qualifiedName 	, ')')."
]

{ #category : #private }
PGSequence >> reserveViaBackupMechanism: anInteger in: aSession [
	"The regular mechanism didn't work, (probably because there weren't enough rows in the table), try a different technique."

	| command row |
	command := self backupReserveCommand: anInteger in: aSession.
	row := (aSession accessor executeCommand: command) first.
	self reservedNumbers addAll: row
]

{ #category : #SQL }
PGSequence >> tableSelectCommandFor: aTable in: aSession reserving: anInteger [
	| stream |
	(tableSelectCommand notNil and: [tableSelectCommand parameters includes: anInteger]) ifFalse:
			[stream := WriteStream on: (String new: 200).
			stream nextPutAll: 'select nextval('.
			self qualifiedName printOn: stream.
			stream nextPutAll: ') from ' , aTable name.
			stream nextPutAll: ' limit '.
			stream nextPutAll: (aSession useBinding ifTrue: ['?'] ifFalse: [anInteger printString]).
			tableSelectCommand := SQLStringSelectCommand new.
			tableSelectCommand parameters: (Array with: anInteger).
			tableSelectCommand setSQLString: stream contents.
			tableSelectCommand session: aSession].
	^tableSelectCommand
]

{ #category : #SQL }
PGSequence >> tableToSelectFromFor: aTable [
	"Sometimes it's inefficient to select sequence values against our own table and we can use a database-specific system table instead to be much faster. Subclasses can override where this is the case"

	^ DatabaseTable named: 'pg_attribute'
]

{ #category : #SQL }
PGSequence >> tableToSelectFromIn: session for: aTable [
	"Sometimes it's inefficient to select sequence values against our own table and we can use a database-specific system table instead to be much faster. Subclasses can override where this is the case"

	^ session databaseTableClass named: 'pg_attribute'
]
