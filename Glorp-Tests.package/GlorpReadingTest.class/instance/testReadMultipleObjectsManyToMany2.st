tests
testReadMultipleObjectsManyToMany2
	| query result customer |
	
	[session beginTransaction.
	self writeCustomer1Rows.

	query := Query read: GlorpCustomer.
	query retrieve: [:each | each ].
	query alsoFetch: [:each | each accounts].
	result := query executeIn: session.
	self assert: result size = 1.
	customer := result first.
	self deny: customer accounts class isGlorpProxy.
	self assert: customer accounts size = 2] 
			ensure: [session rollbackTransaction]