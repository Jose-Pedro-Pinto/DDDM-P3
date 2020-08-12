param j; # number of DCs
param k; # number of customers
param facilityCost; # cost to open a facility
param capacity; # capacity of facility

param LB; # minimum known cost
param UB; # maximum known cost

param transportCost {1..j, 1..k}; # cost of transport from to customer
param demand {1..k}; # demand of customer

var facility {1..j} binary; # if a given facility is active
var transport {1..j, 1..k} >= 0; # amount transporrted from facility to customer
	

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
# facility amount greater or equal to min to cover demand and less than maximum profiable
FacilityCost:
	ceil(sum{customer in 1..k} demand[customer] / capacity) <= 
	sum{dc in 1..j} facility[dc] <=
	ceil(UB/facilityCost);
# cost must be less or equal to a known worse cost and greater or equal to a cost as good as possible
CostConstraint: 
	LB <=
	# cost to open facilities
	sum {dc in 1..j} facility[dc] * facilityCost +
	# cost to transport from facilities to customers
	sum {dc in 1..j, customer in 1..k} transport[dc,customer] * transportCost[dc,customer] <=
	UB; 
# the cost of transport must be lesser or equal to known worse than possible cost and worse or equal to known better than possible cost
TransportCost: 
	LB <=
	sum {dc in 1..j, customer in 1..k} transport[dc,customer] * transportCost[dc,customer] +
	ceil(sum{customer in 1..k} demand[customer] / capacity) * facilityCost <=
	UB;
# no facilit transports more to a customer than its capacity
TransportLimit {customer in 1..k, dc in 1..j}:
	transport[dc,customer] <= capacity * facility[dc];