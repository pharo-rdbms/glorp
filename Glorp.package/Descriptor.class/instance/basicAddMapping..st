accessing
basicAddMapping: aMapping 
	mappings := mappings, (Array with: aMapping).
	aMapping descriptor: self.
	self resetMappedFields