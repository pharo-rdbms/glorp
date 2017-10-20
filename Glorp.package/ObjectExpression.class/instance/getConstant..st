api
getConstant: anObject
	"Allows us to refer to a constant object easily. This is most useful for subselects, where I can already write something like
   [:each | (each count: subQuery) = 5]
but since the subselect part might be very verbose, I might prefer to put the constant value first. I can't write
   [:each | 5 = (each count: subQuery)]
because then the left-hand side expression doesn't refer back to the block argument, and we can't build the expression correctly. So I can write
   [:each | (each getConstant: 5) = (each count: subQuery)]"
	^anObject asGlorpExpressionOn: self.