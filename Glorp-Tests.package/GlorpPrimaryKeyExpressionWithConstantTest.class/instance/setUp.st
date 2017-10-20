support
setUp
	super setUp.
	expression := Join 
		from: 7
		to: ((system tableNamed: 'CUSTOMER_ACCT_LINK') fieldNamed: 'ACCT_ID').

	compoundExpression := Join
		from: ((system tableNamed: 'BANK_ACCT') fieldNamed: 'ID')
		to: ((system tableNamed: 'PERSON') fieldNamed: 'NAME').
	compoundExpression
		addSource: 'B'
		target: ((system tableNamed: 'PERSON') fieldNamed: 'ADDRESS_ID').