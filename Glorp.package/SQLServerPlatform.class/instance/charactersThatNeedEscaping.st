conversion-strings
charactersThatNeedEscaping
	"There seem to be all kind of contradictory bits of information about what sql server does/requires for escaped characters, all of which differ from standard sql. Empirically the only thing that requires escaping appears to be single quote"
	^#($' ).