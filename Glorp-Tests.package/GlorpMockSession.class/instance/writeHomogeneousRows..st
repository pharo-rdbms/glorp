read/write
writeHomogeneousRows: aCollection
	aCollection do: [:each | self writeRow: each].
	^true.