expiry
willRemoveItems
	^(expiryAction == #notifyAndRemove or: [expiryAction == #remove])