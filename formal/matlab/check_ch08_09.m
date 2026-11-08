% check_ch08_09.m -- Geometric Ethics v1.24, Chapters 8-9:
% promise worked example (8.9), Mahalanobis edge weights with boundary
% penalties (Def 8.13 / Prop 8.5), metric admissibility (Ch.9 TA).
% D4-specific material (Prop 8.3, Lemma 9.1, the 45-27-8 count) is skipped.
warning('off', 'symbolic:sym:isAlways:TruthUnknown');
fprintf('\n--- check_ch08_09: stratification and metric ---\n');

%% 8.9 worked example (L11807-11878)
syms g22 g77 g27 g44 x2 x4 x7 real
assume(g22 > 0); assumeAlso(g77 > 0); assumeAlso(g27 > 0); assumeAlso(g44 < 0);
SO = g22*x2 + g44*x4 + g77*x7 + g27*x2*x7;
S0 = subs(SO, [x2 x4 x7], sym([8 3 7])/10);
S2 = subs(SO, [x2 x4 x7], sym([8 5 7])/10);
S3 = subs(SO, [x2 x4 x7], sym([8 5 2])/10);
ge_check('TEXT-Ch08', 11857, isAlways(S0 == g22*sym(8)/10 + g44*sym(3)/10 + g77*sym(7)/10 + g27*sym(56)/100), ...
    't0: S_O = g22(0.8)+g44(0.3)+g77(0.7)+g27(0.8)(0.7)');
ge_check('TEXT-Ch08', 11866, isAlways(S2 < S0), 't2: autonomy cost up (x4 0.3->0.5, g44<0) lowers S_O');
ge_check('TEXT-Ch08', 11873, isAlways(S3 < S2) && isAlways(sym(8)/10*sym(2)/10 < sym(8)/10*sym(7)/10), ...
    't3: x7 0.7->0.2 lowers S_O; coupling term g27 x2 x7 shrinks 0.56 g27 -> 0.16 g27');
ge_check('TEXT-Ch08', 11886, numel({'O->L', 'L->O', 'O->N'}) == 3, ...
    'path t0..t4 crosses three stratum boundaries (O->L, L->O, O->N), two reversible, one absorbing');

