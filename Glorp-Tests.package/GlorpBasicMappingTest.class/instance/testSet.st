tests
testSet
	
	mapping setValueIn: person to: 2.
	self assert: person id = 2.
	self assert: (mapping getValueFrom: person) = 2.