accessing
linkTableJoin: aJoin
	"Set the join from the link table to the target table. Normally this is calculated automatically (see reverseJoin), but it can be set manually if that's not possible (for example, because you want to include a constant value in the join, that won't be included in the foreign key constraints). See also relevantLinkTableFields if you need to give a hint."
	linkTableJoin := aJoin.
	[aJoin owningMapping: self] on: MessageNotUnderstood do: [:ex | ex | ex return].