%% Def 8.13 (L12011-12023): w = da' inv(Sigma) da + sum beta_k
syms rho real
Sig = [1 rho; rho 1];
cost = @(d) simplify(d.' * inv(Sig) * d);
cPar = cost([1; 1]); cSingle = cost([1; 0]); cOpp = cost([1; -1]);
ge_check('TEXT-Ch08', 12020, isAlways(diff(cPar, rho) < 0, 'Unknown', 'false') || ...
    isAlways(subs(diff(cPar, rho), rho, sym(1)/2) < 0), ...
    'co-directional change along correlated dims is cheaper (da=(1,1): cost 2/(1+rho), decreasing in rho)', char(cPar));
ge_check('TEXT-Ch08', 12020, isAlways(subs(cSingle, rho, sym(8)/10) <= 1) && isAlways(subs(cOpp, rho, sym(8)/10) <= 2), ...
    '"changes along highly correlated dimensions ... are cheaper than along independent ... dimensions" (unqualified)', ...
    sprintf('only for co-directional moves: a single-dimension change costs %s (=2.78 at rho=0.8, vs 1 independent), an opposite-sign change %s (=10 at rho=0.8, vs 2)', char(cSingle), char(cOpp)));
% L12026-12030: "In the limit Delta a -> da, the Mahalanobis distance converges to
% the Riemannian arc length" (also Prop 8.5(i)). w is a SQUARED form.
syms Lsq N positive
% straight segment with total displacement D, split into N equal edges: sum of
% squared-form weights = N * (D/N)' S^-1 (D/N) = Lsq/N, where Lsq = D' S^-1 D.
sumW = N * (Lsq / N^2);
ge_check('TEXT-Ch08', 12031, isAlways(limit(sumW, N, inf) == sqrt(Lsq)), ...
    'sum of Mahalanobis weights da'' Sigma^-1 da over a refining path converges to the Riemannian arc length', ...
    sprintf('the weight is a squared form: total = %s -> 0 as N -> inf; arc length needs sqrt(da'' Sigma^-1 da) (sum -> sqrt(Lsq))', char(sumW)));
sumSqrt = N * sqrt(Lsq / N^2);
ge_check('TEXT-Ch08', 12031, isAlways(simplify(sumSqrt - sqrt(Lsq)) == 0), ...
    '(reference) with w = sqrt(da'' Sigma^-1 da) the sum equals the arc length for every N');
ge_check('TEXT-Ch08', 12048, [], 'Type III (absorbing) boundaries "correspond to beta_k = infinity" (L12048)', ...
    'while Prop 8.5(ii) proof (L12072) says "the beta_k are finite constants": internal inconsistency, not algebra');

%% 8.5 jump (L11339): Delta S = lim S(p+eps n) - lim S(p-eps n) for a step
syms e real
Sstep = piecewise(e > 0, 3, e <= 0, -1);
ge_check('TEXT-Ch08', 11343, isAlways(limit(Sstep, e, 0, 'right') - limit(Sstep, e, 0, 'left') == 4), ...
    'jump Delta S of a threshold (step) = one-sided limit difference');

%% Ch.9 Technical Appendix
% Prop 9.2 (L13255-13261): f(p1,p2) = p1/p2 satisfies (2) f(1,1)=1 and (3) f(p1,p2) f(p2,p1)=1
syms p1 p2 k positive
f = p1/p2;
ge_check('GE-PROP-9-2', 13257, isAlways(subs(f, [p1 p2], [1 1]) == 1) && isAlways(simplify(f*subs(f, [p1 p2], [p2 p1])) == 1), ...
    'f = p1/p2 satisfies f(1,1)=1 and f(p1,p2) f(p2,p1)=1');
fk = (p1/p2)^k;
ok2 = isAlways(subs(fk, [p1 p2], [1 1]) == 1) && isAlways(simplify(fk*subs(fk, [p1 p2], [p2 p1])) == 1);
ge_check('GE-PROP-9-2', 13260, ~ok2, ...
    'f = p1/p2 "is the unique solution consistent with the correlative symmetry constraint"', ...
    'conditions (2)-(3) are also met by f = (p1/p2)^k for every k (incl. f = 1); (1) f = g22(a)/g22(b) is a definition, so uniqueness is not established');

% Lemma 9.2 (L13298): Killing equation for xi = d/dx^3 (stand-in for x^7) <=> d_3 g = 0
syms y1 y2 y3 real
Y = [y1 y2 y3];
gfun = sym(zeros(3));
names = {'a11','a12','a13';'a12','a22','a23';'a13','a23','a33'};
for i = 1:3, for j = 1:3, gfun(i,j) = str2sym([names{i,j} '(y1,y2,y3)']); end, end
xi = [0; 0; 1];
% Lie derivative of g along xi (equivalent to nabla_mu xi_nu + nabla_nu xi_mu)
Lg = sym(zeros(3));
for i = 1:3, for j = 1:3
    s = 0;
    for kk = 1:3
        s = s + xi(kk)*diff(gfun(i,j), Y(kk)) + gfun(kk,j)*diff(xi(kk), Y(i)) + gfun(i,kk)*diff(xi(kk), Y(j));
    end
    Lg(i,j) = s;
end, end
ge_check('GE-LEMMA-9-2', 13298, all(isAlways(simplify(Lg(:) - diff(gfun(:), y3)) == 0)), ...
    'Killing equation for xi = d/dx^7 is exactly d_7 g_{mu nu} = 0');
ge_check('GE-LEMMA-9-2', 13294, nnz(setdiff(1:9, 7)) == 8, 'g_{7 mu} = 0 for mu != 7 removes 8 off-diagonal components');
ge_check('GE-LEMMA-9-2', 13299, [], 'Killing alone forces g_{7mu} = 0?', ...
    'no: any x^7-independent metric with g_{7mu} != 0 still has d/dx^7 Killing; the book correctly needs the extra A5 orthogonality assumption');

% Prop 9.1 / Thm 9.2 Step 0-3 (L13380-13410): e13, e45 symmetric, independent; delta + t e PD for |t|<2
E13 = sym(zeros(9)); E13(1,3) = sym(1)/2; E13(3,1) = sym(1)/2;
E45 = sym(zeros(9)); E45(4,5) = sym(1)/2; E45(5,4) = sym(1)/2;
ge_check('GE-THM-9-2', 13380, isequal(E13, E13.') && isequal(E45, E45.') && rank([E13(:) E45(:)]) == 2, ...
    'e13, e45 symmetric and linearly independent');
syms t real
ev = eig(eye(9) + t*E13);
ge_check('GE-THM-9-2', 13401, all(isAlways(subs(ev, t, sym(19)/10) > 0)) && ~all(isAlways(subs(ev, t, 2) > 0)), 'delta + t e13 positive definite for small t (eigenvalues 1 +- t/2: PD iff |t| < 2)');
g = eye(9) + t*E13;
ge_check('GE-THM-9-2', 13408, isAlways(g(1,3) == t/2) && isAlways(g(3,1) == t/2), 'g = delta + t e13 has g_13 = g_31 = t/2');
ge_check('GE-PROP-9-1', 13225, 9*10/2 == 45, 'Sym_9 has 45 independent components (dimension count base)');
