accessing
password
	"Return the password for this login. If we are in a secure mode, then erase the password as soon as it is accessed."
	| returnValue |
	returnValue := password.
	secure ifTrue: [password := nil].
	^returnValue.