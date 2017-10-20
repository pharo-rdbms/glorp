support
addRowsFor: object to: rowMap 
	| descriptor |
	descriptor := system descriptorFor: object class.
	descriptor createRowsFor: object in: rowMap.