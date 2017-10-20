accessing
isKindOf: aClass
	self isInstantiated ifTrue: [^value isKindOf: aClass].
	query isNil ifTrue: [^false].
	query resultClass isNil ifTrue: [^false].
	query resultClass isBehavior ifFalse: [^false].
	^query resultClass includesBehavior: aClass