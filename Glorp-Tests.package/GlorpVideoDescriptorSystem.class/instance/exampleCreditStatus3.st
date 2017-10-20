examples
exampleCreditStatus3
	| example |
	example := GlorpVideoCreditStatus new.	
	example balanceOwing: 33.00.
	example dateOwing: (Date today addDays: -1).
	example comments: 'Three'.
	^example.