tests
testBlank
	singleResult := session execute: singleQuery.
	allResult := session execute: allQuery.
	self assert: singleResult class == Array.
	self assert: allResult class == Array.
	self assert: singleResult size = 1.
	self assert: allResult size = 2.