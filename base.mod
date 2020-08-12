param i; # number of airports
param j; # number of DCs
param k; # number of customers
param facilityCost; # cost to open a facility
param capacity; # capacity of facility

param airCost {1..i, 1..j}; # cost of air transport from airport to DC
param landCost {1..j, 1..k}; # cost of transport from DC to customer
param demand {1..k}; # demand of customer

var facility {1..j} binary; # if a given facility is active
var transport {1..j, 1..k} >= 0; # amount transporrted from facility to customer
var airTransport {1..i, 1..j} >= 0; # amount transported from airport to customer

minimize cost: 
	# cost to open facilities
	sum {dc in 1..j} facility[dc] * facilityCost +
	# cost to transport from airport to facility
	sum {airport in 1..i, dc in 1..j} airTransport[airport, dc] * airCost[airport, dc] +
	# cost to transport from facilities to customers
	sum {dc in 1..j, customer in 1..k} transport[dc,customer] * landCost[dc,customer];

subject to
# for all customers amount transported >= to the demand
Service {customer in 1..k}:
	sum {dc in 1..j} transport[dc,customer] = demand[customer];
# for all facilities amount transported from facility does not excede capacity
Cap {dc in 1..j}:
	sum {customer in 1..k} transport[dc,customer] <= capacity * facility[dc];
# all facilities must be suplied with the amount they transport
Supply {dc in 1..j}:
	sum {airport in 1..i} airTransport[airport,dc] = sum{customer in 1..k} transport[dc,customer];
# optimizations