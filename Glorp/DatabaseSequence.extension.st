Extension { #name : #DatabaseSequence }

{ #category : #'*Glorp' }
DatabaseSequence class >> named: aString [
	^self new name: aString.
]

{ #category : #'*Glorp' }
DatabaseSequence class >> new [

	^super new initialize.
]
