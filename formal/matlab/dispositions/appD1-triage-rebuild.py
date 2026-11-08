# App. D.1 (Emergency Triage): welfare of option γ recomputed as (0.60 + 0.85)/2 = 0.725 and carried
# through every dependent value. REPLACES the L38832 item of edits/e34.py (drop that edit).
# Convention kept from the book: each printed term is rounded half-up to 3 decimals and each printed
# total is the sum of the printed terms (as for all α and β entries). Exact values in comments.
# Only γ's welfare changes; α, β, the covectors and the weights are untouched.
EDITS = [
    # L38826 TEXT-AppD (O_γ welfare component): REAL — (0.60 + 0.85)/2 = 0.725, not 0.62.
    ("sub", "O_γ = (0.62,  0.60,  0.58,", "O_γ = (0.725, 0.60,  0.58,"),

    # L38832 TEXT-AppD (welfare_g 0.62 stated as "(0.60 + 0.85)/2"): REAL — the stated average is 0.725; plain average, as in Transform 4.
    ("sub_eq", "Welfare 0.62: moderate combined prognosis (0.60 + 0.85)/2, but denies the best prognosis (A).",
     "Welfare 0.725: moderate combined prognosis (0.60 + 0.85)/2 = 0.725; A, the best prognosis, is the patient denied. (v1.24 printed 0.62; corrected in v1.25, with every dependent value recomputed.)"),

    # L38945-38957 TEXT-AppD (Step 5, γ row of M_{ia}): REAL — dependent on welfare_γ.
    # exact: phys 0.643, Afam 0.463, Bfam 0.573, Cfam 0.55975, comm 0.5875
    ("sub_in", "M_{γ,phys}  = 0.40(0.62)", "(0.62)", "(0.725)"),
    ("sub", "0.248 + 0.060 + 0.058 + 0.028 + 0.013 + 0.195 = 0.602",
     "0.290 + 0.060 + 0.058 + 0.028 + 0.013 + 0.195 = 0.644"),
    ("sub", "0.124 + 0.060 + 0.058 + 0.055 + 0.113 + 0.033 = 0.443",
     "0.145 + 0.060 + 0.058 + 0.055 + 0.113 + 0.033 = 0.464"),
    ("sub", "0.062 + 0.270 + 0.058 + 0.083 + 0.025 + 0.065 = 0.563",
     "0.073 + 0.270 + 0.058 + 0.083 + 0.025 + 0.065 = 0.574"),
    ("sub", "0.093 + 0.060 + 0.261 + 0.028 + 0.038 + 0.065 = 0.545",
     "0.109 + 0.060 + 0.261 + 0.028 + 0.038 + 0.065 = 0.561"),
    ("sub", "0.124 + 0.120 + 0.145 + 0.055 + 0.025 + 0.098 = 0.567",
     "0.145 + 0.120 + 0.145 + 0.055 + 0.025 + 0.098 = 0.588"),

    # Tensor table, γ row (each cell paragraph is unique in the document).
    ("sub_eq", "0.602", "0.644"),
    ("sub_eq", "0.443", "0.464"),
    ("sub_eq", "0.563", "0.574"),
    ("sub_eq", "0.545", "0.561"),
    ("sub_eq", "0.567", "0.588"),

    # L39010 Utilitarian S_γ: REAL (dependent). β 3.813 still wins; α 3.247 still second.
    ("sub", "S_γ = 0.602 + 0.443 + 0.563 + 0.545 + 0.567 = 2.720",
     "S_γ = 0.644 + 0.464 + 0.574 + 0.561 + 0.588 = 2.831"),

    # L39023 Rawlsian S_γ: REAL (dependent). Floor still A's family; β 0.668 still wins.
    ("sub", "min(0.602, 0.443, 0.563, 0.545, 0.567) = 0.443",
     "min(0.644, 0.464, 0.574, 0.561, 0.588) = 0.464"),

    # L39040 Expert-weighted S_γ: REAL (dependent). Exact on tabulated entries 0.5911; printed terms sum to 0.590. β 0.776 still wins.
    ("sub", "0.35(0.602) + 0.10(0.443) + 0.10(0.563) + 0.10(0.545) + 0.35(0.567)",
     "0.35(0.644) + 0.10(0.464) + 0.10(0.574) + 0.10(0.561) + 0.35(0.588)"),
    ("sub", "0.211 + 0.044 + 0.056 + 0.055 + 0.198 = 0.564",
     "0.225 + 0.046 + 0.057 + 0.056 + 0.206 = 0.590"),

    # L39070-39072 Euclidean d(O_γ): REAL (dependent). (1-0.725)² = 0.075625; exact sum 1.300025, exact d 1.1402. γ still farthest.
    ("sub", "√[(1-0.62)² + (1-0.60)² + (1-0.58)²", "√[(1-0.725)² + (1-0.60)² + (1-0.58)²"),
    ("sub", "√[0.144 + 0.160 + 0.176 + 0.203 + 0.563 + 0.123]",
     "√[0.076 + 0.160 + 0.176 + 0.203 + 0.563 + 0.123]"),
    ("sub", "√1.369 ≈ 1.170", "√1.301 ≈ 1.141"),

    # L39090-39092 Weighted d_W(O_γ): REAL (dependent). Exact sum 1.85515, exact d 1.3620. β 0.740 still wins.
    ("sub", "√[2.0(0.144) + 1.5(0.160)", "√[2.0(0.076) + 1.5(0.160)"),
    ("sub", "√[0.288 + 0.240 + 0.176 + 0.101 + 1.126 + 0.061]",
     "√[0.152 + 0.240 + 0.176 + 0.101 + 1.126 + 0.061]"),
    ("sub", "√1.992 ≈ 1.411", "√1.856 ≈ 1.362"),

    # L39100 Lexicographic: REAL (dependent). Order β > α > γ unchanged.
    ("sub_eq", "Welfare: β (0.90) > α (0.78) > γ (0.62)", "Welfare: β (0.90) > α (0.78) > γ (0.725)"),

    # L39235-39252 DEME audit JSON: REAL (dependent). FairnessEM order of α and γ swaps (γ 0.561 > α 0.557); β still first everywhere.
    ("sub", "\"γ (B+C): 0.602\"", "\"γ (B+C): 0.644\""),
    ("sub", "\"γ (B+C): 0.567\"", "\"γ (B+C): 0.588\""),
    ("sub", "[\"β (A+C): 0.792\", \"α (A+B): 0.557\", \"γ (B+C): 0.545\"]",
     "[\"β (A+C): 0.792\", \"γ (B+C): 0.561\", \"α (A+B): 0.557\"]"),
    # final scores: α 0.6379, β 0.7930, γ 0.6023 (was 0.5744); β selected.
    ("sub", "0.40*0.602 + 0.30*0.567 + 0.30*0.545", "0.40*0.644 + 0.30*0.588 + 0.30*0.561"),
]
