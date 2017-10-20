examples
example1
	| result |
	result := GlorpEncyclopedia new.
	result entries at: 'one' put: GlorpEncyclopediaEntry example1.
	result entries at: 'two' put: GlorpEncyclopediaEntry example2.
	^result.