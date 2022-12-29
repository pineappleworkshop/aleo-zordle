# sandbox.aleo

## Build Guide

To compile this Aleo program, run:
```bash
aleo build
```

```bash
# QUOTE: 21922835013
aleo run score 21922835013u64 19758588620u64

correct: 00001
actual:  00001

# SMEAR: 22442762450
aleo run score 22442762450u64 19758588620u64

correct: 02100
actual:  02100

# EMPTY: 18684848729
aleo run score 18684848729u64 19758588620u64

correct: 12200
actual:  12200

# IMPED: 19758588612
aleo run score 19758588612u64 19758588620u64

correct: 22220
actual:  22220

# IMPEL: 19758588620
aleo run score 19758588620u64 19758588620u64

correct: 22222
program: 22222

```
