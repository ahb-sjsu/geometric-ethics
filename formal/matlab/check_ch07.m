warning('off', 'symbolic:sym:isAlways:TruthUnknown');
% check_ch07.m -- Geometric Ethics v1.24, Chapter 7 "One Case, Five Levels"
% (kidney allocation: Alice, Bob, Carol). Every recomputable number.
fprintf('\n--- check_ch07: One Case, Five Levels ---\n');
r = @(s) sym(round(str2double(s)*1e6))/1e6;   % exact rational from a decimal string
near = @(v, b, h) abs(double(v) - b) <= h + 1e-12;   % book rounding: half last digit

%% Level 0 scalar (L9849-9859), w = (0.5,0.3,0.2)
w = [r('0.5') r('0.3') r('0.2')];
SA = w * [r('0.9'); r('0.29'); r('0.55')];
SB = w * [r('0.6'); r('1.0');  r('0.38')];
SC = w * [r('0.5'); r('0.14'); r('0.72')];
ge_check('TEXT-Ch07', 9855, near(SA, 0.65, 0.005), 'S_Alice = 0.5(0.9)+0.3(0.29)+0.2(0.55) = 0.65', char(SA));
ge_check('TEXT-Ch07', 9857, near(SB, 0.68, 0.005), 'S_Bob = 0.5(0.6)+0.3(1.0)+0.2(0.38) = 0.68', char(SB));
ge_check('TEXT-Ch07', 9859, near(SC, 0.43, 0.005), 'S_Carol = 0.5(0.5)+0.3(0.14)+0.2(0.72) = 0.43', ...
    sprintf('%s = 0.436, which rounds to 0.44', char(SC)));
ge_check('TEXT-Ch07', 9868, SB > SA && SA > SC, 'ranking Bob > Alice > Carol; Bob receives the kidney');
% normalisation of the inputs: wait 2,7,1 years -> /7 ; age factor = 1 - age/100
ge_check('TEXT-Ch07', 9851, near(sym(2)/7, 0.29, 0.005) && near(sym(1)/7, 0.14, 0.005), ...
    'normalised wait times 0.29, 1.0, 0.14 = years/7');
ge_check('TEXT-Ch07', 9851, [], 'age factors 0.55, 0.38, 0.72', 'consistent with 1 - age/100 for ages 45, 62, 28 (the book does not state the rule)');

%% Level 1 vectors (L9969-10005)
OA = [r('0.9') r('0.29') r('0.55') r('0.8') r('0.8') r('0.7')];
OB = [r('0.6') r('1.0')  r('0.70') r('0.7') r('0.2') r('0.5')];
OC = [r('0.5') r('0.14') r('0.72') r('0.9') r('0.6') r('0.8')];
ge_check('TEXT-Ch07', 9970, [], 'Bob fairness x^3 = 0.70', ...
    'Alice/Carol fairness (0.55, 0.72) equal their Level-0 age factors, Bob''s (0.70) does not (0.38); flag only, the book gives no rule');
dom = @(u, v) all(u >= v) && any(u > v);
P = {OA, OB, OC}; anyDom = false;
for i = 1:3, for j = 1:3, if i ~= j && dom(double(P{i}), double(P{j})), anyDom = true; end, end, end
ge_check('TEXT-Ch07', 9994, ~anyDom, 'no vector dominates another on all components');
ge_check('TEXT-Ch07', 10001, all(isAlways(OA - OB == [r('0.3') r('-0.71') r('-0.15') r('0.1') r('0.6') r('0.2')])), ...
    'O_A - O_B = (0.3, -0.71, -0.15, 0.1, 0.6, 0.2)');
M = double([OA; OB; OC]);
[~, am] = max(M);    % argmax per dimension: 1 Alice, 2 Bob, 3 Carol
ge_check('TEXT-Ch07', 9987, am(5) == 1 && am(2) == 2 && am(4) == 3 && am(3) == 3 && am(6) == 3 && M(2,5) == min(M(:,5)), ...
    'profiles: Alice high-care, Bob highest wait / lowest care, Carol highest autonomy, fairness, epistemic');
ge_check('TEXT-Ch07', 10031, am(1) == 1 && am(2) == 2 && am(3) == 3 && am(5) == 1, ...
    'pure I_1 -> Alice, I_2 -> Bob, I_3 -> Carol, I_7 (care) -> Alice');

