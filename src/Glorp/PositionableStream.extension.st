Extension { #name : 'PositionableStream' }

{ #category : '*Glorp' }
PositionableStream >> skipToAll: aCollection [
	"Skips from the current access position to the occurrence (if any, but not inclusive) of aCollection. If aCollection is not in the stream go to end of it."

	| startPos endMatch result |
	startPos := self position.
	^(self match: aCollection) 
		ifTrue: [endMatch := self position.
			self position: startPos.
			result := self skip: endMatch - startPos - aCollection size.
			self position: endMatch.
			true
			]
		ifFalse: [self position: startPos. false]
]
