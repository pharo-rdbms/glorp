functions
castFunctionName

	| targetType conversionFunctions |
	conversionFunctions := (Dictionary new)
				at: #timestamp put: 'CVDATE';
				at: #date put: 'CDATE';
				at: #integer put: 'CLNG';
				at: #double put: 'CDBL';
				at: #string put: 'CSTR';
				at: #boolean put: 'CBOOL';
				yourself.
	targetType := arguments first.
	^conversionFunctions at: targetType value selector