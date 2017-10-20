registering
register: anObject 

	| realObject |
	commitPhase == #building ifTrue: [self halt]. "Should not happen. Probably indicates that we're triggering proxies while firing the mappings"
	realObject := transaction register: anObject.
	self registerTransitiveClosureFrom: realObject