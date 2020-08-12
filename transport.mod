param j; # number of DCs
param k; # number of customers
param capacity; # capacity of facility

param transportCost {1..j, 1..k}; # cost of transport from to customer
param demand {1..k}; # demand of customer

var transport {1..j, 1..k} >= 0; # amount transporrted from facility to customer

minimize cost: 
	# cost to transport from facilities to customers
	sum {dc in 1..j, customer in 1..k} transport[dc,customer] * transportCost[dc,customer];

subject to
# for all customers amount transported >= to the demand
Service {customer in 1..k}:
	sum {dc in 1..j} transport[dc,customer] = demand[customer];
# for all facilities amount transported from facility does not excede capacity
Cap {dc in 1..j}:
	sum {customer in 1..k} transport[dc,customer] <= capacity;
