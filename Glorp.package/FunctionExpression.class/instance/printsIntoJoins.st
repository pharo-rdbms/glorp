testing
printsIntoJoins
	"Certain functions should be printed into joins as well as into select lists (e.g. UPPER). However, there are others that don't (at least I don't think so) make any sense in joins, e.g. DISTINCT. Differentiate the two. Right now the only one I can think of that doesn't make sense is distinct. It's not clear to me that I'm not just hacking my way through this"
	^self isDistinct not.