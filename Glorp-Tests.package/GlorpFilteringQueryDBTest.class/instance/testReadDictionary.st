tests
testReadDictionary
	| entryMapping encyclopedias query readBackEncyclopedias canadian plagiarists |
	session system: (GlorpEncyclopediaDescriptorSystem forPlatform: session platform).
	system := session system.
	encyclopedias := system exampleEncyclopedias.
	entryMapping := (system descriptorFor: GlorpEncyclopedia) mappingForAttributeNamed: #entries.
	entryMapping useFilteredRead.
	session transact: [session register: encyclopedias].
	session reset.
	query := Query read: GlorpEncyclopedia.
	query orderBy: [:each | each name].
	readBackEncyclopedias := session execute: query.
	canadian := readBackEncyclopedias first.
	self assert: canadian entries size = 3.
	session accessor permitNothing.

	self assert: (canadian entries at: 'abcde') id = 'two'.
	self assert: (canadian entries at: '12345') id = 'one'.
	self assert: (canadian entries at: 'unique') id = 'three'.
	plagiarists := readBackEncyclopedias at: 2.
	self assert: plagiarists entries size = 2.
	self assert: (plagiarists entries at: '54321') = (canadian entries at: '12345').
	self assert: (plagiarists entries at: 'edcba') = (canadian entries at: 'abcde').
	self assert: readBackEncyclopedias last entries isEmpty.