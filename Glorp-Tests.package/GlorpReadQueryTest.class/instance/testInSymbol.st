tests
testInSymbol
	| query result transRow transRow2 |
	transRow := session system exampleBankTransactionRow.
	session writeRow: transRow.	
	transRow2 := session system exampleBankTransactionRow2.
	session writeRow: transRow2.	
	query := Query read: GlorpBankTransaction where: [:each | each amount currency in: #(#USD #CDN)].
	result := session execute: query.
	self assert: (result allSatisfy: [:each | each amount currency = #CDN]).
	self assert: result size = 1.
	query := Query read: GlorpBankTransaction where: [:each | each amount currency in: #(#USD #DM)].
	result := session execute: query.
	self assert: result isEmpty.