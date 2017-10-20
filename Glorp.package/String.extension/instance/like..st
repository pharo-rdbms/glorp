*Glorp
like: wildcardString
	" 'abcde' like: 'abc%'  "

	^self likePattern: wildcardString from: 1 sourceStart: 1.
	"
	| newString |
	newString := wildcardString copy.
	newString replaceAll: $% with: $*.
	newString replaceAll: $_ with: $#.
	^newString match: self."