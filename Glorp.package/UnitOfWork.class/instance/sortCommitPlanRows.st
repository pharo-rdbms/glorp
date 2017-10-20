private/mapping
sortCommitPlanRows
	| sorter |
	sorter := GlorpRowSorter new
		getChildrenVia: [:each | self relatedRowsFor: each].
	commitPlan := sorter sort: commitPlan.
	sorter := GlorpRowSorter new
		getChildrenVia: [:each | self relatedRowsFor: each].
	deletePlan := sorter sort: deletePlan