examples
exampleOnlinePurchase2
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 2.
	purchase title: 'Butch Cassidy and the Sundance Kid'.
	purchase price: 2.22.
	purchase inStore: false.
	^purchase.