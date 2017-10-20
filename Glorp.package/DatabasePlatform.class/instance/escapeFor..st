conversion-strings
escapeFor: aCharacter
	aCharacter = $' ifTrue: [^''''''].
	^String with: $\ with: aCharacter.