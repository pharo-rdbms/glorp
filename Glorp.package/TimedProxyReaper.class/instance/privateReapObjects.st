reaping
privateReapObjects
	"Private - Go through all of the objects (sorted by time) and remove those which have expired from the receiver's weakValueDictionary.
	Answer the number of objects reaped."

	| numberReaped timesUp |
	startTime := Time millisecondClockValue.
	numberReaped := 0.
	timesUp := false.
	[(Delay forMilliseconds: 100) wait.
	timesUp := true] forkAt: Processor activePriorityPlusOne.
	keysSortedByExpiryTime
		do:
			[:association | 
			done | timesUp ifTrue: [^numberReaped].
			(self shouldReap: association)
				ifTrue:
					[| timedProxy |
					numberReaped := numberReaped + 1.
					association key isNil
						ifFalse:
							["Been touched in the meantime. Just skip over it, but don't reap"
							timedProxy := weakValueDictionary
								removeKey: association key
								ifAbsent: [nil].
							timedProxy class == TimedProxy ifTrue: [timedProxy uninstantiate]]]
				ifFalse: [^numberReaped]].
	^numberReaped.