tests-ordering
testOrderSQL
	| query sql |
	query := SimpleQuery read: GlorpAddress.
	query orderBy: [:each | each id].
	self setUpQueryFully: query.
	sql := (query sqlWith: Dictionary new) sqlString.
	self assert: ('* from *gr_address t1 order by t1.id' match: sql asLowercase).