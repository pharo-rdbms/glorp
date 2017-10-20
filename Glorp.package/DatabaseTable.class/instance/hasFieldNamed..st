testing
hasFieldNamed: aString

	^(self fieldNamed: aString ifAbsent: [nil] caseSensitive: false) notNil.