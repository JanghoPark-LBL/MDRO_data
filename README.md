# MDRO_water
This repository provides some public data used in "A Multistage Distributionally Robust Optimization Approach to Water Allocation under Climate Uncertainty"
https://arxiv.org/pdf/2005.07811.pdf

1. Data used in the paper.

- Historical July Population
- HistoricFamily Units  &  Ratio (Available upon request for academic research purpose only.)
- Historical_population_gpcd_monthly
- Historical_population_gpcd_year
- Monthly CMIP5 tasmax (C) 
- Monthly CMIP5 pr (mm)
- Avg GPCD of Year: calculated with regression 
- Yearly Population RESIN
- Yearly Population Tucson
- 2007 Interim Guidelines
- Lake Mead simulation
- CAP allocation reduction
- Demand

2. scenario.txt file includes information of Stage, Node, CAP, Population, Climate_RCP_GPCD

      e.g: Stage, Node,    CAP, Population,            Climate_RCP_GPCD
       
               1,    0, Normal,       WISP, csiro_mk3_6_0_1_rcp26_HighG
