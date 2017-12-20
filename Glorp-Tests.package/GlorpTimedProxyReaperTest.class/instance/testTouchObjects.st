tests
testTouchObjects

	| proxy |
	"This test fails because a session isn't supplied to #readOneOf:where:in:.
	It looks like to get this test working would require setting up a proper table and populating it with objects."
	Dialect isPharo ifTrue: [ ^ self skip: '#testAddObjects needs rewrite, see comments.' ].

	reaper delay: 0.25.
	proxy := TimedProxy readOneOf: Object where: nil in: nil.
	proxy glorpSecondsToLive: 2.
	reaper add: proxy.
	(Delay forSeconds: 1) wait.
	proxy glorpTouch.
	(Delay forSeconds: 1.1) wait.
	self should: [reaper includes: proxy].
	(Delay forSeconds: 2) wait.
	self shouldnt: [reaper includes: proxy]