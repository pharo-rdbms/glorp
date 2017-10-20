login
login
	
	| |
	self loginIfError: [:ex | 
		ex pass].
	"Just to help avoid confusion if someone thinks they're getting a login object back from this"
	^nil.