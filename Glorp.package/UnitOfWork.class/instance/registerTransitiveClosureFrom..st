private/mapping
registerTransitiveClosureFrom: anObject

	| descriptor |
	anObject glorpIsCollection ifTrue: [
		anObject do: [:each | session register: each].
		^self].

	descriptor := session descriptorFor: anObject class.
	descriptor isNil ifTrue: [^self].
	descriptor mappings do: [:eachMapping |
			self instantiateIfRequiredFor: anObject mapping: eachMapping].
	descriptor referencedIndependentObjectsFrom: anObject do: [:eachObject |
		session register: eachObject]