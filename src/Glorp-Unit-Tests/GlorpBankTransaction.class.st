"
An bank transaction in the Bank model
"
Class {
	#name : #GlorpBankTransaction,
	#superclass : #Object,
	#instVars : [
		'id',
		'owner',
		'amount',
		'serviceCharge'
	],
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #examples }
GlorpBankTransaction class >> example1 [

	^self new
]

{ #category : #examples }
GlorpBankTransaction class >> example2 [

	^self new
]

{ #category : #accessing }
GlorpBankTransaction >> amount [

	^ amount
]

{ #category : #accessing }
GlorpBankTransaction >> amount: aGlorpMoney [

	amount := aGlorpMoney
]

{ #category : #accessing }
GlorpBankTransaction >> id [
	"Private - Answer the value of the receiver's ''id'' instance variable."

	^ id
]

{ #category : #accessing }
GlorpBankTransaction >> id: anObject [
	"Private - Set the value of the receiver's ''id'' instance variable to the argument, anObject."

	id := anObject
]

{ #category : #initialization }
GlorpBankTransaction >> initialize [

	super initialize.
	amount := GlorpMoney forAmount: 0.
	serviceCharge := GlorpServiceCharge default
]

{ #category : #accessing }
GlorpBankTransaction >> owner [
	"Private - Answer the value of the receiver's ''owner'' instance variable."

	^ owner
]

{ #category : #accessing }
GlorpBankTransaction >> owner: aCustomer [

	owner := aCustomer
]

{ #category : #accessing }
GlorpBankTransaction >> serviceCharge [

	^ serviceCharge
]

{ #category : #accessing }
GlorpBankTransaction >> serviceCharge: aServiceCharge [

	serviceCharge := aServiceCharge
]
