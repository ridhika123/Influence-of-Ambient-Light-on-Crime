**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2007
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2007.dta", clear
rename ORI ori
rename B2005 pop1
rename B2009 pop2
rename B2013 pop3
rename B2017 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2007.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH1 numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2007.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2007_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2007
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2007, replace

	
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2008
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2008.dta", clear
rename ORI ori
rename B2005 pop1
rename B2009 pop2
rename B2013 pop3
rename B2017 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2008.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH1 numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2008.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2008_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2008
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2008, replace


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2009
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2009.dta", clear
rename ORI ori
rename B2005 pop1
rename B2009 pop2
rename B2013 pop3
rename B2017 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2009.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH1 numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2009.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2009_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2009
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2009, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2010
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2010.dta", clear
rename ORI ori
rename B2005 pop1
rename B2009 pop2
rename B2013 pop3
rename B2017 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2010.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH1 numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2010.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2010_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2010
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2010, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2011
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2011.dta", clear
rename ORI ori
rename B2005 pop1
rename B2009 pop2
rename B2013 pop3
rename B2017 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2011.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH1 numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2011.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2011_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2011
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2011, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2012
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2012.dta", clear
rename ORI ori
rename B2005 pop1
rename B2009 pop2
rename B2013 pop3
rename B2017 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2012.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH1 numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2012.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2012_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2012
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2012, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2013
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2013.dta", clear
rename ORI ori
rename BH019 pop1
rename BH023 pop2
rename BH027 pop3
rename BH031 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2013.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2013.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2013_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2013
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2013, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2014
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2014.dta", clear
rename ORI ori
rename BH019 pop1
rename BH023 pop2
rename BH027 pop3
rename BH031 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2014.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2014.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2014_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2014
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2014, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2015
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2056.dta", clear
rename ORI ori
rename BH019 pop1
rename BH023 pop2
rename BH027 pop3
rename BH031 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2015.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2015.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2015_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2015
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2015, replace

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2016
* 2
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2016.dta", clear
rename ORI ori
rename BH019 pop1
rename BH023 pop2
rename BH027 pop3
rename BH031 pop4
collapse (mean) pop1 pop2 pop3 pop4, by(ori)
sort ori
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016_2_dst, replace
clear
	
* 5
use "C:\Users\agrawalr\OneDrive - Grinnell College\nibrs2016.dta"
gen sample_aggassault = V20061==131 & V20071==1
gen sample_simpleassault = V20061==132 & V20071==1
gen sample_intimidation = V20061==133 & V20071==1
gen sample_bribery = V20061==510 & V20071==1
gen sample_burglary = V20061==220 & V20071==1
gen sample_forgery = V20061==250 & V20071==1
gen sample_damageprop = V20061==290 & V20071==1
gen sample_drug = V20061==351 & V20071==1
gen sample_drugequip = V20061==352 & V20071==1
gen sample_embezzlement = V20061==270 & V20071==1
gen sample_extortion = V20061==210 & V20071==1
gen sample_swindle = V20061==261 & V20071==1
gen sample_creditfraud = V20061==262 & V20071==1
gen sample_impersonation = V20061==263 & V20071==1
gen sample_welfarefraud = V20061==264 & V20071==1
gen sample_wirefraud = V20061==265 & V20071==1
gen sample_gambling = V20061==391 & V20071==1
gen sample_gamblingpromot = V20061==392 & V20071==1
gen sample_gamblingequip = V20061==14 & V20071==1
gen sample_murder = V20061==91 & V20071==1
gen sample_negmanslaughter = V20061 == 91 & V20071==1
gen sample_justifiablehomicide = V20061==93 & V20071==1
gen sample_kidnapping = V20061==100 & V20071==1
gen sample_pickpocket = V20061==231 & V20071==1
gen sample_pursesnatch = V20061==232 & V20071==1
gen sample_shoplifting = V20061 == 233 & V20071==1
gen sample_theftbldg = V20061 == 234 & V20071==1
gen sample_theftcoinopmach = V20061== 235 & V20071==1
gen sample_theftmotorveh = V20061 == 236 & V20071==1
gen sample_theftparts = V20061 == 237 & V20071==1
gen sample_theftoth = V20061 == 238 & V20071==1
gen sample_vtheft = V20061==240 & V20071==1
gen sample_obscenemat = V20061==370 & V20071==1
gen sample_prostitution = V20061==401 & V20071==1
gen sample_prostitutionpromot = V20061==402 & V20071==1
gen sample_robbery = V20061==120 & V20071==1
gen sample_rape = V20061==111 & V20071==1
gen sample_sodomy = V20061==112 & V20071==1
gen sample_sexassaultobj = V20061==113 & V20071==1
gen sample_forcfondling = V20061==114 & V20071==1
gen sample_incest = V20061==361 & V20071==1
gen sample_statrape = V20061==362 & V20071==1
gen sample_stolprop = V20061==280 & V20071==1
gen sample_weapon = V20061==520 & V20071==1
	

