examples
exampleCustomer6
	"A customer with purchases and credit"

	| customer |
	customer := GlorpVideoCustomer new.
	customer name: 'Francois'.
	customer dateOfBirth: (Date today subtractDays: 60 * 365).
	customer addInStorePurchase: self exampleInStorePurchase4.
	customer addInStorePurchase: self exampleInStorePurchase5.
	customer creditStatus: self exampleCreditStatus2.
	^customer.