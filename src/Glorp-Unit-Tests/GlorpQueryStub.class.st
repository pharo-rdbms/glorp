"
A test class. This behaves like a query, but doesn't go to the database, it just returns whatever it was told to return on its creation, regardless of the parameters or session.

Instance Variables:
	result	<Object>	The thing we should return.


"
Class {
	#name : #GlorpQueryStub,
	#superclass : #AbstractReadQuery,
	#instVars : [
		'result'
	],
	#category : #'Glorp-Unit-Tests-Database'
}

{ #category : #'instance creation' }
GlorpQueryStub class >> newQuery [
	^self new.
]

{ #category : #executing }
GlorpQueryStub >> executeWithParameters: parameterArray in: aSession [ 

	aSession register: result.
	^result.
]

{ #category : #initialization }
GlorpQueryStub >> initialize [

	super initialize.
	readsOneObject := true
]

{ #category : #accessing }
GlorpQueryStub >> result [
	^result
]

{ #category : #accessing }
GlorpQueryStub >> result: anObject [
	result := anObject
]
