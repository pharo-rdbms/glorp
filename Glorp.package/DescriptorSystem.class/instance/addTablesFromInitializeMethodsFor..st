initialize-release
addTablesFromInitializeMethodsFor: aClass
	| match |
	match := 'tableFor'. 
	Dialect selectorsFor: aClass do:
			[:each | 
			(each copyFrom: 1 to: (match size min: each size)) = match
				ifTrue:
					[| tableName |
					tableName := each copyFrom: match size + 1 to: each size - 1.
					self tableNamed: tableName]]