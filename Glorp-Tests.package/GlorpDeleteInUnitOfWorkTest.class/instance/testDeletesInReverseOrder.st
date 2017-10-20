tests
testDeletesInReverseOrder
	"Not that good a test, because it could be luck with only two tables. Should test this at a lower level"
	| cust trans |
	cust := GlorpCustomer example2.
	trans := cust transactions first.
	"We need to give it a primary key or else the delete logic fails"
	trans id: 42.
	unitOfWork delete: cust.
	unitOfWork delete: trans.
	unitOfWork commit.
	self assert: unitOfWork session rows last owner == cust.
	self assert: (unitOfWork session rows reverse at: 2) owner == trans.