tests
testTouchAndExpireObjectsWhileOtherObjectsAreBeingReaped

	| expiringProxy proxy |
	"This test fails because a session isn't supplied to #readOneOf:where:in:.
	It looks like to get this test working would require setting up a proper table and populating it with objects."
	Dialect isPharo ifTrue: [ ^ self skip: '#testAddObjects needs rewrite, see comments.' ].

	reaper delay: 0.25.
	expiringProxy := TimedProxy readOneOf: Object where: nil in: nil.
	expiringProxy glorpSecondsToLive: 1.
	proxy := TimedProxy readOneOf: Object where: nil in: nil.
	proxy glorpSecondsToLive: 2.

	reaper add: proxy; add: expiringProxy.
	self assert: (reaper includes: proxy).
	self assert: (reaper includes: expiringProxy).
	(Delay forSeconds: 1) wait.
	proxy glorpTouch.
	(Delay forSeconds: 1.5) wait.
	self assert: (reaper includes: proxy).
	self deny: (reaper includes: expiringProxy).
	(Delay forSeconds: 2) wait.
	self deny: (reaper includes: proxy).