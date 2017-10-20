accessing
table
	(self hasField and: [self field notNil]) ifTrue: [^self field table].
	"If we don't have a field, then maybe we have a relationship mapping or a base, so get the descriptor's primary table. Relevant if we have a function like EXISTS"
	^self base table.