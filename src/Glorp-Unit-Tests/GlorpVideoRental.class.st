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

	self assert: customer name = aRental customer name.
	self assert: customer dateOfBirth = aRental customer dateOfBirth.
	self assert: id = aRental id.
	self assert: title = aRental title.
	self assert: price = aRental price.
	self assert: dueDate = aRental dueDate.
]

{ #category : #accessing }
GlorpVideoRental >> customer [
	^customer.
]

{ #category : #accessing }
GlorpVideoRental >> customer: aCustomer [
	customer := aCustomer.
]

{ #category : #accessing }
GlorpVideoRental >> dueDate [
	^dueDate
]

{ #category : #accessing }
GlorpVideoRental >> dueDate: anObject [
	dueDate := anObject
]

{ #category : #accessing }
GlorpVideoRental >> id [
	^id
]

{ #category : #accessing }
GlorpVideoRental >> id: anObject [
	id := anObject
]

{ #category : #'initialize-release' }
GlorpVideoRental >> initialize [
	"Initialize a newly created instance. This method must answer the receiver."

	" *** Edit the following to properly initialize instance variables ***"
	id := nil.
	title := nil.
	dueDate := nil.
	price := nil.
	" *** And replace this comment with additional initialization code *** "
	^self
]

{ #category : #accessing }
GlorpVideoRental >> price [
	^price
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
	aStream nextPut: $).
]

{ #category : #accessing }
GlorpVideoRental >> store: aGlorpVideoStore [

	store := aGlorpVideoStore
]

{ #category : #accessing }
GlorpVideoRental >> title [
	^title
]

{ #category : #accessing }
GlorpVideoRental >> title: anObject [
	title := anObject
]
