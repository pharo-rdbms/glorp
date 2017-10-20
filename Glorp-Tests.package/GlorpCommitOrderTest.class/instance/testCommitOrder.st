tests
testCommitOrder

	| sorter |
	sorter := TableSorter for: (Array with: (system tableNamed: 'BANK_TRANS') with: (system tableNamed: 'GR_CUSTOMER')).
	self assert: sorter sort first name = 'GR_CUSTOMER'.