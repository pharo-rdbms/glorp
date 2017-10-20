tests
testReadBackEntireExample
	| store |
	store := session readOneOf: GlorpVideoStore where: [:each | each id = 1].
	example assertEqual: store.