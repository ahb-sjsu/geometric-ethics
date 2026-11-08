% check_ch14_collective.m -- Geometric Ethics v1.24, Chapter 14 (collective moral agency)
fprintf('\n--- check_ch14: collective agency ---\n');

%% 18301-18304, 18344-18345: component counts
ge_check('TEXT-Ch14', 18301, 9 + 9 == 18 && 9*9 == 81 && 81 - 18 == 63, ...
    'direct sum 9+9=18, tensor product 9x9=81, extra 81-18=63', '');
ge_check('TEXT-Ch14', 18344, 9^3 == 729 && 9^4 == 6561, ...
    'two-agent (1,2)-tensor 9^3=729; three-agent rank-4 9^4=6561', '');

%% 18397: Shapley formula -- efficiency and symmetry for a generic 3-player game
syms v1 v2 v3 v12 v13 v23 v123
vv = containers.Map({'', '1','2','3','12','13','23','123'}, {sym(0), v1, v2, v3, v12, v13, v23, v123});
key = @(S) char(sort(S));
N = '123'; phi = sym(zeros(1,3));
for i = 1:3
    rest = setdiff(N, N(i));
    for m = 0:2^numel(rest)-1
        S = rest(logical(bitget(m, 1:numel(rest))));
        wgt = factorial(numel(S))*factorial(3 - numel(S) - 1)/factorial(3);
        phi(i) = phi(i) + wgt*(vv(key([S N(i)])) - vv(key(S)));
    end
end
ge_check('TEXT-Ch14', 18397, simplify(sum(phi) - v123) == 0, ...
    'Shapley phi_i: efficiency sum_i phi_i = v(N) (generic 3-player game)', char(simplify(sum(phi))));
phs = subs(phi, [v1 v2 v13 v23], [v2 v1 v23 v13]);   % swap players 1,2
ge_check('TEXT-Ch14', 18397, simplify(phs(1) - phi(2)) == 0, 'Shapley symmetry (swap players 1,2)', '');

%% 18496: antisymmetric part of the CEO/employee structure tensor
ge_check('TEXT-Ch14', 18496, (sym(8)/10 - sym(2)/10)/2 == sym(3)/10, ...
    'Sigma_[CE] = (0.8 - 0.2)/2 = 0.3', '');

%% Prop 14.3 (19243-19267): inclusion-exclusion decomposition, n = 2 agents, d = 2 values per index
% Book: C_(k) = Tr_{\k} C (marginal), C_(jk) = Tr_{\jk} C - C_(j) x delta - delta x C_(k),
% and "Pi_S Pi_S' = delta_SS' Pi_S (orthogonality), sum_S Pi_S = id (completeness)".
% Reading 1 (normalised trace = average, delta = uniform):
d = 2;
P1 = @(C) mean(C, 2)*ones(1, d);
P2 = @(C) ones(d, 1)*mean(C, 1);
P12 = @(C) C - P1(C) - P2(C);
Csym = sym('c', [d d]);
ge_check('GE-PROP-14-3', 19266, simplify(P1(Csym) + P2(Csym) + P12(Csym) - Csym) == zeros(d), ...
    'completeness sum_S Pi_S = id', '');
J = ones(d);   % a constant collective tensor
o1 = P1(P12(J)); o2 = P12(P12(J));
ge_check('GE-PROP-14-3', 19267, all(abs(o1(:)) < 1e-12) && all(abs(o2(:) - reshape(P12(J), [], 1)) < 1e-12), ...
    'Pi_S Pi_S'' = delta_SS'' Pi_S with C_(k) = marginal, C_(jk) = Tr C - C_(j) - C_(k)', ...
    sprintf('C = all-ones: Pi_12 C = -J, Pi_1 Pi_12 C = %g*J (not 0), Pi_12 Pi_12 C = %g*J (not Pi_12 C = -J); the 0-body term (full trace) is missing: Moebius needs C_(jk) = Tr C - C_(j) - C_(k) + C_(empty)', o1(1), o2(1)));
% Reading 2 (raw trace, delta = all-ones covector): Pi_1 is not idempotent
Q1 = @(C) sum(C, 2)*ones(1, d);
q = Q1(Q1(J)) - Q1(J);
ge_check('GE-PROP-14-3', 19267, all(q(:) == 0), ...
    'Pi_1 Pi_1 = Pi_1 (raw-trace reading)', sprintf('raw trace: Pi_1 Pi_1 = d*Pi_1 (d = %d; d = 9 on M)', d));

%% Prop 14.1 proof supplement (18575-18583): orthogonality <C_j, C_k> = 0 and the Moebius relation
Cr = [1 2; 3 5];
ip = sum(sum((P1(Cr) + P2(Cr)) .* P12(Cr)));
ge_check('GE-PROP-14-1', 18579, abs(ip) < 1e-12, ...
    '<C_j, C_k> = 0 for j ~= k (1-body vs 2-body parts, Frobenius)', ...
    sprintf('C = [1 2;3 5]: <C_1-body, C_2-body> = %g (not 0); orthogonality needs centring (Hoeffding/ANOVA), i.e. the 0-body term', ip));
