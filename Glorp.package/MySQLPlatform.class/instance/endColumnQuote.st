services tables
endColumnQuote
	"Return the character used to start quoting the name of a column so that we can avoid conflicts with reserved names. The default MySQL quoting is to use backquotes rather than the ANSI style."
	^'`'.