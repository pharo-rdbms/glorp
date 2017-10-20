building objects
createObjectOfClass: aClass
	"Try to create objects using new, so initialization can run. But if we can't do it, then just use basicNew."
	^[aClass new] on: Error do: [:ex | ex return: aClass basicNew]