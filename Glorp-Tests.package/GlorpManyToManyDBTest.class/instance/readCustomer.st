support
readCustomer
	| results query |
	query := Query
		read: GlorpCustomer
		where: [:cust | cust id = customerId].
	results := query executeIn: session.
	self assert: results size = 1.
	customer := results first.