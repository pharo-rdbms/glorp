unifying
containsWrapper: aFieldValueWrapper
	^self == aFieldValueWrapper or: [innerWrapper == aFieldValueWrapper
		or: [aFieldValueWrapper innerWrapper == self
			or: [aFieldValueWrapper innerWrapper == self innerWrapper]]]