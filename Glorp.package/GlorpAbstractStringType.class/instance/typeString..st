SQL
typeString: aString
	"If we set the typeString, we are presumably setting it to the non-parameterized name as well"
	typeString := aString.
	super typeString: aString.