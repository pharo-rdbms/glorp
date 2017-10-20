tests
testBase
	| result |
	result := self join: base. 
	self assert: result == source.