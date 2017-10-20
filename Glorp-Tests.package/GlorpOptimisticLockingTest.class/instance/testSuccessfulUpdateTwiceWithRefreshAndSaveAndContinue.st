tests
testSuccessfulUpdateTwiceWithRefreshAndSaveAndContinue
	| book |
	session beginUnitOfWork.
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	book copiesInStock: 4.
	session saveAndContinue.
	session refresh: book.
	self assert: book copiesInStock = 4.
	"Make sure we've properly updated the optimistic lock field"
	book copiesInStock: 7.
	session commitUnitOfWork.
	session reset.
	book := session readOneOf: GlorpBook where: [:each | each title like: 'Mastering%'].
	self assert: book copiesInStock = 7.