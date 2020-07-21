Class {
	#name : #GlorpVideoCustomer,
	#superclass : #GlorpTestModelClass,
	#instVars : [
		'name',
		'dateOfBirth',
		'onlinePurchases',
		'inStorePurchases',
		'inStoreRentals',
		'store',
		'creditStatus'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpVideoCustomer class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]

{ #category : #comparing }
GlorpVideoCustomer >> <= aVideoCustomer [
	^self name < aVideoCustomer name
	or: [self name = aVideoCustomer name
		and: [self dateOfBirth <= aVideoCustomer dateOfBirth]]
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> addInStorePurchase: aPurchase [
	inStorePurchases add: aPurchase.
	aPurchase customer: self.
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> addOnlinePurchase: aPurchase [
	onlinePurchases add: aPurchase.
	aPurchase customer: self.
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> addRental: aRental [
	inStoreRentals add: aRental.
	aRental customer: self.
]

{ #category : #testing }
GlorpVideoCustomer >> assertEqual: aCustomer [

	onlinePurchases assertEqual: aCustomer onlinePurchases.
	inStorePurchases assertEqual: aCustomer inStorePurchases.
	inStoreRentals assertEqual: aCustomer inStoreRentals.
	creditStatus assertEqual: aCustomer creditStatus.
	self assert: store id = aCustomer videoStore id.
	self assert: name = aCustomer name.
	self assert: dateOfBirth = aCustomer dateOfBirth.
]

{ #category : #accessing }
GlorpVideoCustomer >> creditStatus [
	^creditStatus
]

{ #category : #accessing }
GlorpVideoCustomer >> creditStatus: aCreditStatus [
	creditStatus := aCreditStatus.
	creditStatus isNil ifFalse: [creditStatus customer: self].
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> dateOfBirth [
	^dateOfBirth.
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> dateOfBirth: aDate [
	dateOfBirth := aDate.
]

{ #category : #accessing }
GlorpVideoCustomer >> inStorePurchases [
	^inStorePurchases
]

{ #category : #accessing }
GlorpVideoCustomer >> inStorePurchases: anObject [
	inStorePurchases := anObject
]

{ #category : #accessing }
GlorpVideoCustomer >> inStoreRentals [
	^inStoreRentals.
]

{ #category : #'initialize-release' }
GlorpVideoCustomer >> initialize [
	onlinePurchases := OrderedCollection new.
	inStorePurchases :=OrderedCollection new.
	inStoreRentals := OrderedCollection new.
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> name [
	^name.
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> name: aString [
	name := aString.
]

{ #category : #accessing }
GlorpVideoCustomer >> onlinePurchases [
	^onlinePurchases
]

{ #category : #accessing }
GlorpVideoCustomer >> onlinePurchases: anObject [
	onlinePurchases := anObject
]

{ #category : #printing }
GlorpVideoCustomer >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (name isNil ifTrue: [''] ifFalse: [name]).
	aStream nextPut: $).
]

{ #category : #'As yet unclassified' }
GlorpVideoCustomer >> purchases [
	^inStorePurchases, onlinePurchases.
]

{ #category : #accessing }
GlorpVideoCustomer >> store: anObject [
	store := anObject
]

{ #category : #accessing }
GlorpVideoCustomer >> videoStore [
	^store
]
