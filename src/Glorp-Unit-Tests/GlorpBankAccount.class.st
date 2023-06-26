"
An account in the Bank model
"
Class {
	#name : #GlorpBankAccount,
	#superclass : #Object,
	#instVars : [
		'id',
		'accountNumber',
		'accountHolders',
		'eventsReceived'
	],
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #examples }
GlorpBankAccount class >> example1 [

	^self new 
		id: 123;
		accountNumber: GlorpBankAccountNumber example12345.
]

{ #category : #comparing }
GlorpBankAccount >> <= anAccount [

	^ self accountNumber accountNumber
	  <= anAccount accountNumber accountNumber
]

{ #category : #accessing }
GlorpBankAccount >> accountHolders [

	^ accountHolders
]

{ #category : #accessing }
GlorpBankAccount >> accountNumber [
	^accountNumber
]

{ #category : #accessing }
GlorpBankAccount >> accountNumber: anAccountNumber [

	accountNumber := anAccountNumber
]

{ #category : #accessing }
GlorpBankAccount >> basicAddHolder: aCustomer [

	accountHolders add: aCustomer
]

{ #category : #accessing }
GlorpBankAccount >> basicRemoveHolder: aCustomer [

	accountHolders remove: aCustomer
]

{ #category : #accessing }
GlorpBankAccount >> id [

	^ id
]

{ #category : #accessing }
GlorpBankAccount >> id: anObject [

	id := anObject
]

{ #category : #initialization }
GlorpBankAccount >> initialize [

	super initialize.
	accountHolders := OrderedCollection new
]

{ #category : #printing }
GlorpBankAccount >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(id=';
		print: id;
		nextPut: $)
]
