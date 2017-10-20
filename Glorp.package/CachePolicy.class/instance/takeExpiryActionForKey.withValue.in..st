expiry
takeExpiryActionForKey: key withValue: anObject in: aCache
	expiryAction == #refresh
		ifTrue: [aCache session refresh: anObject].
	(#(#notify #notifyAndRemove) includes: expiryAction) ifTrue: [
		self notifyOfExpiry: anObject in: aCache].
	(#(#remove #notifyAndRemove) includes: expiryAction) ifTrue: [
		aCache removeKey: key ifAbsent: []].