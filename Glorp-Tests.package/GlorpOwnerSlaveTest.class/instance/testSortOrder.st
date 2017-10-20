tests
testSortOrder
	"Validate that it doesn't matter what order we put in the input, the tables come out in the correct sort order."
	| justTheseTables sorted sorted2 |
	justTheseTables := Array with: (system tableNamed: 'GLORP_OWNER') with: (system tableNamed: 'GLORP_SLAVE').
	sorted := (TableSorter for: justTheseTables) sort.
	sorted2 := (TableSorter for: justTheseTables reverse) sort.
	self assert: sorted = sorted2.
	self assert: sorted first name = 'GLORP_SLAVE'.