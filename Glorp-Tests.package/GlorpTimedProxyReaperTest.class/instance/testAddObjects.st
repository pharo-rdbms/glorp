tests
testAddObjects

	| proxies |

	"This test fails because a session isn't supplied to #readOneOf:where:in:.
	It looks like to get this test working would require setting up a proper table and populating it with objects."
	Dialect isPharo ifTrue: [ ^ self skip: '#testAddObjects needs rewrite, see comments.' ].

	proxies := OrderedCollection new.
	1 to: 10 do: [:index | 
		proxies add: (TimedProxy readOneOf: Object where: nil in: nil).
		proxies last glorpSecondsToLive: 1000.
		reaper add: proxies last].

	(Delay forSeconds: 1) wait.
	proxies do: [:proxy | self should: [reaper includes: proxy]].