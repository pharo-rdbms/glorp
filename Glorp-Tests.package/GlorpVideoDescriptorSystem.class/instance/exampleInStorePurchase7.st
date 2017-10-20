examples
exampleInStorePurchase7
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 107.
	purchase title: 'Glengarry GlenRoss'.
	purchase price: 7.00.
	purchase inStore: true.
	^purchase.