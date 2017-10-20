This class provides limited CAST functionality for MS Access, which doesn't use CAST but instead provides some conversion functions.
This class attempts to find the correct conversion function for the intended CAST operation. It ignores the source type, and uses the argument to determine which conversion function to use.

	Here are some of Access' convesion functions: CDBL(), CSTR(), CBOOL(), CLNG(). Also, INT(), which yields a truncated double.
	DATETIME is actually a Double, with Date().Time().
	Get date, the integer part, from a DATETIME with: Int(Now()) == DateValue(#3/31/1999#).
	Get DOUBLE from DATETIME with: CDbl(Now()).
	Get DATETIME back froum DOUBLE with: CVDate(Cdbl(Now())).
	Get DATETIME from DATE with: CVDate( CDate( #Jan 31, 1994#) ).
