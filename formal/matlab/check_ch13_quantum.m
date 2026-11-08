% check_ch13_quantum.m -- Geometric Ethics v1.24, Chapter 13 (quantum normative dynamics)
% Line numbers refer to source/Geometric-Ethics-v1.24.tex.
fprintf('\n--- check_ch13: quantum normative dynamics ---\n');

%% 16945 / 6354: |psi> = sqrt(0.6)|U> + sqrt(0.4)|D> is normalised with credence 60%
p13 = sqrt(sym(6)/10)^2 + sqrt(sym(4)/10)^2;
ge_check('TEXT-Ch13', 16945, p13 == 1 & sqrt(sym(6)/10)^2 == sym(6)/10, ...
    'sqrt(0.6)|U>+sqrt(0.4)|D>: norm 1, P(U)=0.6', char(p13));

%% Prop 13.1 (Robertson): [dA,dB] = [A,B] (symbolic) and the inequality (random Hermitian test)
syms a11 a22 b11 b22 real
syms a12 b12
A = [a11 a12; conj(a12) a22]; B = [b11 b12; conj(b12) b22];
syms mA mB real
cm1 = (A - mA*eye(2))*(B - mB*eye(2)) - (B - mB*eye(2))*(A - mA*eye(2));
ge_check('GE-PROP-13-1', 17245, simplify(cm1 - (A*B - B*A)) == zeros(2), ...
    '[dA,dB] = [A,B] (used in Robertson proof)', '');
