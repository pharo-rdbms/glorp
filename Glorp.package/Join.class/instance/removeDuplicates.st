converting
removeDuplicates
	| existing newSources newTargets |
	existing := Set new.
	newSources := OrderedCollection new: sources size.
	newTargets := OrderedCollection new: targets size.
	sources
		with: targets
		do:
			[:eachSource :eachTarget | 
			| association |
			association := eachSource -> eachTarget.
			(existing includes: association)
				ifFalse:
					[existing add: association.
					newSources add: eachSource.
					newTargets add: eachTarget]].
	sources := newSources.
	targets := newTargets.