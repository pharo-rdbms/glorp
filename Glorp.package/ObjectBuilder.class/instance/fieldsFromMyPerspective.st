selecting fields
fieldsFromMyPerspective
	^query returnProxies 
		ifTrue: [self descriptor table primaryKeyFields]
		ifFalse: [self descriptor fieldsForSelectStatement]