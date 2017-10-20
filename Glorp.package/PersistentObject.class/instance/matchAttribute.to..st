private
matchAttribute: anExpression to: value
	"We match expressions differently depending on what type they are."
	
	^(value isString and: [value includes: $%]) 
		ifTrue: [anExpression like: value] 
		ifFalse: [anExpression = value].