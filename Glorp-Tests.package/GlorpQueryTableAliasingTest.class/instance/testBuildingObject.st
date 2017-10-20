tests
testBuildingObject

	| customer |
	elementBuilder instance: GlorpCustomer new.
	elementBuilder requiresPopulating: true.
	elementBuilder buildObjectFrom: #(12 'Name').
	customer := elementBuilder instance.
	self assert: customer class == GlorpCustomer.
	self assert: customer id = 12.
	self assert: customer name = 'Name'.