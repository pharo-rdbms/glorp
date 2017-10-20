accessing
cachePolicy
	"Return the default cache policy that will be used for descriptors that don't specify their own policy"
	cachePolicy isNil ifTrue: [cachePolicy := CachePolicy default].
	^cachePolicy.