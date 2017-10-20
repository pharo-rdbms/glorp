iterating
mappableSourceFieldsDo: aBlock

	sources do: [:source  |
		source isMappable ifTrue: [aBlock value: source]].