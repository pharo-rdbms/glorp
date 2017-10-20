mapping
applicableMappingForConditionalValue: rowValue
	cases
		do:
			[:each | 
			((Dialect isBlock: each key)
				ifTrue: [each key value: rowValue]
				ifFalse: [self descriptor system perform: each key with: rowValue])
				ifTrue: [^each value]].
	^otherwiseCase