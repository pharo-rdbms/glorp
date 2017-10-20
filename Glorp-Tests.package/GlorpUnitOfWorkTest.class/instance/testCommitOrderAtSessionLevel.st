tests
testCommitOrderAtSessionLevel

	| tables | 
	tables := session tablesInCommitOrder.
	tables first name = 'CUSTOMER'.
	self unfinished.