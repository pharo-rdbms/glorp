tests-ordering
testDescendingSingleOrdering
	| query result sortedResult |
	
	query := Query read: GlorpAddress where: [:each | each street ~= 'Beta'].
	query orderBy: [:each | each street descending].
	result := session execute: query.
	sortedResult := result 
				asSortedCollection: [:a :b | a street > b street].
	self assert: sortedResult asArray = result asArray.