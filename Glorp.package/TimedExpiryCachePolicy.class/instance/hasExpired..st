wrap/unwrap
hasExpired: aCacheEntry

	^(self totalSeconds - (aCacheEntry at: 1)) >= timeout.