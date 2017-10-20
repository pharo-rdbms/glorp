session creation
sessionForLogin: aGlorpLogin
	"Create a session associated with the given login, and using us as a descriptor system. This is the easiest way to get a full blown session going."

	| newSession |
	platform isNil ifTrue: [self platform: aGlorpLogin database].
	aGlorpLogin database class = self platform class ifFalse: [self error: 'Login is incompatible with the database specified in the descriptor system'].
	session isNil ifFalse: [InvalidSessionSetup signal: 'DescriptorSystem already has a session; resume this error if this was intended.'].
	newSession := GlorpSession new.
	newSession accessor: (DatabaseAccessor forLogin: aGlorpLogin).
	newSession system: self.
	^newSession