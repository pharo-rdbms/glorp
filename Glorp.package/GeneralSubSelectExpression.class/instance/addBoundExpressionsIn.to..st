preparing
addBoundExpressionsIn: aCommand to: boundExpressions
	self query session: aCommand query session.
	self query prepare.
	self query addBoundExpressionsIn: aCommand to: boundExpressions.