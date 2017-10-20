begin/commit/abort
validateRows
	"Perform basic validation. Always test for equal named but non-identical tables, a sign of a malformed  system or other loss of identity. Also delegate to the descriptorSystem, which may have useful application-specific validations to do."
	
	| tables tableNames |
	tables := Set new.
	rowMap rowsDo: [:each |
		tables add: each table].
	tableNames := tables collect: [:each | each qualifiedName].
	tables asSet size = tableNames asSet size ifFalse: [self error: 'multiple table objects with the same name'].
	self system validateRows: self