Class {
	#name : #GlorpServiceCharge,
	#superclass : #Object,
	#instVars : [
		'description',
		'amount'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpServiceCharge class >> default [

	^self new
		amount: (GlorpMoney forAmount: 3);
		description: 'additional overcharge'.
]

{ #category : #'as yet unclassified' }
GlorpServiceCharge class >> new [

	^super new initialize.
]

{ #category : #accessing }
GlorpServiceCharge >> amount [
	^amount
]

{ #category : #accessing }
GlorpServiceCharge >> amount: anObject [
	amount := anObject
]

{ #category : #accessing }
GlorpServiceCharge >> description [
	^description
]

{ #category : #accessing }
GlorpServiceCharge >> description: anObject [
	description := anObject
]

{ #category : #initialize }
GlorpServiceCharge >> initialize [
]
