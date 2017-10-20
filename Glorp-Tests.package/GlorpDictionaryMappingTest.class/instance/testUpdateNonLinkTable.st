tests
testUpdateNonLinkTable
	"Test updating a dictionary where we don't have a link table, but the target table refers back to the containing object."
	| encyclopedias canadian bio newBio |
	encyclopedias := session system exampleEncyclopedias.
	bio := GlorpEncyclopediaBioEntry new title: 'Alan Kay'; text: 'A stub'.
	encyclopedias first biographicalEntries at: bio title put: bio.
	session transact: [session register: encyclopedias].
	session reset.
	session inUnitOfWorkDo: [
		canadian := session readOneOf: GlorpEncyclopedia where: [:each | each name like: 'The Ca%'].
		newBio := GlorpEncyclopediaBioEntry new
			title: 'Alan Kay';
			text: 'a bit more information'.
		canadian biographicalEntries at: 'Alan Kay' put: newBio].
	session reset.
	canadian := session readOneOf: GlorpEncyclopedia where: [:each | each name like: 'The Ca%'].
	self assert: canadian biographicalEntries size = 1.
	self assert: (canadian biographicalEntries at: 'Alan Kay') text = 'a bit more information'.
	self assert: (session count: GlorpEncyclopediaBioEntry) = 1.