begin/commit/abort
preCommit
	commitPhase := #registering.
	self registerTransitiveClosure.
	commitPhase := #building.
	self createRows.
	linkRowsForUpdate := rowMap collapseMatchingInsertsAndDeletes.
	self buildCommitPlan.
	commitPhase := nil.
	self sendPreWriteNotification.
	self validateRows