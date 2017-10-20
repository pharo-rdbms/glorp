support
joinedStream2
	| rows |
	rows := #( (1 'Alan' 101 101 '1st Avenue' 111  ) (2 'Bob' 102 102 '2nd Avenue' 222  ) ).
	^ReadStream on: rows.