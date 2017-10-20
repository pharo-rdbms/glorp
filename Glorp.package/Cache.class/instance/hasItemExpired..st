lookup
hasItemExpired: anItem
	^(policy hasExpired: anItem) and: [(mainCache session isRegistered: (policy contentsOf: anItem)) not].