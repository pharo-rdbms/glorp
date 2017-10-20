support
setUp
	super setUp.
	query := Query read: GlorpCustomer.
	query whereClause: [:each | each accounts anySatisfy: [:foo | foo id = 12]].
	session := GlorpSessionResource current newSession.
	query session: session.