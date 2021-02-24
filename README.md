# MDRO_water
This repository provides some public data used in "A Multistage Distributionally Robust Optimization Approach to Water Allocation under Climate Uncertainty"
https://arxiv.org/pdf/2005.07811.pdf.

**1. Data used in the paper (MDRO_data/data.xlsx)**

- Monthly CMIP5 tasmax (C) [Monthly Maximum Surface Air Temperature (deg C)]
- Monthly CMIP5 pr (mm/month) [Monthly Precipitation Rate (mm/month)]
- Avg GPCD of Year: calculated with regression per climate model [high/low GPCD regressions]
- Yearly Predicted Population Study Area - Available upon request for academic research purpose only
- Yearly Predicted Population Tucson
- 2007 Interim Guidelines
- Lake Mead simulation - Available upon request for academic research purpose only
- CAP allocation reduction [Nominal probabilities of water allotment scenarios per climate model]
- Yearly predicted demand per demand zone [high (WISP)/low (TAZ) population]

**2. scenario.txt file includes information of Stage, Node, CAP, Population, Climate_RCP_GPCD**

      e.g: Stage, Node,    CAP, Population,            Climate_RCP_GPCD
       
               1,    0, Normal,       WISP, csiro_mk3_6_0_1_rcp26_HighG

**3. node_information.pkl includes corresponding node information as python dictionary**
- node_information.pkl's keys = node number (0, 1, 2, ..., 224640)
- Each node has three keys: 
     
     - "ancestor": ancestor of the node (returns -1 at node 0, stage 1)
     - "descendant": descendant of the node (returns -1 at nodes in the final stage 5)
     - "rhs": right-hand side of the constraints
       - at node 0: there are 60 rhs (1 year)
       - all other nodes (node_number in (1, 2, ..., 224640)): there are 60*8 rhs (8 years)
     
      e.g: node_number = 0

          >>> import pickle
          >>> with open('node_information.pkl', 'rb') as f:
          ...     node_information = pickle.load(f)
          >>> node_information[0]["ancestor"]
          >>> node_information[0]["descendant"]
          >>> node_information[0]["rhs"]
     
     - Demand and Supply Scenarios are in the  node_information[node_number]["rhs"]
       - at node 0 (1 years)
          - Demand Scenarios
            - Potable Demand at Zone C = node_information[0]["rhs"][16]
            - NonPotable Demand at Zone C = node_information[0]["rhs"][17]
            - Potable Demand at Zone D = node_information[0]["rhs"][21]
            - NonPotable Demand at Zone D = node_information[0]["rhs"][22]
            - Potable Demand at Zone E = node_information[0]["rhs"][26]
            - NonPotable Demand at Zone E = node_information[0]["rhs"][27]
            - Notable Demand at Zone FS = node_information[0]["rhs"][31]
            - NonPotable Demand at Zone FS = node_information[0]["rhs"][32]
            - Notable Demand at Zone GS = node_information[0]["rhs"][36]
            - NonPotable Demand at Zone GS = node_information[0]["rhs"][37]
            - Notable Demand at Zone HS = node_information[0]["rhs"][41]
            - NonPotable Demand at Zone HS = node_information[0]["rhs"][42]
            - Notable Demand at Zone I = node_information[0]["rhs"][44]
            - NonPotable Demand at Zone I = node_information[0]["rhs"][45]
            - Notable Demand at Zone FN = node_information[0]["rhs"][49]
            - NonPotable Demand at Zone FN = node_information[0]["rhs"][50]
            - Notable Demand at Zone GN = node_information[0]["rhs"][54]
            - NonPotable Demand at Zone GN = node_information[0]["rhs"][55]
            - Notable Demand at Zone HN = node_information[0]["rhs"][57]
            - NonPotable Demand at Zone HN = node_information[0]["rhs"][58]
          - Supply Scenarios
            - CAP water supply = node_information[0]["rhs"][59]

        - all other nodes (node_number in (1, 2, ..., 224640)) (8 years)
          - Demand Scenarios
            - Potable Demand at Zone C = [node_information[node_number]["rhs"][16+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone C = [node_information[node_number]["rhs"][17+60*i] for i in range(0,8)]
            - Potable Demand at Zone D = [node_information[node_number]["rhs"][21+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone D = [node_information[node_number]["rhs"][22+60*i] for i in range(0,8)]
            - Potable Demand at Zone E = [node_information[node_number]["rhs"][26+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone E = [node_information[node_number]["rhs"][27+60*i] for i in range(0,8)]
            - Notable Demand at Zone FS = [node_information[node_number]["rhs"][31+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone FS = [node_information[node_number]["rhs"][32+60*i] for i in range(0,8)]
            - Notable Demand at Zone GS = [node_information[node_number]["rhs"][36+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone GS = [node_information[node_number]["rhs"][37+60*i] for i in range(0,8)]
            - Notable Demand at Zone HS = [node_information[node_number]["rhs"][41+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone HS = [node_information[node_number]["rhs"][42+60*i] for i in range(0,8)]
            - Notable Demand at Zone I = [node_information[node_number]["rhs"][44+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone I = [node_information[node_number]["rhs"][45+60*i] for i in range(0,8)]
            - Notable Demand at Zone FN = [node_information[node_number]["rhs"][49+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone FN = [node_information[node_number]["rhs"][50+60*i] for i in range(0,8)]
            - Notable Demand at Zone GN = [node_information[node_number]["rhs"][54+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone GN = [node_information[node_number]["rhs"][55+60*i] for i in range(0,8)]
            - Notable Demand at Zone HN = [node_information[node_number]["rhs"][57+60*i] for i in range(0,8)]
            - NonPotable Demand at Zone HN = [node_information[node_number]["rhs"][58+60*i] for i in range(0,8)]
          - Supply Scenarios
            - CAP water supply = [node_information[node_number]["rhs"][59+60*i] for i in range(0,8)]

      e.g: node_number = 1 # 2nd stage, year= 2019–2026, CAP=Normal, Population=WISP, Climate_RCP_GPCD=csiro_mk3_6_0_1_rcp26_HighG

          >>> import pickle
          >>> with open('node_information.pkl', 'rb') as f:
          ...     node_information = pickle.load(f)
          >>> [node_information[node_number]["rhs"][16+60*i] for i in range(0,8)] # Potable Demand at Zone C, year= 2019–2026.
          [1871.9194261409048, 2121.361589402013, 2231.636089694466, 2347.1466501979003, 2505.0550503281997, 2611.9635977465846, 2701.0129084795044, 2771.0289527900745]
          >>> [node_information[node_number]["rhs"][59+60*i] for i in range(0,8)] # CAP water supply, year= 2019–2026.
          [-27490.147982832674, -29635.605633802752, -31887.871289875155, -34072.44590163931, -36192.33593539704, -38250.37241379317, -40249.22352941174, -42124.21608247416]



