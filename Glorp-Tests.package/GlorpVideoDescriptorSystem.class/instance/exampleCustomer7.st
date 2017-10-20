examples
exampleCustomer7
	"A customer with everything"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'George'.
	customer dateOfBirth: (Date today subtractDays: 70 * 365).
	customer addInStorePurchase: self exampleInStorePurchase6.
	customer addOnlinePurchase: self exampleOnlinePurchase3.
	customer addRental: self exampleInStoreRental3.
	customer addRental: self exampleInStoreRental4.
	customer creditStatus: self exampleCreditStatus3.
	^customer.