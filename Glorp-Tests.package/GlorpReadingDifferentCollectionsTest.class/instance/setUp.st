setup
setUp
	
	| |
	super setUp.
	session := GlorpSessionResource current newSession.
	system := session system.
	session beginTransaction.
	self writeAccountRows.
	singleQuery := Query read: GlorpBankAccount
				where: [:passenger | passenger id = 6].
	allQuery := Query read: GlorpBankAccount.