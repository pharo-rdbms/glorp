conversion-boolean
convertDBBooleanToBoolean: aBoolean for: aType
	
	^ (aBoolean isKindOf: Boolean)
		ifTrue: [ aBoolean ]
		ifFalse: [ super convertIntegerToBoolean: aBoolean for: aType ] 
