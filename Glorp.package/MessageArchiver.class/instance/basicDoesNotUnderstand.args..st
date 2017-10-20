doesNotUnderstand
basicDoesNotUnderstand: sel args: args 
	"Invoke this to avoid infinite recursion in the case of internal errors. We want a dialect-independent way of getting a walkback window, so we'll invoke it against a different object"

	(Array with: self) doesNotUnderstand: sel args: args