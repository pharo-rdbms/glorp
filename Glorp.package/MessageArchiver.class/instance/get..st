expression protocol
get: aSymbol 
	^MessageArchiver receiver: self
		selector: aSymbol
		arguments: #()