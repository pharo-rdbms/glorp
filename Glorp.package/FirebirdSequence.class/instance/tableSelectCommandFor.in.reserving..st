SQL
tableSelectCommandFor: aTable in: aSession reserving: anInteger
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