Class {
	#name : #GlorpObjectTransactionTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'transaction',
		'objects'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #running }
GlorpObjectTransactionTest >> setUp [

	super setUp.
	transaction := ObjectTransaction new
]

{ #category : #tests }
GlorpObjectTransactionTest >> testArray [
	| object |
	object := #(1 2 3 4 5) copy.
	transaction begin.
	transaction register: object.
	object
		at: 1 put: #one;
		at: 2 put: object.
	transaction abort.
	self
		assert: (object at: 1) == 1;
		assert: (object at: 2) == 2
]

{ #category : #tests }
GlorpObjectTransactionTest >> testBecome [
	| object |
	object := 'hello' copy.
	transaction begin.
	transaction register: object.
	object become: Set new.
	transaction abort.
	self 
		assert: object class == '' class;
		assert: object = 'hello'.
]

{ #category : #tests }
GlorpObjectTransactionTest >> testCommit [
	| array |
	array := #(1 2 3 4 5) copy.
	transaction begin.
	transaction register: array.
	array
		at: 1 put: #one;
		at: 2 put: array.
	transaction commit.
	self
		assert: (array at: 1) == #one;
		assert: (array at: 2) == array
]

{ #category : #tests }
GlorpObjectTransactionTest >> testHashedCollection [
	| object originalMembers |
	object := Set new.
	originalMembers := #(#one #two #three 'four' 5 'vi' (1 2 3 4 5 6 7)) collect: [:each | each copy].
	object addAll: originalMembers.
	transaction begin.
	transaction register: object.
	object remove: #one; remove: (originalMembers at: 4).
	object add: 1.
	originalMembers last at: 7 put: 'seven'.
	transaction abort.
	self
		assert: object size = originalMembers size;
		assert: (object includes: originalMembers first);
		assert: (object includes: (originalMembers at: 4));
		assert: object size = (object rehash; size).
	originalMembers do: [:each | self assert: (object includes: each)]
]

{ #category : #tests }
GlorpObjectTransactionTest >> testRegisteredObjectsDoRecursively [

	| link |
	link := 1 -> (2 -> (3 -> (4 ->5))).
	transaction register: link.
	self assert: transaction undoMap size equals: 1.
	transaction registeredObjectsDo: [:each |
		transaction register: each value].
	self assert: transaction undoMap size equals: 4
]

{ #category : #tests }
GlorpObjectTransactionTest >> testString [
	| object |
	object := 'Hello, World!' copy.
	transaction begin.
	transaction register: object.
	object
		at: 1 put: $h;
		at: 2 put: $E.
	transaction abort.
	self
		assert: object first  == $H;
		assert: (object at: 2) == $e
]
