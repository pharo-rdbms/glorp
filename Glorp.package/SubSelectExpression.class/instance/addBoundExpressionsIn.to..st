preparing
addBoundExpressionsIn: aCommand to: boundExpressions
	self query prepare.
	self query addBoundExpressionsIn: aCommand to: boundExpressions.