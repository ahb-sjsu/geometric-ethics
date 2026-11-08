% check_ch15_contraction.m -- Geometric Ethics v1.24, Chapter 15 (moral contraction)
fprintf('\n--- check_ch15: contraction ---\n');
rq = @(x) sym(round(x*1e6))/1e6;     % exact rational from a printed decimal

%% 15.12 kidney allocation (20283-20330): M = options x perspectives
M = rq([0.75 0.90 0.40 0.50 0.62; 0.68 0.35 0.95 0.45 0.70; 0.55 0.30 0.30 0.92 0.58]);
ge_check('TEXT-Ch15', 20289, numel(M) == 15, '(3 x 5) tensor with 15 independent components', '');
u = sum(M, 2).';
ge_check('TEXT-Ch15', 20299, all(isAlways(u == rq([3.17 3.13 2.65]))), ...
    'Utilitarian sums: Alice 3.17 > Bob 3.13 > Carol 2.65 -> Alice', char(u));
rw = min(M, [], 2).';
ge_check('TEXT-Ch15', 20302, all(isAlways(rw == rq([0.40 0.35 0.30]))), ...
    'Rawlsian mins: Alice 0.40 > Bob 0.35 > Carol 0.30 -> Alice', char(rw));
w = rq([0.3 0.1 0.1 0.1 0.4]);
ew = (M*w.').';
ge_check('TEXT-Ch15', 20305, isAlways(sum(w) == 1) && all(isAlways(ew == rq([0.653 0.659 0.549]))) && ew(2) > ew(1) && ew(1) > ew(3), ...
    'Expert-weighted (0.3/0.1/0.1/0.1/0.4): Bob 0.659 > Alice 0.653 > Carol 0.549 -> Bob', char(ew));
ge_check('TEXT-Ch15', 20330, isAlways(rq(0.1)*rq(0.92) == rq(0.092)), '0.1 x 0.92 = 0.092', '');

%% Prop 15.3 (20515-20535): non-commutativity of max and weighted sum
C1 = @(T, w) max(w*T);                % contract over mu (rows) first, then max over nu
C2 = @(T, w) w*max(T, [], 2);         % max over nu first, then contract over mu
Tw = [1 0; 0 1]; ww = [0.5 0.5];
ge_check('GE-PROP-15-3', 20527, C1(Tw, ww) ~= C2(Tw, ww), ...
    'C1(T) ~= C2(T) in general', sprintf('witness T = I_2, w = (1/2,1/2): C1 = %g, C2 = %g', C1(Tw, ww), C2(Tw, ww)));
% iff-clause with strictly positive weights: exhaustive over 2x3 integer T in {0,1,2}, w in {1,2}^2
okIff = true;
vals = 0:2;
for a = 0:3^6-1
    dg = mod(floor(a ./ 3.^(0:5)), 3);
    T = reshape(vals(dg + 1), 2, 3);
    for w1 = 1:2, for w2 = 1:2
        wv = [w1 w2];
        unanimous = any(all(T == max(T, [], 2), 1));
        okIff = okIff && ((C1(T, wv) == C2(T, wv)) == unanimous);
    end, end
end
ge_check('GE-PROP-15-3', 20525, okIff, ...
    'equality iff a common maximising nu for all mu (w_mu > 0; exhaustive 2x3 T in {0,1,2}, w in {1,2}^2)', '');
Tn = [1 0; 1 0]; wn = [1 -2];
Tz = [1 0; 0 1]; wz = [1 0];
ge_check('GE-PROP-15-3', 20525, C1(Tn, wn) == C2(Tn, wn) && C1(Tz, wz) ~= C2(Tz, wz), ...
    '"Equality holds if and only if the maximizing nu is the same for all mu" (no sign condition on w_mu stated)', ...
    sprintf('needs w_mu > 0: T=[1 0;1 0], w=(1,-2) has a unanimous maximiser but C1=%g, C2=%g; T=I, w=(1,0) has none but C1=C2=%g', ...
    C1(Tn, wn), C2(Tn, wn), C1(Tz, wz)));

%% Prop 15.4 (20537-20556): maximin residue
Mm = [1 2; 3 4];                           % 2 options x 2 perspectives
Si = min(Mm, [], 2);
Rr = Mm - Si;                              % per-option floor
ge_check('GE-PROP-15-4', 20541, all(Rr(:) >= 0), 'R_ia = M_ia - S >= 0 (S = per-option floor)', '');
tot = sum(Rr(:)); nA = size(Mm, 2);
bookA = sum(Mm(:)) - nA*Si(1); bookB = sum(Mm(:)) - nA*Si(2);
ge_check('GE-PROP-15-4', 20554, tot == bookA || tot == bookB, ...
    '"sum_{i,a} R_ia = sum_{i,a} M_ia - n*S where n = |A|"', ...
    sprintf('M = [1 2;3 4]: sum R = %g, but sum M - |A|S = %g or %g; correct: sum_{i,a} M_ia - |A| sum_i S_i = %g (book form valid only for one option i)', ...
    tot, bookA, bookB, sum(Mm(:)) - nA*sum(Si)));

%% Prop 15.5 (20559-20578): weighted contraction is BIP-compliant iff w o g = w
wv = sym('w', [1 3]); G = sym('g', [3 3]); Tp = sym('t', [3 1]);
lhs = wv*(G*Tp); diffc = jacobian(lhs - wv*Tp, Tp);
ge_check('GE-PROP-15-5', 20577, all(isAlways(simplify(diffc - (wv*G - wv)) == 0)), ...
    'C(g.T'') = (w o g).T'' and C(g.T'') = C(T'') for all T'' iff w o g = w (coefficientwise)', '');

%% Remark A.1 (20590-20605): Moore-Penrose residue is the g-orthogonal projection onto ker C
syms g11 g22 w1 w2 real
syms g12 real
Gm = [g11 g12; g12 g22]; wc = [w1 w2];
Cst = Gm \ wc.';                           % adjoint C* s = G^-1 w^T s
Cp = Cst / (wc*Cst);                       % C+ = C*(C C*)^-1
Pm = eye(2) - Cp*wc;                       % R = (I - C+ C) T
c1 = simplify(Pm*Pm - Pm); c2 = simplify(wc*Pm); c3 = simplify(Gm*Pm - (Gm*Pm).');
c4 = simplify(wc*Cp*wc - wc); c5 = simplify(Cp*wc*Cp - Cp);
ge_check('GE-DEF-15-2', 20600, all(isAlways([c1(:); c2(:); c3(:); c4(:); c5(:)] == 0)), ...
    'R = T - C+(C(T)) is the g-orthogonal projection onto ker C; Penrose CC+C=C, C+CC+=C+', '');

%% Prop 15.1 (19888-19909): residue nonzero "unless T is already scalar"
wr = [1 2 3]; Tr = wr.';                   % Euclidean metric, T in span(C*)
Rres = Tr - (wr.'/(wr*wr.'))*(wr*Tr);
ge_check('GE-PROP-15-1', 19891, norm(Rres) > 0, ...
    '"the moral residue R is nonzero unless T is already scalar" (rank >= 1)', ...
    sprintf('rank-1 T = (1,2,3), C(T) = w.T with w = (1,2,3): R = T - C+(C(T)) = 0 (norm %g); R = 0 for every T on the line span(G^-1 w), as the supplement at 19907 concedes', norm(Rres)));
ge_check('GE-PROP-15-1', 19904, size(null(ones(1, 9)), 2) == 8 && size(null(ones(1, 81)), 2) == 80, ...
    'dim ker C = n^r - 1 (n = 9: r = 1 -> 8, r = 2 -> 80)', '');

%% Theorem 15.1 (19767-19781): scalar irrecoverability
xs = sym('x', [1 9]); Qf = str2sym('Qf(x1,x2,x3,x4,x5,x6,x7,x8,x9)');
Jq = jacobian(Qf, xs);
ge_check('GE-THM-15-1', 19776, size(Jq, 1) == 1 && numel(Jq) == 9, ...
    '(i) for differentiable Q, dQ is 1 x 9, rank <= 1, dim ker dQ >= 8', '');
% "any function": digit-interleaving map on 2-digit grids is injective with an exact left inverse
rng(15); K = 20000;
X = randi([0 99], K, 9);                   % coordinates x_j = X_j/100 in [0,1)
code = zeros(K, 1, 'uint64');
for dpos = 1:2
    for j = 1:9
        dig = uint64(floor(mod(X(:, j), 10^(3 - dpos)) / 10^(2 - dpos)));
        code = code*10 + dig;              % Q(x) = 0.(d1 of x1)(d1 of x2)...(d2 of x9) as an 18-digit integer
    end
end
dec = zeros(K, 9); cc = code;
for dpos = 2:-1:1
    for j = 9:-1:1
        dec(:, j) = dec(:, j) + double(mod(cc, 10))*10^(2 - dpos); cc = idivide(cc, uint64(10));
    end
end
ok15 = isequal(dec, X) && numel(unique(code)) == size(unique(X, 'rows'), 1);
ge_check('GE-THM-15-1', 19768, ~ok15, ...
    '"Let Q: R^9 -> R be ANY function ... (i) Q is not injective ... (ii) no psi with psi o Q = id"', ...
    'false for arbitrary (discontinuous) Q: digit interleaving is injective with exact left inverse (verified on 20000 grid points; extends to [0,1)^9); the proof uses dQ, so the theorem needs Q continuous/differentiable (as Thm 20.2 states)');

%% 19613-19624: "Every ethical theory that yields a scalar verdict is performing a weighted contraction"
% maximin S = min_mu O^mu (listed at 19624) as a fixed weighted sum w.O would need w.e_k = 0 for all k, but min(1,1,1) = 1.
ge_check('TEXT-Ch15', 19618, false, ...
    '"Every ethical theory that yields a scalar verdict is performing a weighted contraction, differing only in the weights"', ...
    'maximin S = min O (book, 19624) is not w.O for any fixed w: min(e_k) = 0 forces w = 0, yet min(1,...,1) = 1; lexicographic likewise');

%% Prop 15.2 (20083-20102): harm survives contraction
syms Hp Hr real
ge_check('GE-PROP-15-2', 20099, isAlways(Hp - (Hp - Hr) == Hr), 'H(T) = H(C^-1 S) + H(R) by linearity', '');
% contraction discards the harm direction x7: 2-D model (x1, x7), w = (1, 0)
w7 = [1 0]; T0 = [0.5; 0.7];
pre_any = (w7*T0)*[1; 0] + [0; 1];          % another valid preimage of S (e7 in ker C)
ge_check('GE-PROP-15-2', 20098, pre_any(2) == 0, ...
    '"C^-1(S) is any pre-image ... has zero component along x7, so H(C^-1(S)) = 0"', ...
    sprintf('w7 = 0 => e7 in ker C, so preimage S e1 + e7 has x7-component %g; only the minimal-norm preimage can qualify', pre_any(2)));
Gc = [2 1; 1 2];
Cpg = (Gc \ w7.') / (w7*(Gc \ w7.'));
ge_check('GE-PROP-15-2', 20101, [], ...
    'minimal-norm preimage has zero x7-component? depends on g_17 (Ch 9 Lemma 9.2 may force g_17 = 0)', ...
    sprintf('metric coupling x1,x7 (g = [2 1;1 2]): C+(1) = (%g, %g), x7-component nonzero; holds if g_17 = 0, or if H is the metric charge g(xi, .) (then g(e7, C+ s) = w7 s/(w G^-1 w) = 0)', Cpg(1), Cpg(2)));
