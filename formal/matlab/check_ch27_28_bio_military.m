% check_ch27_28_bio_military.m -- Ch. 27 (bioethics) and Ch. 28 (military)
fprintf('\n--- check_ch27_28_bio_military: Ch27-28 ---\n');

% --- Theorem 27.1: germline carriers under replacement fertility --------------
syms k positive integer
kids = 2;                               % replacement fertility: 2 children per individual (couple)
pTransmit = sym(1)/2;                   % Mendelian transmission of a heterozygous edit
descendants = kids^k; carriers = (kids*pTransmit)^k;
ge_check('GE-THM-27-1', 34089, isAlways(carriers >= 2^k), ...
    '"all n descendants carry the modification ... affected vertices grows as n(k) >= 2^k (assuming replacement fertility)"', ...
    sprintf('descendants = %s, but each child inherits a heterozygous edit with p = 1/2: expected carriers at generation k = (2 x 1/2)^k = %s (constant), not exponential growth. Prop 27.4 (L34657) itself uses 50%% sharing for first-degree relatives', ...
    char(descendants), char(carriers)));

% --- Theorem 27.5 proof: sign of d^2w/dv^2 ----------------------------------
syms v a4 s44 positive
syms v real
w = (a4 - v)^2/s44;                     % d_4 term of the Mahalanobis weight to target a4 from agent value v
d2 = diff(w, v, 2);
ge_check('GE-THM-27-5', 34519, ~isAlways(d2 > 0, 'Unknown', 'false'), ...
    '"expansion yields d^2w/dv^2 < 0 (negative curvature); restriction yields d^2w/dv^2 > 0"', ...
    sprintf('for the quadratic Mahalanobis weight d^2w/dv^2 = %s > 0 whatever direction v moves (in general 2 (Sigma^-1)_44 > 0); the sign cannot distinguish expansion from restriction', char(d2)));

% --- Prop 27.4: relatedness ---------------------------------------------------
ge_check('GE-PROP-27-4', 34657, (sym(1)/2)^1 == sym(1)/2 && (sym(1)/2)^2 == sym(1)/4, ...
    'first-degree relatives share ~50% of variants, second-degree ~25% (r = 2^-degree)', '');

% --- Theorem 28.2: constrained minimum >= unconstrained minimum ---------------
rng(28); ok = true;
for t = 1:5000
    c = rand(20,1); cross = rand(20,1) < 0.4; beta = 10*rand(20,1);
    cc = c + beta.*cross;               % add boundary penalties
    feas = rand(20,1) < 0.7; if ~any(feas), feas(1) = true; end
    ok = ok && min(cc(feas)) >= min(c) - 1e-12;
end
ge_check('GE-THM-28-2', 35395, ok, ...
    'C_constrained - C_unconstrained >= 0 (penalties >= 0 and a feasible subset cannot lower the minimum; 5,000 random path sets)', '');

% --- Hospital/command-post example: cost count -------------------------------
costs = {'d1 casualties', 'd6 medical infrastructure', 'd2 protected status', 'd4 displacement', 'd5 trust', 'd7 norm'};
ge_check('TEXT-Ch28', 35489, numel(costs) == 6, ...
    '"The scalar test captures only the first; the geometric test captures all six" (d1 + d6, d2, d4, d5, d7)', '6');

% --- Theorem 28.5: beta_effective = beta_civilian * P(civilian | obs) ----------
ge_check('GE-THM-28-5', 35600, [], ...
    'with beta_civilian = infinity, "nearly every engagement carries near-infinite expected boundary cost" via base rate > 0.9', ...
    sprintf('Inf * p = %g for every p > 0 (even p = 0.01), so the base-rate argument is not needed; at p = 0 the product is undefined (Inf*0 = %g)', Inf*0.01, Inf*0));

% --- Example 28.3: TRC reparations and amnesty -------------------------------
ge_check('TEXT-Ch28', 36174, 30000 < 21000*6, ...
    'reparations: recommended 21,000 rand/yr x 6 yr vs one-time 30,000 rand "far less than recommended"', ...
    sprintf('126,000 vs 30,000 rand (%.1f%%)', 100*30000/126000));
ge_check('TEXT-Ch28', 36149, 1512 < 7112, ...
    'amnesty: "Of the 7,112 amnesty applications filed, only 1,512 were granted"', sprintf('%.1f%% granted', 100*1512/7112));
