services columns
nameForColumn: aColumnString
	| upper |
	upper := self capitalWritingOfColumnName ifTrue: [aColumnString asUppercase] ifFalse: [aColumnString].
	(self reservedWords includes: aColumnString asLowercase) ifFalse: [^upper].
	^self startColumnQuote, upper, self endColumnQuote.