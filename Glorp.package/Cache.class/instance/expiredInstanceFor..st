private
expiredInstanceFor: key
	"Return the expired instance. Used for refreshing so that we don't recursively try and refresh when we get the instance to be refreshed"
	| item value |
	item := self basicAt: key ifAbsent: [self error: 'No expired instance found'].
	value := policy contentsOf: item.
	(self hasItemExpired: item) ifFalse: [self error: 'No expired instance found'].
	^value.