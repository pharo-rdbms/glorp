examples
exampleCustomer4
	"A customer with only credit"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'David'.
	customer dateOfBirth: (Date today subtractDays: (40 * 365)).
	customer creditStatus: self exampleCreditStatus1.
	^customer.