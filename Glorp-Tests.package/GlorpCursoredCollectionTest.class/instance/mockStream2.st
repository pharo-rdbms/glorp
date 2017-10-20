support
mockStream2
	| rows |
	rows := #( ( 4 'David' 104) (5 'Evan' 105)).
	^ReadStream on: rows.