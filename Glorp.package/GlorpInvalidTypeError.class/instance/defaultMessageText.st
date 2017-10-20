accessing
defaultMessageText
	^'Object being written does not match the type of the attribute: ''', self object printString,  ''' ~= ''' , self expectedType printString, ''''.