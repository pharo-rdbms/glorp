examples
exampleCustomer3
	"A customer with only rentals"
	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Carol'.
	customer dateOfBirth: (Date today subtractDays: (30 * 365)).
	customer addRental: self exampleInStoreRental1.
	^customer.