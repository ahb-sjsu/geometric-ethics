% check_ch25_environment.m -- Ch. 25 (environment): discounting, Th 25.2, Th 25.3
fprintf('\n--- check_ch25_environment: Ch25 ---\n');

% --- L31571: "a dollar of climate damage in 100 years is worth less than a cent today" at 3-5%
for r = [0.03 0.05]
    pvC = exp(-r*100); pvA = (1+r)^-100;
    ge_check('TEXT-Ch25', 31571, pvC < 0.01 && pvA < 0.01, ...
        sprintf('Nordhaus r = 3-5%%: $1 in 100 years worth "less than a cent today" (r = %g%%)', 100*r), ...
        sprintf('PV of $1 at r = %g%%: $%.4f continuous, $%.4f annual compounding', 100*r, pvC, pvA));
end
ge_check('TEXT-Ch25', 31572, exp(-0.001*100) > 0.9, ...
    'Stern r = 0.1%: future damages "nearly as significant as present ones"', sprintf('PV factor at 100 years = %.3f', exp(-0.1)));
ge_check('TEXT-Ch25', 31363, [], ...
    'L31363: "Stern (2006) used a social discount rate of r = 0.1%"', ...
    'by the Ramsey rule the book itself cites (L31620, r = delta + eta*g), 0.1% is Stern''s pure time preference delta; with Stern''s eta = 1, g = 1.3% the discount rate is r = 1.4% (Stern-Review parameters, not stated in the book)');

% --- Theorem 25.2: D_r(a,t) = exp(-r t) pi_1(a) has an 8-dimensional kernel ---
syms r t positive
a = sym('a', [9 1], 'real');
D = exp(-r*t)*a(1);
J = jacobian(D, a);
K = null(subs(J, [r t], [sym(3)/100, 50]));
ge_check('GE-THM-25-2', 31609, rank(J) == 1 && size(K,2) == 8 && all(K(1,:) == 0), ...
    'D_r: R^9 -> R has rank 1, dim ker = 9 - 1 = 8, ker = {a : a_1 = 0} (non-monetary vectors)', sprintf('rank %d, dim ker %d', rank(J), size(K,2)));

% --- Theorem 25.3 proof: discounted sustainable vs collapse paths ----------
syms G gs k positive
syms T positive
V1 = int(G*exp(-r*t), t, 0, k);                  % BGE_1: high yield G until collapse at k, then 0
Vf = int(gs*exp(-r*t), t, 0, T);                 % BGE_full: sustainable yield gs < G forever
VfInf = limit(Vf, T, inf);
num = double(subs([VfInf, V1], [G gs k r], [10 2 5 0.5]));
ge_check('GE-THM-25-3', 31669, num(1) > num(2), ...
    '"For any positive discount rate, there exists a time horizon T beyond which the cumulative d_1 value at BGE_full exceeds ... BGE_1"', ...
    sprintf('with discounting the comparison does not improve with T: BGE_full -> %s, BGE_1 = %s; full wins iff gs > G(1 - e^{-rk}). Example G = 10, gs = 2, k = 5, r = 0.5: %.2f (all T) < %.2f. Holds for undiscounted sums (r = 0) only', ...
    char(simplify(VfInf)), char(simplify(V1)), num(1), num(2)));
V1u = G*k; Vfu = gs*T;
ge_check('GE-THM-25-3', 31667, isAlways(subs(Vfu - V1u, T, 2*G*k/gs) > 0), ...
    'undiscounted: T > G k / gs makes the sustainable path''s cumulative d_1 exceed the collapse path''s', '');

% --- Tragedy of the commons 1/n argument (L31641) ----------------------------
syms B C n positive
ge_check('TEXT-Ch25', 31641, isAlways(subs(B > C/n, [B C n], [1 5 10])) && isAlways(subs(C > B, [B C], [1 5])), ...
    'private benefit B exceeds own share C/n of the shared cost for large n (n > C/B) even when total cost C > B', 'B = 1, C = 5, n = 10');
