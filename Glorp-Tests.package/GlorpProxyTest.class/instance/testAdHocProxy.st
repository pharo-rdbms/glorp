tests
testAdHocProxy
	"Some dialects (e.g. VA) inline yourself so we must send yourSelf."

	| p |
	p := AdHocProxy readBlock: ['instantiated!'].
	self assert: p printString = '{uninstantiated AdHocProxy}'.
	self assert: p isInstantiated not.
	p yourSelf.
	self assert: p isInstantiated.
	self assert: p printString = '{''instantiated!''}'.
	p uninstantiate.
	self deny: p isInstantiated.