accessing
printSQL
	"Access doesn't like parenthesies around the first in a group of compound commands."

	| skipFirst |
	self requiresWrapperQuery
		ifTrue: [
			self nextPutAll: 'SELECT '.
			self requiresDistinct
				ifTrue:  [ self nextPutAll: 'DISTINCT '].
			self nextPutAll: '* FROM '.
			self platform supportsAliasInCompoundQuery ifTrue: [self nextPut: $( ]].
	skipFirst := self platform parenthesizeAllButFirstCommandInCompoundQuery.
	GlorpHelper
		do: 
			[:each |
			(self platform parenthesizeCommandsInCompoundQuery and: [skipFirst not])
				ifTrue: [self nextPut: $(].
			self nextPutAll: each sqlString.
			(self platform parenthesizeCommandsInCompoundQuery and: [skipFirst not])
				ifTrue: [self nextPut: $)].
			skipFirst := false]
		for: self commands
		separatedBy: [query printOperationOn: self].
	(self requiresWrapperQuery and: [self platform supportsAliasInCompoundQuery])
		ifTrue: 
			[self nextPut: $).
			query printCompoundSelectAliasesOn: self].
	query printOrderingOn: self.
	query printGroupingOn: self