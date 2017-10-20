eoglorp
loginWithConnectionDictionary: aDict 
	| platformClass |
	platformClass := self allSubclasses
				detect: [:cls | cls understandsConnectionDictionary: aDict].
	^ platformClass isNil
		ifFalse: [platformClass createLoginFromConnectionDictionary: aDict] ifTrue: [nil]