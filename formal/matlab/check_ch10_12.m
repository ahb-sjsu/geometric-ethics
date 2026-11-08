% check_ch10_12.m -- Geometric Ethics v1.24, Chapters 10-12:
% transport / holonomy / geodesic deviation (Props 10.1-10.3), worked examples
% 10.4, 10.5, 10.10; A* example and complexity arithmetic (Ch.11, Thm 11.2,
% Props 11.2-11.3); Euler-Lagrange, Noether / invariance of harm accounting
% (Thm 12.1, Thm A.1, Cor A.1). D4 material (Thm 12.2-12.3, Prop A.2,
% Lemma A.2) is skipped.
warning('off', 'symbolic:sym:isAlways:TruthUnknown');
fprintf('\n--- check_ch10_12: dynamics, search, Noether ---\n');

%% Prop 10.1 (L14485): S = I_mu O^mu constant when O and I are both transported
n = 3;
Gam = sym('G', [n n n]);        % arbitrary connection coefficients Gamma^m_{a b} at a point
gd  = sym('u', [n 1]);          % curve velocity
O = sym('O', [n 1]); I = sym('I', [n 1]);
dO = sym(zeros(n,1)); dI = sym(zeros(n,1));
for m = 1:n, for a = 1:n, for b = 1:n
    dO(m) = dO(m) - Gam(m,a,b)*gd(a)*O(b);     % dO^m/dt = -Gamma^m_ab u^a O^b
    dI(b) = dI(b) + Gam(m,a,b)*gd(a)*I(m);     % dI_b/dt = +Gamma^m_ab u^a I_m
end, end, end
ge_check('GE-PROP-10-1', 14485, isAlways(simplify(dI.'*O + I.'*dO) == 0), ...
    'd/dt(I_mu O^mu) = 0 for parallel-transported O and I (holds for any connection)');

%% Prop 10.3 (L14550): geodesic deviation sign, unit sphere (K = +1)
syms th ph real
Gs = [1 0; 0 sin(th)^2]; Xs = [th ph];
Gm = ge_christoffel(Gs, Xs); R = ge_riemann(Gm, Xs);
u = [0; 1]; xi = [1; 0];        % equator geodesic along phi, separation along theta
acc = sym(zeros(2,1));
for mu = 1:2, for nu = 1:2, for al = 1:2, for be = 1:2
    acc(mu) = acc(mu) + R(mu,nu,al,be)*u(nu)*u(al)*xi(be);
