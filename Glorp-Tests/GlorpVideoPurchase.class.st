Class {
	#name : #GlorpVideoPurchase,
	#superclass : #GlorpTestModelClass,
	#instVars : [
		'id',
		'title',
		'price',
		'inStore',
		'customer',
		'store'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpVideoPurchase class >> new [
	"Answer a newly created and initialized instance."

	^super new initialize
]

{ #category : #comparing }
GlorpVideoPurchase >> <= aVideoPurchase [
	^self title <= aVideoPurchase title.
]

{ #category : #testing }
GlorpVideoPurchase >> assertEqual: aPurchase [

	self assert: customer name = aPurchase customer name.
	self assert: customer dateOfBirth = aPurchase customer dateOfBirth.
	self assert: store id = aPurchase videoStore id.
	self assert: id = aPurchase id.
	self assert: title = aPurchase title.
	self assert: (price * 1000) rounded = (aPurchase price * 1000) rounded.
	self assert: inStore = aPurchase inStore.
]

{ #category : #'As yet unclassified' }
GlorpVideoPurchase >> customer [
	^customer
]

{ #category : #'As yet unclassified' }
GlorpVideoPurchase >> customer: aCustomer [
	customer := aCustomer.
]

{ #category : #accessing }
GlorpVideoPurchase >> id [
	^id
]

{ #category : #accessing }
GlorpVideoPurchase >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpVideoPurchase >> inStore [
	^inStore
]

{ #category : #accessing }
GlorpVideoPurchase >> inStore: anObject [
	inStore := anObject
]

{ #category : #'initialize-release' }
GlorpVideoPurchase >> initialize [
]

{ #category : #accessing }
GlorpVideoPurchase >> price [
	^price
]

{ #category : #accessing }
GlorpVideoPurchase >> price: anObject [
	price := anObject
]

{ #category : #printing }
GlorpVideoPurchase >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self title.
	aStream nextPut: $).
]

{ #category : #'As yet unclassified' }
GlorpVideoPurchase >> store: aGlorpVideoStore [
	store := aGlorpVideoStore.
]

{ #category : #accessing }
GlorpVideoPurchase >> title [
	^title
]

{ #category : #accessing }
GlorpVideoPurchase >> title: aString [
	title := aString
]

{ #category : #'As yet unclassified' }
GlorpVideoPurchase >> videoStore [
	^store.
]
