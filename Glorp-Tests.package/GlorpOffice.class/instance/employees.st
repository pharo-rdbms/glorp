accessing
employees
	employees isNil ifTrue: [ employees := OrderedCollection new ].
	^employees