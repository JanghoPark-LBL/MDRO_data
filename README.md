# MDRO_water
This repository provides some public data used in "A Multistage Distributionally Robust Optimization Approach to Water Allocation under Climate Uncertainty"
https://arxiv.org/pdf/2005.07811.pdf

1. Data used in the paper.

- Monthly CMIP5 tasmax (C) 
- Monthly CMIP5 pr (mm)
- Avg GPCD of Year: calculated with regression 
- Yearly Population RESIN - Available upon request for academic research purpose only.
- Yearly Population Tucson
- 2007 Interim Guidelines
- Lake Mead simulation
- CAP allocation reduction
- Demand

2. scenario.txt file includes information of Stage, Node, CAP, Population, Climate_RCP_GPCD

      e.g: Stage, Node,    CAP, Population,            Climate_RCP_GPCD
       
               1,    0, Normal,       WISP, csiro_mk3_6_0_1_rcp26_HighG

3. node_information.pkl includes corresponding node information as python dictionary
- node_information.pkl's keys = node number (0, 1, 2, ..., 224640)
- Each node has three keys: 
     
     - "ancestor": ancestor of the node (returns -1 at node 0, stage 1)
     - "descendant": descendant of the node (returns -1 at nodes in stage 5)
     - "rhs": right hand side of the node
        - at node 0: there are 60 rhs (1 years)
        
          Demand Scenarios
            Potable Demand at Zone C = node_information[0]["rhs"][16]
            NonPotable Demand at Zone C = node_information[0]["rhs"][17]
            Potable Demand at Zone D = node_information[0]["rhs"][21]
            NonPotable Demand at Zone D = node_information[0]["rhs"][22]
            Potable Demand at Zone E = node_information[0]["rhs"][26]
            NonPotable Demand at Zone E = node_information[0]["rhs"][27]
            Notable Demand at Zone FS = node_information[0]["rhs"][31]
            NonPotable Demand at Zone FS = node_information[0]["rhs"][32]
            Notable Demand at Zone GS = node_information[0]["rhs"][36]
            NonPotable Demand at Zone GS = node_information[0]["rhs"][37]
            Notable Demand at Zone HS = node_information[0]["rhs"][41]
            NonPotable Demand at Zone HS = node_information[0]["rhs"][42]
            Notable Demand at Zone I = node_information[0]["rhs"][44]
            NonPotable Demand at Zone I = node_information[0]["rhs"][45]
            Notable Demand at Zone FN = node_information[0]["rhs"][49]
            NonPotable Demand at Zone FN = node_information[0]["rhs"][50]
            Notable Demand at Zone GN = node_information[0]["rhs"][54]
            NonPotable Demand at Zone GN = node_information[0]["rhs"][55]
            Notable Demand at Zone HN = node_information[0]["rhs"][57]
            NonPotable Demand at Zone HN = node_information[0]["rhs"][58]
          Supply Scenarios
            CAP water supply = node_information[0]["rhs"][59]

        - all other nodes: there are 60*8 rhs (8 years)

      e.g: node number = 0

          >>> import pickle
          >>> with open('node_information.pkl', 'rb') as f:
          ...     node_information = pickle.load(f)
          >>> node_information[0]["ancestor"]
          >>> node_information[0]["descendant"]
          >>> node_information[0]["rhs"]


