support
checkNoAddress
	self deny: person address isGlorpProxy.
	self assert: person address == nil.