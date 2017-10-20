examples
exampleCreditStatus1
	| example |
	example := GlorpVideoCreditStatus new.	
	example balanceOwing: 12.00.
	example dateOwing: (Date today addDays: -1).
	example comments: 'One'.
	^example.