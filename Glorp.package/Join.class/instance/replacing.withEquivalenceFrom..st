converting
replacing: aTable withEquivalenceFrom: aJoin
	"Create a new join in which references to fields in aTable have been replaced with the equivalent based on a Join (we assume that aTable references are in the sources of aJoin). If the field doesn't occur in the translation, just remove it"
	| newSources newTargets newSource |
	newSources := OrderedCollection new.
	newTargets := OrderedCollection new.
	self fieldsDo: [:eachSource :eachTarget |
		(eachSource isGlorpExpression not and: [eachSource table = aTable])
			ifTrue: [
				newSource := aJoin targetForSource: eachSource.
				newSource isNil ifFalse: [
					newSources add: newSource.
					newTargets add: eachTarget]]].
	^self class fromAll: newSources toAll: newTargets.