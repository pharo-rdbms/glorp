"
When we use an expression as a join, we tend to write it backwards. We use expressions when the relationship is more complicated than we can express as a single join. And we describe it by giving the target and describing how to use relationships to get from the target object to the source object. We can't do it forwards, because the forward relationship is exactly what we're trying to describe with this join. For example, for a (rather contrived) Address to Job relationship, we might write it as
  [:eachJob | eachJob worker address]
However, this means that when we're trying to rebuild this expression and fit it into a query, it's backwards from most expressions. We know that, so we give it a special kind of base that makes it rebuild itself slightly different, by preferring the target rather than the source.  
"
Class {
	#name : 'JoinBaseExpression',
	#superclass : 'BaseExpression',
	#category : 'Glorp-Expressions',
	#package : 'Glorp',
	#tag : 'Expressions'
}

{ #category : 'preparing' }
JoinBaseExpression >> asExpressionJoiningSource: source toTarget: target [
	"Create a general expression which represents this relationship where the values of the targets (which are normally parameters) are supplied out of the context provided by 'target' and the source fields are referencing things out of the context of source. Produces something suitable for ANDing into an expression when doing a join
   Example: If we had CUSTOMER.ADDRESS_ID = ADDRESS.ID as a parameter, and we want to AND this into an expression [:customer | customer address street = 'Main'] then we have customer as a base, and we get 
	(customer.ADDRESS.STREET = 'Main') AND (customer.CUSTOMER.ADDRESS_ID = customer.ADDRESS.ID)
	The primary key expression for the relationship has been translated into field references into the customer and address tables in a particular context."

	^ target
]
