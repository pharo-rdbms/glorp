Overview:

A TimedProxyReaper collects TimedProxies and, using a background process, uninstantiates when they are due to expire. You can control the number of seconds between each invocation of the background process, with the message #delay:, and you can control the amount of work the background process will do each time it runs with the message #maximumWork:.

API Methods:
