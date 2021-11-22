** merging with urban and rural ** 

use "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\maindata2008.dta"
sort ori fips
merge ori fips using C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\fips_ori_pop.dta
tab _merge
keep if _merge == 3
drop _merge