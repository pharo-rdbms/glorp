tests
check: aClass
	| collectionClass |
	collectionClass := aClass isBehavior ifTrue: [aClass] ifFalse: [aClass class].
	singleQuery collectionType: aClass.
	allQuery collectionType: aClass.
	singleResult := session execute: singleQuery.
	allResult := session execute: allQuery.
	self assert: singleResult class == collectionClass.
	self assert: allResult class == collectionClass.
	self assert: singleResult size = 1.
	self assert: allResult size = 2.