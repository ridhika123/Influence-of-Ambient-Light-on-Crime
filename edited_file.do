*#delimit;
clear all
set more off
set matsize 10000
set maxvar 20000
set logtype text
local fileloc = "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data"
capture log close
log using doleac_sanders_replicate.txt, replace


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX NOTES XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

** Locals and globals below establish the look of graphs, estout tables, and which parts of the program to execute in any given run. The do-file assumes you have estout installed.

** For ease of replication, place all downloaded data sets and the do-file in a folder named "Replication". Generate three new folders for output and data storage, named "data", "figures", and "regs". The do-file will access these folders as part of the replication process. Place all downloaded data in the "data" folder.

** Replace the local "fileloc" above with the directory to the folder on your machine containing the "Replication" folder. 


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GLOBALS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

global graph_options "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"

global esttab_opts "b(%9.3f) se sfmt(%9.3f) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps staraux r2"

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX locals XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

** DATA BUILDING – set to 1 to run different data set construction steps;
local location = 0
local timezones = 0
local time = 0
local hourly = 1
local basedata = 0
local rebuild = 0

** WEATHER – set "add_weather" to 1 to add data, and turn off comment on local "weather" to run regressions with weather added. Replace local "weather_location" with the location of the weather data, and name variables "avg_temp" for temperature and "prec" for rainfall;
local add_weather = 0
**local weather = "avg_temp prec";
**local weather_location = ;

** Locals for the beginning and end of DST in each year;
local dst2005 = td(03Apr2005)
local dst2006 = td(02Apr2006)
local dst2007 = td(11Mar2007)
local dst2008 = td(09Mar2008)
local dst2009 = td(08Mar2009)
local dst2010 = td(14Mar2010)
local dst2011 = td(13Mar2011)
local dst2012 = td(11Mar2012)
local dst2013 = td(10Mar2013)
local dst2014 = td(9Mar2014)
local dst2015 = td(8Mar2015)
local dst2016 = td(13Mar2016)

