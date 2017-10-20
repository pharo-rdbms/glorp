examples
exampleCreditStatus2
	| example |
	example := GlorpVideoCreditStatus new.	
	example balanceOwing: 22.00.
	example dateOwing: (Date today addDays: -1).
	example comments: 'Two'.
	^example.