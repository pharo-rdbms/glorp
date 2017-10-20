testing
supportsOrdering

	typeResolver isNil ifTrue: [^true].
	^typeResolver supportsOrderingFor: self.