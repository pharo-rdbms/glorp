tests
testCollectionValueQueryWithImpliedValue

	| encyclopedias matches |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	matches := session read: GlorpEncyclopedia where: [:each | each entries anySatisfy: [:eachEntry |
		eachEntry title = 'Vehicular Fish Decay']].
	self assert: matches size = 1.
	self assert: matches first name = 'The Canadian Encyclopedia'.
	matches do: [:each | self assert: (each entries anySatisfy: [:eachEntry | eachEntry id = 'three'])].
	matches do: [:each | self assert: each entries size = 3].