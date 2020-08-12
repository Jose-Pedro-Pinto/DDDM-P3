param j; # number of DCs
param k; # number of customers
param facilityCost; # cost to open a facility
param capacity; # capacity of facility

param transportCost {1..j, 1..k}; # cost of transport from to customer
param demand {1..k}; # demand of customer

var facility {1..j} binary; # if a given facility is active
var transport {1..j, 1..k} >= 0; # amount transported from facility to customer

minimize cost: 
	# cost to open facilities
	sum {dc in 1..j} facility[dc] * facilityCost +
	# cost to transport from facilities to customers
	sum {dc in 1..j, customer in 1..k} transport[dc,customer] * transportCost[dc,customer];

subject to
# for all customers amount transported >= to the demand
Service {customer in 1..k}:
	sum {dc in 1..j} transport[dc,customer] = demand[customer];
# for all facilities amount transported from facility does not excede capacity
Cap {dc in 1..j}:
	sum {customer in 1..k} transport[dc,customer] <= capacity * facility[dc];
# optimizations
# amount of facilities is at least enough to supply demmand
MinFac:
	sum{dc in 1..j} facility[dc] >= ceil(sum{customer in 1..k} demand[customer] / capacity);
# amount of facilities is not more than the amount that would excede the wost know cost
MaxFac:
	sum{dc in 1..j} facility[dc] <=
	 max(
	 	sum {customer in 1..k} max {dc in 1..j} transportCost[dc,customer] * demand[customer] / facilityCost,
	 	ceil(sum{customer in 1..k} demand[customer] / capacity)
	 );