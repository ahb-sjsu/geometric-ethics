% check_ch23_finance.m -- Ch. 23 (finance)
fprintf('\n--- check_ch23_finance: Ch23 ---\n');

% --- Theorem 23.1 proof: "Mahalanobis distance ... is smaller when Da_9 is small"
Sinv = [1 0.9; 0.9 1];                 % (d_1, d_9) block of Sigma_F^-1, positive definite
Q = @(da) da*Sinv*da.';
far = Q([1 -0.9]); near = Q([1 0]);
ge_check('GE-THM-23-1', 30201, near < far, ...
    'proof: Da^T Sigma_F^-1 Da "is smaller when Da_9 is small"', ...
    sprintf('with a d1-d9 cross term (Sigma^-1 = [1 .9; .9 1], PD): Da = (1, -0.9) gives %.2f but Da = (1, 0) gives %.2f; the quadratic is minimised at Da_9 = -(Sigma^-1)_91 Da_1/(Sigma^-1)_99, not at 0 -- the step needs no d9 cross terms', ...
    far, near));

% --- Theorem 23.2 proof: d_1-only Mahalanobis weight --------------------------
syms s11 Dt positive; syms s12 real
s22 = (s12^2 + Dt)/s11;                % parametrises every PD 2x2 Sigma (det = Dt > 0)
Sg = [s11 s12; s12 s22]; Si = simplify(inv(Sg));
ge_check('GE-THM-23-2', 30256, [], ...
    'w_alg = (Da_1)^2 / sigma_11 is the marginal (1-D) Mahalanobis weight', ...
    'it equals the d_1 term Da_1^2 (Sigma^-1)_11 of the full form only when sigma_1j = 0. Same expression at L33111 (Th 26.6) and L35694 (Th 28.6)');
v = simplify(Si(1,1) - 1/s11);
ge_check('GE-THM-23-2', 30256, isAlways(v >= 0, 'Unknown', 'false'), ...
    '(Sigma^-1)_11 - 1/sigma_11 = sigma_12^2/(sigma_11 det Sigma) >= 0 for PD Sigma, so the 1-D weight never exceeds the full-form d_1 term', char(v));

% --- Theorem 23.5: closed bilateral conservation -----------------------------
syms d real
ge_check('GE-THM-23-5', 30383, simplify(d + (-d)) == 0, 'closed transfer d on d_1/d_2/d_4: Da_k(A) + Da_k(B) = 0', '');

% --- Theorem 23.6: bubble condition f = g + h_market < g + h* -----------------
syms g0 hm hs real
ge_check('GE-THM-23-6', 30434, isAlways(subs((g0 + hm) < (g0 + hs), [hm hs], [-1 2])), ...
    'h_market < 0 < h* implies f_market = g + h_market < g + h* (bubble path under-costed)', '');
