Class {
	#name : #GlorpCompressedMoney,
	#superclass : #Object,
	#instVars : [
		'id',
		'array'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #examples }
GlorpCompressedMoney class >> currency: aSymbol amount: aNumber [

	^super new initialize
		currency: aSymbol;
		amount: aNumber.
]

{ #category : #examples }
GlorpCompressedMoney class >> defaultCurrency [

	^#CDN.
]

{ #category : #examples }
GlorpCompressedMoney class >> forAmount: aNumber [

	^self currency: self defaultCurrency amount: aNumber.
]

{ #category : #accessing }
GlorpCompressedMoney >> amount [
	^array at: 2
]

{ #category : #accessing }
GlorpCompressedMoney >> amount: anObject [
	array at: 2 put: anObject
]

{ #category : #accessing }
GlorpCompressedMoney >> currency [
	^array at: 1
]

{ #category : #accessing }
GlorpCompressedMoney >> currency: anObject [
	array at: 1 put: anObject
]

{ #category : #accessing }
GlorpCompressedMoney >> id [
	^id
]

{ #category : #accessing }
GlorpCompressedMoney >> id: anObject [
	id := anObject
]

{ #category : #initialize }
GlorpCompressedMoney >> initialize [

	array := Array new: 2.
]

{ #category : #printing }
GlorpCompressedMoney >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self amount;
		space;
		nextPutAll: self currency;
		nextPut: $).
]
