building objects
nextObjectFrom: aRow
	| objects |
	objects := self buildObjectsForRow: aRow.
	self mightHaveDuplicateRows ifFalse: [
		self registerInstances.
		^objects]