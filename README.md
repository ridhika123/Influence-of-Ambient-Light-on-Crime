# Influence-of-Ambient-Light-on-Crime

## Abstract
Driven by the fact that crime incurs major costs to the economy, studying the determinants of crime is of special importance. This paper studies the effect of ambient light on criminal activity in general, and in urban and rural areas in particular. I use a sharp regression discontinuity design, with daylight savings time as the exogenous shift in light. The model measures crime rates at two levels: daily and hourly. The overall effect on crime is ambiguous, with a decrease in robberies in rural areas, but an increase in aggravated assault. As expected, the effect is felt most in the hours directly affected by the shift in daylight and in rural areas in particular.

## Data
* Crime data from National Incident Based Reporting System (NIBRS) from the year 2007 to 2016.
* Geographical location of each record is obtained from ICPSR.
* Jurisdiction to time zone data from the National Weather Service.
* Population density data at county level from the Inter-university Consortium for Political and Social Research (ICPSR).

## Code
* [sunrise_sunset](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/sunrise_sunset.ipynb): Created data for sunset and sunrise times in every latitude-logitude cross section in the US. Imports data from [crosswalk_stata_version.tab](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/crosswalk_stata_version.tab).
* [data_cleaning1](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/data_cleaning1.do): First data cleaning step and setting it up for analysis.
* [data_cleaning2](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/data_cleaning2.do): Second data cleaning step and setting it up for analysis.
* [sunrise](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/sunrise.do): Sets up sunset data outputted from [sunrise_sunset](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/sunrise_sunset.ipynb) for analysis.
* [maindata_code](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/maindata_code.do): Final data setup for analysis.
* [anaylsis](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/anaylsis.do): Sharp regression discontinuty analysis with figures and results included in paper.

## Final Output
Final paper can be found [here](https://github.com/ridhika123/Influence-of-Ambient-Light-on-Crime/blob/main/Influence%20of%20Ambient%20Light%20on%20Crime.pdf).
