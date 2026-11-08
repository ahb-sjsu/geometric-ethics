% check_ch02_05.m -- Geometric Ethics v1.24, Chapters 2-5:
% parable values, scalar error bar, theory superposition, Ch.4 definitions
% (Levi-Civita, Riemann sign convention, sphere holonomy, gauge curvature).
fprintf('\n--- check_ch02_05: parable, Ch.4 differential-geometry definitions ---\n');

%% Ch.2 parable values (L5067-5068). The book ASSIGNS S = -1, +3, -2
% ("and so on"); nothing is computed from them. No "+10" appears anywhere.
ge_check('TEXT-Ch02', 5068, [], 'parable sequence S(x) = -1, +3, -2, "and so on"', ...
    'values are assigned, not derived; no +10 occurs in v1.24 (grep "S(x) =")');

% L5163-5165: S = -1 "is some contraction of v = (-0.8,-0.4,0,0,?) -- perhaps its
% magnitude, or a weighted sum".
v = sym([-8 -4 0 0]) / 10;
mag = sqrt(sum(v.^2));
ge_check('TEXT-Ch02', 5165, isAlways(-mag == -1) || isAlways(mag == -1), ...
    'S = -1 is "perhaps its magnitude" of v = (-0.8,-0.4,0,0,?)', sprintf('|v| = %s = %.4f > 0, so the magnitude cannot equal -1', char(mag), double(mag)));
w = sym([5 5 0 0]) / 6;            % a weighted sum that gives -1 exists
ge_check('TEXT-Ch02', 5165, isAlways(sum(w .* v) == -1), ...
    '"or a weighted sum" reaching S = -1', 'e.g. w=(5/6,5/6,0,0) gives w.v = -1');

% L5209-5211: S = -1 +- 0.5 -> interval [-1.5, -0.5]
ge_check('TEXT-Ch02', 5211, isAlways(sym(-1) - sym(1)/2 == sym(-3)/2) && isAlways(sym(-1) + sym(1)/2 == sym(-1)/2), ...
    'S = -1 +- 0.5 => [-1.5, -0.5]');

%% Ch.3 L6354: |psi> = sqrt(0.6)|U> + sqrt(0.4)|D>, 60% credence
a = sqrt(sym(6)/10); b = sqrt(sym(4)/10);
ge_check('TEXT-Ch03', 6354, isAlways(a^2 + b^2 == 1) && isAlways(a^2 == sym(6)/10), ...
    'sqrt(0.6)|U>+sqrt(0.4)|D> normalised, P(U)=0.6');

%% Ch.4 Def 4.4 (L7023): Levi-Civita Christoffel formula is metric-compatible
% and torsion-free, for a generic 2-D metric g(x,y).
syms x y real
X = [x y];
syms a(x,y) b(x,y) c(x,y)
G = [a(x,y) b(x,y); b(x,y) c(x,y)];
Gam = ge_christoffel(G, X);             % Gam(k,i,j) = Gamma^k_{ij}
comp = sym(zeros(2,2,2));
for k = 1:2, for i = 1:2, for j = 1:2
    comp(k,i,j) = diff(G(i,j), X(k));
    for l = 1:2
        comp(k,i,j) = comp(k,i,j) - Gam(l,k,i)*G(l,j) - Gam(l,k,j)*G(i,l);
    end
end, end, end
symm = sym(0);
for k = 1:2, for i = 1:2, for j = 1:2, symm = symm + abs(Gam(k,i,j) - Gam(k,j,i)); end, end, end
ge_check('GE-DEF-4-4', 7023, all(isAlways(simplify(comp(:)) == 0)), ...
    'Levi-Civita Gamma^k_ij = 1/2 g^kl(d_j g_il + d_i g_jl - d_l g_ij) gives nabla g = 0 (generic 2-D metric)');
ge_check('GE-DEF-4-4', 7023, isAlways(simplify(symm) == 0), 'same Gamma is torsion-free (Gamma^k_ij = Gamma^k_ji)');

%% Ch.4 Def 4.5 (L7058): component formula sign convention on the unit sphere.
syms th ph real
Gs = [1 0; 0 sin(th)^2]; Xs = [th ph];
Gm = ge_christoffel(Gs, Xs);
R = ge_riemann(Gm, Xs);                 % R(l,k,i,j) = R^l_{kij} as in the book
Ric = sym(zeros(2));
for i = 1:2, for j = 1:2, for k = 1:2, Ric(i,j) = Ric(i,j) + R(k,i,k,j); end, end, end
Rs = simplify(sum(sum(inv(Gs) .* Ric)));
ge_check('GE-DEF-4-5', 7062, isAlways(simplify(R(1,2,1,2) - sin(th)^2) == 0), ...
    'R^l_kij = d_i G^l_kj - d_j G^l_ki + G^l_im G^m_kj - G^l_jm G^m_ki: unit sphere R^th_{ph th ph} = sin^2 th');
