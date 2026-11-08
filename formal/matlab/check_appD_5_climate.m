% check_appD_5_climate.m -- Appendix D.5 "Climate Policy Allocation" (tex L40844-41481)
% and the D.6 summary table counts. Checks the v1.25 rebuilt cooperative game.
fprintf('\n--- check_appD_5_climate: App. D.5 Climate Policy ---\n');
ID = 'TEXT-AppD';
q = @(x) sym(round(x*1e6))/1e6;
hist = sym([350 180 2 80 120]); gdp = sym([65 12 8 25 45]); cur = q([5.0 4.5 0.05 2.0 3.0]);
tot = sum(cur);
check_appD_near(ID, 40888, 'total current emissions = 14.55 Gt/yr', tot, '14.55');
check_appD_near(ID, 40888, 'required reduction 50% = 7.275 Gt/yr', tot/2, '7.275');
R = tot/2;

% "Computed values" (L41120-41122) from the table and the stated definitions
cap = gdp / max(gdp); res = hist / max(hist); sh = cur / tot;
cb = {'1.00','0.18','0.12','0.38','0.69'}; rb = {'1.00','0.51','0.006','0.23','0.34'}; sb = {'0.344','0.309','0.003','0.137','0.206'};
for i = 1:5
    check_appD_near(ID, 41120, sprintf('capacity N%d = GDP/max(GDP) = %s', i, cb{i}), cap(i), cb{i});
    check_appD_near(ID, 41121, sprintf('responsibility N%d = hist/max(hist) = %s', i, rb{i}), res(i), rb{i});
    check_appD_near(ID, 41122, sprintf('current_share N%d = cur/14.55 = %s', i, sb{i}), sh(i), sb{i});
end

% v1.25 game (L41109, rebuilt): national capacity = capacity x current share; b_i = mean of
% national capacity, responsibility, current share, each normalised to sum 1 (printed table values);
% S^a_{bc} adds 3|S^a_{bc}| b_a to v(S) when b, c in S and a not in S. Exact Shapley by enumeration;
% guard: cap at current emissions with the excess shared in proportion to phi (binds only in Transform 3).
% Weight sets: 1 = Step 4 (equal), 2-4 = metrics 1-3 (g_11, g_33, g_66), 5 = Transform 3 (resp = 1).
capT = q([1.00 0.18 0.12 0.38 0.69]); resT = q([1.00 0.51 0.006 0.23 0.34]); shT = q([0.344 0.309 0.003 0.137 0.206]);
natT = capT .* shT;
WS = {q([1 1 1]), q([1.0 3.0 1.5]), q([2.5 1.0 1.0]), q([0.5 1.0 1.0]), q([1 1 1])};
n = 5; PHI = cell(1,5); FSH = cell(1,5); ALC = cell(1,5); CAPD = cell(1,5); B = cell(1,5);
for wk = 1:5
    rr = resT; if wk == 5, rr = sym(ones(1,5)); end
    w = WS{wk};
    b = (w(1)*natT/sum(natT) + w(2)*rr/sum(rr) + w(3)*shT/sum(shT)) / sum(w);
    v = @(m) sum(b(m)) + 3*q(0.35)*b(3)*double(m(1) && m(2) && ~m(3)) ...
                       + 3*q(0.15)*b(2)*double(m(1) && m(5) && ~m(2));
    phi = sym(zeros(1,n));
    for i = 1:n
        others = setdiff(1:n, i);
        for mm = 0:2^(n-1)-1
            S = others(logical(bitget(mm, 1:n-1))); k = numel(S);
            m0 = false(1,n); m0(S) = true; m1 = m0; m1(i) = true;
            phi(i) = phi(i) + factorial(sym(k))*factorial(sym(n-k-1))/factorial(sym(n)) * (v(m1) - v(m0));
        end
    end
    sh0 = phi / sum(phi); fixed = false(1,n);
    while true
        al = sym(zeros(1,n)); if any(fixed), al(fixed) = cur(fixed); end
        al(~fixed) = sh0(~fixed) / sum(sh0(~fixed)) * (R - sum(cur(fixed)));
        over = ~fixed & isAlways(al > cur);
        if ~any(over), break; end
        fixed = fixed | over;
    end
    PHI{wk} = phi; ALC{wk} = al; FSH{wk} = al / R; CAPD{wk} = fixed; B{wk} = b;
end
phi = PHI{1}; b = B{1}; al = ALC{1};
bb = {'0.468','0.216','0.002','0.112','0.203'};
for i = 1:5, check_appD_near(ID, 41125, sprintf('stand-alone burden b_N%d = %s', i, bb{i}), b(i), bb{i}); end
ge_check(ID, 41125, isAlways(sum(b) == 1) && isAlways(sum(phi) == 1), ...
    'sum b_i = 1 and the transfers add nothing to v(N): sum phi = 1 exactly', char(sum(phi)));
