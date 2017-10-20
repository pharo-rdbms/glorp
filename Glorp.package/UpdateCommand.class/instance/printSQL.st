printing
printSQL
	| bodyFields |
	self nextPutAll: 'UPDATE '.
	row table printSQLOn: self withParameters: #().
	self nextPutAll: ' SET '.
	bodyFields := self fieldsNeedingUpdate.
	GlorpHelper 
		do: [:field | row printEqualityTemplateForField: field on: self]
		for: bodyFields
		separatedBy: [self nextPut: $,].
	self nextPutAll: ' WHERE '.
	row printPrimaryKeyTemplateOn: self.
	row lockKeyFields notEmpty
		ifTrue: 
			[self nextPutAll: ' AND '.
			GlorpHelper
				do: [:field | row printLockEqualityForField: field on: self]
				for: row lockKeyFields
				separatedBy: [self nextPutAll: ' AND ']]