support
verifyOrderFor: result byAttribute: aBlock
	1 to: result size - 1
		do: 
			[:i | 
			| a b |
			a := result at: i.
			b := result at: i + 1.
			self assert: (aBlock value: a) <= (aBlock value: b)]