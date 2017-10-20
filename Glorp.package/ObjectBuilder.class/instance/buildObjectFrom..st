building objects
buildObjectFrom: anArray
	self row: anArray.
	self requiresPopulating ifTrue: [self populateInstance].
	(self system shouldResetExpiryTimeForObjectOfClass: instance class readFrom: self query)
		ifTrue: [self session markAsCurrentOfClass: instance class key: self key]