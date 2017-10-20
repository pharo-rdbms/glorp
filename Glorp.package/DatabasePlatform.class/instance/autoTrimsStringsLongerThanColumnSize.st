constants
autoTrimsStringsLongerThanColumnSize
	"Answer true if the platform trims an string longer that the column size without triggering any error.
	E.g. the string 'abcde' is trimmed to 'abcd' during if the column is a CHAR(4)."

	^false