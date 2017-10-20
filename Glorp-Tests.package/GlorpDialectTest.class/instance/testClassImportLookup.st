tests
testClassImportLookup
	self
		assert: (Dialect
					lookupClassNamed: 'AccessCast'
					inContextOf: GlorpDescriptorSystemWithNamespaces
					ifAbsent: [nil]) == AccessCast
		description: 'We cannot find a class visible in the environment of this class, not imported'.
	self
		assert: (Dialect
					lookupClassNamed: 'GlorpTestClassInNamespace'
					inContextOf: GlorpDescriptorSystemWithNamespaces
					ifAbsent: [nil]) == GlorpTestClassInNamespace
		description: 'We cannot find a class imported by the class but not visible in its environment'.