local laterdst2005 = td(30Oct2005)
local laterdst2006 = td(29Oct2006)
local laterdst2007 = td(04Nov2007)
local laterdst2008 = td(02Nov2008)
local laterdst2009 = td(01Nov2009)
local laterdst2010 = td(07Nov2010)
local laterdst2011 = td(06Nov2011)
local laterdst2012 = td(04Nov2012)
local laterdst2013 = td(03Nov2013)
local laterdst2014 = td(02Nov2014)
local laterdst2015 = td(01Nov2015)
local laterdst2016 = td(06Nov2016)

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - TIMEZONES XXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

	** Timezone data by county are from http://www.nws.noaa.gov/geodata/catalog/wsom/html/cntyzone.htm;
	
	insheet using `fileloc'/data/fips_timezones.csv, clear;
	rename v7 fips;
	rename v8 zone;
	keep fips zone;
	destring fips, replace force;
	
	** Replace weird time zones;
	replace zone = "C" if zone == "CE";
	replace zone = "C" if zone == "CM";
	replace zone = "M" if zone == "MC";
	replace zone = "M" if zone == "MP";
	keep if zone == "E" | zone == "C" | zone == "M" | zone == "P"; 
	tab zone;

	bysort fips: keep if _n == 1;
	tab zone;
	
	sort fips;
	save `fileloc'/data/fips_to_timezone.dta, replace;

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - LOCATION XXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

	** Stata version of crosswalk available here http://www.icpsr.umich.edu/icpsrweb/ICPSR/studies/4634;
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\crosswalk_stata_version.dta, clear
	gen fips = FSTATE*1000 + FCOUNTY
	drop FSTATE FCOUNTY
		
	** Keep only major gov't region codes;
	keep if CLASSCD == "C1" | CLASSCD == "C5" | CLASSCD == "H1" | CLASSCD == "T1"
	rename LAT latitude
	rename LONG longitude
	rename ORI9 ori
	** Clean data and keep variables you want;
	keep latitude longitude AGENTYPE fips ori
	** Keep only the "normal" regions: sheriff, county, and municipal only;
	keep if AGENTYPE == 1 | AGENTYPE == 2 | AGENTYPE == 3
	
	sort fips

	tempfile location
	save `location'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\fips_to_timezone.dta, clear
	sort fips
	merge fips using `location'
	tab _merge
	keep if _merge == 3
	drop _merge
	
	sort ori;
	compress;

	** Drop those with missing origin location;
	drop if ori == "";
		
	save `fileloc'/data/ori_lat_long_new.dta, replace;	

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - TIME XXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

	
	** Latitude and longitude-based sunset times derived from http://www.esrl.noaa.gov/gmd/grad/solcalc/;
		
	use `fileloc'/data/latlong_sunrise.dta, clear;
	keep if year >= 2005 & year <= 2008;
	sort latitude longitude;
		
	tempfile latlong;
	save `latlong';
	use `fileloc'/data/ori_lat_long_new.dta, clear;

	sort latitude longitude;
	joinby latitude longitude using `latlong';
	
	gen state = substr(ori,1,2);
	** Drop Alaska and Indiana;
	drop if state == "AK";
	gen stata_date = mdy(month,day,year);
	gen stata_sunset = clock(sunset,"hm");
	gen stata_sunrise = clock(sunrise,"hm");
	format stata_sunset %tc; 
	format stata_sunrise %tc; 
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset);
	gen sunset_min = mmC(stata_sunset);
	gen sunrise_hour = hhC(stata_sunrise);
	gen sunrise_min = mmC(stata_sunrise);
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise;	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E";
	replace sunrise_hour = sunrise_hour + 1 if zone == "E";
	replace sunset_hour = sunset_hour - 1 if zone == "M";
	replace sunrise_hour = sunrise_hour - 1 if zone == "M";
	replace sunset_hour = sunset_hour - 2 if zone == "P";
	replace sunrise_hour = sunrise_hour - 2 if zone == "P";
	
	rename stata_date offdate;
	replace state = lower(state);
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude;

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .;
	foreach year in 2005 2006 2007 2008 {;
		replace daybefore = `dst`year'' - 1 if year == `year';
	};
		
	gen daybefore_fake = .;
	foreach year in 2005 2006 2007 2008 {;
		replace daybefore_fake = `dst`year'fake' - 1 if year == `year';
	};

	gen daybefore_end = .;
	foreach year in 2005 2006 2007 2008 {;
		replace daybefore_end = `laterdst`year'' - 1 if year == `year';
	};	
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end;
	gen fake_dst = offdate > daybefore_fake;

	gen clock_sunset_hour = sunset_hour;
	gen clock_sunset_min = sunset_min;
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1;
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore;
		egen tempdst = max(dst_sunset_hour), by(ori year);
		replace dst_sunset_hour = tempdst;
		drop tempdst;

		gen dst_sunset_min = sunset_min if offdate == daybefore;
		egen tempdst = max(dst_sunset_min), by(ori year);
		replace dst_sunset_min = tempdst;
		drop tempdst;

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end;
		egen tempdst = max(dstend_sunset_hour), by(ori year);
		replace dstend_sunset_hour = tempdst;
		drop tempdst;

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end;
		egen tempdst = max(dstend_sunset_min), by(ori year);
		replace dstend_sunset_min = tempdst;
		drop tempdst;

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake;
		egen tempdst = max(fakedst_sunset_hour), by(ori year);
		replace fakedst_sunset_hour = tempdst;
		drop tempdst;
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake;
		egen tempdst = max(fakedst_sunset_min), by(ori year);
		replace fakedst_sunset_min = tempdst;
		drop tempdst;	
	
		compress;
		
	save `fileloc'/data/sunset.dta, replace;


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - HOURLY XXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

	** The following code import the raw NIBRS data, obtained from ICPSR;
	** Use batch header 1 ("_1" below) and administrative data ("_4" below) segments

	** Hourly crime data;

	**2005;
    use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2005
	rename ORI ori
	rename BH009 pop_group
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
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2005_dst, replace
	clear

	**2006;
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2006
	rename ORI ori
	rename BH009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2006_dst, replace
	clear

	**2007;
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007
	rename ORI ori
	rename B1009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007_dst, replace
	clear
	
	**2008;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008
	rename ORI ori
	rename B1009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008_dst, replace
	clear

	**2009;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009
	rename ORI ori
	rename B1009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1 //Modified this code, might have been dumb but for now -30th Nov
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009_dst, replace
	clear

	**2010;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010
	rename ORI ori
	rename B1009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1 //Modified this code, might have been dumb but for now -30th Nov
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010_dst, replace
	clear

	**2011;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011
	rename ORI ori
	rename B1009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1 //Modified this code, might have been dumb but for now -30th Nov
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011_dst, replace
	clear
	
	**2012;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012
	rename ORI ori
	rename B1009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1 //Modified this code, might have been dumb but for now -30th Nov
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012_dst, replace
	clear

	**2013;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013
	rename ORI ori
	rename BH009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1 //Modified this code, might have been dumb but for now -30th No
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013_dst, replace
	clear

	**2014;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014
	rename ORI ori
	rename BH009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1 
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014_dst, replace
	clear

	**2015;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015
	rename ORI ori
	rename BH009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015_dst, replace
	clear

	**2016;	
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016
	rename ORI ori
	rename BH009 pop_group
	rename INCNUM incident
	rename V1006 reported
	rename V1007 hour
	rename V1011 arrestees
	rename V1013 cleared_excep
	keep ori pop_group incident reported hour arrestees cleared_excep
	replace hour = 99 if hour==.
	gen arrest = arrestees>0 & arrestees!=.
	gen solved = arrest==1 
	drop if ori == ""
	sort ori incident	
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016_dst, replace
	clear

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - ALL OTHER XXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

** Use NIBRS batch header 2 ("_2" below) and offense-level data ("_5" below) segments;
	
	foreach year in 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 {
			
		use  C:\Users\agrawalr\OneDrive - Grinnell College\nibrs`year', clear
		rename ORI ori
		rename B2005 pop1
		rename B2009 pop2
		rename B2013 pop3
		rename B2017 pop4
		collapse (mean) pop1 pop2 pop3 pop4, by(ori)
		sort ori
		save C:\Users\agrawalr\OneDrive - Grinnell College\nibrs`year'_2_dst, replace
		clear
		
		use `fileloc'/data/nibrs/nibrs`year'_5
		
		/*label var V2001  "SEGMENT LEVEL";
		label var V2002  "NUMERIC STATE CODE";
		label var V2003  "ORIGINATING AGENCY IDENTIFIER";
		label var V2004  "INCIDENT NUMBER";
		label var V2005  "INCIDENT DATE";
		label var V2006  "UCR OFFENSE CODE";
		label var V2007  "OFFENSE ATTEMPTED / COMPLETED";
		label var V2008  "OFFENDER(S) SUSPECTED OF USING 1";
		label var V2009  "OFFENDER(S) SUSPECTED OF USING 2";
		label var V2010  "OFFENDER(S) SUSPECTED OF USING 3";
		label var V2011  "LOCATION TYPE";
		label var V2012  "NUMBER OF PREMISES ENTERED";
		label var V2013  "METHOD OF ENTRY";
		label var V2014  "TYPE CRIMINAL ACTIVITY/GANG INFO 1";
		label var V2015  "TYPE CRIMINAL ACTIVITY/GANG INFO 2";
		label var V2016  "TYPE CRIMINAL ACTIVITY/GANG INFO 3";
		label var V2017  "WEAPON / FORCE 1";
		label var V2018  "WEAPON / FORCE 2";
		label var V2019  "WEAPON / FORCE 3";
		label var V2020  "BIAS MOTIVATION";
		label var V2021  "N RECORDS PER ORI-INCIDENT NUMBER";*/
		
		gen sample_aggassault = V20061=="Aggravated Assault" & V20071=="Completed";
		gen sample_simpleassault = V20061=="Simple Assault" & V20071=="Completed";
		gen sample_intimidation = V20061=="Intimidation" & V20071=="Completed";
		gen sample_bribery = V20061=="Bribery" & V20071=="Completed";
		gen sample_burglary = V20061=="Burglary/Breaking and Entering" & V20071=="Completed";
		gen sample_forgery = V20061=="Counterfeiting/Forgery" & V20071=="Completed";
		gen sample_damageprop = V20061=="Destruction/Damage/Vandalism of Property" & V20071=="Completed";
		gen sample_drug = V20061=="Drug/Narcotic Violations" & V20071=="Completed";
		gen sample_drugequip = V20061=="Drug Equipment Violations" & V20071=="Completed";
		gen sample_embezzlement = V20061=="Embezzlement" & V20071=="Completed";
		gen sample_extortion = V20061=="Extortion/Blackmail" & V20071=="Completed";
		gen sample_swindle = V20061=="False Pretenses/Swindle/Confidence Game" & V20071=="Completed";
		gen sample_creditfraud = V20061=="Credit Card/Automatic Teller Machine Fraud" & V20071=="Completed";
		gen sample_impersonation = V20061=="Impersonation" & V20071=="Completed";
		gen sample_welfarefraud = V20061=="Welfare Fraud" & V20071=="Completed";
		gen sample_wirefraud = V20061=="Wire Fraud" & V20071=="Completed";
		gen sample_gambling = V20061=="Betting/Wagering" & V20071=="Completed";
		gen sample_gamblingpromot = V20061=="Operating/Promoting/Assisting Gambling" & V20071=="Completed";
		gen sample_gamblingequip = V20061=="Gambling Equipment Violations" & V20071=="Completed";
		gen sample_murder = V20061=="Murder/Nonnegligent Manslaughter" & V20071=="Completed";
		gen sample_negmanslaughter = V20061 == "Negligent Manslaughter" & V20071=="Completed";
		gen sample_justifiablehomicide = V20061=="Justifiable Homicide" & V20071=="Completed";
		gen sample_kidnapping = V20061=="Kidnaping/Abduction" & V20071=="Completed";
		gen sample_pickpocket = V20061=="Pocket-picking" & V20071=="Completed";
		gen sample_pursesnatch = V20061=="Purse-snatching" & V20071=="Completed";
		gen sample_shoplifting = V20061 == "Shoplifting" & V20071=="Completed";
		gen sample_theftbldg = V20061 == "Theft From Building" & V20071=="Completed";
		gen sample_theftcoinopmach = V20061=="Theft From Coin-Operated Machine or Device" & V20071=="Completed";
		gen sample_theftmotorveh = V20061 == "Theft From Motor Vehicle Theft of MotorVehicle" & V20071=="Completed";
		gen sample_theftparts = V20061 == "Parts/Accessories" & V20071=="Completed";
		gen sample_theftoth = V20061 == "All Other Larceny" & V20071=="Completed";
		gen sample_vtheft = V20061=="Motor Vehicle Theft" & V20071=="Completed";
		gen sample_obscenemat = V20061=="Pornography/Obscene Material" & V20071=="Completed";
		gen sample_prostitution = V20061=="Prostitution" & V20071=="Completed";
		gen sample_prostitutionpromot = V20061=="Assisting or Promoting Prostitution" & V20071=="Completed";
		gen sample_robbery = V20061=="Robbery" & V20071=="Completed";
		gen sample_rape = V20061=="Forcible Rape" & V20071=="Completed";
		gen sample_sodomy = V20061=="Forcible Sodomy" & V20071=="Completed";
		gen sample_sexassaultobj = V20061=="Sexual Assault With An Object" & V20071=="Completed";
		gen sample_forcfondling = V20061=="Forcible Fondling (Indecent Liberties/Child Molesting)" & V20071=="Completed";
		gen sample_incest = V20061=="Incest" & V20071=="Completed";
		gen sample_statrape = V20061=="Statutory Rape" & V20071=="Completed";
		gen sample_stolprop = V20061=="Stolen Property Offenses (Receiving, Selling, Etc.)" & V20071=="Completed";
		gen sample_weapon = V20061=="Weapon Law Violations" & V20071=="Completed";
	
		gen sample_aggassault_att = V20061=="Aggravated Assault" & V20071=="Attempted";
		gen sample_simpleassault_att = V20061=="Simple Assault" & V20071=="Attempted";
		gen sample_intimidation_att = V20061=="Intimidation" & V20071=="Attempted";
		gen sample_bribery_att = V20061=="Bribery" & V20071=="Attempted";
		gen sample_burglary_att = V20061=="Burglary/Breaking and Entering" & V20071=="Attempted";
		gen sample_forgery_att = V20061=="Counterfeiting/Forgery" & V20071=="Attempted";
		gen sample_damageprop_att = V20061=="Destruction/Damage/Vandalism of Property" & V20071=="Attempted";
		gen sample_drug_att = V20061=="Drug/Narcotic Violations" & V20071=="Attempted";
		gen sample_drugequip_att = V20061=="Drug Equipment Violations" & V20071=="Attempted";
		gen sample_embezzlement_att = V20061=="Embezzlement" & V20071=="Attempted";
		gen sample_extortion_att = V20061=="Extortion/Blackmail" & V20071=="Attempted";
		gen sample_swindle_att = V20061=="False Pretenses/Swindle/Confidence Game" & V20071=="Attempted";
		gen sample_creditfraud_att = V20061=="Credit Card/Automatic Teller Machine Fraud" & V20071=="Attempted";
		gen sample_impersonation_att = V20061=="Impersonation" & V20071=="Attempted";
		gen sample_welfarefraud_att = V20061=="Welfare Fraud" & V20071=="Attempted";
		gen sample_wirefraud_att = V20061=="Wire Fraud" & V20071=="Attempted";
		gen sample_gambling_att = V20061=="Betting/Wagering" & V20071=="Attempted";
		gen sample_gamblingpromot_att = V20061=="Operating/Promoting/Assisting Gambling" & V20071=="Attempted";
		gen sample_gamblingequip_att = V20061=="Gambling Equipment Violations" & V20071=="Attempted";
		gen sample_murder_att = V20061=="Murder/Nonnegligent Manslaughter" & V20071=="Attempted";
		gen sample_negmanslaughter_att = V20061 == "Negligent Manslaughter" & V20071=="Attempted";
		gen sample_justifiablehomicide_att = V20061=="Justifiable Homicide" & V20071=="Attempted";
		gen sample_kidnapping_att = V20061=="Kidnaping/Abduction" & V20071=="Attempted";
		gen sample_pickpocket_att = V20061=="Pocket-picking" & V20071=="Attempted";
		gen sample_pursesnatch_att = V20061=="Purse-snatching" & V20071=="Attempted";
		gen sample_shoplifting_att = V20061 == "Shoplifting" & V20071=="Attempted";
		gen sample_theftbldg_att = V20061 == "Theft From Building" & V20071=="Attempted";
		gen sample_theftcoinopmach_att = V20061=="Theft From Coin-Operated Machine or Device" & V20071=="Attempted";
		gen sample_theftmotorveh_att = V20061 == "Theft From Motor Vehicle Theft of MotorVehicle" & V20071=="Attempted";
		gen sample_theftpartsv = V20061 == "Parts/Accessories" & V20071=="Attempted";
		gen sample_theftoth_att = V20061 == "All Other Larceny" & V20071=="Attempted";
		gen sample_vtheft_att = V20061=="Motor Vehicle Theft" & V20071=="Attempted";
		gen sample_obscenemat_att = V20061=="Pornography/Obscene Material" & V20071=="Attempted";
		gen sample_prostitution_att = V20061=="Prostitution" & V20071=="Attempted";
		gen sample_prostitutionpromot_att = V20061=="Assisting or Promoting Prostitution" & V20071=="Attempted";
		gen sample_robbery_att = V20061=="Robbery" & V20071=="Attempted";
		gen sample_rape_att = V20061=="Forcible Rape" & V20071=="Attempted";
		gen sample_sodomy_att = V20061=="Forcible Sodomy" & V20071=="Attempted";
		gen sample_sexassaultobj_att = V20061=="Sexual Assault With An Object" & V20071=="Attempted";
		gen sample_forcfondling_att = V20061=="Forcible Fondling (Indecent Liberties/Child Molesting)" & V20071=="Attempted";
		gen sample_incest_att = V20061=="Incest" & V20071=="Attempted";
		gen sample_statrape_att = V20061=="Statutory Rape" & V20071=="Attempted";
		gen sample_stolprop_att = V20061=="Stolen Property Offenses (Receiving, Selling, Etc.)" & V20071=="Attempted";
		gen sample_weapon_att = V20061=="Weapon Law Violations" & V20071=="Attempted";
	
		
		tostring INCDATE, gen(offdate_str)
		gen offdate = date(offdate_str, "YMD")
		rename STATE state;
		rename ORI ori;
		rename INCNUM incident ;
		rename V20111 location;
		rename V20171 weapon;
		rename RECSBH1 numrecords; //records per ori number
		
		
		forvalues i = 1/25{;
		gen location`i' = location==`i';
		};
		
		** Generate data set of just offense and date;
		preserve;
		keep ori incident offdate;
		save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_`year'.dta, replace;
		restore;
		
		collapse  (max) state (sum) sample*, by(ori incident offdate) fast;
			
		** Add in hourly data;
		sort ori incident;
		merge 1:1 ori incident using `fileloc'/data/nibrs/nibrs`year'_4_dst;
		keep if _merge == 3;
		drop _merge;
			
		collapse (max) state (sum) sample*, by(ori offdate hour) fast;
		
		joinby ori using `fileloc'/data/nibrs/nibrs`year'_1_dst;
		joinby ori using `fileloc'/data/nibrs/nibrs`year'_2_dst;
		
		foreach i in  aggassault murder  robbery  rape {;
			gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4);
			gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4);
		};
		
		gen year = year(offdate)
		tab year;

		** Drop crimes that indicate occurrence in prior year;
		keep if year == `year'
			
		gen population = pop1 + pop2 + pop3 + pop4
		
		** Remove jurisdictions with 0 or missing population data;
		drop if population == 0 | population == .
		
		qui compress

		save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst`year', replace
			
	}



