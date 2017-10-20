private
nextSequenceNumber: anAccessor 
	accessProtect critical: 
			[count := count + 1.
			^(self alwaysGetFromDb or: [count \\ sequenceIncrement = 1]) 
				ifTrue: 
					[count := (anAccessor 
								executeSQLString: self nextSequenceNumberSelectString) first 
								first]
				ifFalse: [count]]