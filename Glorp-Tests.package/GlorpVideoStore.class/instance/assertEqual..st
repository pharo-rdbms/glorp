testing
assertEqual: aStore
	self assert: id = aStore id.
	self assert: name = aStore name.

	customers assertEqual: aStore customers.
	purchases assertEqual: aStore purchases.