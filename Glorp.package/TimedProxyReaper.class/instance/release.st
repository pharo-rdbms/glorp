initializing
release

	done := true.
	maximumWork := 0.
	reaperThread notNil ifTrue: [reaperThread terminate].
	reaperThread := nil.