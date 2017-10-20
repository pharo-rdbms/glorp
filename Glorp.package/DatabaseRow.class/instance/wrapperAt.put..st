accessing
wrapperAt: aField put: aWrapper
	| old |
	old := contents at: aField position.
	old == aWrapper ifTrue: [^self].
	contents at: aField position put: aWrapper.
	aWrapper isNowContainedBy: self and: aField.