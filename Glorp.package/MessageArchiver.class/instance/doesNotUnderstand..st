doesNotUnderstand
doesNotUnderstand: aMessage 
	| sel |
	sel := aMessage selector.
	sel == #doesNotUnderstand: ifTrue: [self basicDoesNotUnderstand: aMessage].
	(sel size >= 8 and: [(sel copyFrom: 1 to: 8) = 'perform:']) 
		ifTrue: 
			[^self get: aMessage arguments first
				withArguments: (aMessage arguments copyFrom: 2 to: aMessage arguments size)].
	^self get: sel withArguments: aMessage arguments