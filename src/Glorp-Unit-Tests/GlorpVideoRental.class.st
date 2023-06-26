"
An video rental store in the Video model
"
Class {
	#name : #GlorpVideoRental,
	#superclass : #GlorpTestModelClass,
	#instVars : [
		'id',
		'title',
		'dueDate',
		'price',
		'customer',
		'store'
	],
	#category : #'Glorp-Unit-Tests-Models - Video'
}

{ #category : #comparing }
GlorpVideoRental >> <= aVideoRental [
	^self title <= aVideoRental title.
]

{ #category : #testing }
GlorpVideoRental >> assertEqual: aRental [

	self assert: customer name equals: aRental customer name.
	self
		assert: customer dateOfBirth
		equals: aRental customer dateOfBirth.
	self assert: id equals: aRental id.
	self assert: title equals: aRental title.
	self assert: price equals: aRental price.
	self assert: dueDate equals: aRental dueDate
]

{ #category : #accessing }
GlorpVideoRental >> customer [

	^ customer
]

{ #category : #accessing }
GlorpVideoRental >> customer: aCustomer [

	customer := aCustomer
]

{ #category : #accessing }
GlorpVideoRental >> dueDate [

	^ dueDate
]

{ #category : #accessing }
GlorpVideoRental >> dueDate: anObject [

	dueDate := anObject
]

{ #category : #accessing }
GlorpVideoRental >> id [

	^ id
]

{ #category : #accessing }
GlorpVideoRental >> id: anObject [

	id := anObject
]

{ #category : #accessing }
GlorpVideoRental >> price [

	^ price
]

{ #category : #accessing }
GlorpVideoRental >> price: anObject [

	price := anObject
]

{ #category : #printing }
GlorpVideoRental >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self title.
	aStream nextPut: $)
]

{ #category : #accessing }
GlorpVideoRental >> store: aGlorpVideoStore [

	store := aGlorpVideoStore
]

{ #category : #accessing }
GlorpVideoRental >> title [

	^ title
]

{ #category : #accessing }
GlorpVideoRental >> title: anObject [

	title := anObject
]
