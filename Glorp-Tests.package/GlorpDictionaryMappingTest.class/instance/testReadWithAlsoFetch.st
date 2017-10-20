tests
testReadWithAlsoFetch
	| encyclopedias query readBackEncyclopedias |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	query alsoFetch: [:each | each entries asOuterJoin].
	readBackEncyclopedias := session execute: query.
	session accessor denyReads.
	self verifyEncyclopedias: readBackEncyclopedias.