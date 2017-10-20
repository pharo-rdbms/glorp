tests
testSuccessfulUpdateTwiceWithRefresh
	| book |
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	session modify: book in: [
		book copiesInStock: 4].
	session refresh: book.
	self assert: book copiesInStock = 4.
	"Make sure we've properly updated the optimistic lock field"
	session modify: book in: [
		book copiesInStock: 7].
	session reset.
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	self assert: book copiesInStock = 7.