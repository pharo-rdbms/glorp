*Glorp
statement: aGlorpPreparedStatement
	"This is the statement used to create us. If it's coming back to a simple read stream, then we must have already used all its data, and can thus reuse it"
	aGlorpPreparedStatement busy: false.