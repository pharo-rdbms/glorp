tests
testSymbol
	"Test that we can store a Symbol as text. This is particularly interesting because then we have to go through a non-empty type converter, and those need to take into account that text type, although a string type, probably doesn't have a maximum width."
	stType := Symbol.
	self helpTestValue: #'ASymbolStoredAsText'.