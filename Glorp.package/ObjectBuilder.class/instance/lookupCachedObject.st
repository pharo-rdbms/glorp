building objects
lookupCachedObject
	| resultClass |
	self canBuild ifFalse: [^self].
	self canCache
		ifTrue:
			[
			resultClass := expression descriptor describedClass.
			(self session hasExpired: resultClass key: self key)
				ifTrue:
					[instance := self session expiredInstanceOf: resultClass key: self key.
					requiresPopulating := true.
					isExpired := true]
				ifFalse:
					[instance := self session cacheLookupForClass: resultClass key: self key.
					requiresPopulating := instance isNil]].