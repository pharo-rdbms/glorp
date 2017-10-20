*Glorp
dialectName

	dialectName isNil ifTrue: [self determineDialect.].
	^ dialectName