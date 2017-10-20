examples
exampleInStoreRental3
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1003.
	rental title: 'Charlie Brown Christmas'.
	rental price: 23.00.
	rental dueDate: Date today.
	^rental.