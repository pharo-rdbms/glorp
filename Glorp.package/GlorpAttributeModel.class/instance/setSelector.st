private
setSelector
	setSelector  == nil ifTrue: [setSelector := (name, ':') asSymbol].
	^setSelector.