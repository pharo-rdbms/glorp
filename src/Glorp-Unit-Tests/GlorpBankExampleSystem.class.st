"
The bank example system
"
Class {
	#name : #GlorpBankExampleSystem,
	#superclass : #GlorpExampleSystem,
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpAddressNumber1: anAddress [

	anAddress
		id: 12;
		street: 'Paseo Montril';
		number: '10185'
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumber1: anAccount [

	anAccount id: 1.
	anAccount accountNumber: (self objectNumber: 1 ofClass: GlorpBankAccountNumber)
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumber2: anAccount [

	anAccount id: 2.
	anAccount accountNumber: (self objectNumber: 2 ofClass: GlorpBankAccountNumber)
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumberNumber1: aBankAccountNumber [

	aBankAccountNumber
		bankCode: '004';
		branchNumber: 0342;
		accountNumber: '12345'
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpBankAccountNumberNumber2: aBankAccountNumber [

	aBankAccountNumber
		bankCode: '004';
		branchNumber: 0342;
		accountNumber: '01010'
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

	aCustomer
		id: 1;
		name: 'Fred Flintstone';
		addTransaction: (self objectNumber: 1 ofClass: GlorpBankTransaction);
		addTransaction: (self objectNumber: 2 ofClass: GlorpBankTransaction);
		addAccount: (self objectNumber: 1 ofClass: GlorpBankAccount);
		addAccount: (self objectNumber: 2 ofClass: GlorpBankAccount)
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpEmailAddressNumber1: anEmailAddress [

	anEmailAddress
		id: 2;
		user: 'foo';
		host: 'bar.com'
]

{ #category : #examples }
GlorpBankExampleSystem >> exampleGlorpPersonNumber1: aPerson [ 
	aPerson id: 1.
	aPerson name: 'Barney Rubble'.
	aPerson address: (self objectNumber: 1 ofClass: GlorpAddress).	
	aPerson emailAddress: (self objectNumber: 1 ofClass: GlorpEmailAddress).
]
