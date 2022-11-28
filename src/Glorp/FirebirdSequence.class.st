"
Implements firebird sequence generation by calling out to gen_id()


"
Class {
	#name : #FirebirdSequence,
	#superclass : #NamedSequence,
	#category : 'Glorp-Database'
}

{ #category : #public }
FirebirdSequence >> creationString [

	^'create generator ' , self qualifiedName.
]

{ #category : #sequencing }
FirebirdSequence >> dropString [
	^'DELETE FROM RDB$GENERATORS
        WHERE RDB$GENERATOR_NAME=''', self qualifiedName, ''''.
]

{ #category : #sequencing }
FirebirdSequence >> getSequenceValueFromDatabaseFor: aDatabaseField in: aDatabaseRow using: anAccessor [ 
	| statement rows pk |
	statement := 'select gen_id(' , self qualifiedName 
				, ',1) from rdb$database'.
	rows := anAccessor executeSQLString: statement.
	pk := rows first first.
	aDatabaseRow at: aDatabaseField put: pk
]

{ #category : #sequencing }
FirebirdSequence >> postWriteAssignSequenceValueFor: aField in: aRow using: aSession [
]

{ #category : #'As yet unclassified' }
FirebirdSequence >> reserveViaBackupMechanism: anInteger in: aSession [
	"For interbase, the generator mechanism should always work"
	self error: 'This should never happen'.
]

{ #category : #sequencing }
FirebirdSequence >> reserveViaTableSelect: anInteger in: aSession for: aTable [
	"Interbase returns the top of the generated range in a single row. Do the iteration ourselves"
	| rows command max |
	command := self
		tableSelectCommandFor: aTable
		in: aSession
		reserving: anInteger.
	command parameters: (Array with: anInteger).
	command useBinding: false.
	rows := aSession accessor executeCommand: command.
	max := rows first first.
	max - anInteger + 1 to: max do: [:i | self reservedNumbers add: i].
]

{ #category : #SQL }
FirebirdSequence >> tableSelectCommandFor: aTable in: aSession reserving: anInteger [
	"Since tableSelectCommand was never nilled, a second pundle version reusing this sequence used to get an SQL string embedding the first's integer value.  If it was a version of a different pundle, its integer probably differed;  when a call to reserve e.g. 1233 returns a maximum got by reusing the prior version's call to reserve e.g. 85, the result is 1148 duplicate keys.  If #insertOnly was set,  replication failed on an illegal command.  If we reached one of the fix-up states where it was not, then our cache assured us we were updating and we happily overwrote e.g. the blob for a class definition with that for a method definition (as I experienced :-/).  As sequences are set in the descriptor system and reused, this persisted until the session was discarded or its system was revised.  We now check the integer."

	| stream useBinding |
	"Binding into this doesn't seem to work"
	useBinding := false.
	(tableSelectCommand notNil and: [tableSelectCommand parameters includes: anInteger]) ifFalse:
		[stream := WriteStream on: (String new: 200).
		stream nextPutAll: 'select gen_id('.
		stream nextPutAll: self qualifiedName.
		stream nextPut: $,.
		stream nextPutAll: (useBinding ifTrue: ['?'] ifFalse: [anInteger printString]).
		stream nextPutAll: ') from rdb$database'.
		tableSelectCommand := SQLStringSelectCommand new.
		tableSelectCommand parameters: (Array with: anInteger).
		tableSelectCommand setSQLString: stream contents.
		tableSelectCommand session: aSession].
	^tableSelectCommand
]
