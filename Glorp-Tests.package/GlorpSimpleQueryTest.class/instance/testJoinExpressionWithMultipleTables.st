tests
testJoinExpressionWithMultipleTables
	| query sql sqlStream result command |
	query := SimpleQuery readOneOf: GlorpPassenger where: [ :each | each id = 1 ].
	query session: session.
	query prepare.
	command := query sqlWith: Dictionary new.
	command useBinding: false.
	sql := command sqlString.
	sqlStream := ReadStream on: sql asLowercase.
	sqlStream skipToAll: self skipToString.
	result := sqlStream upToEnd.
	session platform supportsANSIJoins
		ifTrue:
			[ self
				assert: ('*frequent_flyer t2 on *t1.id = t2.id*<n> where *t1.id = 1*' expandMacros withUnixLineEndings match: result withUnixLineEndings) ]
		ifFalse: [ self assert: ('*(t1.id = 1) and ((t1.id = t2.id*' match: result) ]