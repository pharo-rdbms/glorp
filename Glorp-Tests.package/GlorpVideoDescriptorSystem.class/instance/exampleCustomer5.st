examples
exampleCustomer5
	"A customer with purchases and rentals"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Eleanor'.
	customer dateOfBirth: (Date today subtractDays: 50 * 365).
	customer addInStorePurchase: self exampleInStorePurchase2.
	customer addInStorePurchase: self exampleInStorePurchase3.
	customer addRental: self exampleInStoreRental2.
	^customer.