"
An video store in the Video model
"
Class {
	#name : #GlorpVideoStore,
	#superclass : #GlorpTestModelClass,
	#instVars : [
		'id',
		'name',
		'customers',
		'purchases',
		'rentals'
	],
	#category : #'Glorp-Unit-Tests-Models - Video'
}

{ #category : #testing }
GlorpVideoStore >> assertEqual: aStore [

	self assert: id equals: aStore id.
	self assert: name equals: aStore name.

	customers assertEqual: aStore customers.
	purchases assertEqual: aStore purchases
]

{ #category : #private }
GlorpVideoStore >> computeCollections [

	customers do: [:each | each store: self].
	purchases := customers inject: #() into: [:sum :each | sum, each purchases].
	purchases do: [:each | each store: self]
]

{ #category : #accessing }
GlorpVideoStore >> customers [

	^ customers
]

{ #category : #accessing }
GlorpVideoStore >> customers: anObject [

	customers := anObject
]

{ #category : #'As yet unclassified' }
GlorpVideoStore >> id [
	^id.
]

{ #category : #'As yet unclassified' }
GlorpVideoStore >> id: anInteger [
	id := anInteger.
]

{ #category : #initialization }
GlorpVideoStore >> initialize [

	super initialize.
	customers := OrderedCollection new.
	purchases := OrderedCollection new
]

{ #category : #'As yet unclassified' }
GlorpVideoStore >> name [

	^ name
]

{ #category : #'As yet unclassified' }
GlorpVideoStore >> name: aString [

	name := aString
]

{ #category : #accessing }
GlorpVideoStore >> purchases [

	^ purchases
]

{ #category : #accessing }
GlorpVideoStore >> purchases: aCollection [

	purchases := aCollection
]
