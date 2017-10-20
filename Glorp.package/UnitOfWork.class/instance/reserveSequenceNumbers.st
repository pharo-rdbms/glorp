private/mapping
reserveSequenceNumbers
	rowsByTable := commitPlan glorpGroupedBy: [:each | each table].
	rowsByTable keysAndValuesDo: [:eachTable :rows | 
		eachTable sequences do: [:eachSequence | 
			eachSequence 
				reserveSequenceNumbers: (
					rows inject: 0 into: [:sum :each | 
						(each needsValueFromSequence: eachSequence) 
							ifTrue: [sum + 1] ifFalse: [sum]])
					in: self session
					for: eachTable]]