"
An itinerary holds onto a single reservation. It may not make much sense, but we need to test another layer of indirection.

"
Class {
	#name : #GlorpItinerary,
	#superclass : #Object,
	#instVars : [
		'id',
		'reservation'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #examples }
GlorpItinerary class >> example1 [
	^self new
		reservation: GlorpReservation example1.
]

{ #category : #examples }
GlorpItinerary class >> example2 [
	^self new
		reservation: GlorpReservation example2.
]

{ #category : #accessing }
GlorpItinerary >> id [
	^id
]

{ #category : #accessing }
GlorpItinerary >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpItinerary >> reservation [
	^reservation
]

{ #category : #accessing }
GlorpItinerary >> reservation: anObject [
	reservation := anObject
]
