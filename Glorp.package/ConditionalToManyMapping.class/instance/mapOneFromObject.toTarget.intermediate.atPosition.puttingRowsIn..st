mapping
mapOneFromObject: sourceObject toTarget: targetObject intermediate: aRowMapKey atPosition: index puttingRowsIn: aRowMap
	
	(self applicableMappingForObject: targetObject) mapOneFromObject:
			sourceObject toTarget: targetObject intermediate: aRowMapKey atPosition:
			index puttingRowsIn: aRowMap