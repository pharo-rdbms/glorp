iterating
rowsDo: aBlock 
	self tables do: [:each | self rowsForTable: each do: aBlock]