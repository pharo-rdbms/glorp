iterating
do: aBlock
	"Iterate over the expression tree"

	self do: aBlock skipping: Dialect identitySetClass new.