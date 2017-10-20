accessing
keyField: aDatabaseField
	keyMapping := self newMapping: DirectMapping.
	keyMapping attributeName: #key.
	keyMapping from: #key to: aDatabaseField