/* 

COMMENTS

Coding Population Group variable:

0 = Possessions
1 = All cities >= 250,000
1A = Citiies >= 1,000,000
1B = Cities 500,000-999,999
1C = Cities 250,000-499,999
2 = Cities 100,000-249,999
3 = Cities 50,000-99,999
4 = Cities 25,000-49,999
5 = Cities 10,000-24,999
6 = Cities 2,500-9,999
7 = Cities < 2,500
8 = Non-MSA Counties
8A = Non-MSA Counties >= 100,000
8B = Non-MSA Counties 25,000-99,999
8C = Non-MSA Counties 10,000-24,999
8D = Non-MSA Counties < 10,000
8E = Non-MSA State Police
9 = MSA Counties
9A = MSA Counties >= 100,000
9B = MSA Counties 25,000-99,999
9C = MSA Counties 10,000-24,999
9D = MSA Counties < 10,000
9E = MSA State Police

 Coding Incident Hour:

Military time: 
0 = 12-12:59am
1 = 1-1:59am
. . . 
17 = 5-5:59pm
18 = 6-6:59pm
19 = 7-7:59pm
20 = 8-8:59pm
. . . 
23 = 11-11:59pm

blank = unknown time -- set this to = 99 instead


Other notes:

arrestees = number of arrestees within one year
created variable "arrest" = at least one arrest
clear_excep = "exceptional clearance" -- offender died, victim refused to cooperate, other non-arrest circumstances
created variable "solved" = arrest made or exceptionally cleared
this indicates whether the crime was "solved" in one way or another

collapsed dataset currently tallies # of crimes per hour and # of arrests & solved crimes per hour

Upload code & data.

Drop IN (changed DST boundaries) and AZ (no DST).
Whether arrest was made.
Hours of daylight -- by state.  Time of sunset. 

DST: 

1st Sun in April	last Sun in Oct
2001: April 1 = 15066	Oct 28 = 15276
2002: April 7 = 15437	Oct 27 = 15640
2003: April 6 = 15801	Oct 26 = 16004
2004: April 4 = 16165	Oct 31 = 16375
2005: April 3 = 16529	Oct 30 = 16739
2006: April 2 = 16893	Oct 29 = 17103

2nd Sun in March	1st Sun in Nov
2007: Mar 11 =  17236	Nov 4 = 17474
2008: Mar 9 = 17600	Nov 2 = 17838



2nd Sunday in March:		1st Sunday in April
2001: Mar 11 = 15045		Apr 1 = 15066
2002: Mar 10 = 15409		Apr 7 = 15437
2003: Mar 9 = 15773		Apr 6 = 15801
2004: Mar 14 = 16144		Apr 4 = 16165
2005: Mar 13 = 16508		Apr 3 = 16529
2006: Mar 12 = 16872		Apr 2 = 16893
2007: Mar 11 =  17236		Apr 1 = 17257
2008: Mar 9 = 17600		Apr 6 = 17628

last Sunday in Oct:		1st Sunday in Nov
2001: Oct 28 = 15276		Nov 4 = 15283
2002: Oct 27 = 15640		Nov 3 = 15647	
2003: Oct 26 = 16004		Nov 2 = 16011	
2004: Oct 31 = 16375		Nov 7 = 16382
2005: Oct 30 = 16739		Nov 6 = 16746	
2006: Oct 29 = 17103		Nov 5 = 17110	
2007: Oct 28 = 17467		Nov 4 = 17474
2008: Oct 26 = 17831		Nov 2 = 17838

*/;




