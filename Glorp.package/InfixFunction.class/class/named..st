instance creation
named: aStringOrArray
	| instance trimmedName |
	instance := self new.
	aStringOrArray isString
		ifTrue: [instance function: aStringOrArray]
		ifFalse: [
			instance functionParts: aStringOrArray.
			trimmedName := aStringOrArray copyFrom: 2 to: aStringOrArray size.
			instance function: (trimmedName inject: aStringOrArray first into: [:sum :each | sum, ' ', each])].
	^instance