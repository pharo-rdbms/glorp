tests
testSelectByBoolean

	| inStore notInStore inStoreImplied notInStoreImplied |
	inStore := session read: GlorpVideoPurchase where: [:each | each inStore = true].
	notInStore := session read: GlorpVideoPurchase where: [:each | each inStore = false].
	self assert: inStore size = 7.
	self assert: notInStore size = 3.
	inStoreImplied := session read: GlorpVideoPurchase where: [:each | each inStore].
	notInStoreImplied := session read: GlorpVideoPurchase where: [:each | each inStore not].
	self assert: inStoreImplied size = 7.
	self assert: notInStoreImplied size = 3.