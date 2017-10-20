support
setUp
	super setUp.
	query := SimpleQuery new.
	expression := BaseExpression new.
	expression descriptor: (system descriptorFor: GlorpCustomer).
	(expression descriptor mappingForAttributeNamed: #name) shouldProxy: false.
	elementBuilder := ObjectBuilder for: expression in: query.
	expression aliasTable: (system tableNamed: 'GR_CUSTOMER') to: 't1'.
	session := GlorpSession new.
	session system: system.
	query session: system session.