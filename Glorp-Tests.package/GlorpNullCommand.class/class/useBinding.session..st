instance creation
useBinding: aBoolean session: aSession
	^(self new)
		useBinding: aBoolean;
		session: aSession;
		yourself.