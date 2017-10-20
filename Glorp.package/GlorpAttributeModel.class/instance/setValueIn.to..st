get/set
setValueIn: anObject to: aValue 
	| real |
	self isValid ifFalse: [^self].
	real := anObject yourSelf.
	self checkType: real.
	self useDirectAccess ifTrue: [^self directSetValueIn: real to: aValue].
	^real perform: self setSelector with: aValue