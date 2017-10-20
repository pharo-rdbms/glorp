reaping
shouldReap: anAssociation
	"Check that either we've passed the start time, or that there's been a wraparound in the millisecond value and we're now larger than it by some ridiculous margin, which we'll call 24 hours."

	| expireTime milliseconds shouldReap |
	anAssociation key isNil ifTrue: [^true].  "It's been touched. Skip over but don't reap, handled elsewhere"
	expireTime := anAssociation value.
	milliseconds := "24 * 60 * 60 * 1000" 86400000.
	shouldReap := expireTime <= startTime or: [expireTime - milliseconds > startTime].
	^shouldReap.