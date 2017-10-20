tests
testDeleteRegistration
	| obj |
	obj := Object new.
	unitOfWork delete: obj.
	self assert: (unitOfWork willDelete: obj).
	self deny: (unitOfWork willDelete: 3).