This is a version generator that takes an arbitrary block and runs it.

Instance Variables:
	block	<BlockClosure>	The block we evaluate to get the next version.
	numberOfArguments	<Integer>	Generated automatically. How many arguments does block take. If zero, we invoke it without our arguments. If not, we give it the arguments to use.

