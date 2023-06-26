Class {
	#name : #GlorpPublisher,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'titles',
		'titlesWithNumberInStock',
		'titlesWithNumberInStockLink',
		'employees',
		'differentBunchOfEmployeesById'
	],
	#category : #'Glorp-Unit-Tests-Models - Encyclopedia'
}

{ #category : #accessing }
GlorpPublisher >> differentBunchOfEmployeesById [
	^differentBunchOfEmployeesById
]

{ #category : #accessing }
GlorpPublisher >> differentBunchOfEmployeesById: aDictionary [
	differentBunchOfEmployeesById := aDictionary
]

{ #category : #accessing }
GlorpPublisher >> employees [
	^employees.
]

{ #category : #accessing }
GlorpPublisher >> employees: aDictionary [
	employees := aDictionary.
]

{ #category : #accessing }
GlorpPublisher >> id [
	^id
]

{ #category : #accessing }
GlorpPublisher >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpPublisher >> name [
	^name
]

{ #category : #accessing }
GlorpPublisher >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GlorpPublisher >> titles [
	^titles
]

{ #category : #accessing }
GlorpPublisher >> titles: aCollectionOfStrings [
	titles := aCollectionOfStrings
]

{ #category : #accessing }
GlorpPublisher >> titlesWithNumberInStock [
	^titlesWithNumberInStock
]

{ #category : #accessing }
GlorpPublisher >> titlesWithNumberInStock: aDictionary [
	titlesWithNumberInStock := aDictionary.
	self titlesWithNumberInStockLink: (Dictionary new addAll: (aDictionary associations collect: [:each | each copy]); yourself).
]

{ #category : #accessing }
GlorpPublisher >> titlesWithNumberInStockLink [
	^titlesWithNumberInStockLink
]

{ #category : #accessing }
GlorpPublisher >> titlesWithNumberInStockLink: aDictionary [
	titlesWithNumberInStockLink := aDictionary
]
