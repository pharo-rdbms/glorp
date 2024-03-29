"
A customer in the AnySatisfy model
"
Class {
	#name : #ASCustomer,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'orders',
		'customer'
	],
	#category : #'Glorp-Unit-Tests-Models - AnySatisfy'
}

{ #category : #accessing }
ASCustomer >> customer [

	^ customer
]

{ #category : #accessing }
ASCustomer >> customer: anObject [

	customer := anObject
]

{ #category : #accessing }
ASCustomer >> id [

	^ id
]

{ #category : #accessing }
ASCustomer >> id: anObject [

	id := anObject
]

{ #category : #initialization }
ASCustomer >> initialize [

	super initialize.
	orders := OrderedCollection new
]

{ #category : #accessing }
ASCustomer >> name [

	^ name
]

{ #category : #accessing }
ASCustomer >> name: anObject [

	name := anObject
]

{ #category : #accessing }
ASCustomer >> orders [

	^ orders
]

{ #category : #accessing }
ASCustomer >> orders: anObject [

	orders := anObject
]
