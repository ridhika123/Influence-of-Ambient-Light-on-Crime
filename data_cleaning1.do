* This is the first data cleaning fileloc
* It is connected to:
	* sunrise.do
	* data_cleaning2.do
	* maindata_code.do

clear all
set more off
set matsize 10000
set maxvar 20000
set logtype text
local fileloc = "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data"
capture log close
log using doleac_sanders_replicate.txt, replace

global graph_options "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"
global esttab_opts "b(%9.3f) se sfmt(%9.3f) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps staraux r2"

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - TIME XXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Timezone
** Timezone data by county are from http://www.nws.noaa.gov/geodata/catalog/wsom/html/cntyzone.htm;
	
import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\timezone.csv"
keep fips time_zone
rename time_zone zone
destring fips, replace force
	
** Replace weird time zones
replace zone = "C" if zone == "CE"
replace zone = "C" if zone == "CM"
replace zone = "M" if zone == "MC"
replace zone = "M" if zone == "MP"
keep if zone == "E" | zone == "C" | zone == "M" | zone == "P" 
tab zone

bysort fips: keep if _n == 1
tab zone

sort fips
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\fips_to_timezone.dta, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Crosswalk

** Stata version of crosswalk available here http://www.icpsr.umich.edu/icpsrweb/ICPSR/studies/4634;
use  C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\crosswalk_stata_version.dta, clear
gen fips = FSTATE*1000 + FCOUNTY
drop FSTATE FCOUNTY
		
** Keep only major gov't region codes;
keep if CLASSCD == "C1" | CLASSCD == "C5" | CLASSCD == "H1" | CLASSCD == "T1"
rename LAT latitude
rename LONG longitude
rename ORI9 ori
** Clean data and keep variables you want
keep latitude longitude AGENTYPE fips ori
** Keep only the "normal" regions: sheriff, county, and municipal only
keep if AGENTYPE == 1 | AGENTYPE == 2 | AGENTYPE == 3
	
sort fips

tempfile location
save `location'
use  C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\fips_to_timezone.dta, clear
sort fips
merge fips using `location'
tab _merge
keep if _merge == 3
drop _merge
	
sort ori
compress

** Drop those with missing origin location;
drop if ori == ""
		
save  C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, replace



******************************************************************************************
************* MY DATA CLEANING: creating populationdensity data set **********************
******************************************************************************************
import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\pop_density.csv", clear 
drop gct_stubdisplaylabel
rename gct_stubtargetgeoid2 fips
rename hc08 pop_density
tab pop_density
gen urban = 0
replace urban = 1 if pop_density > 1000
sort fips
save  C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\fips_urban.dta, replace

use  C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta
sort fips
merge fips using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\fips_urban.dta
tab _merge
keep if _merge == 3
drop _merge
sort ori fips
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\fips_ori_pop.dta, replace


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Sunset and Rise
****************************************************************************** In sunrise.do


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - HOURLY XXXXXXXXXXXXXXXXXXXXXXX
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

	** The following code import the raw NIBRS data, obtained from ICPSR
	** Use batch header 1 ("_1" below) and administrative data ("_4" below) segments

	** Hourly crime data

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2007
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2007.dta"
rename ORI ori
rename B1009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2007.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori pop_group incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1 | (cleared_excep!="N" & cleared_excep!=" ")
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007_4_dst, replace
clear
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2008
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2008.dta"
rename ORI ori
rename B1009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2008.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008_4_dst, replace
clear
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2009
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2009.dta"
rename ORI ori
rename B1009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2009.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009_4_dst, replace
clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2010
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2010.dta"
rename ORI ori
rename B1009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2010.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1 
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010_4_dst, replace
clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2011
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2011.dta"
rename ORI ori
rename B1009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2011.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011_4_dst, replace
clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2012
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2012.dta"
rename ORI ori
rename B1009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2012.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012_4_dst, replace
clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2013
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2013.dta"
rename ORI ori
rename BH009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2013.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1 
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013_4_dst, replace
clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2014
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2014.dta"
rename ORI ori
rename BH009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2014.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014_4_dst, replace
clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2015
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2015.dta"
rename ORI ori
rename BH009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2015.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015_4_dst, replace
clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2016
* 1
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2016.dta"
rename ORI ori
rename BH009 pop_group
keep ori pop_group
duplicates drop
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016_1_dst, replace
clear

* 4
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2016.dta"
rename ORI ori
rename INCNUM incident
rename V1006 reported
rename V1007 hour
rename V1011 arrestees
rename V1013 cleared_excep
keep ori incident reported hour arrestees cleared_excep
replace hour = 99 if hour==.
gen arrest = arrestees>0 & arrestees!=.
gen solved = arrest==1
drop if ori == ""
sort ori incident	
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016_4_dst, replace
clear


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
**XXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - ALL OTHER XXXXXXXXXXXXXXXXXXXXXXX
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX A part of this is in data_cleaning2.do