end, end, end, end
acc = simplify(subs(acc, th, sym(pi)/2));
ge_check('GE-PROP-10-3', 14550, isAlways(acc(1) == -1) && isAlways(acc(2) == 0), ...
    'D^2 xi/dt^2 = R^mu_{nu a b} u^nu u^a xi^b gives -K xi on the unit sphere (nearby geodesics converge)', char(acc.'));

%% Prop 10.2 (L14528): holonomy of a small loop = R^mu_{nu a b} O^nu dA^{ab}
th0 = 1.0; ep = 1e-3; O0 = [0.3; 0.8];
GmF = matlabFunction(Gm, 'Vars', {th, ph});
legs = {[1 0], [0 1], [-1 0], [0 -1]};       % +theta, +phi, -theta, -phi
x = [th0; 0]; Ov = O0;
opts = odeset('RelTol', 1e-13, 'AbsTol', 1e-16);
for L = 1:4
    dirv = legs{L}(:);
    rhs = @(s, y) ge_pt_rhs(GmF, y, dirv);
    [~, Y] = ode45(rhs, [0 ep], [x; Ov], opts);
    x = Y(end, 1:2).'; Ov = Y(end, 3:4).';
end
dOnum = (Ov - O0) / ep^2;
Rn = double(subs(R, th, th0));
pred = zeros(2,1);
for mu = 1:2, for nu = 1:2, pred(mu) = pred(mu) + Rn(mu,nu,1,2)*O0(nu); end, end
relerr_plus  = norm(dOnum - pred)/norm(pred);
relerr_minus = norm(dOnum + pred)/norm(pred);
ge_check('GE-PROP-10-2', 14528, relerr_plus < 1e-2, ...
    'loop e_alpha then e_beta: H(O)^mu - O^mu = +R^mu_{nu alpha beta} O^nu dA^{alpha beta}', ...
    sprintf('numerical holonomy (sphere, theta0=1, eps=1e-3) = (%.4f,%.4f), R O = (%.4f,%.4f); rel.err vs +R: %.2e, vs -R: %.2e', ...
    dOnum, pred, relerr_plus, relerr_minus));

%% 10.4 example (L13708) and 10.5 example (L13793): metric-compatible transport
O0a = [0 .8 0 0 0 0 .4 0 0]; O1a = [.5 .3 0 0 0 0 .4 0 0];
ge_check('TEXT-Ch10', 13708, [], 'O(0)=(0,0.8,..,0.4,..) -> O(1)~(0.5,0.3,..,0.4,..) "rotated" under Levi-Civita transport', ...
    sprintf('Euclidean norms %.3f -> %.3f; consistent with norm preservation only if g differs between the two contexts', norm(O0a), norm(O1a)));
Hb = [0 0 0 0 .1 0 .35 0 .05]; Ob = [0 0 0 0 0 0 .5 0 0];
ge_check('TEXT-Ch10', 13793, [], 'holonomy H(O): (.., O^7=0.5, ..) -> (0,0,0,0,0.1,0,0.35,0,0.05)', ...
    sprintf('Levi-Civita holonomy is g_p-orthogonal; Euclidean norms %.3f -> %.3f, so g_p cannot be the identity here (needs 0.1275 g77 = 0.01 g55 + 0.0025 g99 for diagonal g)', norm(Ob), norm(Hb)));

%% 10.10 worked example (L14308-14359)
G1 = sym(3)/10; G2 = -sym(15)/100; O2 = sym(8)/10;
syms dx4 real
dO1 = -G1*dx4*O2; dO2 = -G2*dx4*O2;          % first-order transport step
sol = solve(sym(1)/10 + dO1 == sym(34)/100, dx4);
ge_check('TEXT-Ch10', 14314, isAlways(subs(sym(8)/10 + dO2, dx4, sol) == sym(68)/100), ...
    'O(t1) ~ (0.34, 0.68, ...) from Gamma^1_{4,2}=0.3, Gamma^2_{4,2}=-0.15 (first-order step)', ...
    sprintf('consistent: both components fit one step dx^4 = %s', char(sol)));
dxs = double(sol); O2ex = 0.8*exp(0.15*dxs); O1ex = 0.1 - 0.3*0.8/0.15*(exp(0.15*dxs) - 1);  % exact 2-component transport ODE
ge_check('TEXT-Ch10', 14314, [], 'step direction / exact ODE', ...
    sprintf('fit needs dx^4 = %s (a move toward LOWER x^4); exact transport ODE over that step gives (%.3f, %.3f) vs first-order (0.34, 0.68)', char(sol), O1ex, O2ex));
Ot3 = sym([5 0 5 10 0 25])/100;
ge_check('TEXT-Ch10', 14359, isAlways(all(Ot3 - 0 == sym([5 0 5 10 0 25])/100)), ...
    'H(O(t0)) - 0 = O(t3) = (0.05,0,0.05,0.1,0,0.25)');

%% Ch.11 A* worked example (L15462-15470)
h = [95 70 30 55]; gb = [5 10 15 12];      % continue, swerve right, brake hard, swerve left
f = h + gb;
[~, best] = min(f);
ge_check('TEXT-Ch11', 15469, isequal(f, [100 80 45 67]) && best == 3, ...
    'f = g + h: continue 100, swerve right 80, swerve left 67, brake 45 -> brake hard');

%% Thm 11.2 arithmetic (L15130-15131, L15638-15640)
Nv = sym(100)^9;
ge_check('GE-THM-11-2', 15130, Nv == sym(10)^18, 'eps = 0.01, d = 9: N = (1/eps)^9 = 10^18 per stratum');
edgesN2 = double(Nv)^2;
ge_check('GE-THM-11-2', 15131, edgesN2 <= 10*double(Nv), '"the edge count [is] on the order of m * 10^18"', ...
    'with the O(N^2) edges assumed in the same step, edges ~ m * 10^36 (a pure grid gives (3^9-1) N ~ 2e22)');
T2 = 3 * 1e36 * 81 * log2(3e18); Te = 3 * 1e36 * 81 * log(3e18); T10 = 3 * 1e36 * 81 * log10(3e18);
ge_check('GE-THM-11-2', 15638, abs(T2/1.5e40 - 1) < 0.05, ...
    'T ~ 3 * 100^18 * 81 * log(3*10^18) ~ 1.5e40 operations', ...
    sprintf('log2: %.3g, ln: %.3g, log10: %.3g', T2, Te, T10));
ge_check('GE-THM-11-2', 15638, [], 'log base in T', sprintf('1.5e40 matches log base 2 (%.3g); natural log would give %.3g', T2, Te));
yrs = 1.5e40 / 1e10 / (365.25*86400);
ge_check('GE-THM-11-2', 15640, abs(yrs/4.8e22 - 1) < 0.02, '1.5e40 / 1e10 ops/s = 1.5e30 s ~ 4.8e22 years', sprintf('%.3g years', yrs));

%% Prop 11.3 (L15222-15224): S = I_mu O^mu = -I_mu g^{mu nu} d_nu h
syms y1 y2 real
hh = str2sym('h(y1,y2)');
G = [2 1; 1 3]; Iv = sym('I', [2 1]);
Ovec = -inv(G) * [diff(hh, y1); diff(hh, y2)];
S = Iv.' * Ovec;
Isharp = inv(G) * Iv;                                     % vector metrically dual to I
Dh = Isharp.' * [diff(hh, y1); diff(hh, y2)];             % directional derivative along I#
ge_check('GE-PROP-11-3', 15224, isAlways(simplify(S + Dh) == 0), 'S = -I_mu g^{mu nu} d_nu h (formula)');
ge_check('GE-PROP-11-3', 15222, isAlways(simplify(S - Dh) == 0), ...
    '"the satisfaction scalar is the directional derivative of h in the interest direction"', ...
    'S = -D_{I#} h: minus the directional derivative along I# (the displayed formula has the minus; the sentence omits it)');

%% Prop 11.2 (L15604): h = d_g(n,G) is consistent (triangle inequality), random test
rng(3); P = randn(200, 3); goal = [0 0 0]; ok = true;
for k = 1:199
    hn = norm(P(k,:) - goal); hn2 = norm(P(k+1,:) - goal); c = norm(P(k,:) - P(k+1,:));
    ok = ok && (hn <= c + hn2 + 1e-12);
end
ge_check('GE-PROP-11-2', 15604, ok, 'h(n) = d(n,G) satisfies h(n) <= c(n,n'') + h(n'') (Euclidean spot test, 199 pairs)');

%% Ch.12 Noether (physics form) L15792-15795: J = dL/dqdot dq - F
syms t gg real
syms q(t)
L = diff(q,t)^2/2 - gg*q;               % constant force; translation dq = 1, dL = -gg = d/dt(-gg t)
Fb = -gg*t;
J = diff(q,t)*1 - Fb;
EL = diff(diff(q,t), t) + gg;          % Euler-Lagrange residual (= 0 on solutions)
dJ = diff(J, t);
ge_check('TEXT-Ch12', 15795, isAlways(simplify(dJ - EL) == 0), ...
    'J = (dL/dqdot) dq - F conserved when dL = dF/dt (check: constant force, J = qdot + g t, dJ/dt = EL residual)');

%% Euler-Lagrange (L16180): g ddx + Gamma_{mu nu rho} dx dx = -dV for L = 1/2 g dx dx - V
syms X1 X2 V1 V2 A1 A2 real
syms a(X1,X2) b(X1,X2) c(X1,X2) Vp(X1,X2)
XX = [X1 X2]; VV = [V1 V2]; AA = [A1 A2];
Gf = [a(X1,X2) b(X1,X2); b(X1,X2) c(X1,X2)];
Lag = VV*Gf*VV.'/2 - Vp(X1,X2);
ELv = sym(zeros(2,1)); rhsBook = sym(zeros(2,1));
for mu = 1:2
    pmu = diff(Lag, VV(mu));
    ddt = 0;                                   % total time derivative via chain rule
    for j = 1:2, ddt = ddt + diff(pmu, XX(j))*VV(j) + diff(pmu, VV(j))*AA(j); end
    ELv(mu) = ddt - diff(Lag, XX(mu));
    s2 = 0;
    for nu = 1:2
        s2 = s2 + Gf(mu,nu)*AA(nu);
        for rh = 1:2
            G1k = (diff(Gf(mu,nu), XX(rh)) + diff(Gf(mu,rh), XX(nu)) - diff(Gf(nu,rh), XX(mu)))/2;
            s2 = s2 + G1k*VV(nu)*VV(rh);
        end
    end
    rhsBook(mu) = s2 + diff(Vp(X1,X2), XX(mu));   % book: LHS + d_mu V = 0
end
ge_check('GE-THM-12-1', 16180, all(isAlways(simplify(ELv - rhsBook) == 0)), ...
    'Euler-Lagrange of L = 1/2 g x''x'' - V gives g_{mu nu} x''''^nu + Gamma_{mu nu rho} x''^nu x''^rho = -d_mu V (generic 2-D metric)');

%% Thm 12.1 (L16253-16266): H = p_mu xi^mu conserved when L is invariant
% example: g = diag(1, k(x1)), V = V(x1), xi = d/dx2 (L invariant under x2 shifts)
syms x1(t) x2(t)
syms kf(t1) Vf(t1)
Lx = diff(x1,t)^2/2 + kf(x1)*diff(x2,t)^2/2 - Vf(x1);
H = kf(x1)*diff(x2,t);                           % p_2
% EL for x2: d/dt (k x2') = 0  => dH/dt equals that EL expression identically
ge_check('GE-THM-12-1', 16266, isAlways(simplify(diff(H, t) - diff(kf(x1)*diff(x2,t), t)) == 0), ...
    'dH/dt = d/dt(dL/dx''^2) = dL/dx^2 = 0 when L does not depend on x^2 (xi = d/dx^2)');

%% Thm A.1 (L16764-16782) on the unit sphere: xi = d/dphi is Killing and H = sin^2(th) phi' is conserved
Xs = [th ph];
xiS = [0; 1]; xilow = Gs*xiS;
Kill = sym(zeros(2));
for m = 1:2, for nn = 1:2
    cm = diff(xilow(nn), Xs(m)); cn = diff(xilow(m), Xs(nn));
    for l = 1:2, cm = cm - Gm(l,m,nn)*xilow(l); cn = cn - Gm(l,nn,m)*xilow(l); end
    Kill(m,nn) = simplify(cm + cn);
end, end
ge_check('GE-THM-A-1', 16764, all(isAlways(Kill(:) == 0)), 'xi = d/dphi satisfies Killing''s equation on S^2');
syms TH(t) PH(t)
Hs = sin(TH)^2*diff(PH,t);
geo1 = diff(TH,t,2) - sin(TH)*cos(TH)*diff(PH,t)^2;                 % = 0 on geodesics
geo2 = diff(PH,t,2) + 2*cos(TH)/sin(TH)*diff(TH,t)*diff(PH,t);      % = 0 on geodesics
dHs = diff(Hs, t);
dHs = subs(dHs, diff(PH,t,2), diff(PH,t,2) - geo2);
ge_check('GE-THM-A-1', 16768, isAlways(simplify(dHs) == 0), 'H = g(gamma'', xi) = sin^2(th) phi'' conserved along S^2 geodesics');
% With a potential: the proof (L16771) uses nabla_g' g' = -grad V; then dH/dt = -xi.dV
syms z1(t) z2(t)
Hf = diff(z2, t);                       % flat R^2, xi = d/dz2, H = z2'
Vlin = z2;                              % V = z2 breaks the symmetry
dHf = -diff(Vlin, z2);                  % z2'' = -dV/dz2
ge_check('GE-THM-A-1', 16771, isAlways(dHf == 0), ...
    'Thm A.1 as stated: xi Killing => H conserved along "geodesics" satisfying nabla_g'' g'' = -grad V', ...
    'dH/dt = -xi^nu d_nu V (here -1 for flat R^2, xi = d/dz2, V = z2): the hypothesis xi.dV = 0 used in the proof is missing from the statement (true for V = 0 geodesics)');

%% Cor A.1 (L16790): n(n+1)/2 Killing vectors; 45 for n = 9 (flat-space check n = 3)
% linear part A of xi = A z + b must satisfy A + A' = 0; nullity of vec(A) -> vec(A + A')
Kop = zeros(9);
for kk = 1:9, Eb = zeros(3); Eb(kk) = 1; Kop(:, kk) = reshape(Eb + Eb.', 9, 1); end
freeA = 9 - rank(Kop);
ge_check('GE-COR-A-1', 16790, freeA + 3 == 3*4/2 && 9*10/2 == 45, ...
    'maximally symmetric n-manifold has n(n+1)/2 Killing vectors; n = 9 -> 45 (flat R^3 check: 3 translations + 3 rotations = 6)');

%% L15908-15910: abelian F = dA invariant under A -> A + d alpha
syms w1 w2 real
A1 = str2sym('A1(w1,w2)'); A2 = str2sym('A2(w1,w2)'); al = str2sym('al(w1,w2)');
Fo = diff(A2, w1) - diff(A1, w2);
Fn = diff(A2 + diff(al, w2), w1) - diff(A1 + diff(al, w1), w2);
ge_check('TEXT-Ch12', 15908, isAlways(simplify(Fn - Fo) == 0), 'F_{mu nu} = d_mu A_nu - d_nu A_mu invariant under A -> A + d alpha');

%% L16051: CHSH bound |S| <= 2 classically, up to 2 sqrt 2 ~ 2.83 (Tsirelson)
sx = [0 1; 1 0]; sz = [1 0; 0 -1];
psi = [1; 0; 0; 1]/sqrt(2);
Aop = {sz, sx}; Bop = {(sz + sx)/sqrt(2), (sz - sx)/sqrt(2)};
E = @(Am, Bm) psi' * kron(Am, Bm) * psi;
Sq = E(Aop{1},Bop{1}) + E(Aop{1},Bop{2}) + E(Aop{2},Bop{1}) - E(Aop{2},Bop{2});
best = 0;
for a1 = [-1 1], for a2 = [-1 1], for b1 = [-1 1], for b2 = [-1 1]
    best = max(best, abs(a1*b1 + a1*b2 + a2*b1 - a2*b2));
end, end, end, end
ge_check('TEXT-Ch12', 16051, abs(Sq - 2*sqrt(2)) < 1e-12 && abs(2*sqrt(2) - 2.83) < 0.005 && best == 2, ...
    'CHSH: local bound 2, maximally entangled up to 2 sqrt 2 ~ 2.83', sprintf('S_Bell = %.4f, local max = %d', Sq, best));
