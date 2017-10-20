conversion-strings
escapeFor: aCharacter
	^String with: $' with: aCharacter.
"	^'\', (aCharacter asInteger printStringRadix: 16)."