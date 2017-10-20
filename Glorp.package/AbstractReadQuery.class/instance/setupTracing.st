tracing
setupTracing
	self setUpExpressions.
	self tracing setup.
	self tracing additionalExpressions do: [:each |
		each hasDescriptor ifTrue: [
			each descriptor trace: self tracing context: each].
			each validate].