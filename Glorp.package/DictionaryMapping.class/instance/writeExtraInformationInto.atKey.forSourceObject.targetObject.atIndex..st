mapping
writeExtraInformationInto: aRowMap atKey: rowMapKey forSourceObject: sourceObject targetObject: targetObject atIndex: eachKey
	"Write out any additional information that goes in the link table or else the target table. That means our key, if necessary. If we have a specific value mapping, rather than just using the normal attributes of this mapping, then write that as well. That normally happens when our value is simple"
	
	"We need to know if the key mapping is trying to write to the link table, or to the target. If it's to the link table, then we always use the row map key. If it's to the target table, then we need to use whatever is appropriate for the target table, which is a row map key if we have a simple target, and otherwise it's just the target object"
	| target |
	target := (keyMapping mappedTables includes: self linkTable)
		ifTrue: [rowMapKey]
		ifFalse: [self mapsSimpleObject ifTrue: [rowMapKey] ifFalse: [targetObject]].
	keyMapping
		mapFromObject: eachKey -> nil
		toTarget: target
		puttingRowsIn: aRowMap.

	valueMapping isNil ifTrue: [^self].
	"I'm not sure this will ever be relevant. If the value mapping goes to the link table, then does that mean the key is really the value? And if so, why not just consider the other one to be the link?"
	target := (valueMapping mappedTables includes: self linkTable)
		ifTrue: [rowMapKey]
		ifFalse: [self mapsSimpleObject ifTrue: [rowMapKey] ifFalse: [targetObject]].
	valueMapping
		mapFromObject: nil -> targetObject
		toTarget: target
		puttingRowsIn: aRowMap