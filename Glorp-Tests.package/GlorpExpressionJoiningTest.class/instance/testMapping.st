tests
testMapping
	| result exp |
	exp := base get: #foo.
	result := self join: exp. 
	self assert: result base == source.
	self assert: result name = #foo.