Extension { #name : 'TableBasedSequence' }

{ #category : '*Glorp' }
TableBasedSequence class >> default [

	^self new sequenceTableName: 'SEQUENCE'.
]
