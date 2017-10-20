mapping
translateTable: aTable
	"If we have a field translation, return the translated (i.e. real) table to use. This ideally allows us to use either the real table in which something is embedded, or the imaginary table"
	^aTable