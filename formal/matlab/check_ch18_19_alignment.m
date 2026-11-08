% check_ch18_19_alignment.m -- Ch. 18-19 Technical Appendix algebra
% (Props 18.1, 18.2, 18.4, Lemma 18.1, Props 19.3, 19.4, 19.5).
fprintf('\n--- check_ch18_19_alignment: Ch18-19 technical appendices ---\n');
rng(18);

% --- Prop 18.1: Var of the summed evaluation decomposes into variances + covariances
X = sym(randi([-9 9], 8, 4));          % 8 re-descriptions g, d = 4 components
popvar = @(v) sum((v - mean(v)).^2)/numel(v);
popcov = @(u,v) sum((u - mean(u)).*(v - mean(v)))/numel(u);
lhs = popvar(sum(X,2)); rhs = sym(0);
for m = 1:4
    for nn = 1:4
        if m == nn, rhs = rhs + popvar(X(:,m)); else, rhs = rhs + popcov(X(:,m), X(:,nn)); end
    end
end
ge_check('GE-PROP-18-1', 25715, simplify(lhs - rhs) == 0, ...
    'IV = Var_g[sum_mu Sigma^mu] = sum_mu Var[Sigma^mu] + sum_{mu~=nu} Cov[Sigma^mu,Sigma^nu] (exact, 8x4 integer sample)', ...
    char(lhs - rhs));

% --- Prop 18.2: add-and-subtract identity and Cauchy-Schwarz bound ---------
wA = sym('wA', [3 1], 'real'); ws = sym('ws', [3 1], 'real');
V = sym('V', [3 1], 'real'); Vs = sym('Vs', [3 1], 'real');
ident = expand(wA.'*V - ws.'*Vs - ((wA - ws).'*V + ws.'*(V - Vs)));
ge_check('GE-PROP-18-2', 25753, ident == 0, ...
    'S_AI - S* = (wAI - w*).V + w*.(V - V*) (symbolic)', char(ident));
worst = -inf;
for t = 1:20000
    a = randn(9,1); b = randn(9,1); v = randn(9,1); vs = v + 0.3*randn(9,1);
    worst = max(worst, abs(a'*v - b'*vs) - (norm(a-b)*norm(v) + norm(b)*norm(v-vs)));
end
ge_check('GE-PROP-18-2', 25740, worst <= 1e-12, ...
    '|S_AI - S*| <= ||wAI - w*|| ||V|| + ||w*|| ||V - V*|| (20,000 random 9-D trials)', sprintf('max excess %.3g', worst));

% --- Prop 18.4: L_inv = 0 iff gauge-invariant, with IV as defined in Prop 18.1
syms t1 t2 t3 real
S1 = [t1; t2; t3]; S2 = -S1;           % two components over three re-descriptions g
ivTotal = simplify(popvar(S1 + S2));
ge_check('GE-PROP-18-4', 25803, false, ...
    'proof: "L_inv >= 0 with equality iff Sigma(g(x)) = Sigma(x) for all g" with IV = Var[Sigma_total] (Prop 18.1 proof, L25728)', ...
    sprintf('Sigma^1 = (t1,t2,t3), Sigma^2 = -Sigma^1 over g: Var[Sigma_total] = %s for all t, yet the components are not invariant; the "iff" needs IV = sum_mu Var[Sigma^mu] (trace), which then breaks the covariance terms of Prop 18.1', char(ivTotal)));

% --- Lemma 18.1: non-degenerate metric does not force dSigma/dx^i ~= 0 -----
syms x1 x2 real
g = eye(2); Sig = x1;                  % non-degenerate metric, evaluation depends on x1 only
ge_check('GE-LEMMA-18-1', 25042, false, ...
    'proof: dSigma/dx^i ~= 0 "otherwise dimension i would be degenerate in g" (statement L25035 claims ~= 0 for all i)', ...
    sprintf('counterexample: g = I (det %d, non-degenerate), Sigma = x1 gives dSigma/dx2 = %s everywhere; also the proof only reaches "for at least one configuration", weaker than the statement', ...
    det(g), char(diff(Sig, x2))));

