examples
exampleCustomer1
	"A customer with only online purchases"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Adrian'.
	customer dateOfBirth: (Date today subtractDays: (10 * 365)).
	customer addOnlinePurchase: self exampleOnlinePurchase1.
	customer addOnlinePurchase: self exampleOnlinePurchase2.
	^customer.