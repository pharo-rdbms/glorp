iterating
mappableFieldsDo: aBlock
	"Used when we are emulating a Join"
	self allSourceFields with: self allTargetFields do: [:source :target |
		source isMappable ifTrue: [aBlock value: source value: target]].