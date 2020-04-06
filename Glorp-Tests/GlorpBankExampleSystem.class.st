Class {
	#name : #GlorpBankExampleSystem,
	#superclass : #GlorpExampleSystem,
	#category : 'Glorp-Tests-Models'
}

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpAddressNumber1: anAddress [
	anAddress id: 12.
	anAddress street: 'Paseo Montril'.
	anAddress number: '10185'.
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumber1: anAccount [

	anAccount id: 1.
	anAccount accountNumber: (self objectNumber: 1 ofClass: GlorpBankAccountNumber).
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumber2: anAccount [

	anAccount id: 2.
	anAccount accountNumber: (self objectNumber: 2 ofClass: GlorpBankAccountNumber).
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumberNumber1: aBankAccountNumber [

	aBankAccountNumber bankCode: '004'.
	aBankAccountNumber branchNumber: 0342.
	aBankAccountNumber accountNumber: '12345'.
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumberNumber2: aBankAccountNumber [

	aBankAccountNumber bankCode: '004'.
	aBankAccountNumber branchNumber: 0342.
	aBankAccountNumber accountNumber: '01010'.
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankTransactionNumber1: aTrans [

	"Nothing to initialize"
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankTransactionNumber2: aTrans [

	"Nothing to initialize"
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpCustomerNumber1: aCustomer [

	aCustomer id: 1.
	aCustomer name: 'Fred Flintstone'.
	aCustomer addTransaction: (self objectNumber: 1 ofClass: GlorpBankTransaction).
	aCustomer addTransaction: (self objectNumber: 2 ofClass: GlorpBankTransaction).
	aCustomer addAccount: (self objectNumber: 1 ofClass: GlorpBankAccount).
	aCustomer addAccount: (self objectNumber: 2 ofClass: GlorpBankAccount).
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpEmailAddressNumber1: anEmailAddress [ 
	anEmailAddress id: 2.
	anEmailAddress user: 'foo'.
	anEmailAddress host: 'bar.com'
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpPersonNumber1: aPerson [ 
	aPerson id: 1.
	aPerson name: 'Barney Rubble'.
	aPerson address: (self objectNumber: 1 ofClass: GlorpAddress).	
	aPerson emailAddress: (self objectNumber: 1 ofClass: GlorpEmailAddress).
]
