tests
testCollectionValueQueryWithImpliedValueAndObjectEquality

	| encyclopedias matches entry |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	entry := session readOneOf: GlorpEncyclopediaEntry where: [:each | each title = 'Vehicular Fish Decay'].
	matches := session read: GlorpEncyclopedia where: [:each | each entries anySatisfy: [:eachEntry |
		eachEntry = entry]].
	self assert: matches size = 1.
	self assert: matches first name = 'The Canadian Encyclopedia'.
	matches do: [:each | self assert: (each entries anySatisfy: [:eachEntry | eachEntry id = 'three'])].
	matches do: [:each | self assert: each entries size = 3].