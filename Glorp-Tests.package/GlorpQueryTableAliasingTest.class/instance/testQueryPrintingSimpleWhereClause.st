tests
testQueryPrintingSimpleWhereClause
	| string |
	string := self helpTestPrintingWhereClause: ((expression get: #name) get: #= withArguments: #('Fred')).
	self assert: '(t1.NAME = ''Fred'')' equalsIgnoringOuterBrackets: string.