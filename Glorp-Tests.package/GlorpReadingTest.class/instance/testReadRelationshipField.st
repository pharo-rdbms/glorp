tests
testReadRelationshipField
	| query results |
	
	[session beginTransaction.
	query := Query read: GlorpItinerary where: [:each | ((each getTable: 'ITINERARY') getField: 'RES_ID') = nil].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 0.