tests
testReadWithFunctionInWhereClause
	"The assertion on what we read doesn't matter too much, as we're primarily testing that the expression doesn't walkback."
	| people |
	people := session read: GlorpPerson where: [:each | each id + each id > 2].
	people do: [:each | self assert: (each id + each id) > 10].
	people := session read: GlorpPerson where: [:each | (each name , each address street) = 'person1Beta'].
	self assert: people size = 1.
	self assert: people first name = 'person1'.