pb = {'0.484','0.184','0.001','0.112','0.219'}; PL = [41143 41154 41165 41174 41183];
for i = 1:5
    check_appD_near(ID, PL(i), sprintf('phi_N%d = %s (exact Shapley value of the v1.25 game)', i, pb{i}), phi(i), pb{i});
end
fprintf('INFO  App.D.5 v1.25 Shapley values: %s\n', mat2str(double(phi), 6));
t3 = q(0.35)*b(3); t2 = q(0.15)*b(2);
ge_check(ID, 41165, isAlways(phi == b + [t3/2 + t2/2, t3/2 - t2, -t3, 0, t2/2]), ...
    'transfers: N3 gives 35% and N2 15% of its stand-alone burden, half to each nation of the pair', '');
pv = q([0.484 0.184 0.001 0.112 0.219]);
ge_check(ID, 41190, sum(pv) == 1, 'sum phi = 0.484+0.184+0.001+0.112+0.219 = 1.000', char(sum(pv)));
ge_check(ID, 41168, ~any(CAPD{1}) && all(isAlways(phi*R <= cur)), 'no allocation exceeds current emissions (cap does not bind)', '');
fb = {'3.522','1.337','0.010','0.812','1.593'}; FL = [41146 41157 41168 41177 41186];
pct = {'70.4','29.7','20.4','40.6','53.1'}; resid = {'1.478','3.163','0.040','1.188','1.407'};
fsb = q([3.522 1.337 0.010 0.812 1.593]);
for i = 1:5
    check_appD_near(ID, FL(i), sprintf('N%d fair share phi x 7.275 = %s Gt', i, fb{i}), phi(i)*R, fb{i});
    check_appD_near(ID, FL(i), sprintf('N%d reduction %% = %s', i, pct{i}), 100*phi(i)*R/cur(i), pct{i});
    check_appD_near(ID, 41225+i, sprintf('N%d residual = %s', i, resid{i}), cur(i) - fsb(i), resid{i});
end
check_appD_near(ID, 41168, 'N3 reduction 20% of its 0.05 Gt (text)', 100*phi(3)*R/cur(3), '20');
check_appD_near(ID, 41231, 'total Shapley share 7.274', sum(fsb), '7.274');
check_appD_near(ID, 41231, 'total residual 7.276', tot - sum(fsb), '7.276');
pr = phi*R ./ cur;
ge_check(ID, 41237, fsb(1) == max(fsb) && isAlways(pr(1) == max(pr)), 'N1 largest absolute and highest proportional burden', '');
ge_check(ID, 41237, isAlways(pr(5) == max(pr(2:5))) && isAlways(pr(2) == min(pr([1 2 4 5]))) && isAlways(pr(3) < pr(2)), ...
    'N5 next-highest proportional burden; N2 lowest of the four large emitters, N3 (20.4%) lower still', '');

% NDC comparison (L41274-41295)
ndc = q([2.00 1.00 0.01 0.80 1.20]); gb = {'-1.522','-0.337','0.000','-0.012','-0.393'};
for i = 1:5, check_appD_near(ID, 41273+i, sprintf('N%d gap = %s', i, gb{i}), ndc(i) - fsb(i), gb{i}); end
check_appD_near(ID, 41279, 'NDC total 5.01', sum(ndc), '5.01');
check_appD_near(ID, 41283, 'contraction loss 7.274 - 5.01 = 2.264', sum(fsb) - sum(ndc), '2.264');
check_appD_near(ID, 41284, 'NDC achieves 69% of the Shapley-fair allocation', 100*sum(ndc)/sum(fsb), '69');
check_appD_near(ID, 41431, 'gap_pct 31.1', 100*(sum(fsb)-sum(ndc))/sum(fsb), '31.1');
check_appD_near(ID, 41292, 'N1 undercommits 43% of its fair share', 100*(fsb(1)-ndc(1))/fsb(1), '43');
check_appD_near(ID, 41294, 'N5 undercommits 25% of its fair share', 100*(fsb(5)-ndc(5))/fsb(5), '25');
g = fsb - ndc; gs = sort(g, 'descend');
ge_check(ID, 41292, g(1) == gs(1) && g(5) == gs(2), 'N1 has the largest absolute gap, N5 the second', '');
ge_check(ID, 41443, 32 + 6 == 38, 'transforms 32 + 6 = 38', '');

