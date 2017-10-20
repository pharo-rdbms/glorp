tests
testCreation
	
	self assert: vc notNil.
	self should: [vc isKindOf: GlorpVirtualCollection].