/*
// LIST DONATIONS THIS MONTH (View: list_donations_this_month)
SELECT * FROM `erro_donors` WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE + INTERVAL 1 MONTH, '%Y/%m/01')

// TOTAL DONATIONS THIS MONTH (View: total_donations_this_month)
SELECT sum(amount) as total FROM `erro_donors` WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE + INTERVAL 1 MONTH, '%Y/%m/01')

// LIST DONATIONS LAST MONTH (View: list_donations_last_month)
SELECT * FROM `erro_donors` WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE, '%Y/%m/01')

// TOTAL DONATIONS LAST MONTH (View: total_donations_last_month)
SELECT sum(amount) as total FROM `erro_donors` WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE, '%Y/%m/01')
*/

/datum/donation
	var/ckey
	var/amount
	var/datetime

/datum/donation/New(var/ckey, var/amount, var/datetime)
	src.ckey = ckey
	src.amount = amount
	src.datetime = datetime



/proc/test_donations_procs()
	world << "-------------------------"
	var/total1 = get_aggregate_donations()
	world << "Donations made this month: [total1] USD"
	var/total2 = get_aggregate_donations_last_month()
	world << "Donations made last month: [total2] USD"
	world << "-------------------------"
	var/list/L1 = get_list_donations()
	for (var/datum/donation/C in L1)
		world << "Donator this month [C.ckey] with [C.amount] USD"
	world << "-------------------------"
	var/list/L2 = get_list_donations_last_month()
	for (var/datum/donation/C in L2)
		world << "Donator last month [C.ckey] with [C.amount] USD"
	world << "-------------------------"



/proc/get_aggregate_donations()
	if(!dbcon.IsConnected())
		return 0

	var/DBQuery/query_donations = dbcon.NewQuery("SELECT sum(amount) as total FROM [format_table_name("donors")] WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE + INTERVAL 1 MONTH, '%Y/%m/01')")

	if(!query_donations.Execute())
		return 0

	if(query_donations.NextRow())
		return query_donations.item[1]

	return 0

/proc/get_aggregate_donations_last_month()
	if(!dbcon.IsConnected())
		return 0

	var/DBQuery/query_donations = dbcon.NewQuery("SELECT sum(amount) as total FROM [format_table_name("donors")] WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE, '%Y/%m/01')")

	if(!query_donations.Execute())
		return 0

	if(query_donations.NextRow())
		return query_donations.item[1]

	return 0



/proc/get_list_donations()
	if(!dbcon.IsConnected())
		return 0

	var/DBQuery/query_donations = dbcon.NewQuery("SELECT `ckey`, `amount`, `datetime` FROM [format_table_name("donors")] WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE + INTERVAL 1 MONTH, '%Y/%m/01')")

	if(!query_donations.Execute())
		return 0

	var/list/L = list()

	while(query_donations.NextRow())
		var/datum/donation/D = new /datum/donation(query_donations.item[1], query_donations.item[2], query_donations.item[3])
		L.Add(D)

	return L

/proc/get_list_donations_last_month()
	if(!dbcon.IsConnected())
		return 0

	var/DBQuery/query_donations = dbcon.NewQuery("SELECT `ckey`, `amount`, `datetime` FROM [format_table_name("donors")] WHERE `revoked` IS NULL AND `datetime` >= DATE_FORMAT(CURRENT_DATE - INTERVAL 1 MONTH, '%Y/%m/01') AND `datetime` < DATE_FORMAT(CURRENT_DATE, '%Y/%m/01')")

	if(!query_donations.Execute())
		return 0

	var/list/L = list()

	while(query_donations.NextRow())
		var/datum/donation/D = new /datum/donation(query_donations.item[1], query_donations.item[2], query_donations.item[3])
		L.Add(D)

	return L