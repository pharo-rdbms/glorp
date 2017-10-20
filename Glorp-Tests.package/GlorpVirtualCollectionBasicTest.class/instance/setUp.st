support
setUp
	super setUp.
	session beginTransaction.
	self writePersonRows.
	vc := session virtualCollectionOf: GlorpPerson.