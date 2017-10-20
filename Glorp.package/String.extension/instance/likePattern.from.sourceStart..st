*Glorp
likePattern: aPattern from: patternStart sourceStart: sourceStart 
	"Note that this uses, with permission, the code from ObjectStudio that does this. It's a recursive implementation, but this is primarily for in-memory mimicking of database operations so the performance limitations shouldn't be a big issue."
	| c |
	patternStart > aPattern size ifTrue: [^sourceStart > self size].
	c := aPattern at: patternStart.
	c == $% 
		ifTrue: 
			[sourceStart to: self size + 1
				do: 
					[:ind | 
					(self 
						likePattern: aPattern
						from: patternStart + 1
						sourceStart: ind) ifTrue: [^true]].
			^false].
	sourceStart > self size ifTrue: [^false].
	(c == $_ or: [c == (self at: sourceStart)]) 
		ifTrue: 
			[^self 
				likePattern: aPattern
				from: patternStart + 1
				sourceStart: sourceStart + 1].
	^false


	":Section Reference
							likePattern: aPattern from: patternStart sourceStart: sourceStart
		Description:        	Returns true if the receiver contains a string being
                    				matched by the parameter 'aPattern'. Using the wildcard
					  		$% serves as placeholder for 0-n $_ as a placeholder
					  		for a single matched character.
		Assumptions:        'aPattern' is expected to be of class String.
		Return Value:       true or false.
		Receiver Modified:  No.
	:End"