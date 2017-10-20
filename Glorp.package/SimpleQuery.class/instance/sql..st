accessing
sql: aString
	"Specify the sql string to use for this query, instead of having it be generated. Note that doing this will override the normal sql generation mechanisms."
	self command: (SQLStringSelectCommand new setSQLString: aString)