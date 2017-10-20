preparing
rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression
	"Rebuild the expression on the new base. If we encounter anExpression, treat that as the base, and build only from that point up. e.g. if we have a.b.c.d and we rebuildOn: z startingFrom: b, then the result will be z.c.d. Pieces that aren't based on anExpression should be built onto ultimateBaseExpression instead of aBaseExpression. They represents parts of outer scope trees that are referenced within us.
  Note that anExpression can be nil, but if it is, then ultimateBaseExpression is effectively ignored."
	self subclassResponsibility.