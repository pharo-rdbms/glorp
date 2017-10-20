support
joinedStreamToMany
	| rows |
	rows := #( (1 'Alan' 101  7 'root' 'foo.com' )  (1 'Alan' 101  8 'root' 'bar.com' )  ).
	^ReadStream on: rows.