# `ALFAM2-app/output`
Predictions from ALFAM2 model

# Variables
Most variables follow those in [ALFAM2-data](https://github.com/sashahafner/ALFAM2-data/).
Some of those are copied from there and pasted below.

|Name|Description|Type|Units|
|----|-----------|----|-----|
ct|Time since application (c for cumulative) based on reported interval duration (assumes first interval started at time of application)|numeric|h|
cta|Time since application (c for cumulative, a for application) based on reported interval date/time and application date/time if available|numeric|h|
e.cum|Cumulative NH3 emission to the end of measurement interval|numeric|kg/ha as N|
|e.rel|Cumulative relative NH3 emission to the end of measurement interval|numeric|fraction of applied TAN|

The suffixes `.pred1` and `.pred2` mean that values are predicted by the ALFAM2 model using parameter set 1 and 2.
