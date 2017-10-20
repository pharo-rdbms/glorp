tests-ordering
testDoubleOrderSQL
	| query sql |
	query := SimpleQuery read: GlorpAddress.
	query orderBy: [:each | each id].
	query orderBy: [:each | each number].
	self setUpQueryFully: query.
	sql := (query sqlWith: Dictionary new) sqlString.
	self assert: ('* from *gr_address t1 order by t1.id, t1.house_num' match: sql asLowercase).