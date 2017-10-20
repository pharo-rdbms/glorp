examples
exampleCustomer2
	"A customer with only inStore purchases"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Bob'.
	customer dateOfBirth: (Date today subtractDays: (20 * 365)).
	customer addInStorePurchase: self exampleInStorePurchase1.
	^customer.