support
checkAddress
	self assert: person address isGlorpProxy.
	self assert: person address getValue id = 123.
	^self assert: person address getValue class == GlorpAddress.