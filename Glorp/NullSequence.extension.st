Extension { #name : #NullSequence }

{ #category : #'*Glorp' }
NullSequence classSide >> default [

	^self new.
]

{ #category : #'*Glorp' }
NullSequence classSide >> new [

	Singleton isNil ifTrue: [Singleton := self basicNew].
	^Singleton.
]
