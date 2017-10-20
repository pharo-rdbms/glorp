accessing
numberOfElements
	^subCaches inject: 0 into: [:sum :each |
		sum + each numberOfElements].