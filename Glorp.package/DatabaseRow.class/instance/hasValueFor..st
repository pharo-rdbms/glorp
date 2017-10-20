querying
hasValueFor: aField

	^(self wrapperAt: aField ifAbsent: [^false]) hasValue.