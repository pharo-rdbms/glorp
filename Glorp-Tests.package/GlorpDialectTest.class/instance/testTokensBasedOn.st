tests
testTokensBasedOn
	self assert: (Dialect tokensBasedOn: '.' in: 'abc.def.ghi') asArray = #('abc' 'def' 'ghi').