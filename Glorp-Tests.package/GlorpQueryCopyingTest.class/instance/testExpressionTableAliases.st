tests
testExpressionTableAliases
	query prepare.
	newQuery := query copy.
	self assert: (self tableAliasesPresentFor: query).
	self deny: (self tableAliasesPresentFor: newQuery).