
********************************************************************************
* Do File D - Figures 4, 5, 6, 7, 8 
********************************************************************************

********************************************************************************
* Load Data
********************************************************************************

use "${data}/thompson_seg_choice_analysis_github.dta", clear


*****************************
*	Linear Splines & Continuous Quadratic 
***************************** 


*** Loops that create identical figures by respondent race/ethnicity 


foreach race in White Black Asian {

eststo clear 

***** Start with responses to %Black 
preserve

	** Generate the splines at .1 increments 
	mkspline perblk1 0.1 perblk2 0.2 perblk3 0.3 perblk4 0.4 perblk5 0.5 perblk6 0.6 perblk7 0.7 perblk8 0.8 perblk9 0.9 perblk10 =  perblack

	** Model with .10 splines for %black 
	eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses ///
	c.perasian c.perhisp  ///
	perblk1-perblk10 ///
	if ethnicitysimplified=="`race'", robust cluster(id)

	testparm perblk1-perblk10

	**
	margins, at(perblk1=0 perblk2=0 perblk3=0 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0 perblk3=0 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0.1 perblk9=0 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0.1 perblk9=0.1 perblk10=0) ///
			 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0.1 perblk9=0.1 perblk10=0.1) vsquish
			
	matrix yhat_vm = r(b)'
	svmat yhat_vm 
	matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \ 1 )
	svmat x_vm
	graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 

	** Compare to a quadratic continuous model 
	eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicitysimplified=="`race'", robust cluster(id) 

	margins, at(perblack=(0(0.1)1)) post

	marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1))) ysize(5) xsize(5) recast(line) plot1opts(lcolor(black)) recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Black")  ///
	graphregion(color(white)) saving(${output}/temp/spline_blk_`race'_$date, replace) name(spline_blk_`race', replace)

restore
eststo clear 

***** %ASIAN SPLINES 

preserve


mkspline perasn1 0.1 perasn2 0.2 perasn3 0.3 perasn4 0.4 perasn5 0.5 perasn6 0.6 perasn7 0.7 perasn8 0.8 perasn9 0.9 perasn10 =  perasian

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses c.perblack c.perhisp ///
perasn1-perasn10 ///
if ethnicitysimplified=="`race'", robust cluster(id) 

testparm perasn1-perasn10

** 
margins, at(perasn1=0 perasn2=0 perasn3=0 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0 perasn3=0 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0.1 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0.1 perasn9=0.1 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0.1 perasn9=0.1 perasn10=0.1) vsquish

		 
		 
			 

matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 


eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicitysimplified=="`race'", robust cluster(id) 

margins, at(perasian=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline"))   ylabel(0(0.25)1) yscale(range(0(.25)1)))ysize(5) xsize(5) recast(line) plot1opts(lcolor(black)) recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Asian")  ///
graphregion(color(white)) saving(${output}/temp/spline_asn_`race'_$date, replace) name(spline_asn_`race', replace) 

restore
eststo clear 

***** %HISP SPLINES 


preserve



mkspline perhisp1 0.1 perhisp2 0.2 perhisp3 0.3 perhisp4 0.4 perhisp5 0.5 perhisp6 0.6 perhisp7 0.7 perhisp8 0.8 perhisp9 0.9 perhisp10 =  perhisp

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses c.perblack c.perasian ///
perhisp1-perhisp10 ///
if ethnicitysimplified=="`race'", robust cluster(id) 

testparm perhisp1-perhisp10

** 
margins, at(perhisp1=0 perhisp2=0 perhisp3=0 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0 perhisp3=0 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0.1 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0.1 perhisp9=0.1 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0.1 perhisp9=0.1 perhisp10=0.1) vsquish post

		 
		 
			 

matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 
// graph export spline_hisp.png, replace

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicitysimplified=="`race'", robust cluster(id) 

margins, at(perhisp=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1))) ysize(5) xsize(5) recast(line) plot1opts(lcolor(black))  recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Hispanic")  ///
graphregion(color(white)) saving(${output}/temp/spline_hisp_`race'_$date ,replace) name(spline_hisp_`race', replace) 

restore
eststo clear 

*** SES

preserve


mkspline perses1 0.1 perses2 0.2 perses3 0.3 perses4 0.4 perses5 0.5 perses6 0.6 perses7 0.7 perses8 0.8 perses9 0.9 perses10 =  perses

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perblack c.perhisp c.perasian  ///
perses1-perses10 ///
if ethnicitysimplified=="`race'", robust cluster(id) 

testparm perses1-perses10

** 
margins, at(perses1=0 perses2=0 perses3=0 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0 perses3=0 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0.1 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0.1 perses9=0.1 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0.1 perses9=0.1 perses10=0.1) vsquish

		 
		 
			 

matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicitysimplified=="`race'", robust cluster(id) 

margins, at(perses=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1))) ysize(5) xsize(5) recast(line) plot1opts(lcolor(black)) recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Low-Income") ///
graphregion(color(white)) saving(${output}/temp/spline_ses_`race'_$date, replace) name(spline_ses_`race', replace) 

restore
eststo clear 

*********** COMBINE 

grc1leg2 ${output}/temp/spline_ses_`race'_$date.gph ///
${output}/temp/spline_blk_`race'_$date.gph ///
${output}/temp/spline_asn_`race'_$date.gph ///
${output}/temp/spline_hisp_`race'_$date.gph,  rows(2)  graphregion(color(white)) scheme(s2mono) saving(${output}/temp/spline_combine_`race'_$date, replace) xcommon ycommon  ysize(10) xsize(10) name(g3, replace)  labsize(small) imargin(0 0 0 0)   
graph display g3, xsize(10) ysize(10)

    * conditional labelling
    if "`race'" == "White" {
       local title "figure_4"
    }
	if "`race'" == "Black" {
       local title "figure_6"
	} 
    else if "`race'" == "Asian" {
       local title "figure_7"
    }


