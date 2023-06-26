"
An video store customer in the Video model
"
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
	#category : #'Glorp-Unit-Tests-Models - Video'
}

{ #category : #comparing }
GlorpVideoCustomer >> <= aVideoCustomer [

	^ self name < aVideoCustomer name or: [
		  self name = aVideoCustomer name and: [
			  self dateOfBirth <= aVideoCustomer dateOfBirth ] ]
]

{ #category : #accessing }
GlorpVideoCustomer >> addInStorePurchase: aPurchase [

	inStorePurchases add: aPurchase.
	aPurchase customer: self
]

{ #category : #accessing }
GlorpVideoCustomer >> addOnlinePurchase: aPurchase [

	onlinePurchases add: aPurchase.
	aPurchase customer: self
]

{ #category : #accessing }
GlorpVideoCustomer >> addRental: aRental [

	inStoreRentals add: aRental.
	aRental customer: self
]

{ #category : #testing }
GlorpVideoCustomer >> assertEqual: aCustomer [

	onlinePurchases assertEqual: aCustomer onlinePurchases.
	inStorePurchases assertEqual: aCustomer inStorePurchases.
	inStoreRentals assertEqual: aCustomer inStoreRentals.
	creditStatus assertEqual: aCustomer creditStatus.
	self assert: store id equals: aCustomer videoStore id.
	self assert: name equals: aCustomer name.
	self assert: dateOfBirth equals: aCustomer dateOfBirth
]

{ #category : #accessing }
GlorpVideoCustomer >> creditStatus [

	^ creditStatus
]

{ #category : #accessing }
GlorpVideoCustomer >> creditStatus: aCreditStatus [

	creditStatus := aCreditStatus.
	creditStatus ifNotNil: [ creditStatus customer: self ]
]

{ #category : #accessing }
GlorpVideoCustomer >> dateOfBirth [

	^ dateOfBirth
]

{ #category : #accessing }
GlorpVideoCustomer >> dateOfBirth: aDate [

	dateOfBirth := aDate
]

{ #category : #accessing }
GlorpVideoCustomer >> inStorePurchases [

	^ inStorePurchases
]

{ #category : #accessing }
GlorpVideoCustomer >> inStorePurchases: anObject [

	inStorePurchases := anObject
]

{ #category : #accessing }
GlorpVideoCustomer >> inStoreRentals [

	^ inStoreRentals
]

{ #category : #initialization }
GlorpVideoCustomer >> initialize [

	super initialize.
	onlinePurchases := OrderedCollection new.
	inStorePurchases :=OrderedCollection new.
	inStoreRentals := OrderedCollection new
]

{ #category : #accessing }
GlorpVideoCustomer >> name [

	^ name
]

{ #category : #accessing }
GlorpVideoCustomer >> name: aString [

	name := aString
]

{ #category : #accessing }
GlorpVideoCustomer >> onlinePurchases [

	^ onlinePurchases
]

{ #category : #accessing }
GlorpVideoCustomer >> onlinePurchases: anObject [

	onlinePurchases := anObject
]

{ #category : #printing }
GlorpVideoCustomer >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (name ifNil: [ '' ] ifNotNil: [ name ]).
	aStream nextPut: $)
]

{ #category : #accessing }
GlorpVideoCustomer >> purchases [

	^ inStorePurchases , onlinePurchases
]

{ #category : #accessing }
GlorpVideoCustomer >> store: anObject [

	store := anObject
]

{ #category : #accessing }
GlorpVideoCustomer >> videoStore [

	^ store
]
