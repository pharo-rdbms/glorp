As yet unclassified
release
	super release.
	statement isNil ifFalse: [
		| stmt |
		stmt := statement.
		statement := nil.
		stmt disconnect].