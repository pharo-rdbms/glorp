registering
requiresRegistrationFor: anObject

	| realObject |
	realObject := self realObjectFor: anObject ifNone: [^false].
	^(self isRegistered: realObject) not