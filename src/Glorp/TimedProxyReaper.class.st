"
Overview:

A TimedProxyReaper collects TimedProxies and, using a background process, uninstantiates when they are due to expire. You can control the number of seconds between each invocation of the background process, with the message #delay:, and you can control the amount of work the background process will do each time it runs with the message #maximumWork:.

API Methods:

"
Class {
	#name : #TimedProxyReaper,
	#superclass : #Object,
	#instVars : [
		'weakValueDictionary',
		'keysSortedByExpiryTime',
		'indexOffset',
		'mutex',
		'reaperThread',
		'delay',
		'maximumWork',
		'nextId',
		'timeout',
		'done',
		'startTime'
	],
	#category : #'Glorp-Core'
}

{ #category : #'*Glorp' }
TimedProxyReaper class >> delay: seconds [

	^ self new delay: seconds
]

{ #category : #'*Glorp' }
TimedProxyReaper class >> delay: seconds maximumWork: milliseconds [

	^ self new
		  delay: seconds;
		  maximumWork: milliseconds
]

{ #category : #caching }
TimedProxyReaper >> add: aTimedProxy [

	[
	mutex wait.
	self noWaitAdd: aTimedProxy ] ensure: [ mutex signal ].
	self restartIfNecessary
]

{ #category : #caching }
TimedProxyReaper >> at: id ifAbsent: errorBlock [

	| result |
	[
	mutex wait.
	result := weakValueDictionary at: id ifAbsent: [ ^ errorBlock value ] ]
		ensure: [ mutex signal ].
	^ result
]

{ #category : #accessing }
TimedProxyReaper >> delay [
	"Answer the delay, in seconds, between runs of the reaper process."

	^ delay
]

{ #category : #accessing }
TimedProxyReaper >> delay: seconds [
	"Set delay between runs of the reaper process in seconds."

	delay := seconds
]

{ #category : #reaping }
TimedProxyReaper >> finish [
	"	Transcript cr; show: 'Done', (Time millisecondClockValue // 1000) printString."

	done := true
]

{ #category : #reaping }
TimedProxyReaper >> forkReaperThread [

	| block |
	block := [
	         [ done ] whileFalse: [
		         (Delay forSeconds: self delay) wait.
		         self reapExpiredObjects ] ].
	reaperThread := block forkAt: Processor userBackgroundPriority
]

{ #category : #caching }
TimedProxyReaper >> includes: aTimedProxy [

	self at: aTimedProxy glorpId ifAbsent: [ ^ false ].
	^ true
]

{ #category : #initialization }
TimedProxyReaper >> initialize [

	done := false.
	self delay: 5. "seconds"
	self maximumWork: 100. "milliseconds"
	nextId := 1.
	weakValueDictionary := Dialect weakValueDictionaryClass new.
	weakValueDictionary manager: self.

	"Note: The sort used by keysSortedByExpiryTime _must_ be stable."
	keysSortedByExpiryTime := SortedCollection sortBlock: [:associationA :associationB | associationA value "timeToDie" <= associationB value].

	indexOffset := 0.
	mutex := Semaphore forMutualExclusion.
	self forkReaperThread
]

{ #category : #accessing }
TimedProxyReaper >> maximumWork [
	"Answer the maximum amount of time the reaper thread will run for before yielding."

	^ maximumWork
]

{ #category : #accessing }
TimedProxyReaper >> maximumWork: milliseconds [
	"Set the maximum amount of time the reaper thread will run for before yielding."

	maximumWork := milliseconds
]

{ #category : #reaping }
TimedProxyReaper >> mournKeyOf: anEphemeron [
	"Don't really need to do anything."

	anEphemeron value uninstantiate
]

{ #category : #accessing }
TimedProxyReaper >> nextSequenceNumber [

	| id |
	id := nextId.
	nextId := nextId + 1.
	^ id
]

{ #category : #caching }
TimedProxyReaper >> noWaitAdd: aTimedProxy [

	| association id |
	aTimedProxy glorpId ifNil: [
		aTimedProxy glorpId: self nextSequenceNumber ].
	id := aTimedProxy glorpId.
	association := Association key: id value: aTimedProxy glorpTimeToDie.
	weakValueDictionary at: id put: aTimedProxy.
	aTimedProxy glorpAssociation: association.
	keysSortedByExpiryTime add: association.
	aTimedProxy glorpReaper: self
]

{ #category : #reaping }
TimedProxyReaper >> privateReapObjects [
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
	^numberReaped
]

{ #category : #reaping }
TimedProxyReaper >> reapExpiredObjects [

	| numberReaped |
	[
	mutex wait.
	keysSortedByExpiryTime ifEmpty: [ self finish ].
	done ifTrue: [ ^ self ].
	numberReaped := self privateReapObjects. "If the cache is empty, shut down"
	numberReaped timesRepeat: [ keysSortedByExpiryTime removeFirst ].
	indexOffset := indexOffset + numberReaped ] ensure: [ mutex signal ]
]

{ #category : #dependencies }
TimedProxyReaper >> release [

	done := true.
	maximumWork := 0.
	reaperThread ifNotNil: [ reaperThread terminate ].
	reaperThread := nil
]

{ #category : #caching }
TimedProxyReaper >> remove: aTimedProxy ifAbsent: errorBlock [

	^ self removeKey: aTimedProxy glorpId ifAbsent: errorBlock
]

{ #category : #caching }
TimedProxyReaper >> removeKey: key ifAbsent: errorBlock [
	"Note: The key is NOT removed from keysSortedByExpiryTime. The reaper
	will eventually reap the given key, and ignore it since it is already gone.
	Removing objects from the middle of keysSortedByExpiryTime will screw
	up the indexing of objects that are registered later. Don't do it."

	| result |
	[
	mutex wait.
	result := weakValueDictionary
		          removeKey: key
		          ifAbsent: [ ^ errorBlock value ] ] ensure: [ mutex signal ].
	^ result
]

{ #category : #reaping }
TimedProxyReaper >> restartIfNecessary [

	[
	mutex wait.
	done ifTrue: [ "Transcript cr; show: 'Restarting', (Time millisecondClockValue // 1000) printString."
		done := false.
		self forkReaperThread ] ] ensure: [ mutex signal ]
]

{ #category : #reaping }
TimedProxyReaper >> shouldReap: anAssociation [
	"Check that either we've passed the start time, or that there's been a wraparound in the millisecond value and we're now larger than it by some ridiculous margin, which we'll call 24 hours."

	| expireTime milliseconds shouldReap |
	anAssociation key ifNil: [ ^ true ].
	expireTime := anAssociation value.
	milliseconds := 86400000. "24 * 60 * 60 * 1000"
	shouldReap := expireTime <= startTime or: [
		              expireTime - milliseconds > startTime ].
	^ shouldReap
]

{ #category : #caching }
TimedProxyReaper >> touch: aTimedProxy [

	[
	| association |
	mutex wait.
	association := aTimedProxy glorpAssociation.
	association ifNil: [ ^ self ].
	association key: nil. "This indicates that the key should not be reaped at this time."
	self noWaitAdd: aTimedProxy ] ensure: [ mutex signal ]
]
