"
A service charge in the Bank model
"
Class {
	#name : #GlorpServiceCharge,
	#superclass : #Object,
	#instVars : [
		'description',
		'amount'
	],
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #accessing }
GlorpServiceCharge class >> default [

	^ self new
		  amount: (GlorpMoney forAmount: 3);
		  description: 'additional overcharge'
]

{ #category : #accessing }
GlorpServiceCharge >> amount [

	^ amount
]

{ #category : #accessing }
GlorpServiceCharge >> amount: anObject [

	amount := anObject
]

{ #category : #accessing }
GlorpServiceCharge >> description [

	^ description
]

{ #category : #accessing }
GlorpServiceCharge >> description: anObject [

	description := anObject
]
