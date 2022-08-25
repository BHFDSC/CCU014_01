*****************************************************************************
*** ITS ARIMA models for supplementary; saving results & plotting graphs  ***
*****************************************************************************

ssc install arimaauto

clear
cd "N:\Time_series\analysis"


***********************************************
*** Data prep ***

global cvd_groups "antihypertensives lipid_lowering type_2_diabetes insulin anticoagulant_DOAC heart_failure antiplatelets_secondary anticoagulant_warfarins"

foreach c in $cvd_groups {

clear
use "N:\Time_series\Update_May22\prescribed_key_groups_year_month_weeks_by_group"

drop if year<2018 | year>2022

keep if key_group=="`c'"

sort year month weekofyear
rename weekofyear week

* Fix 2018-2019
recode month 12=1 if year==2018 & month==12 & week==1
recode year 2018=2019 if year==2018 & month==1 & week==1

* Fix 2019-2020
recode year 2019=8888 if year==2019 & month==12 & week==1
recode month 12=1 if year==8888 & month==12 & week==1
recode year 8888=2020 if year==8888 & month==1 & week==1

* Fix 2020-2021
recode month 1=12 if year==2021 & month==1 & week==53
recode year 2021=2020 if year==2021 & month==12 & week==53

* Fix 2021-2022
recode month 1=12 if year==2022 & month==1 & week==52
recode year 2022=2021 if year==2022 & month==12 & week==52
drop if year>2021

* Merge partial weeks
sort year month week
destring count, replace force
collapse (sum) count, by(year week)
sort year week

* Create consecutive week counter
gen new_weeks=week[_n]

save gdppr_box_cvd_weeks_its_`c'.dta, replace	
	
}


*************************************************
*** ARIMA analysis & graphs ***

foreach c in $cvd_groups {

clear

cd "N:\Time_series\analysis"
use gdppr_box_cvd_weeks_its_`c'.dta

replace new_weeks=week+52 if year==2019
replace new_weeks=week+104 if year==2020
replace new_weeks=week+157 if year==2021

* End date May 2021 
drop if new_weeks>=179
drop if new_weeks<=20

* Generate dummy variables
gen before_lockdown1=0
replace before_lockdown1=1 if new_weeks==114 | new_weeks==115 | new_weeks==116 | new_weeks==117
gen before_lockdown2=0
replace before_lockdown2=1 if new_weeks==145 | new_weeks==146 | new_weeks==147 | new_weeks==148
gen before_lockdown3=0
replace before_lockdown3=1 if new_weeks==158
gen before_christmas=0
replace before_christmas=1 if new_weeks==50 | new_weeks==51 | new_weeks==102 | new_weeks==103 | new_weeks==154 | new_weeks==155
gen christmas_new_year=0
replace christmas_new_year=1 if new_weeks==52 | new_weeks==104 | new_weeks==105 | new_weeks==156 | new_weeks==157


* Fit arima model - as requested by reviewer #5 - specifying models selected by R auto.arima 
tsset new_weeks, weekly

* all except warfarins
arima count new_weeks before_christmas christmas_new_year before_lockdown1 before_lockdown2 before_lockdown3, arima(0,1,3)
* warfarins only
*arima count new_weeks before_christmas christmas_new_year before_lockdown1 before_lockdown2 before_lockdown3, arima(2,1,1)
predict predicted_counts_y, y


* Graphs
* label weeks for graphs
label define new_weeks 0 "1Jan18" 10 "12Mar18" 20 "21May18" 30 "23Jul18" 40 "1Oct18" 50 "10Dec18" 60 "18Feb19" 70 "29Apr19" 80 "8Jul19" 90 "16Sep19" 100 "25Nov19" 110 "3Feb20" 120 "13Apr20" 130 "22Jun20" 140 "31Aug20" 150 "9Nov20" 160 "18Jan21" 170 "29Mar21" 180 "7Jun21" 190 "16Aug21" 200 "25Oct21" 210 "3Jan22" 
label values new_weeks new_weeks

* plot ITS
twoway (scatter count new_weeks, msymbol(X) msize(small)) (line predicted_counts_y new_weeks), title("`c'", size(small)) graphregion(fcolor(white)) xlabel(0(10)180, valuelabel angle(vertical) labsize(vsmall)) ylabel(, nogrid angle(horizontal) labsize(vsmall)) legend(off)  xtitle("week", size(small)) ytitle("count", size(small)) xline(117 149 158, lpattern(dash) lcolor(black))
graph save "N:\Time_series\plots\lag_its_`c'_ma3.gph", replace
graph export "N:\Time_series\plots\lag_its_`c'_ma3.png", as(png) replace

* saving regression output for supp table
cd "N:\Time_series\results"
parmest, saving(lag_its_`c'_ma3, replace)

clear
use lag_its_`c'_ma3.dta
gen cvd="`c'"
save lag_its_`c'_ma3, replace

*/

}

***************************************************
*** Combining graphs for supplementary material ***

cd "N:\Time_series\plots"    

graph combine lag_its_antihypertensives_ma3.gph lag_its_lipid_lowering_ma3.gph lag_its_type_2_diabetes_ma3.gph lag_its_insulin_ma3.gph, graphregion(fcolor(white))
graph save "N:\Time_series\plots\its_supp1.gph", replace
graph export "N:\Time_series\plots\its_supp1.png", as(png) replace

graph combine lag_its_anticoagulant_DOAC_ma3.gph  lag_its_anticoagulant_warfarins_ar2.gph lag_its_antiplatelets_secondary_ma3.gph lag_its_heart_failure_ma3.gph, graphregion(fcolor(white))
graph save "N:\Time_series\plots\its_supp2.gph", replace
graph export "N:\Time_series\plots\its_supp2.png", as(png) replace

