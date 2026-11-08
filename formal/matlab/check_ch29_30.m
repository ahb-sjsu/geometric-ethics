% check_ch29_30.m -- Ch 29 Technical Appendix (Props 29.1-29.3, ledger GE-PROP-20-1..3,
% author status Conjecture/Proposal), Ch 30 and Appendices B/C numerics (tex L36349-38647).
fprintf('\n--- check_ch29_30: Ch 29 TA, Ch 30, App. B/C ---\n');

%% Prop 29.1 (L37384): holonomy of a small loop ~ curvature x area. Test on the unit 2-sphere.
syms th ph real
x = [th ph]; g = diag([1, sin(th)^2]); gi = inv(g);
Gam = sym(zeros(2,2,2));
for m = 1:2, for a = 1:2, for b = 1:2
    Gam(m,a,b) = simplify(sum(arrayfun(@(n) gi(m,n)*(diff(g(n,a),x(b)) + diff(g(n,b),x(a)) - diff(g(a,b),x(n)))/2, 1:2)));
end, end, end
% Riemann R^m_{n a b} = d_a Gam^m_{nb} - d_b Gam^m_{na} + Gam^m_{ae}Gam^e_{nb} - Gam^m_{be}Gam^e_{na}
Rm = sym(zeros(2,2,2,2));
for m = 1:2, for n = 1:2, for a = 1:2, for b = 1:2
    s = diff(Gam(m,n,b), x(a)) - diff(Gam(m,n,a), x(b));
    for e = 1:2, s = s + Gam(m,a,e)*Gam(e,n,b) - Gam(m,b,e)*Gam(e,n,a); end
    Rm(m,n,a,b) = simplify(s);
end, end, end, end
ge_check('GE-PROP-20-1', 37384, simplify(Rm(1,2,1,2) - sin(th)^2) == 0, 'sphere: R^th_{ph th ph} = sin^2(th) (curvature nonzero)', char(Rm(1,2,1,2)));
% numerically transport O around a square of side e at (th0, ph0)
Gf = matlabFunction(Gam, 'Vars', {th, ph});
th0 = pi/3; ph0 = 0; O0 = [0.3; 0.7];
ratios = zeros(1,3); es = [0.02 0.01 0.005];
for k = 1:3
    e = es(k);
    legs = {[th0 ph0], [th0+e ph0]; [th0+e ph0], [th0+e ph0+e]; [th0+e ph0+e], [th0 ph0+e]; [th0 ph0+e], [th0 ph0]};
    O = O0;
    for L = 1:4
        p0 = legs{L,1}; p1 = legs{L,2}; dxv = (p1 - p0).';
        f = @(t, V) -squeeze(sum(sum(Gf(p0(1)+t*dxv(1), p0(2)+t*dxv(2)) .* reshape(V, [1 2 1]) .* reshape(dxv, [1 1 2]), 2), 3));
        [~, Vs] = ode45(f, [0 1], O, odeset('RelTol', 1e-12, 'AbsTol', 1e-14));
        O = Vs(end, :).';
    end
    dO = O - O0;
    Rn = double(subs(Rm, [th ph], [th0 ph0]));
    pred = zeros(2,1);   % R^m_{n th ph} O^n * area (one ordering of the area element)
    for m = 1:2, for n = 1:2, pred(m) = pred(m) + Rn(m,n,1,2)*O0(n)*e^2; end, end
    ratios(k) = dO(1)/pred(1);
end
fprintf('INFO  Prop 29.1 sphere: DeltaO / (R O area) for e = %s : %s\n', mat2str(es), mat2str(ratios, 6));
ge_check('GE-PROP-20-1', 37392, all(abs(abs(ratios) - 1) < 0.05) && abs(abs(ratios(3)) - 1) < abs(abs(ratios(1)) - 1) + 1e-9, ...
    'DeltaO -> R^mu_{nu ab} O^nu x (enclosed area), |DeltaO| proportional to area x curvature (first order)', mat2str(ratios, 6));
ge_check('GE-PROP-20-1', 37392, [], 'sign and factor of the area element', ...
    sprintf('ratio DeltaO/(R O e^2) -> %+.4f: holds with the oriented area element dx^a dx^b of one ordering; written as an unrestricted sum over a,b with dx^a ^ dx^b it double-counts (factor 2) unless 1/2 is included; sign is convention-dependent', ratios(3)));

%% Prop 29.2 (L37411): closure failure of the transported parallelogram = torsion
n = 3; G = sym('G', [n n n]); v = sym('v', [n 1]); w = sym('w', [n 1]);
d1 = sym(zeros(n,1)); d2 = d1; dT = d1;
for m = 1:n, for a = 1:n, for b = 1:n
    d1(m) = d1(m) + G(m,a,b)*v(a)*w(b);
    d2(m) = d2(m) + G(m,a,b)*w(a)*v(b);
    dT(m) = dT(m) + (G(m,a,b) - G(m,b,a))*v(a)*w(b);
