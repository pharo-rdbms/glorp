descriptors/airline
descriptorForGlorpPassenger: aDescriptor 
	| passTable ffTable ffMiles airlineMapping |
	passTable := self tableNamed: 'PASSENGER'.
	ffTable := self tableNamed: 'FREQUENT_FLYER'.
	aDescriptor table: passTable.
	aDescriptor addTable: ffTable.
	aDescriptor addMultipleTableJoin: (	
		Join 
			from: (passTable fieldNamed: 'ID')
			to: (ffTable fieldNamed: 'ID')) beOuterJoin.
	(aDescriptor newMapping: DirectMapping) from: #id to: (passTable fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (passTable fieldNamed: 'NAME').

	ffMiles := aDescriptor newMapping: ConditionalMapping.
	ffMiles 
		forField: (ffTable fieldNamed: 'POINTS')
		attribute: [:object | object frequentFlyerPoints]
		if: [:x | x notNil]
		useMapping: ((ffMiles newMapping: DirectMapping) from: #frequentFlyerMiles to: (ffTable fieldNamed: 'POINTS')).
	ffMiles otherwise: (ffMiles newMapping: ConstantMapping).
	
	airlineMapping := aDescriptor newMapping: ConditionalMapping.
	airlineMapping
		forField: (ffTable fieldNamed: 'AIRLINE_ID')
		attribute: [:object | object airline]
		if: [:x | x notNil]
		useMapping: ((airlineMapping newMapping: OneToOneMapping) attributeName: #airline).
	airlineMapping otherwise: (airlineMapping newMapping: ConstantMapping).