% --- Prop 19.3: BIP of the aggregate does not require BIP of each module ---
syms f0 hg hgt real                    % f0: invariant part; hg / hgt: non-invariant part before/after g
J1 = f0 + hg; J2 = f0 - hg; J1g = f0 + hgt; J2g = f0 - hgt; w1 = sym(1)/2; w2 = sym(1)/2;
Sagg = simplify(w1*J1 + w2*J2 - (w1*J1g + w2*J2g));
ge_check('GE-PROP-19-3', 27790, false, ...
    '(=>) "If some J_k violates the BIP ... the weighted sum changes unless ... w_k = 0. Hence each J_k must satisfy the BIP"', ...
    sprintf('J1 = f + h, J2 = f - h, w = (1/2,1/2): S(gF) - S(F) = %s for every h, while J1(gF) - J1(F) = hgt - hg ~= 0; the "only if" direction is false (all w_k > 0)', char(Sagg)));
syms j1 j2 real; Jinv = [j1 j2]; Jinvg = Jinv;   % invariant modules: J_k(gF) = J_k(F)
ge_check('GE-PROP-19-3', 27774, simplify([w1 w2]*Jinvg.' - [w1 w2]*Jinv.') == 0, ...
    '(<=) invariant modules + fixed weights give an invariant weighted sum (linearity)', '');

% --- Prop 19.4: Bond Index bound -------------------------------------------
n = 100; X = zeros(n,1); X(1) = 1; xe = X(2);          % identity element value 0, one outlier
maxdev = max(abs(X - xe)); sd = sqrt(var(X,1));
ge_check('GE-PROP-19-4', 27811, maxdev <= 2*sd, ...
    'proof step: max_g |Sigma(g(x)) - Sigma(x)| <= 2 std_g[Sigma(g(x))]', ...
    sprintf('|G| = 100, one outlier: max deviation = %.3f > 2 std = %.3f; the valid bound is 2*sqrt(|G|-1)*std (Samuelson) = %.3f', ...
    maxdev, 2*sd, 2*sqrt(n-1)*sd));
syms ep positive
ge_check('GE-PROP-19-4', 27815, 2*sqrt(ep) <= ep, ...
    'statement: L_inv < eps => E[Bd] <= eps/tau; proof derives E[Bd] <= 2 sqrt(L_inv)/tau <= eps/tau only "when L_inv <= eps^2/4"', ...
    sprintf('under the stated hypothesis L_inv < eps the proof gives 2 sqrt(eps)/tau, which exceeds eps/tau for all eps < 4 (e.g. eps = 0.01: 0.2 vs 0.01)'));
iv = rand(1e5,1).^3;
ge_check('GE-PROP-19-4', 27813, mean(sqrt(iv)) <= sqrt(mean(iv)), ...
    'Jensen step E[sqrt(IV)] <= sqrt(E[IV])', sprintf('%.4f vs %.4f', mean(sqrt(iv)), sqrt(mean(iv))));

% --- Prop 19.5: trace over the gauge index does not remove input-gauge dependence
T_en = [1 0; 0 0]; T_fr = [3 0; 0 0];   % rows mu, cols gauge index g; same moral input, two languages
O_en = T_en*ones(2,1); O_fr = T_fr*ones(2,1);
probe = [1 0];                          % linear probe on O
ge_check('GE-PROP-19-5', 27402, probe*O_en == probe*O_fr, ...
    '"no linear probe on O^mu can recover the gauge index"; language-probe accuracy "would drop to chance ... by structural impossibility"', ...
    sprintf('tr_G removes the index g but not the dependence of T on the input''s gauge: T_en, T_fr give O = (%g,%g) vs (%g,%g), separated by the probe O^1; chance accuracy needs T''s gauge dependence to cancel in the g-sum, which the proposition does not assume', ...
    O_en, O_fr));