graph export "`title'_$date.png", replace
}




*********** HISPANIC 


eststo clear 

***** START WITH BLACK 
preserve


mkspline perblk1 0.1 perblk2 0.2 perblk3 0.3 perblk4 0.4 perblk5 0.5 perblk6 0.6 perblk7 0.7 perblk8 0.8 perblk9 0.9 perblk10 =  perblack

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses  c.perasian  c.perhisp  ///
perblk1-perblk10 ///
if ethnicity=="Latino/Hispanic", robust cluster(id) 

testparm perblk1-perblk10

** 
margins, at(perblk1=0 perblk2=0 perblk3=0 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0 perblk3=0 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0.1 perblk9=0 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0.1 perblk9=0.1 perblk10=0) ///
		 at(perblk1=0.1 perblk2=0.1 perblk3=0.1 perblk4=0.1 perblk5=0.1 perblk6=0.1 perblk7=0.1 perblk8=0.1 perblk9=0.1 perblk10=0.1) vsquish

		 
		
matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 


eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicity=="Latino/Hispanic", robust cluster(id) 

margins, at(perblack=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1))) ysize(5) xsize(5) recast(line) plot1opts(lcolor(black))recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Black")  ///
graphregion(color(white)) saving(${output}/temp/spline_blk_Hispanic_$date, replace) name(spline_blk_Hispanic, replace) 

restore
eststo clear 

***** %ASIAN SPLINES 

preserve

mkspline perasn1 0.1 perasn2 0.2 perasn3 0.3 perasn4 0.4 perasn5 0.5 perasn6 0.6 perasn7 0.7 perasn8 0.8 perasn9 0.9 perasn10 =  perasian

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses  c.perblack  c.perhisp  ///
perasn1-perasn10 ///
if ethnicity=="Latino/Hispanic", robust cluster(id) 

testparm perasn1-perasn10

** 
margins, at(perasn1=0 perasn2=0 perasn3=0 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0 perasn3=0 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0.1 perasn9=0 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0.1 perasn9=0.1 perasn10=0) ///
		 at(perasn1=0.1 perasn2=0.1 perasn3=0.1 perasn4=0.1 perasn5=0.1 perasn6=0.1 perasn7=0.1 perasn8=0.1 perasn9=0.1 perasn10=0.1) vsquish

		 
		 
			 

matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 


eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicity=="Latino/Hispanic", robust cluster(id) 

margins, at(perasian=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1))) ysize(5) xsize(5) recast(line) plot1opts(lcolor(black)) recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Asian")  ///
graphregion(color(white)) saving(${output}/temp/spline_asn_Hispanic_$date, replace) name(spline_asn_Hispanic, replace) 

restore
eststo clear 

***** %HISP SPLINES 

preserve


mkspline perhisp1 0.1 perhisp2 0.2 perhisp3 0.3 perhisp4 0.4 perhisp5 0.5 perhisp6 0.6 perhisp7 0.7 perhisp8 0.8 perhisp9 0.9 perhisp10 =  perhisp

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses  c.perblack  c.perasian ///
perhisp1-perhisp10 ///
if ethnicity=="Latino/Hispanic", robust cluster(id) 

testparm perhisp1-perhisp10

** 
margins, at(perhisp1=0 perhisp2=0 perhisp3=0 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0 perhisp3=0 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0.1 perhisp9=0 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0.1 perhisp9=0.1 perhisp10=0) ///
		 at(perhisp1=0.1 perhisp2=0.1 perhisp3=0.1 perhisp4=0.1 perhisp5=0.1 perhisp6=0.1 perhisp7=0.1 perhisp8=0.1 perhisp9=0.1 perhisp10=0.1) vsquish post

		 
		 
			 

matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.24)1) 

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicity=="Latino/Hispanic", robust cluster(id) 

margins, at(perhisp=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1))) ysize(5) xsize(5) recast(line) plot1opts(lcolor(black)) recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Hispanic")  ///
graphregion(color(white)) saving(${output}/temp/spline_hisp_Hispanic_$date, replace) name(spline_hisp_Hispanic, replace) 

