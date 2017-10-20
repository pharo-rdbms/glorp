accessing
messageText
	messageText ifNotNil: [^messageText].
	self model isString ifTrue: [^'No table <1s> found' expandMacrosWith: self model].
	^'No table found for <1s>, expected to see one of  <2s>' expandMacrosWith: self model name with: self expectedTables printString