Class {
	#name : #GlorpBookstoreCustomer,
	#superclass : #Object,
	#instVars : [
		'name',
		'accountNumber',
		'booksOnOrder'
	],
	#category : #'Glorp-Unit-Tests-Models - Bookstore'
}

{ #category : #accessing }
GlorpBookstoreCustomer >> accountNumber [
	^accountNumber
]

{ #category : #accessing }
GlorpBookstoreCustomer >> accountNumber: anObject [
	accountNumber := anObject
]

{ #category : #accessing }
GlorpBookstoreCustomer >> booksOnOrder [
	^booksOnOrder
]

{ #category : #accessing }
GlorpBookstoreCustomer >> booksOnOrder: someBooks [
	booksOnOrder := someBooks.
]

{ #category : #initialization }
GlorpBookstoreCustomer >> initialize [

	super initialize.
	booksOnOrder := OrderedCollection new
]

{ #category : #accessing }
GlorpBookstoreCustomer >> name [
	^name
]

{ #category : #accessing }
GlorpBookstoreCustomer >> name: anObject [
	name := anObject
]
