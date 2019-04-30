Class {
	#name : #GlorpObjectComparisonJoinsTest,
	#superclass : #GlorpSessionBasedTest,
	#instVars : [
		'itinerary1',
		'itinerary2'
	],
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpObjectComparisonJoinsTest >> setUp [
	super setUp.
	session system useJoinsForAnySatisfy: true.
	session beginTransaction.
	itinerary1 := GlorpItinerary example1.
	itinerary2 := GlorpItinerary example2.
	itinerary2 reservation passenger: nil.
	itinerary2 reservation passengers: #().

	session transact: [
		session register: itinerary1.
		session register: itinerary2].
]

{ #category : #support }
GlorpObjectComparisonJoinsTest >> tearDown [
	
	session rollbackTransaction.
	itinerary1 := nil.
	itinerary2 := nil.
	super tearDown.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testBasicEqualNil [

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passenger isNIL].
	self assert: reservations size = 1.
	self assert: reservations first id = 7.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testBasicNotNil [

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passenger notNIL].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testEqualNil [

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger isNIL]].
	self assert: reservations size = 1.
	self assert: reservations first id = 7.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testEqualToIdsInExpression [
	"Just to verify that this works when not directly comparing objects"

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger id = each passenger id]].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testEqualToObjectInExpression [
	"A somewhat contrived example of comparing two relationships that should end up with the same object, because they're actually mapped the same way. But will fail if the passenger is nil"

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger = each passenger]].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testEqualToObjectInMemory [
	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger = itinerary1 reservation passenger]].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testNotEqualToObjectInExpression [
	"A somewhat contrived example of comparing two relationships that should end up with the same object, because they're actually mapped the same way. But will fail if the passenger is nil, because nil ~= nil"

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger ~= each passenger]].
	self assert: reservations isEmpty.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testNotEqualToObjectInMemory [
	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger ~= (GlorpPassenger new id: 7)]].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.
]

{ #category : #tests }
GlorpObjectComparisonJoinsTest >> testNotNil [

	| reservations |
	reservations := session read: GlorpReservation where: [:each |
		each passengers anySatisfy: [:eachPassenger | eachPassenger notNIL]].
	self assert: reservations size = 1.
	self assert: reservations first id = 2.
	self assert: reservations first passenger id = 3.
]
