private
registerAsNew: anObject 
	anObject isNil ifTrue: [^nil].
	commitPhase == #building ifTrue: [self halt]. "Should not happen. Probably indicates that we're triggering proxies while firing the mappings"
	self newObjects add: anObject.
	self register: anObject.
	^anObject