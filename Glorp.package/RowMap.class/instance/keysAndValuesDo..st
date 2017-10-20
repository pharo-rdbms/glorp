iterating
keysAndValuesDo: aBlock 
	self tables do: [:each | 
		(self subMapForTable: each) keysAndValuesDo: aBlock]