printing
printTreeOn: aStream 
	[lookupKey printSQLOn: aStream withParameters: #()] on: Dialect error do: [:ex | lookupKey printOn: aStream].