tests
testPrintingUninstantiatedCollection
	proxy query readsOneObject: false.
	self assert: proxy printString = '{uninstantiated collection of GlorpAddress}'.