running
populate
	| workers |
	session beginUnitOfWork.
	workers := GlorpTaskedWorker example1.
	session register: workers.
	session commitUnitOfWork.