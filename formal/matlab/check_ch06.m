warning('off', 'symbolic:sym:isAlways:TruthUnknown');
% check_ch06.m -- Geometric Ethics v1.24, Chapter 6 (tensor hierarchy):
% satisfaction S = I_mu O^mu, Props 6.1-6.3, the 6.8 worked example, 6.9 formula.
fprintf('\n--- check_ch06: satisfaction scalar and tensor algebra ---\n');

%% Prop 6.1 (L9698): S invariant under coordinate change (generic 3x3 Jacobian)
J = sym('J', [3 3]);            % d xtilde / d x  (generic, assumed invertible)
I = sym('I', [3 1]); O = sym('O', [3 1]);
Ot = J*O;                        % vector: O~^mu = (dx~/dx) O
It = (inv(J)).' * I;             % covector: I~_mu = (dx/dx~) I
ge_check('GE-PROP-6-1', 9698, isAlways(simplify(It.'*Ot - I.'*O) == 0), ...
    'I~_mu O~^mu = I_mu O^mu (Jacobian and inverse Jacobian cancel)');

%% Prop 6.2 (L9708): S' - S = Delta I_mu O^mu ; S=S' for all O iff I=I'
Ip = sym('Ip', [3 1]);
ge_check('GE-PROP-6-2', 9707, isAlways(simplify((Ip.'*O - I.'*O) - (Ip - I).'*O) == 0), ...
    'S'' - S = (I''_mu - I_mu) O^mu');
E = eye(3); okAll = true;
for k = 1:3, okAll = okAll && isAlways((Ip - I).' * E(:,k) == Ip(k) - I(k)); end
ge_check('GE-PROP-6-2', 9719, okAll, 'choosing O = e_mu isolates Delta I_mu (so S=S'' for all O => I=I'')');

%% Prop 6.3 (L9725): gradient (grad f)^mu = g^{mu nu} d_nu f depends on the metric
syms x1 x2 real
f = x1^2 + 3*x1*x2;
df = [diff(f,x1); diff(f,x2)];
g1 = eye(2); g2 = [2 0; 0 1];
gr1 = simplify(inv(g1)*df); gr2 = simplify(inv(g2)*df);
ge_check('GE-PROP-6-3', 9725, ~all(isAlways(gr1 == gr2, 'Unknown', 'false')), ...
    'different metrics give different gradient directions for the same f', ...
    sprintf('g=I: %s ; g=diag(2,1): %s', char(gr1.'), char(gr2.')));
% Proof's sufficient condition (L9740-9746): grad_g f != grad_ghat f "whenever
% df_mu != 0 along a dimension where the inverse metrics differ".
gi1 = [3 1; 1 3]; gi2 = [2 0; 0 2];        % both positive definite inverse metrics
dfc = [1; -1];                              % both components non-zero
v1 = gi1*dfc; v2 = gi2*dfc;
ge_check('GE-PROP-6-3', 9740, ~isequal(v1, v2), ...
    '(grad_g f) != (grad_ghat f) whenever df != 0 along a dimension where g^{-1} and ghat^{-1} differ', ...
    sprintf('counterexample g^-1=[3 1;1 3], ghat^-1=2I (differ in every entry), df=(1,-1): both gradients = (%d,%d); correct condition is (g^-1 - ghat^-1) df != 0', v1(1), v1(2)));

%% 6.8 worked example (L9475-9501)
O9 = sym([6 8 7 5 1 3 4 6 3]) / 10;
Iph = sym([20 15 15 10 5 10 10 10 5]) / 100;
Ifa = sym([30 25 5 15 5 2 13 3 2]) / 100;
termsPh = Iph .* O9; termsFa = Ifa .* O9;
bookPh = sym([120 120 105 50 5 30 40 60 15]) / 1000;
bookFa = sym([180 200 35 75 5 6 52 18 6]) / 1000;
ge_check('TEXT-Ch06', 9491, all(isAlways(termsPh == bookPh)) && isAlways(sum(termsPh) == sym(545)/1000), ...
    'S_physician terms 0.12+0.12+0.105+0.05+0.005+0.03+0.04+0.06+0.015 = 0.545', char(sum(termsPh)));
ge_check('TEXT-Ch06', 9501, all(isAlways(termsFa == bookFa)) && isAlways(sum(termsFa) == sym(577)/1000), ...
    'S_family terms 0.18+0.20+0.035+0.075+0.005+0.006+0.052+0.018+0.006 = 0.577', char(sum(termsFa)));
ge_check('TEXT-Ch06', 9503, isAlways(sum(termsFa) > sum(termsPh)), 'family satisfaction higher than physician''s');
ge_check('TEXT-Ch06', 9486, isAlways(sum(Iph) == 1) && isAlways(sum(Ifa) == 1), ...
    'both interest covectors are normalised (weights sum to 1)');
[~, mx] = max(double(Iph));
ge_check('TEXT-Ch06', 9488, mx == 1 && Iph(2) == Iph(3) && Iph(2) == sym(15)/100, ...
    'physician weights welfare (0.20) most, rights = justice = 0.15');
od = double(O9);
ge_check('TEXT-Ch06', 9477, od(2) >= od(3) && od(3) >= od(8) && ...
    od(8) >= max(od([1 4:7 9])) && od(5) == min(od), ...
    'O strongest in dims 2, 3, 8; weakest in dim 5');
ge_check('TEXT-Ch06', 9477, [], 'dims 2,3,8 named strongest', 'dim 1 (0.6) ties dim 8 (0.6)');

%% 6.9 tensor product and contraction (L9566-9573)
T = O * I.';                    % T^mu_nu = O^mu I_nu
ge_check('TEXT-Ch06', 9573, isAlways(trace(T) == I.'*O), 'S = T^mu_mu = O^mu I_mu');
% rank-1 (1,1) tensor: only one non-zero eigenvalue, equal to S
ge_check('TEXT-Ch06', 9576, [], '"eigenvalues give the principal modes of satisfaction"', ...
    'T = O (x) I has rank 1: a single nonzero eigenvalue = S, the other eigenvalues are 0');

% L9611: S = g^{mu alpha} E_alpha^beta I_beta . O^mu  -- two upper mu's are summed.
A = [2 1 0; 0 1 0; 0 0 3];       % non-orthogonal linear coordinate change x~ = A x
Gup = sym('h', [3 3]); Gup = (Gup + Gup.')/2;      % inverse metric g^{mu nu}
Em = sym('E', [3 3]);           % Em(alpha,beta) = E_alpha^beta
Sbook  = O.' * Gup * Em * I;                      % sum_mu O^mu g^{mu a} E_a^b I_b
Sbookt = (A*O).' * (A*Gup*A.') * (inv(A).'*Em*A.') * (inv(A).'*I);
dS = Sbookt - Sbook;  % evaluate at random rational inputs to show it is non-zero
vars = symvar(dS); rng(2); vals = sym(randi([-5 5], size(vars)));
dSn = double(subs(dS, vars, vals));
ge_check('TEXT-Ch06', 9611, dSn == 0, ...
    'S = g^{mu alpha} E_alpha^beta I_beta . O^mu is a scalar', ...
    'contracts two upper indices (mu); not invariant under x~=Ax (picks up A''A); a valid form is S = O^mu E_mu^beta I_beta (or lower mu with g_{mu nu})');
Sfix  = O.' * Em * I; Sfixt = (A*O).' * (inv(A).'*Em*A.') * (inv(A).'*I);
ge_check('TEXT-Ch06', 9611, isAlways(simplify(Sfixt - Sfix) == 0), ...
    '(reference) corrected contraction O^mu E_mu^beta I_beta is invariant');
