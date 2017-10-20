get/set
getValueFrom: anObject
	| real |
	real := anObject yourSelf.
	self checkType: real.
	self useDirectAccess ifTrue: [^self directGetValueFrom: real].
	^real perform: self name