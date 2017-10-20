examples
exampleCustomer8
	"A customer with just a single purchase"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Hieronymous'.
	customer dateOfBirth: (Date today subtractDays: 80 * 365).
	customer addInStorePurchase: self exampleInStorePurchase7.
	^customer.