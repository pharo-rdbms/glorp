mapping
mapFromObject: anObject toTarget: target puttingRowsIn: aRowMap 

	self transformationExpression 
		mapFromSource: anObject
		andTarget: target
		intoRowsIn: aRowMap.

	self transformationExpression allTables do: [:eachTable |	
		aRowMap rowForTable: eachTable withKey: target ifPresent: [  :each |
			each shouldBeWritten: false]].