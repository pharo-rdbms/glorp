tests-data reading
testReadDistinctRelatedAttribute

	| query result allStreets |
	query := Query read: GlorpPerson.
	query retrieve: [:each | each address street distinct].
	result := query executeIn: session.
	self assert: (result asSortedCollection asArray = #('Alpha' 'Beta' 'Gamma')).
	allStreets := (session read: GlorpAddress) collect: [:each | each street].
	self assert: allStreets size = 5.