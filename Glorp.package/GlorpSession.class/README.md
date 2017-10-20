This is the main class for communicating between the user and Glorp. It acts as a broker for reading queries, and as the main point for registering objects for modification.

A note about the distinction between #begin/rollback/commitUnitOfWork and #begin/rollback/commitTransaction is in order. There are two basic scenarios. In the first scenario, you wrap your updates in a UnitOfWork using #beginUnitOfWork, doing the updates, and then #commitUnitOfWork. Method #commitUnitOfWork privately sends #beginTransaction, writes all the data to disk, and then sends #commitTransaction. So, the UnitOfWork itself keeps track of all the updates, and if commited, it sends them on to the database within a private Transaction.

In the second scenario, you control the Transaction, starting with #beginTransaction. If you then wrap your updates inside a UnitOfWork, you get the same behavior as before--the UnitOfWork won't send to disk until you say #commitUnitOfWork. But this time, your UnitOfWork will notice that you have an ongoing Transaction so it sends neither #beginTransaction nor #commitTransaction. Instead, it expects you to send #commitTransaction later. In short, it won't touch the Transaction control since you own it. This scenario can be used to execute a series of operations, each in a separate UnitOfWork, where all can be committed or rolled back downstream.

Of course, a UnitOfWork is optional, likewise a Transaction, but their use is much recommended.

Instance Variables

	system	<DescriptorSystem>	The definition of our tables, classes, and the relationships between them.
	currentUnitOfWork	<UnitOfWork | nil>	If we have an active unit of work, this will hold it. All modifications are tracked through the unit of work.
	cache	<CacheManager>	Our cache of objects that we've already read.
	accessor	<DatabaseAccessor>	Our connection to the database.
	application	<?>	application-specific data
	reaper <TimedProxyReaper> If we are using TimedProxy for some of our relationships, this holds the reaper which will expire them on timeout.
	errorAction <Block> What block should we evaluate when there's an error.
	modificationTracker <GlorpVWWriteBarrierTracker> VisualWorks-specific. This holds the GlorpVWWriteBarrierTracker in use for this session. This uses immutability to keep track of objects which are changed.
