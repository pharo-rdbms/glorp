private/mapping
buildCommitPlan
	| tablesInCommitOrder |
	commitPlan := OrderedCollection new.
	deletePlan := OrderedCollection new.
	tablesInCommitOrder := session tablesInCommitOrder.
	tablesInCommitOrder do: 
			[:eachTable | 
			self rowsForTable: eachTable
				do: 
					[:eachRow | 
					eachRow forDeletion 
						ifTrue: [self addToDeletePlan: eachRow]
						ifFalse: [self addToCommitPlan: eachRow]]].
	self sortCommitPlanRows