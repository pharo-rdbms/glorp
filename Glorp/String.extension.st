Extension { #name : #String }

{ #category : #'*Glorp' }
String >> glorpIsCollection [
	"For our purposes, these aren't collections, but rather a simple database type"
	^false.
]

{ #category : #'*Glorp' }
String >> glorpPrintSQLOn: aCommand [
	| platform requiresEscape |
	platform := [aCommand platform] on: MessageNotUnderstood do: [:ex | ex return: nil].
	aCommand nextPut: $'.
	1
		to: self size
		do:
			[:i | 
			| char |
			char := self at: i.
			requiresEscape := platform isNil ifTrue: [false] ifFalse: [platform requiresEscapeFor: char].
			requiresEscape
				ifTrue: [aCommand nextPutAll: (aCommand platform escapeFor: char)]
				ifFalse: [aCommand nextPut: char]].
	aCommand nextPut: $'.
]

{ #category : #'*Glorp' }
String >> like: wildcardString [
	" 'abcde' like: 'abc%'  "

	^self likePattern: wildcardString from: 1 sourceStart: 1.
	"
	| newString |
	newString := wildcardString copy.
	newString replaceAll: $% with: $*.
	newString replaceAll: $_ with: $#.
	^newString match: self."
]

{ #category : #'*Glorp' }
String >> likePattern: aPattern from: patternStart sourceStart: sourceStart [ 
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
]
