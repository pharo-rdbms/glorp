examples
exampleOnlinePurchase1
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 1.
	purchase title: 'All About Eve'.
	purchase price: 1.11.
	purchase inStore: false.
	^purchase.