n = 3; k = 1; Sp = 2;   % |S'| ~= k
moeb = nchoosek(n, k)*(-1)^k*(-1)^Sp;
ge_check('GE-PROP-14-1', 18583, moeb == 0, ...
    '"sum_{S:|S|=k} mu(S) mu(S'') = 0 for |S''| ~= k" (Boolean lattice, mu(S) = (-1)^|S|)', ...
    sprintf('n=3, k=1, |S''|=2: sum = C(3,1)(-1)^1(-1)^2 = %d (nonzero; in general C(n,k)(-1)^(k+|S''|))', moeb));

%% Prop 14.4 and 14.12 hospital example (19166-19169)
syms Ra1 Ra2 real
syms RE real
assume(RE >= 0);
ge_check('GE-PROP-14-4', 19284, Ra1 + Ra2 + RE >= Ra1 + Ra2, 'R_coll = sum R_a + R_E >= sum R_a when R_E >= 0', '');
Rm = sym([30 15 20 15 10])/100;
ge_check('GE-PROP-14-4', 19168, sum(Rm) == sym(9)/10 && 1 - sum(Rm) == sym(1)/10, ...
    'R = 0.30+0.15+0.20+0.15+0.10 = 0.90; Delta R = 1.00 - 0.90 = 0.10', char(sum(Rm)));

%% 18639 vs 18667: "gap" vs "surplus"
% 18639: gap if sum R_a < R_coll, surplus if sum R_a > R_coll.  18667: mob has Delta R = R_coll - sum R_a > 0 "surplus".
Rcoll = 1; sumRa = 0.9; DR = Rcoll - sumRa;
isGap = sumRa < Rcoll;
ge_check('TEXT-Ch14', 18667, ~isGap, ...
    '18667: mob "responsibility surplus Delta R > 0" (Delta R = R_coll - sum R_a, 18646)', ...
    sprintf('Delta R = %.2f > 0 means sum R_a < R_coll, which 18639 defines as a "responsibility gap", not a surplus', DR));

%% Prop 14.5 (19293-19316): delta O_coll = Lambda int dSigma + O(dSigma^2)
syms o s0 sd e
syms Cf(oo, ss)
lhs = Cf(o, s0 + e*sd) - Cf(o, s0);
t1 = taylor(lhs, e, 'Order', 2);
Lam = subs(diff(Cf(oo, ss), ss), {oo, ss}, {o, s0});
ge_check('GE-PROP-14-5', 19299, simplify(t1 - e*Lam*sd) == 0, ...
    'with individual obligations transported (O fixed), delta O_coll = (dC/dSigma) dSigma + O(dSigma^2)', char(t1));
ge_check('GE-PROP-14-5', 19316, simplify(subs(lhs, sd, 0)) == 0, 'Sigma constant => delta O_coll = 0', '');

%% Def 14.6 (18811): "nabla O + Gamma gamma' O + Lambda Sigma' = 0" -- Christoffel term counted twice
% flat plane, polar coordinates (r, th), unit circle r = 1, gamma'(t) = (0, 1); O = constant Cartesian e_x
syms t real
r = sym(1); Om = [cos(t); -sin(t)/r];                 % polar components of e_x on the circle
Gam = sym(zeros(2,2,2)); Gam(1,2,2) = -r; Gam(2,1,2) = 1/r; Gam(2,2,1) = 1/r;
gd = [0; 1];
GO = sym(zeros(2,1));
for mu = 1:2, for nu = 1:2, for rh = 1:2
    GO(mu) = GO(mu) + Gam(mu,nu,rh)*gd(nu)*Om(rh);
end, end, end
nablaO = simplify(diff(Om, t) + GO);                   % covariant derivative along the circle
ge_check('TEXT-Ch14', 18811, all(isAlways(nablaO == 0)), 'reference: e_x is parallel along the circle (nabla O = 0)', char(nablaO.'));
bookLHS = simplify(nablaO + GO);                       % book's equation with Sigma' = 0
ge_check('TEXT-Ch14', 18822, all(isAlways(bookLHS == 0, 'Unknown', 'false')), ...
    '18811/18822: nabla O + Gamma gamma'' O + Lambda Sigma'' = 0 "reduces to individual transport" when Sigma'' = 0', ...
    sprintf('a parallel-transported O gives nabla O + Gamma gamma'' O = [%s] ~= 0: Gamma is counted twice; the equation should be dO/dt + Gamma gamma'' O + Lambda Sigma'' = 0 (or nabla O + Lambda Sigma'' = 0)', char(bookLHS.')));
