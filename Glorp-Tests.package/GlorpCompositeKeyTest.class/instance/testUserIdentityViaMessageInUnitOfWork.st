tests- basic reading
testUserIdentityViaMessageInUnitOfWork
	session beginUnitOfWork.
	[self testUserIdentityViaMessage] ensure: [session rollbackUnitOfWork].