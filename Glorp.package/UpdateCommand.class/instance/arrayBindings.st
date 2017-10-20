accessing
arrayBindings
	"I don't think we can array bind updates. There may be values in the row that we haven't read, and if we attempt to write all the fields we'll be overwriting them with nulls. It's possible that there's a set of rows with all the same fields and we could update them all the same way, but that isn't done yet"
	self error: 'cannot array bind an update'.