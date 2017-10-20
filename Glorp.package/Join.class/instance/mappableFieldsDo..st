iterating
mappableFieldsDo: aBlock

	sources with: targets do: [:source :target |
		source isMappable ifTrue: [aBlock value: source value: target]].