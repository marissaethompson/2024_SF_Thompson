

********************************************************************************
* Do File A - Table 1, Table 2, Figure 1 
********************************************************************************

********************************************************************************
* Load Data
********************************************************************************

use "${data}/thompson_seg_choice_analysis_github.dta", clear


*****************************
*	Respondent Descriptives - Table 1
*****************************

preserve 
	bys id: keep if _n==1 // Generate table at the profile level
	mdesc eth hisp hhi age

	desctable i.eth i.hisp i.hhi age i.gender, filename("table 1_descriptive_$date") stats(mean sd)
restore 

********************************************************************************
*	AMCE Models - Table 2 and Figure 1
******************************************************************************** 

eststo clear 
estimates clear 

	*** OVERALL 
	eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ///
		ses_num_sch_std black_num_sch_std asian_num_sch_st hisp_num_sch_std, robust cluster(id)

	*** BY RACE 
	foreach race in White Black Asian {
	eststo `race':  reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_st hisp_num_sch_std if ethnicitysimplified=="`race'" , robust cluster(id)
	estimates store `race'
	}

	eststo Hisp: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_st hisp_num_sch_std if ethnicity=="Latino/Hispanic", robust cluster(id)
	estimates store Hisp

	*** BY INCOME 
	eststo low_income: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std  if hhi==0, robust cluster(id)
	estimates store low_income 

	eststo high_income: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std if hhi==1, robust cluster(id)
	estimates store high_income 

esttab using "table_2_$date.csv", obslast se nogaps label noomitted replace compress star(* 0.05 ** 0.01 *** 0.001) stardetach b(%9.2f)


******************************************************************************** 
*	Coefficient Plot - Figure 1  
******************************************************************************** 

eststo clear 
eststo model: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std, robust cluster(id)

foreach race in Asian Black White {
eststo `race': reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std if ethnicitysimplified=="`race'", robust cluster(id)
}

eststo Hisp: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std if ethnicity=="Latino/Hispanic", robust cluster(id)


coefplot  (model, mcolor(black) msymbol(Oh) mfcolor(black)  msize(vsmall) ciopts(color(black%30)) drop(_cons)) /// 
	(White, mcolor(red) msymbol(Oh) mfcolor(red)  msize(vsmall) ciopts(color(red%30)) drop(_cons) xline(0) ) ///
	(Black, mcolor(green) msymbol(Oh) mfcolor(green) msize(vsmall)  ciopts(color(green%30)) drop(_cons) ) ///
	(Asian, mcolor(blue) msymbol(Oh) mfcolor(blue) msize(vsmall)  ciopts(color(blue%30)) drop(_cons) ) ///
	(Hisp, mcolor(orange) msymbol(Oh) mfcolor(orange) msize(vsmall)  ciopts(color(orange%30)) drop(_cons) ) ///
	, xline(0) plotlabels("All" "White" "Black" "Asian" "Latino/Hispanic") base graphregion(color(white)) ysize(6) xsize(4) xtitle("Average Marginal Component Effect")

graph export "figure_2_$date.png", replace


*****************************
*	Table 4 - Equity tradeoff? 
***************************** 

eststo clear

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ///
	ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std ///
	c.equity_sch#c.ses_num_sch_std c.equity_sch_std#c.black_num_sch_std c.equity_sch_std#c.asian_num_sch_std c.equity_sch_std#c.hisp_num_sch_std, robust cluster(id)

esttab using "table_4_$date.csv", obslast se nogaps label noomitted replace compress star(* 0.05 ** 0.01 *** 0.001) stardetach b(%9.2f)


******************************************************************************** 
*	Tests for heterogeneity across respondent race/income 
******************************************************************************** 


