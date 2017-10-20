tests
testCreation
	| otherProxy |
	self deny: proxy isInstantiated.
	otherProxy := Proxy new.
	self deny: otherProxy isInstantiated.