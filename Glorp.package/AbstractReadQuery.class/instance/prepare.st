preparing
prepare
	prepared ifTrue: [^self].
	self setupTracing.
	prepared := true.