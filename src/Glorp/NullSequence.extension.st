Extension { #name : 'NullSequence' }

{ #category : '*Glorp' }
NullSequence class >> default [

	^self new.
]

{ #category : '*Glorp' }
NullSequence class >> new [

	Singleton isNil ifTrue: [Singleton := self basicNew].
	^Singleton.
]
