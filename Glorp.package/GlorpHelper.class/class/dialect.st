classes
dialect
	"Provide a way to refer to the dialect class from an extension or class that doesn't include the Glorp namespace, while still avoiding explicit namespace imports (which confuse other dialects when the 'pool dictionaries' don't exist)."
	| glorpNamespace |
	glorpNamespace := Smalltalk at: #Glorp ifAbsent: [nil].
	^((glorpNamespace isNil ifTrue: [Smalltalk] ifFalse: [glorpNamespace]) at: #Dialect ifAbsent: [Smalltalk at: #Dialect])