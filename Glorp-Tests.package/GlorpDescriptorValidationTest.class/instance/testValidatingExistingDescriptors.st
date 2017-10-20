testing
testValidatingExistingDescriptors
	| session |
	session := GlorpSessionResource current newSession.
	GlorpTestDescriptorSystem allSubclasses do: [:each |
		session system: (each forPlatform: (OraclePlatform new)).
		session system validate].