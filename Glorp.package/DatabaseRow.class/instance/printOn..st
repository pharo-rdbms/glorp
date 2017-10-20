printing
printOn: aStream

	super printOn: aStream.
	aStream nextPutAll: '(' , ((table isNil or: [table name isNil]) ifTrue: [''] ifFalse: [table name]),  ')'.
	aStream cr.
	self fieldsAndValuesDo: [:eachField :eachWrapper |
		aStream nextPutAll: '    '.
		eachField printOn: aStream.
		aStream nextPutAll: '->'.
		eachWrapper printOn: aStream.
		aStream cr.].