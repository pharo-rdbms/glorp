initialization
constructTablesFromInitializeMethods
	self withAllSuperclassesDo: [:aClass | self addTablesFromInitializeMethodsFor: aClass].