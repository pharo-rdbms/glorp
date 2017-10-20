tests
testPrintingInstantiated

	proxy getValue.
	self assert: proxy printString = ('{', proxy getValue printString, '}').