functions
initializeFunctions
	super initializeFunctions.
	functions at: #copyFrom:to: put: (SubstringFunction named: 'substring').