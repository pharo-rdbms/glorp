"
There is a possibility of one of these for each customer in a Store. If there is no credit owing or owed, then there is no record. Otherwise the record exists and records the total amount. This is pretty unlikely as a model of credit, but suits our purposes by providing a 1-1 relationship that may or may not exist.

Instance Variables:
	balanceOwing	<Number>	
	comments	<String>	
	customer	<Customer>
	dateOwing	<Date>


"
Class {
	#name : #GlorpVideoCreditStatus,
	#superclass : #GlorpTestModelClass,
	#instVars : [
		'customer',
		'balanceOwing',
		'dateOwing',
		'comments'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #testing }
GlorpVideoCreditStatus >> assertEqual: aCreditStatus [

	self assert: customer name = aCreditStatus customer name.
	self assert: customer dateOfBirth = aCreditStatus customer dateOfBirth.
	self assert: balanceOwing = aCreditStatus balanceOwing.
	self assert: dateOwing = aCreditStatus dateOwing.
	self assert: comments = aCreditStatus comments.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> balanceOwing [
	^balanceOwing.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> balanceOwing: aNumber [
	balanceOwing := aNumber.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> comments [
	^comments.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> comments: aString [
	comments := aString.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> customer [
	^customer.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> customer: aCustomer [
	customer := aCustomer.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> dateOwing [
	^dateOwing.
]

{ #category : #'As yet unclassified' }
GlorpVideoCreditStatus >> dateOwing: aDate [
	dateOwing := aDate.
]
