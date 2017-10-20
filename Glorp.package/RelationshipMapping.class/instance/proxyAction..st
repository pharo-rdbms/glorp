accessing
proxyAction: aBlock
	"Set an action each proxy should take when it's instantiated. This is a two-argument block
		[:owner :target | "
	proxyAction := aBlock.