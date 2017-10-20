preparing
rewriteFunctionArguments
	"If a function needs to adjust its arguments, do that here. The motivating example is one where a string argument is rewritten into a form that's of a different length, e.g. the Postgresql driver does that to strings in Blobs."
	leftChild rewriteFunctionArgumentsWith: rightChild.