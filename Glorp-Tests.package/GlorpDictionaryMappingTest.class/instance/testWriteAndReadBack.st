tests
testWriteAndReadBack
	| encyclopedias query readBackEncyclopedias |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	readBackEncyclopedias := session execute: query.
	self verifyEncyclopedias: readBackEncyclopedias.