**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ANALYSIS  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

if `rebuild' == 1 {;

	use `fileloc'/data/nibrs/dst2005, clear;
	append using `fileloc'/data/nibrs/dst2006;
	append using `fileloc'/data/nibrs/dst2007;
	append using `fileloc'/data/nibrs/dst2008;

	gen state_ar = state==3;
	gen state_az = state==2;
	gen state_ca = state==4;
	gen state_co = state==5;
	gen state_ct = state==6;
	gen state_de = state==7;
	gen state_dc = state==8;
	gen state_fl = state==9;
	gen state_ga = state==10;
	gen state_hi = state==51;
	gen state_ia = state==14;
	gen state_id = state==11;
	gen state_il = state==12;
	gen state_in = state==13;
	gen state_ks = state==15;
	gen state_ky = state==16;
	gen state_la = state==17;
	gen state_ma = state==20;
	gen state_md = state==19;
	gen state_me = state==18;
	gen state_mi = state==21;
	gen state_mn = state==22;
	gen state_mo = state==24;
	gen state_ms = state==23;
	gen state_mt = state==25;
	gen state_ne = state==26;
	gen state_nc = state==32;
	gen state_nd = state==33;
	gen state_nh = state==28;
	gen state_nj = state==29;
	gen state_nm = state==30;
	gen state_nv = state==27;
	gen state_ny = state==31;
	gen state_pa = state==37;
	gen state_oh = state==34;
	gen state_ok = state==35;
	gen state_or = state==36;
	gen state_ri = state==38;
	gen state_sc = state==39;
	gen state_sd = state==40;
	gen state_tn = state==41;
	gen state_tx = state==42;
	gen state_ut = state==43;
	gen state_va = state==45;
	gen state_vt = state==44;
	gen state_wa = state==46;
	gen state_wi = state==48;
	gen state_wv = state==47;
	gen state_wy = state==49;
	
	gen mergestate = "";
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {;
		qui replace mergestate = "`state'" if state_`state' == 1;
	};

	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*;
	qui compress;

	save `fileloc'/data/allyears.dta, replace;

	use `fileloc'/data/allyears.dta, clear;
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {;
		cap drop rate_`var'*;
	};

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1;
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100";
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;
		gen `crime'_combined = `crime'_att + `crime';
		gen any_`crime' = `crime' > 0 & `crime' ~= .;
		gen `cr