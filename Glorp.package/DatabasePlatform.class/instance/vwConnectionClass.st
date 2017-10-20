accessing
vwConnectionClass
	^self isODBCPlatform 
			ifTrue: [self vwODBCConnectionClass]
			ifFalse: [self vwEXDIConnectionClass]