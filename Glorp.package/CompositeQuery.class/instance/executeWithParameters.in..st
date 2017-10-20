executing
executeWithParameters: parameterArray in: aSession
	| results |
	results := self collectionType new writeStream.
	queries do: [:each |
		results nextPutAll: (each executeWithParameters: parameterArray in: aSession)].
	^results contents