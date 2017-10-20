proxies
newProxyIn: anObjectBuilder 
	| proxy |
	proxy := Proxy new.
	proxy query: (self queryFor: anObjectBuilder).
	proxy glorpProxyAction: self proxyAction.
	^proxy