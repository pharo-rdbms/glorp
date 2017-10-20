tests
makeSupertaxIn: aCollection
	| previous newTax |
	previous := aCollection last.
	newTax := (GlorpBasicTax new)
		name: (String with: (Character value: previous name first asInteger + 1));
		yourself.
	previous addTax: newTax.
	aCollection add: newTax.