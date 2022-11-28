Extension { #name : #UndefinedObject }

{ #category : #'*Glorp' }
UndefinedObject >> glorpPrintSQLOn: aCommand [

	aCommand nextPutAll: 'NULL'.
]
