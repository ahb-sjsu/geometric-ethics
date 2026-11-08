% check_ch16_uncertainty.m -- Geometric Ethics v1.24, Chapter 16 (moral uncertainty)
fprintf('\n--- check_ch16: moral uncertainty ---\n');

%% 20832: |psi> = sum_k sqrt(c_k)|T_k> is normalised when sum c_k = 1
syms ca cb positive
cc = [ca cb 1 - ca - cb];
ge_check('TEXT-Ch16', 20832, isAlways(simplify(sum(sqrt(cc).^2) - 1) == 0), 'sum_k (sqrt c_k)^2 = 1', '');

%% 20953 vs Prop 16.4: hedging penalty sqrt(sum_jk c_j c_k (S_j - S_k)^2) = sqrt(2) std_c(S)
Sv = sym('S', [1 3]);
pen = 0;
for j = 1:3, for k = 1:3, pen = pen + cc(j)*cc(k)*(Sv(j) - Sv(k))^2; end, end
mu = sum(cc.*Sv); vr = sum(cc.*(Sv - mu).^2);
ge_check('TEXT-Ch16', 20953, isAlways(simplify(expand(pen - 2*vr)) == 0), ...
    'sum_jk c_j c_k (S_Tj - S_Tk)^2 = 2 Var_c(S)  (so 20953 penalty = sqrt2 * std of Prop 16.4; lambda rescales)', '');

%% Prop 16.1 (21147-21163): perturbation bound |sum_k dc_k s_k| <= eps max_k |s_k|
s4 = [1 1 0.01 0.01]; ep = 1e-3; dc = 0.99*ep*[1 1 -1 -1];   % sum dc = 0, |dc_k| < eps
lhs = abs(dc*s4.');
ge_check('GE-PROP-16-1', 21160, lhs <= ep*max(abs(s4)), ...
    '"perturbation ... is bounded by eps * max_k |I^(k)_mu O^mu|"', ...
    sprintf('m = 4 theories, s = (1,1,.01,.01), dc = .99 eps (1,1,-1,-1): |sum dc_k s_k| = %.4g eps > eps max|s_k|; valid bound is eps sum_k |s_k| (<= m eps max|s_k|)', lhs/ep));
okS = true; rng(16);
for t = 1:2000
    m = randi([2 6]); s = rand(1, m) + 1e-3; c = rand(1, m); c = c/sum(c);
    okS = okS && (c*s.' > 0);
end
ge_check('GE-PROP-16-1', 21156, okS, 'conclusion: S_MEC = sum c_k s_k > 0 for O in the robust core (all s_k > 0), any credences', '');

%% Prop 16.2 (21544-21558): robust core nonempty iff 0 not in conv{I^(k)} (Gordan) -- LP test
opts = optimoptions('linprog', 'Display', 'off');
rng(162); agree = true; nTot = 0;
for t = 1:300
    n = 3; m = randi([2 5]);
    Ik = randn(m, n);
    if mod(t, 3) == 0, Ik = [Ik; -Ik(1, :)*rand]; m = m + 1; end      % force some opposed sets
    % core: max tau s.t. Ik*O >= tau, -1 <= O <= 1, tau <= 1
    f = [zeros(n, 1); -1];
    A = [-Ik, ones(m, 1)]; b = zeros(m, 1);
    lb = [-ones(n, 1); -Inf]; ub = [ones(n, 1); 1];
    [z, ~, fl] = linprog(f, A, b, [], [], lb, ub, opts);
    coreNonempty = fl == 1 && z(end) > 1e-9;
    % hull: exists lambda >= 0, sum lambda = 1, Ik' lambda = 0
    [~, ~, fl2] = linprog(zeros(m, 1), [], [], [Ik.'; ones(1, m)], [zeros(n, 1); 1], zeros(m, 1), [], opts);
    zeroInHull = fl2 == 1;
    agree = agree && (coreNonempty ~= zeroInHull); nTot = nTot + 1;
end
ge_check('GE-PROP-16-2', 21557, agree, ...
    sprintf('robust core nonempty iff 0 not in conv{I^(k)} (LP on %d random covector sets in R^3)', nTot), '');
syms i1 i2 i3 positive
ge_check('GE-PROP-16-2', 21562, isAlways([i1 i2 i3]*[1;0;0] > 0), 'Corollary: I_mu^(k) > 0 for all k => e_mu in the core', '');

%% Prop 16.4 (21600-21629): lambda -> infinity hedging vs minimax regret
Sa = [0 0; 10 9];                 % rows: actions a1, a2; columns: theories T1, T2
cw = [0.5 0.5];
Sbar = Sa*cw.'; sd = sqrt(((Sa - Sbar).^2)*cw.');
lam = 1e6; [~, aH] = max(Sbar - lam*sd);
reg = max(Sa, [], 1) - Sa; [~, aR] = min(max(reg, [], 2));
ge_check('GE-PROP-16-4', 21605, aH == aR, ...
    '"hedging a* = argmax[sum c_k S_k(a) - lambda std_k S_k(a)] converges, as lambda -> inf, to the minimax-regret strategy"', ...
    sprintf('S(a1) = (0,0), S(a2) = (10,9), c = (1/2,1/2): lambda -> inf picks a%d (std 0, max regret %g); minimax regret picks a%d (max regret %g). Min-std is not min-max-regret (21619 "equivalent to minimizing sigma(a)" does not give regret)', ...
    aH, max(reg(aH, :)), aR, max(reg(aR, :))));
[~, a0] = max(Sbar);
ge_check('GE-PROP-16-4', 21626, a0 == 2, 'lambda = 0 gives the MEC objective', '');
