** Final data set **

clear all
set more off
set matsize 10000
set maxvar 20000
set logtype text
global graph_options "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"
global esttab_opts "b(%9.3f) se sfmt(%9.3f) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps staraux r2" 

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2007

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2007, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2007 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2007.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007.dta, replace	
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2008

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2008, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2008 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2008.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2008.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2009

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2009, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2009 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2009.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2009.dta, replace
	

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2010

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2010, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2010 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2010.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2010.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2011

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2011, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2011 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2011.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2011.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2012

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2012, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2012 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2012.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2012.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2013

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2013, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2013 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2013.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2013.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2014

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2014, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2014 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2014.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2014.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2015

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2015, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2015 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2015.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2015.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2016

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2016, clear
	gen state_ar = state==3
	gen state_az = state==2
	gen state_ca = state==4
	gen state_co = state==5
	gen state_ct = state==6
	gen state_de = state==7
	gen state_dc = state==8
	gen state_fl = state==9
	gen state_ga = state==10
	gen state_hi = state==51
	gen state_ia = state==14
	gen state_id = state==11
	gen state_il = state==12
	gen state_in = state==13
	gen state_ks = state==15
	gen state_ky = state==16
	gen state_la = state==17
	gen state_ma = state==20
	gen state_md = state==19
	gen state_me = state==18
	gen state_mi = state==21
	gen state_mn = state==22
	gen state_mo = state==24
	gen state_ms = state==23
	gen state_mt = state==25
	gen state_ne = state==26
	gen state_nc = state==32
	gen state_nd = state==33
	gen state_nh = state==28
	gen state_nj = state==29
	gen state_nm = state==30
	gen state_nv = state==27
	gen state_ny = state==31
	gen state_pa = state==37
	gen state_oh = state==34
	gen state_ok = state==35
	gen state_or = state==36
	gen state_ri = state==38
	gen state_sc = state==39
	gen state_sd = state==40
	gen state_tn = state==41
	gen state_tx = state==42
	gen state_ut = state==43
	gen state_va = state==45
	gen state_vt = state==44
	gen state_wa = state==46
	gen state_wi = state==48
	gen state_wv = state==47
	gen state_wy = state==49
	
	gen mergestate = ""
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {
		qui replace mergestate = "`state'" if state_`state' == 1
	}
 
	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*
	qui compress

	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, replace

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allyears1.dta, clear
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {
		cap drop rate_`var'*
	}

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100"
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
		gen `crime'_combined = `crime'_att + `crime'
		gen any_`crime' = `crime' > 0 & `crime' ~= .
		gen `crime'_count = `crime' * (population/1000000)
	}
	
	** Generate month variable;
	gen month = month(offdate)

	** Drop missing hour data;
	drop if hour == 99
	drop if hour == .
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode
	sum modehour, d
	preserve
	sample 1, by(ori year) count
	hist modehour, w(1)
		*$graph_options
	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\mode_hour_histogram1.eps, replace
	restore

	drop if modehour == .
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve
	bysort ori year month: keep if _n == 1
	by ori: gen months_total = _N
	tab months_total
	keep if months_total == 12
	keep ori
	bysort ori: keep if _n ==1
	tempfile allmonths
	save `allmonths', replace
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta, replace
	restore	
	
	*merge ori using `allmonths'
	*joinby ori using `allmonths'
	joinby ori using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\allmonths1.dta

	** Build variable for total number of crimes in a year;
	foreach crime in rate_rape rate_aggassault rate_murder rate_robbery  {
		egen total`crime' = sum(`crime'_count), by(ori year)
		egen mintotal`crime' = min(total`crime'), by(ori)
		drop total*
	}

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0
	drop if mintotalrate_aggassault == 0
	drop if mintotalrate_rape == 0
	
	tab pop_group
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
	
	compress
	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, replace


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period 
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	keep offdate ori population mergestate modehour
	gen year = year(offdate)
	drop offdate
	** Keep one per year;
	sample 1, by(year ori) count
							
	** One obs per day for each;
	expand (365)
	gen day1 = .
	foreach year in 2016 {
		replace day1 = td(1jan`year') if year == `year'
	}
	format day1 %td			
	tab day1

	bysort ori year: gen offdate = day1 + _n - 1
	format offdate %td

	gen year2 = year(offdate)
	drop if year2 ~= year
			
	duplicates drop ori offdate, force
	*drop if year > 2008
	
	** Make one for each hour;
	expand (24)
	bysort ori offdate: gen hour = (_n - 1)

	compress

	keep ori offdate hour population mergestate modehour
	sort ori offdate hour
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta, replace
				
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\building.dta, clear
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour
	
	** Merge on all days;
	sort ori offdate hour
	merge ori offdate hour using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\alldays1.dta
		
	tab _merge
	drop if _merge == 1
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in rate_robbery rate_rape rate_aggassault rate_murder rate_robbery_combined rate_rape_combined rate_aggassault_combined rate_murder_combined rate_robbery_count rate_rape_count rate_aggassault_count rate_murder_count {
		replace `var' = 0 if _merge == 2
		}
	drop _merge
	
	gen dow = dow(offdate)
	tab dow
		
	** Add on sunset data, dst, and location data;
	sort ori offdate
	tempfile states
	save `states'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2016.dta, clear
	sort ori offdate
	merge ori offdate using `states'
	tab _merge
	keep if _merge == 3
	drop _merge

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1
	gen running_day_fake = (offdate - daybefore_fake) - 1
	gen rdcontinuous = running_day
	gen running_dayint = running_day*dst
	replace running_day = 0 if dst == 1
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60)
	sum hours_since_sunset
	gen cleaned_hours = round(hours_since_sunset,1)
	gen hours_since_sunset_fake = .
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60)
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1)
	
	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60)
	sum hours_since_sunset_end
	gen cleaned_hours_end = round(hours_since_sunset_end,1)
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year)
	qui compress
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes)
	tab dupes
	drop dupes
/*
	if `add_weather' == 1 {
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location'
	}*/
	
		gsort ori, g(ori_cluster)
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2016.dta, replace
	
