initialize/release
tearDown

	Transcript show: self class name asString, ' tearDown'; cr.
	accessor notNil ifTrue: [[accessor logout] on: Dialect error do: [:ex | ]].