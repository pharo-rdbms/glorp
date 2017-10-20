tests
testTaxInsertOrdering
	| taxes first |
	taxes := OrderedCollection new.
	first := (GlorpBasicTax new)
		name: 'A';
		yourself.
	taxes add: first.
	10 timesRepeat: [self makeSupertaxIn: taxes].
	[session beginTransaction.
	session inUnitOfWorkDo: [session registerAll: taxes]]
		ensure: [session rollbackTransaction].