ge_check('GE-DEF-4-5', 7075, isAlways(Rs == 2) && all(isAlways(simplify(Ric(:) - Gs(:)) == 0)), ...
    'Ricci R_ij = R^k_ikj, scalar R = g^ij R_ij: unit sphere gives Ric = g, R = +2');

%% Ch.4 L7035: holonomy on S^2 equals enclosed solid angle (latitude loop).
syms t th0 real
% parallel transport around the latitude circle theta = th0, phi = t in [0, 2*pi]
% components V = (V^th, V^ph); dV^k/dt = -Gamma^k_{ij} gdot^i V^j with gdot = (0,1)
syms A(tt) B(tt)
eqs = [diff(A,tt) == -Gm(1,2,2)*B, diff(B,tt) == -Gm(2,2,1)*A];
eqs = subs(eqs, th, th0);
sol = dsolve(eqs, [A(0) == 1, B(0) == 0]);
% orthonormal-frame components: e_th = V^th, e_ph = sin(th0) V^ph; rotation angle after one loop
ang_c = simplify(subs(sol.A, tt, 2*pi));
ang_s = simplify(subs(sin(th0)*sol.B, tt, 2*pi));
solid = 2*pi*(1 - cos(th0));
okH = isAlways(simplify(ang_c - cos(solid)) == 0, 'Unknown', 'false') && ...
      isAlways(simplify(ang_s^2 - sin(solid)^2) == 0, 'Unknown', 'false');
if ~okH   % fall back to numeric spot values
    vals = [0.3 0.7 1.1 1.4];
    okH = all(abs(double(subs(ang_c, th0, vals)) - cos(double(subs(solid, th0, vals)))) < 1e-10) && ...
          all(abs(abs(double(subs(ang_s, th0, vals))) - abs(sin(double(subs(solid, th0, vals))))) < 1e-10);
end
ge_check('GE-DEF-10-3', 7038, okH, 'S^2 parallel transport around a loop rotates the vector by the enclosed solid angle (latitude-circle check, 2*pi*(1-cos th0))');

%% Ch.4 L7263: F^a_{mu nu} = d_mu A^a_nu - d_nu A^a_mu + f^a_bc A^b_mu A^c_nu
% equals the matrix form F = dA + A^A ([A_mu, A_nu]) for su(2) with
% T_a = -i sigma_a / 2, [T_b,T_c] = eps_abc T_a.
s1 = [0 1; 1 0]; s2 = [0 -1i; 1i 0]; s3 = [1 0; 0 -1];
T = {-1i*s1/2, -1i*s2/2, -1i*s3/2};
Amu = sym('Am', [3 1]); Anu = sym('An', [3 1]);
Mmu = sym(zeros(2)); Mnu = sym(zeros(2));
for a_ = 1:3, Mmu = Mmu + Amu(a_)*T{a_}; Mnu = Mnu + Anu(a_)*T{a_}; end
comm = Mmu*Mnu - Mnu*Mmu;
fA = sym(zeros(2));
for a_ = 1:3, for b_ = 1:3, for c_ = 1:3
    e = ge_levicivita3(a_, b_, c_);
    if e ~= 0, fA = fA + e*Amu(b_)*Anu(c_)*T{a_}; end
end, end, end
ge_check('GE-DEF-4-8', 7263, all(isAlways(simplify(comm(:) - fA(:)) == 0)), ...
    'gauge curvature quadratic term f^a_bc A^b_mu A^c_nu T_a = [A_mu, A_nu] (su(2) check)');

%% Ch.5 Example 1 (L8466-8500): 2-simplex strata and weighted metric
ge_check('TEXT-Ch05', 8470, true, 'simplex Delta^2: 1 interior, 3 edges, 3 vertices (counts by construction)');
syms bA bB positive
dsA = 1/bA; dsB = 1/bB;   % cost per unit move along p_i under g_ij = delta_ij / beta_i
ge_check('TEXT-Ch05', 8494, isAlways(subs(dsA - dsB, [bA bB], [sym(9)/10 sym(3)/10]) < 0), ...
    'g_ij = delta_ij/beta_i: moving toward higher-beta patient is cheaper');
