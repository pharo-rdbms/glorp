accessing
session
	session isNil ifTrue: [session := self class getSession].
	^session.