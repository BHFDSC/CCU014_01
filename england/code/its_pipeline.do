*****************************************************************************************
*** Script to run ITS analysis by CVD sub-group from weekly counts generated from SQL ***
*****************************************************************************************

clear
cd "N:\Time_series\analysis"

global cvd_groups "insulin anticoagulant_DOAC anticoagulant_warfarins antiplatelets_secondary type_2_diabetes lipid_lowering antihypertensives heart_failure"


*** Load counts by weeks and prep data for each CVD sub-group ***

foreach c in $cvd_groups {

clear
import delimited "N:\Time_series\analysis\prescribed_key_groups_year_month_weeks_by_group.csv"

drop if year<2018 | year>2021
keep if key_group=="`c'"

sort year month weekofyear
rename weekofyear week

* Fix 2018-2019 year end
recode month 12=1 if year==2018 & month==12 & week==1
recode year 2018=2019 if year==2018 & month==1 & week==1

* Fix 2019-2020 year end
recode year 2019=8888 if year==2019 & month==12 & week==1
recode month 12=1 if year==8888 & month==12 & week==1
recode year 8888=2020 if year==8888 & month==1 & week==1

* Fix 2020-2021 year end
recode month 1=12 if year==2021 & month==1 & week==53
recode year 2021=2020 if year==2021 & month==12 & week==53

* Merge partial weeks
sort year month week
destring count, replace force
collapse (sum) count, by(year week)
sort year week

* Create consecutive week counter
gen new_weeks=week[_n]

save prescribed_weeks_its_`c'.dta, replace	
	
}


*** Running cubic ITS model, saving results (parmest) & plotting graphs ***

foreach c in $cvd_groups {

clear
cd "N:\Time_series\analysis"
use prescribed_weeks_its_`c'.dta

replace new_weeks=week+52 if year==2019
replace new_weeks=week+104 if year==2020
replace new_weeks=week+157 if year==2021

drop if new_weeks>=179
drop if new_weeks<=20

scatter count new_weeks
reg count new_weeks

gen before_christmas1=0
replace before_christmas1=1 if new_weeks==50 | new_weeks==51

gen before_christmas2=0
replace before_christmas2=1 if new_weeks==102 | new_weeks==103

gen before_christmas3=0
replace before_christmas3=1 if new_weeks==154 | new_weeks==155

gen christmas_new_year1=0
replace christmas_new_year1=1 if new_weeks==52

gen christmas_new_year2=0
replace christmas_new_year2=1 if new_weeks==104 | new_weeks==105

gen christmas_new_year3=0
replace christmas_new_year3=1 if new_weeks==156 | new_weeks==157

gen before_lockdown1=0
replace before_lockdown1=1 if new_weeks==114 | new_weeks==115 | new_weeks==116 | new_weeks==117

gen before_lockdown2=0
replace before_lockdown2=1 if new_weeks==145 | new_weeks==146 | new_weeks==147 | new_weeks==148

gen before_lockdown3=0
replace before_lockdown3=1 if new_weeks==158

* linear
reg count new_weeks before_christmas1 before_christmas2 before_christmas3 christmas_new_year1 christmas_new_year2 christmas_new_year3 before_lockdown1 before_lockdown2 before_lockdown3

* quadratic
reg count c.new_weeks#c.new_weeks new_weeks before_christmas1 before_christmas2 before_christmas3 christmas_new_year1 christmas_new_year2 christmas_new_year3 before_lockdown1 before_lockdown2 before_lockdown3

* cubic
reg count c.new_weeks#c.new_weeks#c.new_weeks c.new_weeks#c.new_weeks new_weeks before_christmas1 christmas_new_year1 before_christmas2 christmas_new_year2 before_lockdown1 before_lockdown2 before_christmas3 christmas_new_year3 before_lockdown3

scalar effect=_b[before_lockdown1]
sum count
scalar mean_week_count=r(mean)
scalar effect_percent= round(100 * effect/mean_week_count)
predict predicted_counts, xb

*  graph
twoway (scatter count new_weeks, msymbol(X) msize(small)) (line predicted_counts new_weeks), title("`c'", size(medsmall)) graphregion(fcolor(white)) xlabel(0(10)200, labsize(vsmall)) ylabel(, labsize(tiny)) xtitle("week") legend(size(small)) legend(label(2 "prediction"))
graph save "N:\Time_series\plots\its_`c'.gph", replace
graph export "N:\Time_series\plots\its_`c'.png", as(png) replace

* saving regression output
cd "N:\Time_series\results"
parmest, saving(its_`c'_cubic, replace)

clear
use its_`c'_cubic.dta
gen cvd="`c'"
save its_`c'_cubic, replace

}


*** Combine individual CVD sub-group plots into two groups of 4
clear
cd "N:\Time_series\plots"
graph combine its_antihypertensives.gph its_lipid_lowering.gph its_insulin.gph its_type_2_diabetes.gph, graphregion(fcolor(white))
graph save its_cvd4_1, replace
graph export "N:\Time_series\plots\its_cvd4_1.png", as(png) replace

graph combine its_anticoagulant_DOAC.gph its_anticoagulant_warfarins.gph its_antiplatelets_secondary.gph its_heart_failure.gph, graphregion(fcolor(white)) 
graph save its_cvd4_2, replace
graph export "N:\Time_series\plots\its_cvd4_2.png", as(png) replace


*** Append all post-regression parmest output files together ahead of meta-analysis
clear
cd "N:\Time_series\results"
use its_insulin_cubic
save its_cvd_cubic.dta, replace

foreach c in $cvd_groups {

clear
use its_cvd_cubic.dta
append using its_`c'_cubic.dta

save its_cvd_cubic.dta, replace
}


*** Metan to generate forest plots

* relabel cvds for plotting
replace cvd="DOACs" if cvd=="anticoagulant_DOAC"
replace cvd="Warfarins" if cvd=="anticoagulant_warfarins"
replace cvd="Antihypertensives" if cvd=="antihypertensives"
replace cvd="Antiplatelets" if cvd=="antiplatelets_secondary"
replace cvd="HF" if cvd=="heart_failure"
replace cvd="Insulin" if cvd=="insulin"
replace cvd="Lipid_lowering" if cvd=="lipid_lowering"
replace cvd="T2DM" if cvd=="type_2_diabetes"
save its_cvd_cubic_labelled.dta, replace


global cvd_groups "Insulin DOACs Warfarins Antiplatelets T2DM Lipid_lowering Antihypertensives HF"

foreach c in $cvd_groups {

clear
use its_cvd_cubic_labelled.dta, replace

keep if cvd=="`c'"

drop if parm=="c.new_weeks#c.new_weeks#c.new_weeks" | parm=="c.new_weeks#c.new_weeks" |  parm=="new_weeks" | parm=="_cons"

gen Period="."
replace Period = "Before Christmas 2018" if _n==1
replace Period = "Christmas & NY 2018-19" if _n==2
replace Period = "Before Christmas 2019" if _n==3
replace Period = "Christmas & NY 2019-20" if _n==4
replace Period = "Before lockdown 1" if _n==5
replace Period = "Before lockdown 2" if _n==6
replace Period = "Before Christmas 2020" if _n==7
replace Period = "Christmas & NY 2020-21" if _n==8
replace Period = "Before lockdown 3" if _n==9

metan estimate stderr, nooverall nobox nowt effect(beta) graphregion(color(white)) textsize(140) dp(0) title("`c'", size(small)) xlabel(-2000000,-1000000,0,1000000,2000000) lcols(Period)

graph save "N:\Time_series\plots\forest_`c'.gph", replace
graph export "N:\Time_series\plots\forest_`c'.png", width(3200) height(2400) replace

}

*** Combine individual forest plots into two groups of 4
cd "N:\Time_series\plots"

graph combine forest_Antihypertensives.gph forest_Lipid_lowering.gph forest_T2DM.gph forest_Insulin.gph, graphregion(color(white))
graph save "N:\Time_series\plots\forest_hyp_lipid_diabetes.gph", replace
graph export "N:\Time_series\plots\forest_hyp_lipid_diabetes.png", width(3200) height(2400) replace

graph combine forest_DOACs.gph forest_Warfarins.gph forest_Antiplatelets.gph forest_HF.gph, graphregion(color(white))
graph save "N:\Time_series\plots\forest_anticoags_HF.gph", replace
graph export "N:\Time_series\plots\forest_anticoags_HF.png", width(3200) height(2400) replace







