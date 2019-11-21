Extension { #name : #TableBasedSequence }

{ #category : #'*Glorp' }
TableBasedSequence classSide >> default [

	^self new sequenceTableName: 'SEQUENCE'.
]
