private
privateTableAt: aString put: aTable
	"Normally you don't want to be setting tables explicitly, as it may defeat the identity management but it's here if needed"
	tables at: aString asUppercase put: aTable