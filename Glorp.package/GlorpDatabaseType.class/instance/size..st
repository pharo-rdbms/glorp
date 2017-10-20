accessing
size: anInteger

	^self error: ((self class name asString), ' is not a variable sized type.')