** Check for Interactions 
	reg choice_clean c.growth_sch_std##ib5.eth c.ach_sch_std##ib5.eth  c.stat_sch_std##ib5.eth  c.equity_sch_std##ib5.eth /// race
		c.ses_num_sch_std##ib5.eth  c.black_num_sch_std##ib5.eth c.hisp_num_sch_std##ib5.eth  c.asian_num_sch_st##ib5.eth ///
		i.hisp c.growth_sch_std#i.hisp c.ach_sch_std#i.hisp  c.stat_sch_std#i.hisp  c.equity_sch_std#i.hisp  /// hisp
		c.ses_num_sch_std#i.hisp  c.black_num_sch_std#i.hisp c.hisp_num_sch_std#i.hisp  c.asian_num_sch_st#i.hisp ///
		i.hhi c.growth_sch_std#i.hhi c.ach_sch_std#i.hhi  c.stat_sch_std#i.hhi  c.equity_sch_std#i.hhi  /// income 
		c.ses_num_sch_std#i.hhi  c.black_num_sch_std#i.hhi c.hisp_num_sch_std#i.hhi c.asian_num_sch_st#i.hhi ///
		, robust cluster(id)
			
		estimates clear 
	
** Tests of Statistical Significance 

		*** BY RACE 
		foreach race in White Black Asian {
		quietly: eststo `race':  reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_st hisp_num_sch_std if ethnicitysimplified=="`race'" 
		estimates store `race'
		}

		quietly: eststo Hisp: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_st hisp_num_sch_std if ethnicity=="Latino/Hispanic"
		estimates store Hisp

		*** BY INCOME 
		quietly: eststo low_income: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std  if hhi==0
		estimates store low_income 

		quietly: eststo high_income: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std if hhi==1
		estimates store high_income 	
		
	quietly: suest White Asian Black Hisp low_income high_income, robust cluster(id)

	** testing growth 
	test _b[White_mean:growth_sch_std] = _b[Black_mean:growth_sch_std] = _b[Asian_mean:growth_sch_std] = _b[Hisp_mean:growth_sch_std]
	test _b[White_mean:growth_sch_std] = _b[Black_mean:growth_sch_std] 
	test _b[White_mean:growth_sch_std] = _b[Asian_mean:growth_sch_std]
	test _b[White_mean:growth_sch_std] = _b[Hisp_mean:growth_sch_std]
	test _b[high_income_mean:growth_sch_std] = _b[low_income_mean:growth_sch_std]


	** testing achievement  
	test _b[White_mean:ach_sch_std] = _b[Black_mean:ach_sch_std] = _b[Asian_mean:ach_sch_std] = _b[Hisp_mean:ach_sch_std]
	test _b[White_mean:ach_sch_std] = _b[Black_mean:ach_sch_std] 
	test _b[White_mean:ach_sch_std] = _b[Asian_mean:ach_sch_std]
	test _b[White_mean:ach_sch_std] = _b[Hisp_mean:ach_sch_std]
	test _b[high_income_mean:ach_sch_std] = _b[low_income_mean:ach_sch_std]

	** testing ranking
	test _b[White_mean:stat_sch_std] = _b[Black_mean:stat_sch_std] = _b[Asian_mean:stat_sch_std] = _b[Hisp_mean:stat_sch_std]
	test _b[White_mean:stat_sch_std] = _b[Black_mean:stat_sch_std] 
	test _b[White_mean:stat_sch_std] = _b[Asian_mean:stat_sch_std]
	test _b[White_mean:stat_sch_std] = _b[Hisp_mean:stat_sch_std]
	test _b[high_income_mean:stat_sch_std] = _b[low_income_mean:stat_sch_std]


	** testing equity
	test _b[White_mean:equity_sch_std] = _b[Black_mean:equity_sch_std] = _b[Asian_mean:equity_sch_std] = _b[Hisp_mean:equity_sch_std]
	test _b[White_mean:equity_sch_std] = _b[Black_mean:equity_sch_std] 
	test _b[White_mean:equity_sch_std] = _b[Asian_mean:equity_sch_std]
	test _b[White_mean:equity_sch_std] = _b[Hisp_mean:equity_sch_std]
	test _b[high_income_mean:equity_sch_std] = _b[low_income_mean:equity_sch_std]

	** testing ses_num
	test _b[White_mean:ses_num_sch_std] = _b[Black_mean:ses_num_sch_std] = _b[Asian_mean:ses_num_sch_std] = _b[Hisp_mean:ses_num_sch_std]
	test _b[White_mean:ses_num_sch_std] = _b[Black_mean:ses_num_sch_std] 
	test _b[White_mean:ses_num_sch_std] = _b[Asian_mean:ses_num_sch_std]
	test _b[White_mean:ses_num_sch_std] = _b[Hisp_mean:ses_num_sch_std]
	test _b[high_income_mean:ses_num_sch_std] = _b[low_income_mean:ses_num_sch_std]


	** testing black_num
	test _b[White_mean:black_num_sch_std] = _b[Black_mean:black_num_sch_std] = _b[Asian_mean:black_num_sch_std] = _b[Hisp_mean:black_num_sch_std]
	test _b[White_mean:black_num_sch_std] = _b[Black_mean:black_num_sch_std] 
	test _b[White_mean:black_num_sch_std] = _b[Asian_mean:black_num_sch_std]
	test _b[White_mean:black_num_sch_std] = _b[Hisp_mean:black_num_sch_std]
	test _b[high_income_mean:black_num_sch_std] = _b[low_income_mean:black_num_sch_std]

	** testing asian_num
	test _b[White_mean:asian_num_sch_std] = _b[Black_mean:asian_num_sch_std] = _b[Asian_mean:asian_num_sch_std] = _b[Hisp_mean:asian_num_sch_std]
	test _b[White_mean:asian_num_sch_std] = _b[Black_mean:asian_num_sch_std] 
	test _b[White_mean:asian_num_sch_std] = _b[Asian_mean:asian_num_sch_std]
	test _b[White_mean:asian_num_sch_std] = _b[Hisp_mean:asian_num_sch_std]
	test _b[high_income_mean:asian_num_sch_std] = _b[low_income_mean:asian_num_sch_std]


	** testing hisp_num
	test _b[White_mean:hisp_num_sch_std] = _b[Black_mean:hisp_num_sch_std] = _b[Asian_mean:hisp_num_sch_std] = _b[Hisp_mean:hisp_num_sch_std]
	test _b[White_mean:hisp_num_sch_std] = _b[Black_mean:hisp_num_sch_std] 
	test _b[White_mean:hisp_num_sch_std] = _b[Asian_mean:hisp_num_sch_std]
	test _b[White_mean:hisp_num_sch_std] = _b[Hisp_mean:hisp_num_sch_std]
	test _b[high_income_mean:hisp_num_sch_std] = _b[low_income_mean:hisp_num_sch_std]

	


*****************************
*	Appendix - Same Race Reference AMCEs 
***************************** 

eststo clear 
estimates clear 
	
	
	eststo White: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std if ethnicitysimplified=="White", robust cluster(id)
	estimates store White
	
	eststo Black: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std white_num_sch_std asian_num_sch_std hisp_num_sch_std if ethnicitysimplified=="Black", robust cluster(id)
	estimates store Black	
	
	eststo Asian: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std white_num_sch_std hisp_num_sch_std if ethnicitysimplified=="Asian", robust cluster(id)
	estimates store Asian
	
	eststo Hisp: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std white_num_sch_std if ethnicity=="Latino/Hispanic", robust cluster(id)
	estimates store Hisp

esttab using "table_A2_$date.csv", obslast se nogaps label noomitted replace compress star(* 0.05 ** 0.01 *** 0.001) stardetach b(%9.2f)
	
	
*****************************
*	Appendix - Marginal Means for race & subgroup 
***************************** 	

eststo clear 
estimates clear 


		*** BY RACE 
		quietly: eststo overall:  reg choice_clean perwht perblack perasian perhisp , robust cluster(id) nocons 
		estimates store overall 
		
		foreach race in White Black Asian {
		quietly: eststo `race':  reg choice_clean perwht perblack perasian perhisp  if ethnicitysimplified=="`race'" , robust cluster(id) nocons 
		estimates store `race'
		}

		quietly: eststo Hisp: reg choice_clean perwht perblack perasian perhisp  if ethnicity=="Latino/Hispanic" , robust cluster(id) nocons 
		estimates store Hisp
		
		
		coefplot ///
			(overall, mcolor(black) msymbol(Oh) mfcolor(black)  msize(vsmall) keep(perwht perblack perasian perhisp) ciopts(color(black%30))) /// 
			(White, mcolor(red) mfcolor(red) msymbol(Oh)  msize(vsmall) keep(perwht perblack perasian perhisp) ciopts(color(red%30)) ) ///
			(Asian, mcolor(blue) mfcolor(blue) msymbol(Oh) msize(vsmall) keep(perwht perblack perasian perhisp) ciopts(color(blue%30))  ) ///
			(Black, mcolor(green) mfcolor(green) msymbol(Oh)  msize(vsmall) keep(perwht perblack perasian perhisp) ciopts(color(green%30)) ) ///
			(Hisp, mcolor(orange) mfcolor(orange) msymbol(Oh)  msize(vsmall) keep(perwht perblack perasian perhisp) ciopts(color(orange%30))  ) ///
			, xline(.5) plotlabels("Overall" "White" "Asian" "Black" "Latino/Hispanic") base graphregion(color(white)) ysize(6) xsize(4) xtitle("Marginal Mean")

graph save "figure_A6_$date", replace 
graph export "figure_A6_$date.png", replace


eststo clear 
estimates clear 	
		quietly: eststo overall:  reg choice_clean perses perhighses , robust cluster(id) nocons 
		estimates store overall 
		
		*** BY INCOME 
		quietly: eststo low_income: reg choice_clean perses perhighses if hhi==0 , robust cluster(id) nocons 
		estimates store low_income 

		quietly: eststo high_income: reg choice_clean perses perhighses if hhi==1 , robust cluster(id) nocons 
		estimates store high_income 	
		
		
		coefplot ///
			(overall, mcolor(black) msymbol(Oh) mfcolor(black)  msize(vsmall) keep(perses perhighses) ciopts(color(black%30))) /// 
			(low_income, mcolor(red) mfcolor(red) msymbol(Oh)  msize(vsmall) keep(perses perhighses) ciopts(color(red%30)) ) ///
			(high_income, mcolor(blue) mfcolor(blue) msymbol(Oh) msize(vsmall) keep(perses perhighses) ciopts(color(blue%30))  ) ///
			, xline(.5) plotlabels("Overall" "Lower-Income" "Higher-Income") base graphregion(color(white)) ysize(2) xsize(2) xtitle("Marginal Mean")
			
		
graph save "figure_A7_$date", replace 
graph export "figure_A7_$date.png", replace


	
*****************************
*	CONDITIONAL LOGIT 
***************************** 

eststo clear 

		clogit choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std, robust group(id)
		eststo: margins, dydx(*) post


esttab using "table_A1_clogit_$date.csv", obslast se nogaps label noomitted replace compress star(* 0.05 ** 0.01 *** 0.001) stardetach b(%9.2f)

*****************************
*	RANDOM EFFECTS  
***************************** 

eststo clear 
estimates clear 

eststo: mixed choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std ses_num_sch_std black_num_sch_std asian_num_sch_std hisp_num_sch_std || id: , robust 


esttab using "table_A1_mixed_$date.csv", obslast se nogaps label noomitted replace compress star(* 0.05 ** 0.01 *** 0.001) stardetach b(%9.2f)





