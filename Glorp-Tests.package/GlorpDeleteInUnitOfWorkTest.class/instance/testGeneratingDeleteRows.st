tests
testGeneratingDeleteRows
	unitOfWork delete: GlorpAddress example1.
	unitOfWork createRows.
	self assert: unitOfWork privateGetRowMap numberOfEntries = 1.
	unitOfWork rowsForTable: (self tableNamed: 'GR_ADDRESS')
		do: [:each | self assert: each forDeletion]