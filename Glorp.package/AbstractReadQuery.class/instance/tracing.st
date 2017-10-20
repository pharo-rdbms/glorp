accessing
tracing
	tracing isNil ifTrue: [tracing := self defaultTracing].
	^tracing.