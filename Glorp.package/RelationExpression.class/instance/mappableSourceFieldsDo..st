iterating
mappableSourceFieldsDo: aBlock
	"Used when we are emulating a Join"
	self allSourceFields do: [:source |
		source isMappable ifTrue: [aBlock value: source]].