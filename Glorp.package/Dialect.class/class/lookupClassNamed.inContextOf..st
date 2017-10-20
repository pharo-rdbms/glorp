class lookup
lookupClassNamed: aString inContextOf: aClass
	"Look up the class by name, but use the namespace of the class. Mostly useful if we're trying to guess from unqualified names in dialects with namespaces."
	^self lookupClassNamed: aString inContextOf: aClass ifAbsent: [nil]