tests
addToString: aString
	"Append a couple of special characters. The result will utf-8 encode to be 3 characters longer than its number of characters"
	^aString, (String with: (Character value: 16r2022) "bullet point" with: (Character value: 16r0131) "Turkish i with no dot")

"If PostgreSQL, or another DB returning true to measuresStringFieldWidthsInBytes, is provided in VA, this test must alter to
handle incompatible protocol between VW, which lacks Character>>asString and VA, in which String>>with:with: will not handle
double-byte entries.  The VA could be implemented as
	^aString, (Character value: 16r2022) asString, (Character value: 16r0131) asString
"