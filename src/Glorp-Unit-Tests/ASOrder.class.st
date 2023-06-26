"
An order in the AnySatisfy model
"
Class {
	#name : #ASOrder,
	#superclass : #Object,
	#instVars : [
		'orderNo',
		'lineItems',
		'customer'
	],
	#category : #'Glorp-Unit-Tests-Models - AnySatisfy'
}

{ #category : #accessing }
ASOrder >> customer [

	^ customer
]

{ #category : #accessing }
ASOrder >> customer: anObject [

	customer := anObject
]

{ #category : #initialization }
ASOrder >> initialize [

	super initialize.
	lineItems := OrderedCollection new
]

{ #category : #accessing }
ASOrder >> lineItems [

	^ lineItems
]

{ #category : #accessing }
ASOrder >> lineItems: anObject [

	lineItems := anObject
]

{ #category : #accessing }
ASOrder >> orderNo [

	^ orderNo
]

{ #category : #accessing }
ASOrder >> orderNo: anObject [

	orderNo := anObject
]
