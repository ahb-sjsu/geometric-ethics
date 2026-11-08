# Ch. 17 gate rates rebuilt from the source (non-abelian-sqnd experiments/ground_truth_summary.md:
# "you promised" 94%, "only if convenient" 89%, as Ch. 5 and Ch. 8 already say). Replaces the
# e33 Wilson-CI and Cohen's h items, which assumed counts that have no source.
EDITS = [
    ("nth_after", "“only if convenient”", 2, "94%", "89%"),
    ("nth_after", "“you promised”", 2, "91%", "94%"),
    ("sub", "A letter describing a promise generates an obligation with high probability (91%). Adding “only if convenient” flips it to a liberty with high probability (94%).",
     "A letter describing a promise generates an obligation with high probability (94%). Adding “only if convenient” flips it to a liberty with high probability (89%)."),
    ("sub", "[Statistical detail.] The 91% obligation-triggering rate for “you promised” has a 95% Wilson CI of [88.2%, 93.4%] (n = 582). The 94% liberty-triggering rate for “only if convenient” has CI [91.1%, 96.2%] (n = 347). Effect size for semantic gate discreteness (comparing pooled gate-trigger rate vs. 50% chance): Cohen’s h = 1.42 (large). These intervals exclude sigmoidal transitions at p < 0.001.",
     "[Statistical detail.] The source records give the rates (94% obligation-triggering for “you promised”, 89% liberty-triggering for “only if convenient”) but not the counts behind them, so no confidence interval is reported. Effect size for semantic gate discreteness (the unweighted mean of the five gate rates in the table, 89.8%, against 50% chance): Cohen’s h = 0.92 (large). (v1.24 printed 91% and 94%, the reverse of the source, with intervals for n = 582 and n = 347 that match no count and no source; corrected in v1.25.)"),
    ("sub", "Cohen’s h = 1.42 (see §17.3 for comparison specification)", "Cohen’s h = 0.92 (see §17.3 for comparison specification)"),
    ("sub", "Moderate variation: Rights (22%), Loyalty (18%)", "Moderate variation: Rights (22%), Loyalty (18%) (the two reports of this study disagree, see Discovery 2; its data are not in the released repositories)"),
    ("sub", "Moderate variation: Loyalty (28%), Rights (17%)", "Moderate variation: Loyalty (28%), Rights (17%) (this disagrees with the §17.10 summary of the same study; its data are not in the released repositories)"),
]
