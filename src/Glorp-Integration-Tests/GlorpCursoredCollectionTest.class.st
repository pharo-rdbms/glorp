Class {
	#name : #GlorpCursoredCollectionTest,
	#superclass : #TestCase,
	#instVars : [
		'session',
		'stream'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #'as yet unclassified' }
GlorpCursoredCollectionTest class >> resources [
	^Array with: GlorpSessionResource.
]

{ #category : #support }
GlorpCursoredCollectionTest >> customerStream [
	| rows |
	rows := #( ( 1 'Alan' ) (2 'Bob')).
	^ReadStream on: rows.
]

{ #category : #support }
GlorpCursoredCollectionTest >> joinedStream [
	| rows |
	rows := #( ( 1 'Alan' 101 101 '1st Avenue' 111) (2 'Bob' 102 102 '2nd Avenue' 222) ).
	^ReadStream on: rows.
]

{ #category : #support }
GlorpCursoredCollectionTest >> joinedStream2 [
	| rows |
	rows := #( (1 'Alan' 101 101 '1st Avenue' 111  ) (2 'Bob' 102 102 '2nd Avenue' 222  ) ).
	^ReadStream on: rows.
]

{ #category : #support }
GlorpCursoredCollectionTest >> joinedStreamToMany [
	| rows |
	rows := #( (1 'Alan' 101  7 'root' 'foo.com' )  (1 'Alan' 101  8 'root' 'bar.com' )  ).
	^ReadStream on: rows.
]

{ #category : #support }
GlorpCursoredCollectionTest >> joinedStreamToMany3 [
	| rows |
	rows := #( 
			(1 'Alan' 1 '001' '001'  '123' 1 1 #CDN 1.5 'stuff' #CDN 1)  
			(1 'Alan' 1 '001' '001'  '123' 2 1  #USD 1.5 'stuff' #USD 1)
 			(1 'Alan' 2 '002' '002'  '234' 3 1  #CHF 1.5 'stuff' #CHF 1)
			(1 'Alan' 2 '002' '002'  '234' 4 1  #EUR 1.5 'stuff' #EUR 1)
 ).
	^ReadStream on: rows.
]

{ #category : #support }
GlorpCursoredCollectionTest >> mockStream [
	| rows |
	rows := #( ( 1 'Alan' 101) (2 'Bob' 102) (3 'Carol' 103)).
	^ReadStream on: rows.
]

{ #category : #support }
GlorpCursoredCollectionTest >> mockStream2 [
	| rows |
	rows := #( ( 4 'David' 104) (5 'Evan' 105)).
	^ReadStream on: rows.
]

{ #category : #running }
GlorpCursoredCollectionTest >> setUp [

	| query |
	super setUp.
	session := GlorpSessionResource current newSession.
	((session descriptorFor: GlorpCustomer) mappingForAttributeNamed: #name) shouldProxy: false.
	query := Query read: GlorpPerson.
	query session: session.
	query prepare.
	stream := GlorpCursoredStream on: self mockStream for: (query sqlWith: nil) accessor: nil
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testBuilderIsolation [
	"Make sure that we can have multiple streams open simultaneously against the same query"
	| stream2 person1 stream3 person4 person4a |
	stream2 := GlorpCursoredStream on: self mockStream2 for: stream command.
	stream3 := GlorpCursoredStream on: self mockStream2 for: stream command.
	person1 := stream next.
	person4 := stream2 next.
	person4a := stream3 next.
	self assert: person4 == person4a.
	self assert: person4 id = 4.
	self assert: person1 id = 1.
	self assert: stream next id = 2.
	self assert: person4a id = 4.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testCollect [
	self assert: (stream collect: [:each | each name]) = #('Alan' 'Bob' 'Carol').
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testKnittingWithAlsoFetch [
	| query person1 person2 |
	query := Query read: GlorpPerson.
	query session: session.
	query alsoFetch: [:each | each address].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStream2 for: (query sqlWith: nil).
	person1 := stream next.
	self assert: session privateGetCache numberOfElements = 2.
	self assert: person1 address street = '1st Avenue'.
	person2 := stream next.
	self assert: session privateGetCache numberOfElements = 4.
	self assert: stream atEnd.
	self assert: person2 id = 2.
	self assert: person2 address street = '2nd Avenue'.
	self assert: session privateGetCache numberOfElements = 4.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testKnittingWithAlsoFetchDoubleToMany [
	| query customer1 |
	query := Query read: GlorpCustomer.
	query session: session.
	query alsoFetch: [:each | each accounts].
	query alsoFetch: [:each | each transactions].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStreamToMany3 for: (query sqlWith: #()).
	customer1 := stream next.
	self assert: session privateGetCache numberOfElements = 7.
	self assert: stream atEnd.
	self assert: customer1 id = 1.
	self assert: customer1 accounts size = 2.
	self assert: customer1 accounts first accountNumber accountNumber = '123'.
	self assert: customer1 accounts last accountNumber accountNumber = '234'.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testKnittingWithAlsoFetchToManyInSingleGroup [
	| query person1 |
	query := Query read: GlorpPerson.
	query session: session.
	query alsoFetch: [:each | each emailAddresses].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStreamToMany for: (query sqlWith: #()).
	person1 := stream next.
	self assert: session privateGetCache numberOfElements = 3.
	self assert: (person1 emailAddresses allSatisfy: [:each | each user = 'root']).
	self assert: person1 emailAddresses first ~= person1 emailAddresses last.
	self assert: stream atEnd.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testKnittingWithRetrieve [
	| query tuple person1 address1 person2 address2 |
	query := Query read: GlorpPerson.
	query session: session.
	query retrieve: [:each | each].
	query retrieve: [:each | each address].
	query prepare.
	stream := GlorpCursoredStream on: self joinedStream for: (query sqlWith: nil).
	tuple := stream next.
	self assert: session privateGetCache numberOfElements = 2.
	person1 := tuple first.
	address1 := tuple last.
	self assert: address1 street = '1st Avenue'.
	self assert: person1 address == address1.
	tuple := stream next.
	self assert: stream atEnd.
	person2 := tuple first.
	address2 := tuple last.
	self assert: person2 id = 2.
	self assert: address2 street = '2nd Avenue'.
	self assert: person2 address == address2.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testNext [
	| person |
	person := stream next.
	self assert: person class == GlorpPerson.
	self assert: person id = 1.
	self assert: person name = 'Alan'.
	self assert: session privateGetCache numberOfElements = 1.
	person := stream next.
	self assert: person id = 2.
	self assert: person name = 'Bob'.
	self assert: session privateGetCache numberOfElements = 2.
	stream next.
	self assert: stream atEnd.
	self assert: stream next = nil.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testNextColon [
	| people |
	people := stream next: 2.
	self assert: people size = 2.
	self assert: people first id = 1.
	self assert: people first name = 'Alan'.
	self assert: session privateGetCache numberOfElements = 2.
	self assert: people last id = 2.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testPostFetchEvents [
	| query customer |
	query := Query read: GlorpCustomer.
	query session: session.
	query prepare.
	stream := GlorpCursoredStream on: self customerStream for: (query sqlWith: #()).
	customer := stream next.
	self assert: customer seenPostFetch.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testReadEmpty [
	stream := GlorpCursoredStream on: (ReadStream on: #()) for: (stream query sqlWith: #()).
	self assert: stream atEnd.
	self assert: stream next isNil.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testRegistration [
	| person |
	session beginUnitOfWork.
	person := stream next.
	self assert: (session isRegistered: person).
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testRelease [
	| person |
	stream next.
	stream release.
	self assert: stream atEnd.
	self assert: stream next isNil.
]

{ #category : #tests }
GlorpCursoredCollectionTest >> testUpToEnd [
	| people |
	people := stream upToEnd.
	self assert: people size = 3.
	self assert: people first name = 'Alan'.
	self assert: people last name = 'Carol'.
]
