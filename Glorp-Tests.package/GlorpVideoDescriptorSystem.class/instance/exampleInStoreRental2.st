examples
exampleInStoreRental2
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1002.
	rental title: 'Best in Show'.
	rental price: 22.00.
	rental dueDate: Date today.
	^rental.