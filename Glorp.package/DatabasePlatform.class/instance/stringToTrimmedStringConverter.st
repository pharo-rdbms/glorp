conversion-strings
stringToTrimmedStringConverter
	"Between 0.3.140.1 and 7.10 inclusive, Glorp routinely trimmed strings that were too long for fixed-length fields in the stringToString converter.  It no longer does this, but if a particular Mapping wants trimming (e.g. StoreProperty has a searchString summary field for its comment's text blob, so the longest initial length of text that can be written to the search field is always OK), then assign this converter to the Mapping in the descriptor."

	^DelegatingDatabaseConverter
		named: #stringToTrimmedString
		hostedBy: self
		fromStToDb: #padTrimmedString:for:
		fromDbToSt: #unpadString:for: