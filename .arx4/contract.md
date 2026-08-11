# ARX4 Engineering Contract

This repository is an ARX4 priority target.

## Evidence
- OBSERVED: facts demonstrated by repository files, GitHub checks, or executed commands.
- CORRELATED: associated signals without causal proof.
- HYPOTHESIS: proposed explanation requiring validation.
- VALIDATED: repeatable evidence supports the conclusion.
- UNKNOWN: required evidence is unavailable.

## Engineering rules
1. Preserve working functionality.
2. Prefer minimal, testable changes.
3. Never commit secrets.
4. Never delete tests to obtain green CI.
5. Never claim success without evidence.
6. Keep repair attempts bounded to three iterations.
7. Record performance regressions and improvements.
8. Treat security and correctness as merge gates.

## Self-improvement loop
OBSERVE → MEASURE → BOTTLENECK → HYPOTHESIS → IMPLEMENT → TEST → COMPARE → VALIDATE → RECORD.
