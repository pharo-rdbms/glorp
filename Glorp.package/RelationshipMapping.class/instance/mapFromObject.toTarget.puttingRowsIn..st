mapping
mapFromObject: anObject toTarget: target puttingRowsIn: aRowMap
	self attribute
		loopOver: target
		doing:
			[:index :eachTarget | 
			| intermediate |
			intermediate := self
				rowMapKeyForSource: anObject
				target: eachTarget
				index: index.
			self
				mapOneFromObject: anObject
				toTarget: eachTarget
				intermediate: intermediate
				atPosition: index
				puttingRowsIn: aRowMap].