% Claim 2 (L10488): Alice's decision region in interest space larger than Bob's.
rng(1); N = 2e6;
Iw = -log(rand(N, 6)); Iw = Iw ./ sum(Iw, 2);        % uniform on the simplex
[~, win] = max(Iw * M.', [], 2);
fr = accumarray(win, 1, [3 1]) / N;
ge_check('TEXT-Ch07', 10488, fr(1) > fr(2), ...
    'Alice''s decision region has larger volume than Bob''s', ...
    sprintf('uniform-simplex shares Alice %.3f, Bob %.3f, Carol %.3f', fr));
ge_check('TEXT-Ch07', 10488, [], 'decision-region shares (uniform on the interest simplex, N=2e6)', ...
    sprintf('Alice %.3f, Bob %.3f, Carol %.3f', fr));

% Claim 3 (L10500): O_B - O_C large positive on wait-claim
dBC = OB - OC;
ge_check('TEXT-Ch07', 10500, isAlways(dBC(2) == r('0.86')) && double(dBC(2)) == max(double(dBC)), ...
    'O_B - O_C has a large positive wait-claim component (0.86)');

% Claim 6 (L10549): Gram matrix of O_A,O_B,O_C "span a two-dimensional subspace"
Gm = M * M.';
ge_check('TEXT-Ch07', 10549, rank(sym([OA; OB; OC])) == 2, ...
    'O_A, O_B, O_C span a two-dimensional subspace (Gram matrix)', ...
    sprintf('rank = %d, det(Gram) = %.4g (Euclidean): they span a 3-dimensional subspace', rank(sym([OA;OB;OC])), det(Gm)));

%% Level 3 rank-2 tensor M_ia (L10109-10180)
T = [r('0.75') r('0.90') r('0.40') r('0.50') r('0.62'); ...
     r('0.68') r('0.35') r('0.95') r('0.45') r('0.70'); ...
     r('0.55') r('0.30') r('0.30') r('0.92') r('0.58')];
util = sum(T, 2); rawls = min(double(T), [], 2);
ge_check('TEXT-Ch07', 10157, all(isAlways(util == [r('3.17'); r('3.13'); r('2.65')])), ...
    'utilitarian sums 3.17, 3.13, 2.65 -> Alice', char(util.'));
ge_check('TEXT-Ch07', 10168, isequal(rawls, [0.40; 0.35; 0.30]), 'Rawlsian minima 0.40, 0.35, 0.30 -> Alice');
v = [r('0.3') r('0.1') r('0.1') r('0.1') r('0.4')];
ex = T * v.';
ge_check('TEXT-Ch07', 10180, all(isAlways(ex == [r('0.653'); r('0.659'); r('0.549')])), ...
    'expert-weighted v=(0.3,0.1,0.1,0.1,0.4): 0.653, 0.659, 0.549 -> Bob', char(ex.'));
ge_check('TEXT-Ch07', 10124, double(T(1,2)) == max(double(T(:,2))) && double(T(2,3)) == max(double(T(:,3))), ...
    'Family(A) ranks Alice first (0.90); Family(B) ranks Bob first (0.95)');
Td = double(T); cc = corrcoef(Td);
ge_check('TEXT-Ch07', 10131, cc(1,5) > 0, 'physician and committee columns positively correlated', sprintf('r = %.3f', cc(1,5)));
ge_check('TEXT-Ch07', 10132, cc(2,3) < 0 && cc(2,4) < 0 && cc(3,4) < 0, ...
    'family columns pairwise negatively correlated', sprintf('r_AB=%.3f r_AC=%.3f r_BC=%.3f', cc(2,3), cc(2,4), cc(3,4)));
% Claim 1 (L10473): D_prof . D_fam (book: "can be orthogonal")
Dprof = Td(:,1) - Td(:,5); Dfam = var(Td(:,2:4), 1, 2);
ge_check('TEXT-Ch07', 10473, [], 'D_prof and D_fam "can be orthogonal" (modal claim)', ...
    sprintf('for this data cos(D_prof, D_fam) = %.3f, i.e. not orthogonal', dot(Dprof, Dfam)/norm(Dprof)/norm(Dfam)));

%% Level 4 metrics (L10241-10287), ideal = (1,...,1)
dA = 1 - OA; dB = 1 - OB; dC = 1 - OC;
eA = sum(dA.^2); eB = sum(dB.^2); eC = sum(dC.^2);
ge_check('TEXT-Ch07', 10247, near(eA, 0.88, 0.01) && near(sqrt(eA), 0.94, 0.005), ...
    'd(O_A,ideal) = sqrt(0.88) ~ 0.94', sprintf('%s -> %.4f', char(eA), double(sqrt(eA))));
ge_check('TEXT-Ch07', 10250, isAlways(eB == r('1.23')) && near(sqrt(eB), 1.11, 0.005), ...
    'd(O_B,ideal) = sqrt(1.23) ~ 1.11', sprintf('%s -> %.4f', char(eB), double(sqrt(eB))));
ge_check('TEXT-Ch07', 10253, near(eC, 1.28, 0.005) && near(sqrt(eC), 1.13, 0.005), ...
    'd(O_C,ideal) = sqrt(1.28) ~ 1.13', sprintf('%s -> %.4f', char(eC), double(sqrt(eC))));
ge_check('TEXT-Ch07', 10257, eA < eB && eA < eC, 'Euclidean decision: Alice closest');
Wd = [2 r('1.5') 1 r('0.5') 1 r('0.5')];
wA = sum(Wd .* dA.^2); wB = sum(Wd .* dB.^2); wC = sum(Wd .* dC.^2);
% with the book's own rounded squares (0.01,0.50,0.20,0.04,0.04,0.09) etc.
wAbook = sum(Wd .* [r('0.01') r('0.50') r('0.20') r('0.04') r('0.04') r('0.09')]);
wBbook = sum(Wd .* [r('0.16') r('0.00') r('0.09') r('0.09') r('0.64') r('0.25')]);
ge_check('TEXT-Ch07', 10267, near(wA, 1.14, 0.005) && near(sqrt(wA), 1.07, 0.005), ...
    'd_W(O_A,ideal) = sqrt(2(0.01)+1.5(0.50)+1(0.20)+0.5(0.04)+1(0.04)+0.5(0.09)) = sqrt(1.14) ~ 1.07', ...
    sprintf('the listed terms sum to %s (exact squares: %s), sqrt = %.2f, not sqrt(1.14)=1.07', char(wAbook), char(wA), double(sqrt(wA))));
ge_check('TEXT-Ch07', 10270, near(wB, 1.30, 0.005) && near(sqrt(wB), 1.14, 0.005), ...
    'd_W(O_B,ideal) = sqrt(2(0.16)+1.5(0.00)+1(0.09)+0.5(0.09)+1(0.64)+0.5(0.25)) = sqrt(1.30) ~ 1.14', ...
    sprintf('the listed terms sum to %s, sqrt = %.2f', char(wBbook), double(sqrt(wB))));
ge_check('TEXT-Ch07', 10273, near(wC, 1.87, 0.005) && near(sqrt(wC), 1.37, 0.005), ...
    'd_W(O_C,ideal) = sqrt(1.87) ~ 1.37', sprintf('%s -> %.4f', char(wC), double(sqrt(wC))));
ge_check('TEXT-Ch07', 10276, wA < wB && wA < wC, 'weighted decision: Alice (unchanged by the corrected values)');
ge_check('TEXT-Ch07', 10286, double(OB(2)) > double(OA(2)) && double(OA(2)) > double(OC(2)) && ...
    double(OB(2) - OA(2)) > 0.1, 'lexicographic on wait-claim: Bob 1.0 >> Alice 0.29 >> Carol 0.14 -> Bob');

% Off-diagonal (L10328-10334): g_12 < 0 reduces the distance from the ideal for
% profiles with high benefit AND high wait-claim (both deficits positive).
syms g12 real
assume(g12 < 0)
syms d1 d2 positive
ge_check('TEXT-Ch07', 10338, isAlways(2*g12*d1*d2 < 0), ...
    'negative g_12 reduces moral distance to the ideal when both deficits are positive');

% Claim 4 (L10516): utilitarian and Rawlsian both pick Alice
ge_check('TEXT-Ch07', 10516, find(util == max(util)) == 1 && find(rawls == max(rawls)) == 1, ...
    'utilitarian (sum) and Rawlsian (min) contractions both yield Alice');
