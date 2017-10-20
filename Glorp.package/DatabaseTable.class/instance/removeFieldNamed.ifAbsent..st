fields
removeFieldNamed: aString ifAbsent: aBlock
	
	fields remove: (self fieldNamed: aString ifAbsent: aBlock).
	1 to: fields size do: [:i | (fields at: i) position: i].