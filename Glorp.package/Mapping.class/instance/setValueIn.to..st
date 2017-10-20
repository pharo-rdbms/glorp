public
setValueIn: anObject to: aValue
	self canRead ifFalse: [^self].
	self attribute setValueIn: anObject to: aValue