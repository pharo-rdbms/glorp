sequencing
preWriteAssignSequencesUsing: aSession
	"Skip if we've already been generated"
	generated ifTrue: [^self].
	self table fields do: 
			[:each | 
			(self shouldGenerateValueFor: each in: aSession) 
				ifTrue: 
					[each type 
						preWriteAssignSequenceValueFor: each
						in: self
						using: (aSession isNil ifTrue: [nil] ifFalse: [aSession accessor])]].
	generated := true.