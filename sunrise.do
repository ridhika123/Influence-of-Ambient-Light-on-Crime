clear all
set more off
set matsize 10000
set maxvar 20000
set logtype text
global graph_options "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"
global esttab_opts "b(%9.3f) se sfmt(%9.3f) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps staraux r2"


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2007

local dst2007 = td(11Mar2007)	
local laterdst2007 = td(04Nov2007)
	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2007.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2007' - 1 if year == 2007
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2007fake' - 1 if year == 2007

	gen daybefore_end = .
	replace daybefore_end = `laterdst2007' - 1 if year == 2007
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2007.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2008
local dst2008 = td(09Mar2008)
local laterdst2008 = td(02Nov2008)
	
	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2008.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2008' - 1 if year == 2008
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2008fake' - 1 if year == 2008

	gen daybefore_end = .
	replace daybefore_end = `laterdst2008' - 1 if year == 2008
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2008.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2009

local dst2009 = td(08Mar2009)
local laterdst2009 = td(01Nov2009)	
	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2009.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2009' - 1 if year == 2009
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2009fake' - 1 if year == 2009

	gen daybefore_end = .
	replace daybefore_end = `laterdst2009' - 1 if year == 2009
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2009.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2010

local dst2010 = td(14Mar2010)
local laterdst2010 = td(07Nov2010)	
	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2010.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2010' - 1 if year == 2010
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2010fake' - 1 if year == 2010

	gen daybefore_end = .
	replace daybefore_end = `laterdst2010' - 1 if year == 2010
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
		
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2010.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2011	
	
local dst2011 = td(13Mar2011)
local laterdst2011 = td(06Nov2011)

	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2011.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2011' - 1 if year == 2011
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2011fake' - 1 if year == 2011

	gen daybefore_end = .
	replace daybefore_end = `laterdst2011' - 1 if year == 2011
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2011.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2012	
	
local dst2012 = td(11Mar2012)
local laterdst2012 = td(04Nov2012)

import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2012.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2012' - 1 if year == 2012
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2012fake' - 1 if year == 2012

	gen daybefore_end = .
	replace daybefore_end = `laterdst2012' - 1 if year == 2012
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2012.dta, replace
	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2013	

local dst2013 = td(10Mar2013)
local laterdst2013 = td(03Nov2013)

	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2013.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2013' - 1 if year == 2013
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2013fake' - 1 if year == 2013

	gen daybefore_end = .
	replace daybefore_end = `laterdst2013' - 1 if year == 2013
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2013.dta, replace

	**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2014	
	
local dst2014 = td(9Mar2014)
local laterdst2014 = td(02Nov2014)
	
	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2014.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2014' - 1 if year == 2014
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2014fake' - 1 if year == 2014

	gen daybefore_end = .
	replace daybefore_end = `laterdst2014' - 1 if year == 2014
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2014.dta, replace
	
	**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2015	
	
local dst2015 = td(8Mar2015)
local laterdst2015 = td(01Nov2015)

	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2015.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2015' - 1 if year == 2015
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2015fake' - 1 if year == 2015

	gen daybefore_end = .
	replace daybefore_end = `laterdst2015' - 1 if year == 2015
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2015.dta, replace
	
	**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2016	
	
local dst2016 = td(13Mar2016)
local laterdst2016 = td(06Nov2016)

	import delimited "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\latlong_sunrise_2016.csv", clear
	sort latitude longitude
		
	tempfile latlong
	save `latlong'
	use C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\ori_lat_long_new.dta, clear

	sort latitude longitude
	joinby latitude longitude using `latlong'
	
	gen state = substr(ori,1,2)
	** Drop Alaska and Indiana
	drop if state == "AK"
	gen stata_date = mdy(month,day,year)
	gen stata_sunset = clock(sunset,"hms")
	gen stata_sunrise = clock(sunrise,"hms")
	format stata_sunset %tc
	format stata_sunrise %tc
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset)
	gen sunset_min = mmC(stata_sunset)
	gen sunrise_hour = hhC(stata_sunrise)
	gen sunrise_min = mmC(stata_sunrise)
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E"
	replace sunrise_hour = sunrise_hour + 1 if zone == "E"
	replace sunset_hour = sunset_hour - 1 if zone == "M"
	replace sunrise_hour = sunrise_hour - 1 if zone == "M"
	replace sunset_hour = sunset_hour - 2 if zone == "P"
	replace sunrise_hour = sunrise_hour - 2 if zone == "P"
	
	rename stata_date offdate
	replace state = lower(state)
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .
	replace daybefore = `dst2016' - 1 if year == 2016
	
	gen daybefore_fake = .
	replace daybefore_fake = `dst2016fake' - 1 if year == 2016

	gen daybefore_end = .
	replace daybefore_end = `laterdst2016' - 1 if year == 2016
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end
	gen fake_dst = offdate > daybefore_fake

	gen clock_sunset_hour = sunset_hour
	gen clock_sunset_min = sunset_min
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore
		egen tempdst = max(dst_sunset_hour), by(ori year)
		replace dst_sunset_hour = tempdst
		drop tempdst

		gen dst_sunset_min = sunset_min if offdate == daybefore
		egen tempdst = max(dst_sunset_min), by(ori year)
		replace dst_sunset_min = tempdst
		drop tempdst

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_hour), by(ori year)
		replace dstend_sunset_hour = tempdst
		drop tempdst

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end
		egen tempdst = max(dstend_sunset_min), by(ori year)
		replace dstend_sunset_min = tempdst
		drop tempdst

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_hour), by(ori year)
		replace fakedst_sunset_hour = tempdst
		drop tempdst
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake
		egen tempdst = max(fakedst_sunset_min), by(ori year)
		replace fakedst_sunset_min = tempdst
		drop tempdst	
	
		compress
		
	save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\sunset2016.dta, replace
	