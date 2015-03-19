base:
  '*':
    - baseinstall
  '*masta*':
    - masterinstall
  'host:kubminion1':
    - match: grain
    - minion1
  'host:kubminion2':
    - match: grain
    - minion2
  'host:kubminion3':
    - match: grain
    - minion3
  'host:kubminion4':
    - match: grain
    - minion4    
