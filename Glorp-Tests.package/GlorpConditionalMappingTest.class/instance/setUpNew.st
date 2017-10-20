support
setUpNew
	"Set up using the newer protocol"
	newMapping := descriptor newMapping: ConditionalMapping.
	newMapping
		forField: (descriptor primaryTable fieldNamed: 'ID')
		attribute: #id
		if: [:value | value = 1]
		useMapping: (mapping1 := DirectMapping from: #blah to: (descriptor primaryTable fieldNamed: 'ID')).
	newMapping if: #testIDMoreThan5: then: (mapping2 := DirectMapping from: #bletch to: (descriptor primaryTable fieldNamed: 'NAME')).
	newMapping otherwise: (mapping3 := DirectMapping from: #bazoomer to: (descriptor primaryTable fieldNamed: 'ID')).