Extension { #name : #DatabaseSequence }

{ #category : #'*Glorp' }
DatabaseSequence classSide >> named: aString [
	^self new name: aString.
]

{ #category : #'*Glorp' }
DatabaseSequence classSide >> new [

	^super new initialize.
]
