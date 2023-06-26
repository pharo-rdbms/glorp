"
A money representation in the Bank model
"
Class {
	#name : #GlorpMoney,
	#superclass : #Object,
	#instVars : [
		'currency',
		'amount'
	],
	#category : #'Glorp-Unit-Tests-Models - Bank'
}

{ #category : #'instance creation' }
GlorpMoney class >> currency: aSymbol amount: aNumber [

	^self new
		currency: aSymbol;
		amount: aNumber.
]

{ #category : #'instance creation' }
GlorpMoney class >> defaultCurrency [

	^#CDN.
]

{ #category : #'instance creation' }
GlorpMoney class >> forAmount: anAmount [

	^self currency: self defaultCurrency amount: anAmount.
]

{ #category : #accessing }
GlorpMoney >> amount [

	^ amount
]

{ #category : #accessing }
GlorpMoney >> amount: anInteger [

	amount := anInteger
]

{ #category : #accessing }
GlorpMoney >> currency [

	^ currency
]

{ #category : #accessing }
GlorpMoney >> currency: aSymbol [

	currency := aSymbol
]