% table 20394: "Harm in residue H(R) >= 0"
wh = [1 1]; Th = [1; 0.2];                  % H(T) = 0.2 > 0, Euclidean
Cph = wh.'/(wh*wh.'); HR = Th(2) - Cph(2)*(wh*Th);
ge_check('GE-PROP-15-2', 20394, HR >= 0, '"Harm in residue: H(R) >= 0"', ...
    sprintf('T = (1, 0.2) (H(T) = 0.2), w = (1,1), Euclidean: C+(S) = (0.6, 0.6), H(R) = %g < 0', HR));

%% Smart home (20443-20462)
Dh = rq([0.9 -0.8 0.0 -0.3 -0.8 -0.5 0.3 0.0 0.1]);
ge_check('TEXT-Ch15', 20452, [], ...
    '"(1) Utilitarian: allow (S = 0.62)" -- agent weights not given', ...
    sprintf('not reproducible from the stated data; the book''s own summative contraction S = sum_mu O^mu (19602, 20382) gives %s (mean %s), i.e. negative', char(sum(Dh)), char(sum(Dh)/9)));
ge_check('TEXT-Ch15', 20456, isAlways(Dh(1)*(1 - rq(0.8)) == rq(0.18)), ...
    'effective_benefit = 0.18 at uncertainty 0.8 (= D1 x (1 - 0.8), formula assumed)', char(Dh(1)*(1 - rq(0.8))));
ge_check('TEXT-Ch15', 20462, isAlways(Dh(4) == rq(-0.3)) && isAlways(Dh(5) == rq(-0.8)) && isAlways(Dh(6) == rq(-0.5)), ...
    'residue autonomy -0.3, privacy -0.8, procedural -0.5 match D4, D5, D6', '');

%% Carbon budget (20480-20493)
ge_check('TEXT-Ch15', 20491, 200+200+100 == 500 && 100+150+250 == 500 && 80+170+250 == 500, ...
    'allocations 200/200/100, 100/150/250, 80/170/250 each sum to the 500 GtCO2 budget', '');
ge_check('TEXT-Ch15', 20484, 9*3 == 27, 'rank-2 tensor (9 dimensions x 3 blocs) = 27 components', '');