gen sample_aggassault_att = V20061==131 & V20071==0
gen sample_simpleassault_att = V20061==132 & V20071==0
gen sample_intimidation_att = V20061==133 & V20071==0
gen sample_bribery_att = V20061==510 & V20071==0
gen sample_burglary_att = V20061==220 & V20071==0
gen sample_forgery_att = V20061==250 & V20071==0
gen sample_damageprop_att = V20061==290 & V20071==0
gen sample_drug_att = V20061==351 & V20071==0
gen sample_drugequip_att = V20061==352 & V20071==0
gen sample_embezzlement_att = V20061==270 & V20071==0
gen sample_extortion_att = V20061==210 & V20071==0
gen sample_swindle_att = V20061==261 & V20071==0
gen sample_creditfraud_att = V20061==262 & V20071==0
gen sample_impersonation_att = V20061==263 & V20071==0
gen sample_welfarefraud_att = V20061==264 & V20071==0
gen sample_wirefraud_att = V20061==265 & V20071==0
gen sample_gambling_att = V20061==391 & V20071==0
gen sample_gamblingpromot_att = V20061==392 & V20071==0
gen sample_gamblingequip_att = V20061==14 & V20071==0
gen sample_murder_att = V20061==91 & V20071==0
gen sample_negmanslaughter_att = V20061 == 91 & V20071==0
gen sample_justifiablehomicide_att = V20061==93 & V20071==0
gen sample_kidnapping_att = V20061==100 & V20071==0
gen sample_pickpocket_att = V20061==231 & V20071==0
gen sample_pursesnatch_att = V20061==232 & V20071==0
gen sample_shoplifting_att = V20061 == 233 & V20071==0
gen sample_theftbldg_att = V20061 == 234 & V20071==0
gen sample_theftcoinopmach_att = V20061== 235 & V20071==0
gen sample_theftmotorve_atth = V20061 == 236 & V20071==0
gen sample_theftparts_att = V20061 == 237 & V20071==0
gen sample_theftoth_att = V20061 == 238 & V20071==0
gen sample_vtheft_att = V20061==240 & V20071==0
gen sample_obscenemat_att = V20061==370 & V20071==0
gen sample_prostitution_att = V20061==401 & V20071==0
gen sample_prostitutionpromot_att = V20061==402 & V20071==0
gen sample_robbery_att = V20061==120 & V20071==0
gen sample_rape_att = V20061==111 & V20071==0
gen sample_sodomy_att = V20061==112 & V20071==0
gen sample_sexassaultobj_att = V20061==113 & V20071==0
gen sample_forcfondling_att = V20061==114 & V20071==0
gen sample_incest_att = V20061==361 & V20071==0
gen sample_statrape_att = V20061==362 & V20071==0
gen sample_stolprop_att = V20061==280 & V20071==0
gen sample_weapon_att = V20061==520 & V20071==0

tostring INCDATE, gen(offdate_str)
gen offdate = date(offdate_str, "YMD")
rename STATE state
rename ORI ori
rename INCNUM incident 
rename V20111 location
rename V20171 weapon
rename RECSBH numrecords //records per ori number
		
		
forvalues i = 1/25{
	gen location`i' = location==`i'
}
		
** Generate data set of just offense and date
preserve
keep ori incident offdate
save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\just_dates_2016.dta, replace
restore
		
collapse (max) state (sum) sample*, by(ori incident offdate) fast
		
** Add in hourly data
sort ori incident
merge 1:1 ori incident using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016_4_dst"
keep if _merge == 3
drop _merge

collapse (max) state (sum) sample*, by(ori offdate hour) fast

joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016_1_dst"
joinby ori using "C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\nibrs2016_2_dst"
		
foreach i in  aggassault murder  robbery  rape {
	gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4)
	gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4)
}
		
gen year = year(offdate)
tab year

** Drop crimes that indicate occurrence in prior year
keep if year == 2016
		
gen population = pop1 + pop2 + pop3 + pop4

** Remove jurisdictions with 0 or missing population data
drop if population == 0 | population == .
		
qui compress

save C:\Users\agrawalr\Desktop\Doleac_Sanders\My_data\dst2016, replace