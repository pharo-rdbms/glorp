building objects
findInstanceForRow: aRow proxyType: proxyType
	instance := nil.
	self row: aRow.
	self canBuild ifFalse: [^self].
	(self shouldProxyInstanceFor: proxyType)
		ifTrue: [^self newProxyWithNewQueryForClass: proxyType].
	self lookupCachedObject.
	self instanceExistsButIsDeleted
		ifTrue:
			[instance := nil.
			^self].
	instance isNil
		ifFalse:
			[requiresPopulating := requiresPopulating | query shouldRefresh.
			^self].
	requiresPopulating := true.
	instance := self createObjectOfClass: (expression descriptor
		describedConcreteClassFor: self row
		withBuilder: self).
	self canCache ifTrue: [self session cacheAt: self key put: instance]