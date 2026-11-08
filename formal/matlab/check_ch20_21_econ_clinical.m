% check_ch20_21_econ_clinical.m -- Ch. 20 (economics) and Ch. 21 (clinical)
fprintf('\n--- check_ch20_21_econ_clinical: Ch20-21 ---\n');

% --- Example 20.3: Daraprim $13.50 -> $750.00 "a 5,455% increase" ----------
inc = (sym(750) - sym(27)/2)/(sym(27)/2)*100;
ge_check('TEXT-Ch20', 28494, abs(double(inc) - 5455) <= 0.5, ...
    'Daraprim $13.50 -> $750.00 per tablet = "a 5,455% increase" (tol 0.5 pp)', ...
    sprintf('(750 - 13.50)/13.50 = %s = %.2f%%, which rounds to 5,456%% (the book truncates)', char(inc), double(inc)));

% --- Lemma 20.1: contraction from alpha_i > kappa_i -------------------------
% Proof step "taking the maximum over i, ||T(s)-T(s')|| <= L ||s-s'||" is valid in the
% product sup-norm (||s_{-i}|| <= ||s||). Check it, then test the Euclidean norm.
rng(20); worst = -inf; n = 4; L = 0.6;
for t = 1:5000
    A = randn(n); A(logical(eye(n))) = 0;                  % T_i depends on s_{-i} only
    A = A ./ sum(abs(A),2) * L;                              % sup-norm Lipschitz const of T_i = L
    s = randn(n,1); sp = randn(n,1);
    worst = max(worst, norm(A*(s-sp),inf) - L*norm(s-sp,inf));
end
ge_check('GE-LEMMA-20-1', 28222, worst <= 1e-12, ...
    'max-over-agents step: ||T(s)-T(s'')|| <= max_i(kappa_i/alpha_i) ||s-s''|| (product sup-norm, 5,000 random linear maps)', sprintf('max excess %.3g', worst));
n = 5; L = 0.5; Te = L/sqrt(n-1)*(ones(n) - eye(n));       % |T_i(s)-T_i(s')| <= L ||s_{-i}-s'_{-i}||_2 (Cauchy-Schwarz)
fixedDim = n - rank(eye(n) - Te);
ge_check('GE-LEMMA-20-1', 28213, fixedDim == 0, ...
    '"If alpha_i > kappa_i for all i ... L = max_i(kappa_i/alpha_i) < 1, and the BGE is unique" (norm not specified)', ...
    sprintf('with Euclidean norms: n = 5 agents, kappa_i/alpha_i = 0.5 for each agent, T = (0.5/2)(J - I) has eigenvalue %.2f, fixed-point set of dimension %d -- not unique; the proof''s max-over-i step holds only in the sup-norm (Euclidean constant is L*sqrt(n-1))', ...
    max(eig(Te)), fixedDim));

% --- Theorem 20.6: bilateral conservation (closed exchange) -----------------
syms aA aB d real
ge_check('GE-THM-20-6', 28335, simplify(((aA + d) - aA) + ((aB - d) - aB)) == 0, ...
    'closed bilateral exchange of amount d on a transferable dimension: Da_k(A) + Da_k(B) = 0', '');

% --- Theorem 21.2: kernel of dQ ---------------------------------------------
q = sym('q', [1 9], 'real');
ge_check('GE-THM-21-2', 28930, size(null(sym([3 1 4 1 5 9 2 6 5])),2) == 8 && rank(q) <= 1, ...
    'dQ: R^9 -> R has rank <= 1, so ker dQ has dimension >= 8 (rank-nullity; example gradient)', '8');
ge_check('GE-THM-21-2', 28912, [], ...
    'statement: "Let Q: R^9 -> R be any scalar QALY function ... Q is not injective"', ...
    'true only for continuous Q (the proof uses rank-nullity/regular points); R^9 and R are equinumerous, so a discontinuous injective Q exists. Th 20.2 (L28094) states the continuity hypothesis; Th 21.2, 23.4 (L30335), 26.1 (L32723) do not');

% --- Definition 21.6 / Theorem 21.3: Delta MI >= 0 => MI non-decreasing ------
syms beta tau real; syms ind real
dMI = max(0, beta - tau)*ind;
ok = true; rng(21);
for t = 1:2000
    b = 10*randn; ta = 10*randn; I = randi([0 1]);
    ok = ok && double(subs(dMI, [beta tau ind], [b ta I])) >= 0;
end
ge_check('GE-THM-21-3', 29009, ok, ...
    'Delta MI(t) = sum_k max(0, beta_k - tau) * 1[crossed] >= 0, so MI(T) is non-decreasing', '');

% --- Theorem 21.4 framing example -------------------------------------------
ge_check('GE-THM-21-4', 29055, 1 - sym(90)/100 == sym(10)/100, ...
    '"90% survival rate" and "10% mortality rate" are the same fact (1 - 0.90 = 0.10)', '');

% --- Example 21.1: edge weight of Path B vs Definition 21.2 -----------------
syms da1 da5 s1 s5 positive
wB_def = [da1 da5] * diag([1/s1^2, 1/s5^2]) * [da1; da5];   % Def 21.2 with diagonal Sigma, Da_1, Da_5 ~= 0
wB_book = da1^2/s1^2;
ge_check('TEXT-Ch21', 29212, simplify(wB_def - wB_book) == 0, ...
    'Path B: Da_1 = -moderate, Da_5 = +moderate (trust reinforced); "Edge weight: w_B = (mortality risk)^2 / sigma_1^2"', ...
    sprintf('Def. 21.2 (L28803) gives w_B = Da^T Sigma^-1 Da = %s even for diagonal Sigma: the stated Da_5 ~= 0 adds %s (a quadratic form charges improvements too)', ...
    char(expand(wB_def)), char(simplify(wB_def - wB_book))));
ge_check('TEXT-Ch21', 28874, [], ...
    'Th 21.1 proof: "This is the Heuristic Truncation Theorem of Chapter 11"', ...
    'the Heuristic Truncation Theorem is Theorem 20.1 (Ch 20, L28030); cross-reference, not algebra');
