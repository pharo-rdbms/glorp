building objects
newProxyWithNewQueryForClass: aClass
	| parameters |
	parameters := IdentityDictionary new.
	self descriptor primaryTable primaryKeyFields
		do:
			[:eachField | parameters at: eachField put: (self valueOfField: eachField in: row)].
	instance := aClass new
		session: self session;
		parameters: parameters;
		query: self queryForNewProxy.
	self session addToReaper: instance.
	^self