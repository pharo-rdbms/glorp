printing
printTreeOn: aStream 
	aStream
		print: leftChild;
		space;
		nextPutAll: relation;
		space;
		print: rightChild