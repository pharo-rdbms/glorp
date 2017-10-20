*Glorp
new

	Singleton isNil ifTrue: [Singleton := self basicNew].
	^Singleton.