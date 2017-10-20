api/transactions
modify: anObject in: aBlock
	"Evaluate aBlock inside a unit of work. Start a database transaction at the beginning and commit it at the end. If we don't terminate normally, roll everything back. Register anObject before starting. Explicitly circumvent the registration of  the block result at the end, because that can cause problems if we're doing things like delete and re-insert and end up returning e.g. the deleted object"
	| result |
	self transact: [
		self register: anObject.
		result := aBlock value.
		nil].
	^result