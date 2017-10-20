login
login
	self isLoggedIn ifTrue: [^nil].
	^self loginIfError: [:ex | ex pass]