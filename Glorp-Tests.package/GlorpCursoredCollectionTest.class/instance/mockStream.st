support
mockStream
	| rows |
	rows := #( ( 1 'Alan' 101) (2 'Bob' 102) (3 'Carol' 103)).
	^ReadStream on: rows.