********************************************************************************
* Do File C - Table 3
********************************************************************************

********************************************************************************
* Load Data
********************************************************************************

use "${data}/thompson_seg_choice_analysis_github.dta", clear


********************************************************************************
* Willingness to Pay Estimates
********************************************************************************

eststo clear 

quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch hisp_num_sch asian_num_sch, robust cluster(id)
wtp ach_sch growth_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch


*** same as output from wtp stata command, but includes SEs and significance 

// achievement 
eststo: nlcom ///
(ach_sch: -_b[ach_sch]/_b[growth_sch]) ///
(stat_sch: -_b[stat_sch]/_b[growth_sch]) ///
(equity_sch: -_b[equity_sch]/_b[growth_sch]) ///
(ses_num_sch: -_b[ses_num_sch]/_b[growth_sch]) ///
(black_num_sch: -_b[black_num_sch]/_b[growth_sch]) ///
(asian_num_sch: -_b[asian_num_sch]/_b[growth_sch]) ///
(hisp_num_sch: -_b[hisp_num_sch]/_b[growth_sch]) ///
, post 

//growth
quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch, robust cluster(id)

eststo: nlcom (growth_sch: -_b[growth_sch]/_b[ach_sch]) ///
(stat_sch: -_b[stat_sch]/_b[ach_sch]) ///
(equity_sch: -_b[equity_sch]/_b[ach_sch]) ///
(ses_num_sch: -_b[ses_num_sch]/_b[ach_sch]) ///
(black_num_sch: -_b[black_num_sch]/_b[ach_sch]) ///
(asian_num_sch: -_b[asian_num_sch]/_b[ach_sch]) ///
(hisp_num_sch: -_b[hisp_num_sch]/_b[ach_sch]) ///
, post 

// status ranking 
quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch, robust cluster(id)

eststo: nlcom (growth_sch: -_b[growth_sch]/_b[stat_sch]) ///
(ach_sch: -_b[ach_sch]/_b[stat_sch]) ///
(equity_sch: -_b[equity_sch]/_b[stat_sch]) ///
(ses_num_sch: -_b[ses_num_sch]/_b[stat_sch]) ///
(black_num_sch: -_b[black_num_sch]/_b[stat_sch]) ///
(asian_num_sch: -_b[asian_num_sch]/_b[stat_sch]) ///
(hisp_num_sch: -_b[hisp_num_sch]/_b[stat_sch]) ///
, post 

//equity 

quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch, robust cluster(id)

eststo: nlcom (growth_sch: -_b[growth_sch]/_b[equity_sch]) ///
(ach_sch: -_b[ach_sch]/_b[equity_sch]) ///
(stat_sch: -_b[stat_sch]/_b[equity_sch]) ///
(ses_num_sch: -_b[ses_num_sch]/_b[equity_sch]) ///
(black_num_sch: -_b[black_num_sch]/_b[equity_sch]) ///
(asian_num_sch: -_b[asian_num_sch]/_b[equity_sch]) ///
(hisp_num_sch: -_b[hisp_num_sch]/_b[equity_sch]) ///
, post 


// low-income   
quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch, robust cluster(id)

eststo: nlcom (growth_sch: -_b[growth_sch]/_b[ses_num_sch]) ///
(ach_sch: -_b[ach_sch]/_b[ses_num_sch]) ///
(stat_sch: -_b[stat_sch]/_b[ses_num_sch]) ///
(equity_sch: -_b[equity_sch]/_b[ses_num_sch]) ///
(black_num_sch: -_b[black_num_sch]/_b[ses_num_sch]) ///
(asian_num_sch: -_b[asian_num_sch]/_b[ses_num_sch]) ///
(hisp_num_sch: -_b[hisp_num_sch]/_b[ses_num_sch]) ///
, post 

// black 
quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch, robust cluster(id)

eststo: nlcom (growth_sch: -_b[growth_sch]/_b[black_num_sch]) ///
(ach_sch: -_b[ach_sch]/_b[black_num_sch]) ///
(stat_sch: -_b[stat_sch]/_b[black_num_sch]) ///
(equity_sch: -_b[equity_sch]/_b[black_num_sch]) ///
(ses_num_sch: -_b[ses_num_sch]/_b[black_num_sch]) ///
(asian_num_sch: -_b[asian_num_sch]/_b[black_num_sch]) ///
(hisp_num_sch: -_b[hisp_num_sch]/_b[black_num_sch]) ///
, post

// asian 
quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch, robust cluster(id)

eststo: nlcom (growth_sch: -_b[growth_sch]/_b[asian_num_sch]) ///
(ach_sch: -_b[ach_sch]/_b[asian_num_sch]) ///
(stat_sch: -_b[stat_sch]/_b[asian_num_sch]) ///
(equity_sch: -_b[equity_sch]/_b[asian_num_sch]) ///
(ses_num_sch: -_b[ses_num_sch]/_b[asian_num_sch]) ///
(black_num_sch: -_b[black_num_sch]/_b[asian_num_sch]) ///
(hisp_num_sch: -_b[hisp_num_sch]/_b[asian_num_sch]), post


// hispanic 
quietly: probit choice_clean growth_sch ach_sch stat_sch equity_sch ses_num_sch black_num_sch asian_num_sch hisp_num_sch, robust cluster(id)

eststo: nlcom (growth_sch: -_b[growth_sch]/_b[hisp_num_sch]) ///
(ach_sch: -_b[ach_sch]/_b[hisp_num_sch]) ///
(stat_sch: -_b[stat_sch]/_b[hisp_num_sch]) ///
(equity_sch: -_b[equity_sch]/_b[hisp_num_sch]) ///
(ses_num_sch: -_b[ses_num_sch]/_b[hisp_num_sch]) ///
(black_num_sch: -_b[black_num_sch]/_b[hisp_num_sch]) ///
(asian_num_sch: -_b[asian_num_sch]/_b[hisp_num_sch]), post


esttab using "table_3_$date.csv", obslast se nogaps label noomitted replace compress star(* 0.05 ** 0.01 *** 0.001) b(%9.2f)