% Metric analysis (L41308-41344): diagonal entries in the 7-dim order (welf,rights,fair,auton,soc,proc,epist)
g1 = q([1.0 1.0 3.0 0.5 1.5 1.0 0.5]); g2 = q([2.5 0.5 1.0 0.5 1.0 0.5 0.5]); g3 = q([0.5 0.5 1.0 3.0 1.0 0.5 0.5]);
ge_check(ID, 41308, g1(3) == max(g1), 'per-capita metric amplifies g_33 (fairness)', '');
ge_check(ID, 41325, g2(1) == max(g2), 'capacity metric weights welfare (g_11) most', '');
ge_check(ID, 41344, g3(4) == max(g3), 'sovereignty metric weights autonomy (g_44) most', '');
ge_check(ID, 41316, isequal(WS{2}, g1([1 3 5])) && isequal(WS{3}, g2([1 3 5])) && isequal(WS{4}, g3([1 3 5])), ...
    'metric k weights the base terms by (g_11, g_33, g_66)', '');
ge_check(ID, 41316, ~any(CAPD{2}) && ~any(CAPD{3}) && ~any(CAPD{4}), 'cap binds under no metric', '');
M1 = FSH{2}; M2 = FSH{3}; M3 = FSH{4}; F0 = FSH{1};
nN = natT/sum(natT); rN = resT/sum(resT);
check_appD_near(ID, 41316, 'N1 national-capacity share 0.58', nN(1), '0.58');
check_appD_near(ID, 41316, 'N1 responsibility share 0.48', rN(1), '0.48');
check_appD_near(ID, 41316, 'N2 responsibility share 0.24', rN(2), '0.24');
check_appD_near(ID, 41316, 'N2 national-capacity share 0.09', nN(2), '0.09');
check_appD_near(ID, 41316, 'metric 1: phi''_N1 = 0.479', M1(1), '0.479');
check_appD_near(ID, 41316, 'metric 1: phi''_N2 = 0.200', M1(2), '0.200');
ge_check(ID, 41316, isAlways(M1(1) < F0(1)) && isAlways(M1(2) > F0(2)), 'metric 1: N1 down (from 0.484), N2 up (from 0.184)', '');
check_appD_near(ID, 41333, 'metric 2: phi''_N1 = 0.518', M2(1), '0.518');
check_appD_near(ID, 41333, 'metric 2: phi''_N5 = 0.228', M2(5), '0.228');
check_appD_near(ID, 41333, 'metric 2: phi''_N2 = 0.149', M2(2), '0.149');
ge_check(ID, 41333, isAlways(M2(1) > F0(1)) && isAlways(M2(5) > F0(5)) && isAlways(M2(2) < F0(2)) && isAlways(M2(3) < F0(3)), ...
    'metric 2: N1, N5 up; N2, N3 down', '');
check_appD_near(ID, 41346, 'metric 3: phi''_N1 = 0.464', M3(1), '0.464');
check_appD_near(ID, 41346, 'metric 3: phi''_N2 = 0.205', M3(2), '0.205');
check_appD_near(ID, 41346, 'metric 3: phi''_N5 = 0.214', M3(5), '0.214');
ns = ndc / sum(ndc); d0 = sqrt(sum((F0 - ns).^2)); d3 = sqrt(sum((M3 - ns).^2));
check_appD_near(ID, 41346, 'distance of allocation shares from pledge shares 0.101', d0, '0.101');
check_appD_near(ID, 41346, 'metric 3: distance 0.082 (closer to the NDC framework)', d3, '0.082');
% Transform 3 (L41369): responsibility_i = 1 for all
p3 = FSH{5};
ge_check(ID, 41369, isAlways(p3(1) < F0(1)) && isAlways(p3(2) > F0(2)), ...
    'Transform 3 (responsibility = 1): N1 share drops, N2 share rises', mat2str(double(p3), 4));
% Emergence degree (audit artifact, L41425; D.6 L41530): eta = |phi - b| / |phi|
eta = sqrt(sum((phi - b).^2)) / sqrt(sum(phi.^2));
check_appD_near(ID, 41425, 'emergence degree eta = |phi - b|/|phi| = 0.07', eta, '0.07');
% Why the transfer form: a unanimity term on {a,b,c} would be split equally and raise N3's burden
ge_check(ID, 41125, [], 'a +0.35 unanimity term on {N1,N2,N3} would add 0.35/3 to N3''s Shapley value (Shapley symmetry)', ...
    'the case reads S^N3_{N1,N2} as lowering N3''s burden, so it is entered as a transfer');

% D.6 summary table (L41513-41514): CS5 "5 nations x 7 dims"
ON = {[0.40 0.90 0.95 0.60 0.85 0.80 0.75],[0.55 0.60 0.50 0.80 0.75 0.70 0.60],[0.95 0.10 0.05 0.90 0.10 0.85 0.50], ...
      [0.60 0.55 0.55 0.70 0.50 0.75 0.65],[0.45 0.75 0.70 0.55 0.65 0.70 0.70]};
ge_check(ID, 41514, numel(ON) == 5 && all(cellfun(@numel, ON) == 7), 'D.6: CS5 obligation vectors are 5 nations x 7 dims', '');
