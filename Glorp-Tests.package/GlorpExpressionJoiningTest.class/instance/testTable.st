tests
testTable
	| result exp table |
	table := DatabaseTable named: 'T'.
	exp := base getTable: table.
	result := self join: exp. 
	self assert: result base == target.
	self assert: result table == table.