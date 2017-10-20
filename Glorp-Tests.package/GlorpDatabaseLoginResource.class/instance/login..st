accessing
login: anObject
	"We don't attempt to be secure on logins being used for tests. Make sure we don't surprise someone by modifying the original instance."

	login := anObject copy.
	login secure: false.