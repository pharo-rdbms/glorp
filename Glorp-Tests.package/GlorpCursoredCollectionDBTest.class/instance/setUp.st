support
setUp
	session := GlorpSessionResource current newSession.
	session beginTransaction.
	self writePersonRows.