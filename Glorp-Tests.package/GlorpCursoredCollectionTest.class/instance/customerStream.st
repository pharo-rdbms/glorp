support
customerStream
	| rows |
	rows := #( ( 1 'Alan' ) (2 'Bob')).
	^ReadStream on: rows.