restore
eststo clear 

***** SES SPLINES 

preserve

mkspline perses1 0.1 perses2 0.2 perses3 0.3 perses4 0.4 perses5 0.5 perses6 0.6 perses7 0.7 perses8 0.8 perses9 0.9 perses10 =  perses

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perblack c.perhisp c.perasian ///
perses1-perses10 ///
if ethnicity=="Latino/Hispanic", robust cluster(id) 

testparm perses1-perses10

** 
margins, at(perses1=0 perses2=0 perses3=0 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0 perses3=0 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0.1 perses9=0 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0.1 perses9=0.1 perses10=0) ///
		 at(perses1=0.1 perses2=0.1 perses3=0.1 perses4=0.1 perses5=0.1 perses6=0.1 perses7=0.1 perses8=0.1 perses9=0.1 perses10=0.1) vsquish

		 
		 
			 

matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses##c.perses c.perblack##c.perblack c.perhisp##c.perhisp c.perasian##c.perasian if ethnicity=="Latino/Hispanic", robust cluster(id) 

margins, at(perses=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1))) ysize(5) xsize(5) recast(line) plot1opts(lcolor(black)) recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% Low-Income") ///
graphregion(color(white)) saving(${output}/temp/spline_ses_Hispanic_$date, replace) name(spline_ses_Hispanic, replace) 

restore
eststo clear 

*********** COMBINE 

grc1leg2 ${output}/temp/spline_ses_Hispanic_$date.gph ///
${output}/temp/spline_blk_Hispanic_$date.gph ///
${output}/temp/spline_asn_Hispanic_$date.gph ///
${output}/temp/spline_hisp_Hispanic_$date.gph,  rows(2)  graphregion(color(white)) scheme(s2mono) saving(${output}/temp/spline_combine_Hispanic_$date, replace) xcommon ycommon  ysize(10) xsize(10) name(g3, replace)  labsize(small) imargin(0 0 0 0)   
graph display g3, xsize(10) ysize(10)
graph export "figure_8_$date.png", replace


eststo clear 
estimates clear 

********* WHITE (INGROUP) ***************************************************************

preserve

mkspline perwht1 0.1 perwht2 0.2 perwht3 0.3 perwht4 0.4 perwht5 0.5 perwht6 0.6 perwht7 0.7 perwht8 0.8 perwht9 0.9 perwht10 =  perwht

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perses ///
perwht1-perwht10 ///
if ethnicitysimplified=="White", robust cluster(id) 

testparm perwht1-perwht10

** 
margins, at(perwht1=0 perwht2=0 perwht3=0 perwht4=0 perwht5=0 perwht6=0 perwht7=0 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0 perwht3=0 perwht4=0 perwht5=0 perwht6=0 perwht7=0 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0 perwht4=0 perwht5=0 perwht6=0 perwht7=0 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0 perwht5=0 perwht6=0 perwht7=0 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0.1 perwht5=0 perwht6=0 perwht7=0 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0.1 perwht5=0.1 perwht6=0 perwht7=0 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0.1 perwht5=0.1 perwht6=0.1 perwht7=0 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0.1 perwht5=0.1 perwht6=0.1 perwht7=0.1 perwht8=0 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0.1 perwht5=0.1 perwht6=0.1 perwht7=0.1 perwht8=0.1 perwht9=0 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0.1 perwht5=0.1 perwht6=0.1 perwht7=0.1 perwht8=0.1 perwht9=0.1 perwht10=0) ///
		 at(perwht1=0.1 perwht2=0.1 perwht3=0.1 perwht4=0.1 perwht5=0.1 perwht6=0.1 perwht7=0.1 perwht8=0.1 perwht9=0.1 perwht10=0.1) vsquish

matrix yhat_vm = r(b)'
svmat yhat_vm 
matrix x_vm = (0 \ 0.1 \ 0.2 \ 0.3 \ 0.4 \ 0.5 \ 0.6 \ 0.7 \ 0.8 \ 0.9 \1 )
svmat x_vm
graph twoway line yhat_vm1 x_vm1, ylabel(0(0.25)1) 

eststo: reg choice_clean growth_sch_std ach_sch_std stat_sch_std equity_sch_std c.perwht##c.perwht c.perses##c.perses if ethnicitysimplified=="White", robust cluster(id) 

margins, at(perwht=(0(0.1)1)) post

marginsplot, addplot(line yhat_vm1 x_vm1, lpattern("--") lcolor(black) legend(order(2 "Quadratic Continuous" 3 "Linear Spline")) ylabel(0(0.25)1) yscale(range(0(.25)1)))  ysize(5) xsize(5) recast(line) plot1opts(lcolor(black)) recastci(rspike) ciopts(lcolor(black%20)) title("") ytitle("Predicted Probability") xtitle("% White") ///
graphregion(color(white)) saving(${output}/temp/spline_white_ingroup_$date, replace) name(spline_white_ingroup, replace) 
graph export "figure_5_$date.png", replace

restore
eststo clear

