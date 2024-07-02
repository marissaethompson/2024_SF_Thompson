********************************************************************************
* Do File B - Figures 2-3
********************************************************************************

********************************************************************************
* Load Data
********************************************************************************

use "${data}/thompson_seg_choice_analysis_github.dta", clear


********************************************************************************
* All Pairwise Heatmaps 
********************************************************************************

heatplot choice_clean growth_sch ses_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/ses.gph, replace

heatplot choice_clean growth_sch black_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/black.gph, replace

heatplot choice_clean ach_sch ses_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/achses.gph, replace

heatplot choice_clean ach_sch black_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/achblack.gph, replace


graph combine ${output}/temp/ses.gph ${output}/temp/black.gph ${output}/temp/achses.gph ${output}/temp/achblack.gph, rows(2)  graphregion(color(white)) scheme(s2mono)
graph export "figure_2_$date.png", replace


heatplot choice_clean equity_sch ses_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/equity1.gph, replace

heatplot choice_clean equity_sch black_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/equity2.gph, replace

heatplot choice_clean equity_sch hisp_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/equity3.gph, replace

heatplot choice_clean equity_sch asian_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/equity4.gph, replace


graph combine ${output}/temp/equity1.gph ${output}/temp/equity2.gph  ${output}/temp/equity4.gph ${output}/temp/equity3.gph, rows(2)  graphregion(color(white)) scheme(s2mono)
graph export "figure_3_$date.png", replace


**** Appendix Heat Maps 

heatplot choice_clean growth_sch white_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/white.gph, replace

heatplot choice_clean ach_sch white_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/white1.gph, replace

heatplot choice_clean growth_sch hisp_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/hisp.gph, replace

heatplot choice_clean ach_sch hisp_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/hisp1.gph, replace

heatplot choice_clean growth_sch asian_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/asn.gph, replace

heatplot choice_clean ach_sch asian_num_sch, bins(10) cuts(0(0.1)1) graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) legend(subtitle("") symysize(5)) color(inferno)
graph save ${output}/temp/asn1.gph, replace


***********************************
* Compare to SEDA distribution 
* 		note that SEDA 4.1 is publicly available at edopportunity.org
***********************************

use "${data}/thompson_seg_choice_analysis_github.dta", clear
gen perblk = black_num_sch/100 
gen perasn = asian_num_sch/100 
gen perhsp = hisp_num_sch/100 
gen perfrl= ses_num_sch/100 

** school covariates, minimum and maximum 
use "${data}/seda_cov_school_pool_4.1.dta", clear 

keep perwht perblk perhsp perasn perfrl sedasch totenrl level

tempfile schoolcov 
save `schoolcov' 

** school achievement and growth rates 

use "${data}/seda_school_pool_gcs_4.1.dta", clear 

keep gcs_mn_avg_ol gcs_mn_grd_ol sedasch gradecenter

merge 1:1 sedasch using `schoolcov'

** generate approximately comparable measures 

su gcs_mn_avg_ol
by gradecenter, sort: egen mean_ach = mean(gcs_mn_avg_ol) // within gradecenter average  
gen ach_sch = gcs_mn_avg_ol-mean_ach // subtract the within-gradecenter average (centered on 0)

su gcs_mn_grd_ol
gen growth_sch = ((gcs_mn_grd_ol-r(mean))/r(mean))*100 

keep growth_sch ach_sch perfrl perblk perhsp perasn sedasch totenrl perwht

label var ach_sch "Achievement"
label var growth_sch "Learning Rate"
label var perblk "% Black"
label var perhsp "% Hispanic"
label var perfrl "% Low-Income"
label var perasn "% Asian"
label var perwht "% White"

foreach var in perfrl perblk perhsp perasn perwht{
	
	replace `var' = `var'*100
}

** plots for appendix 
keep if growth_sch >-50 & growth_sch <50 // remove outliers for visualization purposes
keep if ach_sch > -4 & ach_sch <4 
	
	scatter growth_sch perfrl, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/growth_perfrl", replace) msize(vtiny) mcolor(edkblue%50)
	scatter growth_sch perblk, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/growth_perblk", replace) msize(vtiny) mcolor(edkblue%50)
	scatter ach_sch perfrl, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/ach_perfrl", replace) msize(vtiny) mcolor(edkblue%50)
	scatter ach_sch perblk, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/ach_perblk", replace) msize(vtiny) mcolor(edkblue%50)

graph combine ${output}/temp/growth_perfrl.gph ${output}/temp/growth_perblk.gph ${output}/temp/ach_perfrl.gph ${output}/temp/ach_perblk.gph, rows(2)  graphregion(color(white)) 
graph export "figure_A2_$date.png", replace
	
	scatter growth_sch perwht, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/growth_perwht", replace) msize(vtiny) mcolor(edkblue%50)
	scatter growth_sch perhsp, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/growth_perhsp", replace) msize(vtiny) mcolor(edkblue%50)
	scatter growth_sch perasn, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/growth_perasn", replace) msize(vtiny) mcolor(edkblue%50)

	scatter ach_sch perwht, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/ach_perwht", replace) msize(vtiny) mcolor(edkblue%50)
	scatter ach_sch perhsp, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/ach_perhsp", replace) msize(vtiny) mcolor(edkblue%50)
	scatter ach_sch perasn, graphregion(color(white)) aspectratio(1) ysize(5) xsize(5) saving("${output}/temp/ach_perasn", replace) msize(vtiny) mcolor(edkblue%50)
	
graph combine ${output}/temp/white.gph ${output}/temp/white1.gph, rows(1) title("Panel A: Experimental Choices") graphregion(color(white)) scheme(s2mono) saving(${output}/temp/row1, replace)
graph combine ${output}/temp/growth_perwht.gph ${output}/temp/ach_perwht.gph, rows(1) title("Panel B: Actual Distributions") graphregion(color(white)) scheme(s2mono)  saving(${output}/temp/row2, replace)
graph combine ${output}/temp/row1.gph ${output}/temp/row2.gph, rows(2)  graphregion(color(white)) scheme(s2mono)
graph export "figure_A3_$date.png", replace

graph combine ${output}/temp/hisp.gph ${output}/temp/hisp1.gph,  rows(1) title("Panel A: Experimental Choices") graphregion(color(white)) scheme(s2mono)  saving(${output}/temp/row1, replace)
graph combine ${output}/temp/growth_perhsp.gph ${output}/temp/ach_perhsp.gph,rows(1) title("Panel B: Actual Distributions") graphregion(color(white)) scheme(s2mono)  saving(${output}/temp/row2, replace)
graph combine ${output}/temp/row1.gph ${output}/temp/row2.gph, rows(2)  graphregion(color(white)) scheme(s2mono)
graph export "figure_A4_$date.png", replace

graph combine  ${output}/temp/asn.gph ${output}/temp/asn1.gph, rows(1) title("Panel A: Experimental Choices") graphregion(color(white)) scheme(s2mono) saving(${output}/temp/row1, replace)
graph combine  ${output}/temp/growth_perasn.gph ${output}/temp/ach_perasn.gph, rows(1) title("Panel B: Actual Distributions") graphregion(color(white)) scheme(s2mono)  saving(${output}/temp/row2, replace)
graph combine ${output}/temp/row1.gph ${output}/temp/row2.gph, rows(2)  graphregion(color(white)) scheme(s2mono)
graph export "figure_A5_$date.png", replace

