accessing
characterEncoding
	"We hope that this will be set appropriately for the connection, but make sure the default is fairly harmless, and will in most cases complain rather than write characters incorrectly"
	characterEncoding isNil ifTrue: [characterEncoding := #ascii].
	^characterEncoding