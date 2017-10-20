tests
testGlorpIsCollection
	self deny: 'abc' glorpIsCollection.
	self deny: Object new glorpIsCollection.
	self deny: $a glorpIsCollection.
	self assert: #() glorpIsCollection.