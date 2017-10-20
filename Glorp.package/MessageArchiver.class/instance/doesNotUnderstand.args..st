doesNotUnderstand
doesNotUnderstand: sel args: args 
	"This is the variant for ObjectStudio"
	sel == #doesNotUnderstand: ifTrue: [self basicDoesNotUnderstand: sel args: args].
	(sel size >= 8 and: [(sel copyFrom: 1 to: 8) = 'perform:']) 
		ifTrue: 
			[^self get: args first
				withArguments: (args copyFrom: 2 to: args size)].
	^self get: sel withArguments: args