end, end, end
ge_check('GE-PROP-20-2', 37425, all(isAlways(expand(d1 - d2 - dT) == 0)), ...
    'Gam^m_{ab} v^a w^b - Gam^m_{ab} w^a v^b = (Gam^m_{ab} - Gam^m_{ba}) v^a w^b = T^m_{ab} v^a w^b (generic 3-D Gamma)', '');
Gs = G; for m = 1:n, for a = 1:n, for b = 1:n, Gs(m,a,b) = G(m,min(a,b),max(a,b)); end, end, end
ds = subs(dT, G(:), Gs(:));
ge_check('GE-PROP-20-2', 37421, all(isAlways(ds == 0)), 'symmetric (torsion-free) connection gives zero closure failure', '');
ge_check('GE-PROP-20-2', 37425, [], 'sign of the transport step', ...
    'parallel transport is V -> V - Gam V dx (L37425 writes +Gam); the closure failure is then -T v w, same zero set, so the criterion is unaffected');

%% Prop 29.3 (L37435): DeWitt metric on Sym+(k)
rng(1); k = 4; ok = true; okinv = true; okinv2 = true;
for t = 1:200
    A = randn(k); gg = A*A' + k*eye(k); H = randn(k); H = H + H'; K = randn(k); K = K + K';
    Gv = trace(gg\H/gg*H);
    ok = ok && Gv > 0;
    J = randn(k) + k*eye(k);
    gt = J'*gg*J; Ht = J'*H*J; Kt = J'*K*J;
    okinv  = okinv  && abs(trace(gt\Ht/gt*Kt) - trace(gg\H/gg*K)) < 1e-8*max(1, abs(trace(gg\H/gg*K)));
    okinv2 = okinv2 && abs(trace(gt\Ht)*trace(gt\Kt) - trace(gg\H)*trace(gg\K)) < 1e-8*max(1, abs(trace(gg\H)*trace(gg\K)));
end
ge_check('GE-PROP-20-3', 37445, ok, 'G_g(h,h) = Tr((g^-1 h)^2) > 0 for symmetric h ~= 0, g > 0 (200 random draws)', '');
Z = sym([0 1; -1 0]);
ge_check('GE-PROP-20-3', 37447, [], 'justification "since g^-1 h is a real matrix"', ...
    sprintf('insufficient: real A = [0 1; -1 0] has Tr(A^2) = %s < 0; positivity holds because g^-1 h is similar to the symmetric g^-1/2 h g^-1/2', char(trace(Z^2))));
ge_check('GE-PROP-20-3', 37450, okinv, 'Tr(g^-1 h g^-1 k) invariant under g,h,k -> J^T (.) J', '');
ge_check('GE-PROP-20-3', 37439, ~okinv2, ...
    'statement: meta-metric "unique up to overall scale" under coordinate invariance', ...
    'Tr(g^-1 h)Tr(g^-1 k) is ALSO invariant (checked), so the invariant family a Tr(g^-1hg^-1k) + b Tr(g^-1h)Tr(g^-1k) has two parameters: unique only up to scale AND b/a, as the proof itself (L37455) concludes');

%% Ch 30 / Ch 2 scalar error bar (L37530)
ge_check('TEXT-Ch30', 37530, sym(-1) - sym(1)/2 == sym(-3)/2 && sym(-1) + sym(1)/2 == sym(-1)/2, 'S = -1 +/- 0.5 spans [-1.5, -0.5]', '');

%% Appendix C power analyses (L38512-38560)
nreq = sampsizepwr('t', [0 1], 0.5, 0.80);
ge_check('TEXT-AppC', 38512, nreq <= 200, 'paired design, d = 0.5, alpha = .05, power .80: "N ~ 200 is sufficient"', sprintf('required N = %d', nreq));
ge_check('TEXT-AppC', 38512, [], 'Study 1 sample size', sprintf('sufficient but ~6x the required N = %d (two-sided paired t); N = 200 gives power %.4f', nreq, sampsizepwr('t', [0 1], 0.5, [], 200)));
ge_check('TEXT-AppC', 38560, 3*150 == 450, '3 gate types x 150 = 450 total', '');

%% Bond Index tier tables are inconsistent across the book
ge_check('TEXT-AppB', 38441, [], 'Bd tiers: App. B.6 <0.1 cosmetic / 0.1-0.5 substantive / >0.5 systematic; BIP-compliant iff Bd < 0.1', ...
    'App. D (L39208 etc.) uses deploy iff Bd < 0.01, and D.4 (L40724-40727) uses <0.01 / 0.01-0.10 / 0.10-1.0 / >1.0: the two tier scales disagree');
