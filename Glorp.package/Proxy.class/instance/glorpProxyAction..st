proxy actions
glorpProxyAction: aTwoArgumentBlock
	"Set the action we'll take when the proxy fires. This is a two argument block that takes the owning object and the value of the proxy as arguments."
	aTwoArgumentBlock isNil ifTrue: [^action := nil].
	action := nil -> aTwoArgumentBlock