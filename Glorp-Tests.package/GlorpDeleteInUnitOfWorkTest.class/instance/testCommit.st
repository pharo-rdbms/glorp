tests
testCommit

	unitOfWork delete: GlorpAddress example1.
	unitOfWork commit.
	self assert: (unitOfWork numberOfRows) = 1.