setup
writeMore

	| other |
	session transact: [
		session register: GlorpThingWithLotsOfDifferentCollections example1.
		other := GlorpThingWithLotsOfDifferentCollections example1.
		other name: 'barney'.
		session register: other].