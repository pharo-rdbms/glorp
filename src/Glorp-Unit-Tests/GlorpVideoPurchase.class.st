"
An video purchase in the Video model
"
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
	#category : #'Glorp-Unit-Tests-Models - Video'
}

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

{ #category : #accessing }
GlorpVideoPurchase >> customer [
	^customer
]

{ #category : #accessing }
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

{ #category : #accessing }
GlorpVideoPurchase >> store: aGlorpVideoStore [

	store := aGlorpVideoStore
]

{ #category : #accessing }
GlorpVideoPurchase >> title [
	^title
]

{ #category : #accessing }
GlorpVideoPurchase >> title: aString [
	title := aString
]

{ #category : #accessing }
GlorpVideoPurchase >> videoStore [
	^store.
]
