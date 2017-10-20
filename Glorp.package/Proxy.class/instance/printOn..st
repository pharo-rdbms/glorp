printing
printOn: aStream 
	aStream nextPut: ${.
	isInstantiated 
		ifTrue: [self getValue printOn: aStream]
		ifFalse: 
			[aStream nextPutAll: 'uninstantiated '.
			query isNil
				ifTrue: [aStream nextPutAll: '???']
				ifFalse: [
					query readsOneObject ifFalse: [aStream nextPutAll: 'collection of '].
					aStream nextPutAll: query resultClass name]].
	aStream nextPut: $}