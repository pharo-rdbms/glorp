preparing
condensePrimaryKeyComparisons
	"Because we're replacing the expression, we need to do it at the parent and replace the previous child"
	leftChild := leftChild condensePrimaryKeyComparison.
	rightChild := rightChild condensePrimaryKeyComparison.