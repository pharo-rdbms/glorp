private
helpTestValue: anObject compareModelWith: modelBlock compareWith: aBlock 
	| dbOutValue |
	dbOutValue := self adjustForMaximumSize: anObject.
	^super helpTestValue: dbOutValue compareModelWith: modelBlock compareWith: aBlock.