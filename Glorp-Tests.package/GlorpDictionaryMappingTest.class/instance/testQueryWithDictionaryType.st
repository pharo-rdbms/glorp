tests
testQueryWithDictionaryType

	| encyclopedias query dict linkTable entryTable refField linkTableField idField |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	linkTable := session system tableNamed: 'ENCYC_ENTRY_LINK'.
	entryTable := session system tableNamed: 'ENCYC_ENTRY'.
	refField := linkTable fieldNamed: 'REFERENCE_NO'.
	linkTableField := linkTable fieldNamed: 'ENCYC_ENTRY_ID'.
	idField := entryTable fieldNamed: 'ID'.
	query := Query read: GlorpEncyclopediaEntry.
	query where: [:each | ((each getTable: linkTable) getField: linkTableField) = ((each getTable: entryTable) getField: idField)].
	query retrieveDictionaryWithKey: [:each | (each getTable: linkTable) getField: refField] value: [:each | each].
	dict := session execute: query.
	self assert: dict class == Dictionary.
	self assert: dict size = 5.
	self assert: (dict at: 'abcde') id = 'two'.
	self assert: (dict at: 'abcde') == (dict at: 'edcba').