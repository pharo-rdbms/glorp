tests
testBasicSort2
	"Try it with a different initial order. The sort is a convoluted way of writing the questionably-portable reverse"
	self sort: (self data1 asSortedCollection: [:a :b | a id >= b id]).
	self assertSortOrder: #(3 2 1).