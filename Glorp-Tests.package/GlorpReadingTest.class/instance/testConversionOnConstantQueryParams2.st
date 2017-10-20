tests
testConversionOnConstantQueryParams2
	| query result transRow |
	
	[
	session beginTransaction.
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.
	query := Query read: GlorpBankTransaction where: [:trans | trans amount amount = 7].
	result := session execute: query.
	self assert: result size = 1.
	self assert: result first amount amount = 7] 
			ensure: [session rollbackTransaction]