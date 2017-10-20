support
writeTestData

	session writeRow: system exampleWorkerRow.
	session writeRow: (system exampleJobRow: 1 finished: false).
	session writeRow: (system exampleJobRow: 2 finished: false).
	session writeRow: (system exampleJobRow: 3 finished: true).
	session writeRow: (system exampleJobRow: 4 finished: true).
	session writeRow: system exampleLinkRow1.
	session writeRow: system exampleLinkRow2.