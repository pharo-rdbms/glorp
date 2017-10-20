support
setUp
	super setUp.
	system cachePolicy: CachePolicy new.
	session := GlorpSessionResource current newSession.
	session system: system.
	cache := session privateGetCache.