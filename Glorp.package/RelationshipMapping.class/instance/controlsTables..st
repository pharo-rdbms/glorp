accessing
controlsTables: aBoolean
	"We can indicate that this relationship does not actually control its tables. This is going to be true if the parent controls the same tables and coexists with us. Think StoreVersionlessPundle and Pundle"
	controlsTables := aBoolean.