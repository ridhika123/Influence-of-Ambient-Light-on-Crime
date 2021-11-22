clear all
set more off
set matsize 10000
set maxvar 20000
set logtype text
global graph_options "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"
global esttab_opts "b(%9.3f) se sfmt(%9.3f) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps staraux r2"

	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007, clear
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2008
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2009
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2010
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2011
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2012
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2013
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2014
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2015
	append using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2016


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2007

************************************************** Figure 2
use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2007, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2007) saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2007.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2007.gph

************************************************** Figure 3
foreach crime in rate_murder rate_robbery rate_aggassault rate_rape {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace	
}

************************************************** Table 1 
use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear

preserve

local meancrimes = "rate_robbery rate_rape rate_aggassault rate_murder"
xtset ori_by_year
postutil clear
tempname xtsums

postfile `xtsums' str16 crime str6 hour mean sd using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\means.dta, replace
	
tempfile means
save `means'

collapse (sum) rate_*_combined (mean) population, by(offdate ori_by_year)
foreach var in `meancrimes' {

	sum `var' [aw = population]

	local mean = r(mean)
	local sd = r(sd)
	post `xtsums' ("`var'") ("all") (`mean') (`sd')
		
}

use `means', clear
collapse (sum) rate_*_combined (mean) population, by(offdate ori_by_year dst)
foreach var in `meancrimes' {

	sum `var' if dst == 0 [aw = population]
	local mean = r(mean)
	local sd = r(sd)
	post `xtsums' ("`var'") ("pre") (`mean') (`sd')

	sum `var' if dst == 1 [aw = population]
	local mean = r(mean)
	local sd = r(sd)
	post `xtsums' ("`var'") ("post") (`mean') (`sd')
	
}

use `means', clear
keep if cleaned_hours == 0 | cleaned_hours == 1
collapse (sum) rate_*_combined (mean) population, by(offdate ori_by_year dst)
foreach var in `meancrimes' {

	sum `var' if dst == 0  [aw = population]
	local mean = r(mean)
	local sd = r(sd)
	post `xtsums' ("`var'") ("0,1 pre") (`mean') (`sd')

	sum `var' if dst == 1 [aw = population]
	local mean = r(mean)
	local sd = r(sd)
	post `xtsums' ("`var'") ("0,1 post") (`mean') (`sd')
	
}
	
postclose `xtsums'
use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\means.dta, clear
export excel C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\means.xls, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\means.dta

** Number of reporting regions and population;
restore
sample 1, by(ori year) count
count if ori == ""
gsort ori, g(ori_sort)
egen totalpopulation = total(population), by(year)
replace totalpopulation = totalpopulation / 1000000
format totalpopulation %16.9g

estpost summarize totalpopulation ori_sort if year == 2007
esttab using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\number_of_obs_2007.xls, tab cells(mean max) replace 

************************************************** Table 2 Column 1
local crimesused "rate_robbery rate_rape rate_aggassault rate_murder"

** Regressions as RD;
use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007.dta if rdcontinuous >= -21 & rdcontinuous <= 20 &  modehour ~= 0, clear	

gen weekend = (dow == 0 | dow == 6)
gen weekofyear = week(offdate)

** Use both attempted and successful crimes;
foreach crime in `crimesused'  {
	replace `crime' = (`crime'_combined)
}

collapse (sum) `crimesused' (mean) population year dst dow month running_day running_dayint ori_cluster `weather' fips weekend rdcontinuous weekofyear, by(ori_by_year offdate) fast

tempfile rdregs
save `rdregs'

eststo clear		
foreach crime in `crimesused' {
	
	use `rdregs', clear
	
	gen dstXweekend = dst*weekend
	gen lnpop = ln(population)

	xi i.dow i.year, noomit
	
	eststo clear	
	areg `crime' _Idow* `weather' dst running_day running_dayint [aw = population], cluster(ori_cluster) absorb(ori_by_year)
	_eststo
	
	** Generate pre-dst mean;
	sum `crime' if rdcontinuous < 0 [aw = population]
	estadd scalar priorweekmean = r(mean)
	estadd scalar shareofmean = _b[dst] / r(mean)

	** Replicate Weekend Interactions (Table A-6);
	** Add weekend difference;
	areg `crime' _Idow* `weather' weekend dstXweekend dst running_day running_dayint [aw = population] if rdcontinuous >= -21 & rdcontinuous <= 20, cluster(ori_cluster) absorb(ori_by_year)
	_eststo
						
esttab, keep(dst dstXweekend) $esttab_opts	

estout using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\daily_`crime'.xls, keep(dst dstXweekend) cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) replace starlevels(* 0.10 ** 0.05 *** 0.01) mlabels("Basic" "Add Weather" "Add Pop" "Add Year FE" "Add DoW FE") stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"))
	
esttab using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\daily_`crime'.tex, keep(dst dstXweekend) replace $esttab_opts stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"))

}

************************************************** Table 2 Column 2
use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear	

collapse (sum) rate* (mean) `weather' dow running_day running_dayint dst population ori_cluster year rdcontinuous, by(ori_by_year offdate) fast

foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {
	replace `crime' = 1 if `crime'_combined > 0
}

eststo clear

xi i.dow

xtset ori_by_year
		
eststo clear
	
foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {

	xtreg `crime' _I* `weather' running_day running_dayint dst [aw = population], fe cluster(ori_cluster)

	eststo

	sum `crime' if rdcontinuous < 0
	di _b[dst] / r(mean)
	estadd scalar shareofmean = _b[dst] / r(mean)
	
}

	esttab, keep(dst)
	
	esttab using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\anycrime_day.rtf, keep(dst) replace stats(shareofmean, fmt(%9.2f) label("Share of Mean"))

	estout using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\anycrime_day.xls, keep(dst) cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) replace stats(shareofmean N, fmt(%9.3f %9.0fc)) starlevels(* 0.10 ** 0.05 *** 0.01)

************************************************** Table 3 & 4 Column 2
	
	local crimesused "rate_robbery rate_rape rate_aggassault rate_murder"

** Regressions as RD;
use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2007.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear

** Use both attempted and successful crimes;
foreach crime in `crimesused' {
	replace `crime' = `crime'_combined
}

** Keep only hours of sunset;
keep if cleaned_hours == 0 | cleaned_hours == 1

collapse (sum) `crimesused' (mean) dow `weather' running_day running_dayint dst population ori_cluster rdcontinuous, by(ori_by_year offdate) fast

xi i.dow

xtset ori_by_year

tempfile rdregs
save `rdregs'

eststo clear

foreach crime in `crimesused'  {
		
	xtreg `crime' _I* `weather' running_day running_dayint dst [aw = population], cluster(ori_cluster) fe
		
	_eststo
		
	** Generate pre-dst mean;
	sum `crime' if rdcontinuous < 0 [aw = population]
	estadd scalar priorweekmean = r(mean)
	estadd scalar shareofmean = _b[dst] / r(mean)
		
}

	esttab, stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean")) keep(dst)

	estout using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\rd_by_hour.xls, keep(dst) cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) replace stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean")) starlevels(* 0.10 ** 0.05 *** 0.01)
		
	esttab using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\rd_by_hour.rtf, keep(dst) replace stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean"))
	
eststo clear

** Now linear probability model;
foreach crime in `crimesused' {
	replace `crime' = 1 if  `crime' > 0
	tab `crime'
}	


foreach crime in `crimesused'  {
		
	xtreg `crime' _I* `weather' running_day running_dayint dst [aw = population], cluster(ori_cluster) fe
		
	_eststo
		
	sum `crime' if rdcontinuous < 0 [aw = population]
	estadd scalar priorweekmean = r(mean)
	estadd scalar shareofmean = _b[dst] / r(mean)
		
	}

	esttab, stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean")) keep(dst)

	estout using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\anycrime_by_hour.xls, keep(dst) cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) replace stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean")) starlevels(* 0.10 ** 0.05 *** 0.01)
		
	esttab using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\anycrime_by_hour.rtf, keep(dst) replace stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean"))

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2008

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2008.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2008, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2008)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2008.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2008.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2008.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2009

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2009.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2009, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2009)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2009.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2009.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2009.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2010

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2010.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2010, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2010)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2010.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2010.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2010.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2011

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2011.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2011, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2011)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2011.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2011.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2011.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2012

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2012.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2012, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2012)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2012.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2012.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2012.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2013

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2013.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2013, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2013)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2013.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2013.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2013.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2014

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2014.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2014, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2014)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2014.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2014.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2014.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2015

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2015.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2015, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2015)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2015.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2015.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2015.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}



**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX2016

use modehour ori_cluster year daybefore* dst* offdate using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2016.dta if modehour ~= 0, clear

** Only want day before DST begins in spring;
keep if offdate == daybefore
sample 1, by(ori_cluster year) count
tab year
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) 
	
twoway hist hourandminute if year == 2016, percent start(17.5) width(0.25) xlabel(17.5(.5)19.5) xtitle("Day Before DST Sunset Hour") ytitle("Percent") title(2016)
		*$graph_options
		saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2016.gph, replace)	
		
graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution.eps, replace
shell rm C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset_distribution_2016.gph


foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {

	local cutter = 8*7
	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2016.dta if modehour ~= 0, clear

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6

	** Combine attempted and successful;
	replace `crime' = `crime'_combined

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast

	gen week = week(offdate)
			
	tempfile local_linear_run
	save `local_linear_run'
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast
	rename rdcontinuous running_day
	tempfile means
	save `means'
	
	postutil clear
	tempname locallinear
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, replace
		
	local llband = (21)
	
	forvalues day = -`cutter'/`cutter' {
			use `local_linear_run', clear

			quietly {

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' 
			
				sum dow if rdcontinuous == `day'
				local dow = r(mean)

				reg `crime' dst running_day running_dayint [aw = population] 
			
				clear
				set obs 1
				gen dst = (`day' >= 0)
				gen running_day = `day'*(1 - dst)
				gen running_dayint = `day' * dst
			
				** predict estimate;
				predict localestimate
				** predict standard error of estimate;
				predict reg_st_dev, stdp
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev
				gen lowerCI = localestimate - 1.96 * reg_st_dev
			
			}
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow')

	}
				
	postclose `locallinear'
		
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_graphs_day.dta, clear
	append using `means'
	
	drop if running_day < -`cutter' | running_day > `cutter'

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) || line predicted_rob running_day if running_day >= 0, lcolor(black) xline(0, lpattern(longdash) lcolor(gray)) || scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none) graphregion(fcolor(white) lcolor(white)) legend(off) ytitle("Rate per 1,000,000") xtitle("Day") xlabel(-`cutter'(7)`cutter') saving(C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel, replace)

	graph export C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\local_linear_allyears_`crime'_daylevel.eps, replace
	
}

********************************************
