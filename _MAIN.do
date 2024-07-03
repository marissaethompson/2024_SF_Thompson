
********************************************************************************
* Author: Thompson
* File posted to github: March 2024
* Version: 01 
* Purpose: Conjoint school profile experiment replication 
********************************************************************************

********************************************************************************
* Setting up data and globals  
********************************************************************************

** All analyses were run using Stata 17 

clear 
set more off 
version 17 
set matsize 5000
pause on

*** Set seeds and sortseed 
set seed 10027
set sortseed 10027

**** Globals (users will need to replace)
global dir "/Users/marissathompson/Dropbox/_Research/segregation_conjoint/_post" 
global data "${dir}/data/"
global output "${dir}/output"


**** Define working directory (users will need to replace)

cd "${dir}/output"
capture mkdir temp


**** Install necessary packages 
local packages estout desctable coefplot renfiles heatplot mkspline grc1leg2 // These packages must be installed to run the code without errors 

foreach package in `packages' {
	capture : which `package'
	if (_rc) {
		display as result in smcl `"Please install `package' in order to run this syntax"'
		exit 199
	}
}

***********************************
* Date global 
***********************************

*makes date in numeric year_month_day format for file version control 

quietly {
	global date=c(current_date)

	***day
	if substr("$date",1,1)==" " {
		local val=substr("$date",2,1)
		global day=string(`val',"%02.0f")
	}
	else {
		global day=substr("$date",1,2)
	}

	***month
	if substr("$date",4,3)=="Jan" {
		global month="01"
	}
	if substr("$date",4,3)=="Feb" {
		global month="02"
	}
	if substr("$date",4,3)=="Mar" {
		global month="03"
	}
	if substr("$date",4,3)=="Apr" {
		global month="04"
	}
	if substr("$date",4,3)=="May" {
		global month="05"
	}
	if substr("$date",4,3)=="Jun" {
		global month="06"
	}
	if substr("$date",4,3)=="Jul" {
		global month="07"
	}
	if substr("$date",4,3)=="Aug" {
		global month="08"
	}
	if substr("$date",4,3)=="Sep" {
		global month="09"
	}
	if substr("$date",4,3)=="Oct" {
		global month="10"
	}
	if substr("$date",4,3)=="Nov" {
		global month="11"
	}
	if substr("$date",4,3)=="Dec" {
		global month="12"
	}

	***year
	global year=substr("$date",8,4)

	global date="$year"+"_"+"$month"+"_"+"$day"
}

dis "$date"


********************************************************************************
* Run Do Files
********************************************************************************

*** Table 1, Table 2, Figure 1, Table 4
do "${dir}/A_descriptive_AMCE.do" 

*** Figures 2-3
do "${dir}/B_heatmaps.do" 

*** Table 3
do "${dir}/C_wtp.do" 

*** Figures 4-8
do "${dir}/D_splines.do" 


