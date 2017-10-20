building objects
registerInstances
	self session isNil ifTrue: [^self].
	builders do: [:each | self session register: each instance].