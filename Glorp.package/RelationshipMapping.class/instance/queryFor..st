proxies
queryFor: anObjectBuilder 
	"If we have a specific query we should use in this case, rather than our general one, construct it. Right now that only applies if we're using filtered reads"
	| basicQuery collection primaryKey newQuery cachedQuery filterBlock |
	self shouldUseFilteredRead 
		ifFalse: [^self query].
	cachedQuery := anObjectBuilder cachedQueryFor: self.
	cachedQuery isNil 
		ifTrue: 
			[basicQuery := self buildGeneralQueryIn: anObjectBuilder.
			self query tracing alsoFetchExpressions 
				do: [:each | basicQuery alsoFetch: each].
			collection := GlorpVirtualCollection new setQuery: basicQuery]
		ifFalse: [collection := cachedQuery collection].
	primaryKey := anObjectBuilder primaryKey.
	filterBlock := self descriptor keyFields size = 1 
				ifTrue: [[:objects :parameters | (objects at: 1) = primaryKey]]
				ifFalse: 
					[
					[:objects :parameters | 
					(1 to: primaryKey size) inject: true
						into: [:sum :i | sum and: [(primaryKey at: i) = (objects at: i)]]]].
	newQuery := FilteringQuery on: collection filter: filterBlock.
	newQuery collectBlock: [:each | each last].
	newQuery readsOneObject: self attribute isCollectionAttribute not.
	newQuery collectionType: self collectionType.
	anObjectBuilder cachedQueryFor: self is: newQuery.
	^newQuery