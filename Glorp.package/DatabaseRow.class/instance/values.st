accessing
values
	| result |
	result := OrderedCollection new.
	self keysAndValuesDo: [:key :value |
		result add: value].
	^result