rng(13); worst = inf;
for k = 1:2000
    n = 4; X = randn(n) + 1i*randn(n); Ah = (X + X')/2;
    Y = randn(n) + 1i*randn(n); Bh = (Y + Y')/2;
    v = randn(n,1) + 1i*randn(n,1); v = v/norm(v);
    eA = real(v'*Ah*v); eB = real(v'*Bh*v);
    dA = sqrt(real(v'*Ah^2*v) - eA^2); dB = sqrt(real(v'*Bh^2*v) - eB^2);
    worst = min(worst, dA*dB - 0.5*abs(v'*(Ah*Bh - Bh*Ah)*v));
end
ge_check('GE-PROP-13-1', 17235, worst > -1e-12, ...
    'dA*dB >= |<[A,B]>|/2 (2000 random 4x4 Hermitian pairs/states)', sprintf('min slack %.3g', worst));

%% 17254: "S = I_mu O^mu depends nonlinearly on the obligation"
I = sym('I', [1 3]); O1 = sym('O1_', [3 1]); O2 = sym('O2_', [3 1]); syms al be
lin = simplify(I*(al*O1 + be*O2) - (al*I*O1 + be*I*O2));
ge_check('GE-PROP-13-1', 17254, ~isAlways(lin == 0), ...
    '"S = I_mu O^mu depends nonlinearly on the obligation"', ...
    'S = I_mu O^mu is LINEAR in O: S(aO1+bO2) = aS(O1)+bS(O2) identically');

%% 17099 / 17104: superposition density matrix and coherence term
syms p th real
assume(p > 0 & p < 1);
ka = [1;0]; kb = [0;1];
psi = sqrt(p)*ka + exp(1i*th)*sqrt(1-p)*kb;
rho_sup = psi*psi';
rho_book = p*(ka*ka') + (1-p)*(kb*kb') + sqrt(p*(1-p))*(exp(1i*th)*(ka*kb') + exp(-1i*th)*(kb*ka'));
rho_mix = p*(ka*ka') + (1-p)*(kb*kb');
dz = @(M) simplify(expand(rewrite(M, 'sincos')));
ge_check('TEXT-Ch13', 17099, dz(rho_sup - rho_book) == zeros(2), ...
    'rho_sup = |psi><psi| = p|a><a| + (1-p)|b><b| + sqrt(p(1-p))(e^{i th}|a><b| + e^{-i th}|b><a|), psi = sqrt(p)|a> + e^{i th}sqrt(1-p)|b>', ...
    'phases swapped: |psi><psi| = p|a><a| + (1-p)|b><b| + sqrt(p(1-p))(e^{-i th}|a><b| + e^{+i th}|b><a|)');
ge_check('TEXT-Ch13', 17104, dz(rho_sup - rho_mix - sqrt(p*(1-p))*(exp(1i*th)*(ka*kb') + exp(-1i*th)*(kb*ka'))) == zeros(2), ...
    'rho_sup - rho_mix = sqrt(p(1-p))(e^{i th}|a><b| + e^{-i th}|b><a|)', ...
    'coherence term is sqrt(p(1-p))(e^{-i th}|a><b| + e^{i th}|b><a|) (same phase swap; harmless only for th = 0, pi)');

%% 17295 / 17301: interference formula
syms u1 v1 u2 v2 real
xa = u1 + 1i*v1; xb = u2 + 1i*v2;
zz = (xa + exp(1i*th)*xb)/sqrt(sym(2)); Pr = zz*conj(zz);
w = exp(1i*th)*conj(xa)*xb;
Pr_book = (xa*conj(xa) + xb*conj(xb) + (w + conj(w)))/2;
ge_check('TEXT-Ch13', 17295, dz(Pr - Pr_book) == 0, ...
    'Pr(x) = (|<x|a>|^2 + |<x|b>|^2 + 2Re(e^{i th}<x|a>*<x|b>))/2', '');
% numeric confirmation of the same identity
rng(1); okI = true;
for k = 1:200
    za = randn + 1i*randn; zb = randn + 1i*randn; t = 2*pi*rand;
    okI = okI && abs(abs((za + exp(1i*t)*zb)/sqrt(2))^2 - (abs(za)^2 + abs(zb)^2 + 2*real(exp(1i*t)*conj(za)*zb))/2) < 1e-12;
end
ge_check('TEXT-Ch13', 17295, okI, 'interference formula, 200 random numeric cases', '');

%% 17316: "When theta = 0 ... they reinforce everywhere"
% orthonormal framings (needed for the 1/sqrt2 state to be normalised); verdict basis |x+->=(|a>+-|b>)/sqrt2
xp = [1;1]/sqrt(2); xm = [1;-1]/sqrt(2);
Ip = 2*real(exp(0)*conj(xp'*ka)*(xp'*kb)); Im = 2*real(exp(0)*conj(xm'*ka)*(xm'*kb));
ge_check('TEXT-Ch13', 17316, Ip >= 0 && Im >= 0, ...
    '"When theta = 0, the framings are aligned: they reinforce everywhere"', ...
    sprintf('theta=0, orthonormal framings: I(x+)=%+.2f, I(x-)=%+.2f; sum_x I(x)=2Re(e^{i th}<a|b>)=0 for any normalised state with <a|b>=0, so I(x) cannot be >=0 everywhere unless it is 0 everywhere', Ip, Im));

%% 17449: purity: pure state 1, maximally mixed 1/n
okp = true;
for n = 2:6
    v = sym(ones(n,1))/sqrt(sym(n)); okp = okp && isAlways(trace((v*v')^2) == 1) && isAlways(trace((eye(n)/n)^2) == 1/sym(n));
end
ge_check('TEXT-Ch13', 17449, okp, 'purity Tr(rho^2) = 1 (pure), 1/n (maximally mixed), n=2..6', '');

%% Prop 13.2: probability conservation under self-adjoint H
syms h11 h22 real
syms h12 c1 c2
H = [h11 h12; conj(h12) h22]; ps = [c1; c2];
dps = -1i*H*ps;
ge_check('GE-PROP-13-2', 18081, simplify(dps'*ps + ps'*dps) == 0, ...
    'd/dt <psi|psi> = <-iH psi|psi> + <psi|-iH psi> = 0 for H = H^dagger', '');
X = randn(5) + 1i*randn(5); Hn = (X + X')/2; U = expm(-1i*Hn*1.7);
ge_check('GE-PROP-13-2', 18095, norm(U'*U - eye(5)) < 1e-10, 'U(t) = exp(-iHt) unitary', sprintf('||U''U-I|| = %.2g', norm(U'*U - eye(5))));

%% Prop 13.3: rectangular-barrier tunnelling (hbar = m = 1, -psi''/2 + V psi = E psi)
E0 = 0.3; V0 = 1.0; d0 = 1.7;
k0 = sqrt(2*E0); kap = sqrt(2*(V0 - E0));
% unknowns [r A B t]: psi = e^{ikx}+r e^{-ikx} (x<0); A e^{kap x}+B e^{-kap x}; t e^{ikx} (x>d)
Mx = [ 1, -1, -1, 0;
      -1i*k0, -kap, kap, 0;
       0, exp(kap*d0), exp(-kap*d0), -exp(1i*k0*d0);
       0, kap*exp(kap*d0), -kap*exp(-kap*d0), -1i*k0*exp(1i*k0*d0)];
rhs = [-1; -1i*k0; 0; 0];
sol = Mx\rhs; Tnum = abs(sol(4))^2;
Tex = 1/(1 + V0^2*sinh(kap*d0)^2/(4*E0*(V0 - E0)));
ge_check('GE-PROP-13-3', 18118, abs(Tnum - Tex) < 1e-12, ...
    'exact T = [1 + V0^2 sinh^2(kd)/(4E(V0-E))]^-1 (matching conditions solved, E=0.3,V0=1,d=1.7)', ...
    sprintf('matching gives %.12f, formula %.12f', Tnum, Tex));
syms E V d positive
assume(E < V);
kk = sqrt(2*(V - E));
ratio = (16*E*(V - E)/V^2*exp(-2*d*kk)) * (1 + V^2*sinh(kk*d)^2/(4*E*(V - E)));
ge_check('GE-PROP-13-3', 18104, simplify(limit(ratio, d, inf)) == 1, ...
    'T ~ 16E(V0-E)/V0^2 exp(-2d sqrt(2(V0-E))) for kd >> 1 (ratio -> 1)', char(simplify(limit(ratio, d, inf))));

%% Prop 13.4: reduced state of rho_AB = (1-eps)|Psi+><Psi+| + eps I/4   (basis OC, ON, LC, LN)
syms ep real
Psi = sym([1;0;0;1])/sqrt(sym(2));
rhoAB = (1 - ep)*(Psi*Psi') + ep*eye(4)/4;
ptrB = @(r) [r(1,1)+r(2,2), r(1,3)+r(2,4); r(3,1)+r(4,2), r(3,3)+r(4,4)];
rhoA = ptrB(rhoAB);
ge_check('GE-PROP-13-4', 18134, simplify(rhoA - eye(2)/2) == zeros(2), ...
    'rho_A = I/2 so S(rho_A) = ln 2 for all eps', '');
SA = -sum(eig(sym(eye(2))/2).*log(eig(sym(eye(2))/2)));
ge_check('GE-PROP-13-4', 18134, simplify(SA - log(sym(2))) == 0, '-Tr(I/2 ln I/2) = ln 2', char(SA));
% is S(rho_A) an entanglement measure here?  partial transpose on B
ptT = @(r) [r(1,1) r(2,1) r(1,3) r(2,3); r(1,2) r(2,2) r(1,4) r(2,4); r(3,1) r(4,1) r(3,3) r(4,3); r(3,2) r(4,2) r(3,4) r(4,4)];
mineig = @(e) min(eig(double(subs(ptT(rhoAB), ep, e))));
ge_check('GE-PROP-13-4', 18138, mineig(0.9) < 0, ...
    '18123/18138: S(rho_A)=ln2 is the "entanglement entropy"; positions indeterminate "whenever the collective state has any entanglement"', ...
    sprintf('rho_AB is separable (PPT, min eig of partial transpose = %+.3f) for eps >= 2/3, yet S(rho_A) = ln2 there too: for mixed rho_AB, S(rho_A) does not measure entanglement (rho_AB entangled iff eps < 2/3)', mineig(0.9)));

%% 17696 / 17699: rho_AB = 0.87|Psi+><Psi+| + 0.13 rho_noise and "13% violation rate"
r87 = subs(rhoAB, ep, sym(13)/100);         % noise = I/4, the noise model of Prop 13.4
pviol = r87(2,2) + r87(3,3);                % P(O,N) + P(L,C)
ge_check('TEXT-Ch13', 17696, [], ...
    '"The 13% violation rate corresponds ... to rho_AB = 0.87|Psi+><Psi+| + 0.13 rho_noise" (noise unspecified)', ...
    sprintf('with noise I/4 (Prop 13.4 model) the violation probability is 0.13 x 1/2 = %s (6.5%%); 13%% requires product noise that always violates', char(pviol)));
ge_check('TEXT-Ch13', 17702, mineig(0.13) < 0, '0.87/0.13 mixture is a "mixed entangled state"', sprintf('min eig PT = %.3f', mineig(0.13)));

%% 17833 / 16051: Tsirelson bound 2 sqrt 2 ~ 2.83
Z = [1 0; 0 -1]; Xp = [0 1; 1 0];
A0 = Z; A1 = Xp; B0 = (Z + Xp)/sqrt(2); B1 = (Z - Xp)/sqrt(2);
Bell = kron(A0,B0) + kron(A0,B1) + kron(A1,B0) - kron(A1,B1);
ps2 = [1;0;0;1]/sqrt(2); chsh = ps2'*Bell*ps2;
ge_check('TEXT-Ch13', 17833, abs(chsh - 2*sqrt(2)) < 1e-12 && abs(round(2*sqrt(2),2) - 2.83) < 1e-12, ...
    '|S| up to 2 sqrt2 ~ 2.83 (CHSH, maximally entangled state)', sprintf('%.6f', chsh));
