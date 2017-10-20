tests
testUpdate

	| encyclopedias canadian allEntryRows allLinkRows |
	encyclopedias := session system exampleEncyclopedias.
	session transact: [session register: encyclopedias].
	session reset.
	session accessor denyCommands: (Array with: DeleteCommand).
	session inUnitOfWorkDo: [
		| newEntry |
		canadian := session readOneOf: GlorpEncyclopedia where: [:each | each name like: 'The Ca%'].
		newEntry := GlorpEncyclopediaEntry new
			id: 'seven';
			title: 'The Latest Entry';
			text: 'This is all about the very newest stuff'.
		canadian entries at: 'unique' put: newEntry].
	self assert: (canadian entries at: 'abcde') id = 'two'.
	self assert: (canadian entries at: '12345') id = 'one'.
	self assert: (canadian entries at: 'unique') id = 'seven'.
	self assert: (canadian entries at: 'unique') title = 'The Latest Entry'.
	allEntryRows := session accessor executeSQLString: 'select * from ENCYC_ENTRY'.
	"We didn't actually delete the 'three' entry"
	self assert: allEntryRows size = 4.
	allLinkRows := session accessor executeSQLString: 'select * from ENCYC_ENTRY_LINK'.
	"But we should have only our 3 link table rows, plus 2 for the other encyclopedia"
	self assert: allLinkRows size = 5.