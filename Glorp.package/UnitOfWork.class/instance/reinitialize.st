initialize-release
reinitialize

	rowMap := RowMap new.
	commitPhase := nil.
	deletedObjects := IdentitySet new.
	deleting := IdentitySet new.
	commitPlan := OrderedCollection new.
	deletePlan := OrderedCollection new.
	transaction abort