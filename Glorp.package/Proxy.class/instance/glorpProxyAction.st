proxy actions
glorpProxyAction
	"Return the block we expect to evaluate when the proxy is fired."
	action isNil ifTrue: [^nil].
	^action value.