% check_appD_1_triage.m -- Appendix D.1 "Emergency Triage" (tex L38668-39305).
% Recomputes every stated product, sum, min, distance and aggregation exactly
% (rationals). Rounded book values pass if within half a unit of the last
% printed digit of the exact value.
% v1.25: welfare of option gamma corrected from 0.62 to (0.60+0.85)/2 = 0.725,
% and every dependent gamma value (tensor row, contractions, distances,
% lexicographic order, DEME audit rankings/scores) recomputed in the book.
fprintf('\n--- check_appD_1_triage: App. D.1 Emergency Triage ---\n');
ID = 'TEXT-AppD';
q = @(x) sym(round(x*1e6))/1e6;

% Obligation vectors (L38774, 38801, 38826) and covectors (L38855-38894)
Oa = q([0.78 0.65 0.35 0.80 0.70 0.72]);
Ob = q([0.90 0.55 0.82 0.55 0.80 0.85]);
Og = q([0.725 0.60 0.58 0.55 0.25 0.65]);
I.phys = q([0.40 0.10 0.10 0.05 0.05 0.30]);
I.Afam = q([0.20 0.10 0.10 0.10 0.45 0.05]);
I.Bfam = q([0.10 0.45 0.10 0.15 0.10 0.10]);
I.Cfam = q([0.15 0.10 0.45 0.05 0.15 0.10]);
I.comm = q([0.20 0.20 0.25 0.10 0.10 0.15]);
ag = {'phys','Afam','Bfam','Cfam','comm'};

% welfare component rationale (L38781, 38808, 38833)
d1near(ID, 38780, 'welfare_a 0.78 ~ (0.95+0.60)/2', (q(0.95)+q(0.60))/2, '0.78');
d1near(ID, 38806, 'welfare_b 0.90 ~ (0.95+0.85)/2', (q(0.95)+q(0.85))/2, '0.90');
d1near(ID, 38832, 'welfare_g 0.725 = (0.60 + 0.85)/2 (v1.25; v1.24 printed 0.62)', (q(0.60)+q(0.85))/2, '0.725');
ge_check(ID, 38826, Og(1) == (q(0.60)+q(0.85))/2, 'O_g welfare component = 0.725', char(Og(1)));
d1near(ID, 39204, 'Transform 4: welfare 0.58 ~ (0.30+0.85)/2', (q(0.30)+q(0.85))/2, '0.58');

% covector weights sum to 1 (normalisation sanity)
for k = 1:5
    ge_check(ID, 38858, sum(I.(ag{k})) == 1, sprintf('I_%s weights sum to 1', ag{k}), char(sum(I.(ag{k}))));
end

% Step 5 -- all 15 entries M_{ia}, with printed products (L38912-38960)
P = struct();
P.a.phys = {{'0.312','0.065','0.035','0.040','0.035','0.216'},'0.703',38907};
P.a.Afam = {{'0.156','0.065','0.035','0.080','0.315','0.036'},'0.687',38910};
P.a.Bfam = {{'0.078','0.293','0.035','0.120','0.070','0.072'},'0.668',38913};
P.a.Cfam = {{'0.117','0.065','0.158','0.040','0.105','0.072'},'0.557',38916};
P.a.comm = {{'0.156','0.130','0.088','0.080','0.070','0.108'},'0.632',38919};
P.b.phys = {{'0.360','0.055','0.082','0.028','0.040','0.255'},'0.820',38926};
P.b.Afam = {{'0.180','0.055','0.082','0.055','0.360','0.043'},'0.775',38929};
P.b.Bfam = {{'0.090','0.248','0.082','0.083','0.080','0.085'},'0.668',38932};
P.b.Cfam = {{'0.135','0.055','0.369','0.028','0.120','0.085'},'0.792',38935};
P.b.comm = {{'0.180','0.110','0.205','0.055','0.080','0.128'},'0.758',38938};
P.g.phys = {{'0.290','0.060','0.058','0.028','0.013','0.195'},'0.644',38945};
P.g.Afam = {{'0.145','0.060','0.058','0.055','0.113','0.033'},'0.464',38948};
P.g.Bfam = {{'0.073','0.270','0.058','0.083','0.025','0.065'},'0.574',38951};
P.g.Cfam = {{'0.109','0.060','0.261','0.028','0.038','0.065'},'0.561',38954};
P.g.comm = {{'0.145','0.120','0.145','0.055','0.025','0.098'},'0.588',38957};
opts = {'a','b','g'}; Ovec = {Oa, Ob, Og};
M = sym(zeros(3,5));
for i = 1:3
    for k = 1:5
        e = P.(opts{i}).(ag{k});
        w = I.(ag{k}); o = Ovec{i};
        pr = w .* o;
        okp = true; bad = '';
        for j = 1:6
            if ~isAlways(abs(pr(j) - sym(round(str2double(e{1}{j})*1000))/1000) <= sym(5)/10^4)
                okp = false; bad = [bad sprintf(' term%d=%s', j, char(pr(j)))]; %#ok<AGROW>
            end
        end
        ge_check(ID, e{3}, okp, sprintf('M_{%s,%s} products', opts{i}, ag{k}), bad);
        % printed total = sum of the printed (rounded) terms, the book's convention
        ge_check(ID, e{3}, sum(sym(round(str2double(e{1})*1000))/1000) == sym(round(str2double(e{2})*1000))/1000, ...
            sprintf('M_{%s,%s} printed terms sum to printed total %s', opts{i}, ag{k}, e{2}), '');
        M(i,k) = sum(pr);
        d1near(ID, e{3}, sprintf('M_{%s,%s} = %s', opts{i}, ag{k}, e{2}), M(i,k), e{2}, 6*sym(1)/2000);
    end
end
Mtab = q([0.703 0.687 0.668 0.557 0.632; 0.820 0.775 0.668 0.792 0.758; 0.644 0.464 0.574 0.561 0.588]);

% Observation (L38991): beta max for 4 of 5 perspectives, Bfam tie a=b, beta never least
best = all(Mtab(2,[1 2 4 5]) > Mtab(1,[1 2 4 5])) && all(Mtab(2,[1 2 4 5]) > Mtab(3,[1 2 4 5]));
ge_check(ID, 38995, best && Mtab(1,3)==Mtab(2,3) && Mtab(2,3) > Mtab(3,3), ...
    'beta top for 4/5 perspectives; Bfam a=b=0.668; beta never least', '');

% Step 6 contractions (L39007-39037), on the tabulated (rounded) entries as the book does
S = sum(Mtab, 2);
lab = {'3.247','3.813','2.831'}; ln = [39008 39009 39010];
for i = 1:3, d1near(ID, ln(i), sprintf('Utilitarian S_%s = %s', opts{i}, lab{i}), S(i), lab{i}); end
ge_check(ID, 39013, S(2) == max(S), 'Utilitarian winner beta', '');
mins = min(Mtab, [], 2); lab = {'0.557','0.668','0.464'}; ln = [39021 39022 39023];
for i = 1:3, d1near(ID, ln(i), sprintf('Rawlsian S_%s = %s', opts{i}, lab{i}), mins(i), lab{i}); end
ge_check(ID, 39026, mins(2) == max(mins), 'Rawlsian winner beta (0.668)', '');
we = q([0.35 0.10 0.10 0.10 0.35]);
ge_check(ID, 39029, sum(we) == 1, 'expert weights sum to 1', char(sum(we)));
EW = Mtab * we.';
prs = {{'0.246','0.069','0.067','0.056','0.221'},{'0.287','0.078','0.067','0.079','0.265'},{'0.225','0.046','0.057','0.056','0.206'}};
lab = {'0.659','0.776','0.590'}; ln = [39036 39038 39040];
for i = 1:3
    pr = Mtab(i,:) .* we; okp = true; bad = '';
    for j = 1:5
        if ~isAlways(abs(pr(j) - sym(round(str2double(prs{i}{j})*1000))/1000) <= sym(5)/10^4), okp = false; bad = [bad sprintf(' term%d=%s', j, char(vpa(pr(j),6)))]; end %#ok<AGROW>
    end
    ge_check(ID, ln(i), okp, sprintf('Expert-weighted S_%s products', opts{i}), bad);
    d1near(ID, ln(i), sprintf('Expert-weighted S_%s = %s', opts{i}, lab{i}), EW(i), lab{i}, 5*sym(1)/2000);
end
ge_check(ID, 39044, EW(2) == max(EW), 'Expert-weighted winner beta', '');

% Step 7 metric distances (L39060-39102)
one = sym(ones(1,6));
sq = {(one-Oa).^2, (one-Ob).^2, (one-Og).^2};
sqp = {{'0.048','0.123','0.423','0.040','0.090','0.078'},{'0.010','0.203','0.032','0.203','0.040','0.023'},{'0.076','0.160','0.176','0.203','0.563','0.123'}};
ssum = {'0.802','0.511','1.301'}; dist = {'0.896','0.715','1.141'}; ln = [39062 39066 39070];
for i = 1:3
    okp = true; bad = '';
    for j = 1:6
        if ~isAlways(abs(sq{i}(j) - sym(round(str2double(sqp{i}{j})*1000))/1000) <= sym(5)/10^4), okp = false; bad = [bad sprintf(' term%d=%s', j, char(sq{i}(j)))]; end %#ok<AGROW>
    end
    ge_check(ID, ln(i)+1, okp, sprintf('Euclid squared terms opt %s', opts{i}), bad);
    d1near(ID, ln(i)+2, sprintf('Euclid sum opt %s = %s', opts{i}, ssum{i}), sum(sq{i}), ssum{i}, 6*sym(1)/2000);
    d1near(ID, ln(i)+2, sprintf('Euclid step sqrt(%s) ~ %s', ssum{i}, dist{i}), sqrt(sym(round(str2double(ssum{i})*1000))/1000), dist{i});
    d1near(ID, ln(i)+2, sprintf('Euclid d(O_%s,ideal) end-to-end ~ %s', opts{i}, dist{i}), sqrt(sum(sq{i})), dist{i}, sqrt(sum(sq{i})) - sqrt(sum(sq{i}) - 7*sym(1)/2000));
end
W = q([2.0 1.5 1.0 0.5 2.0 0.5]);
wp = {{'0.096','0.184','0.423','0.020','0.180','0.039'},{'0.020','0.304','0.032','0.101','0.080','0.011'},{'0.152','0.240','0.176','0.101','1.126','0.061'}};
wsum = {'0.942','0.548','1.856'}; wd = {'0.971','0.740','1.362'}; ln = [39082 39086 39090];
for i = 1:3
    % book multiplies its rounded squared terms by the weights
    sqr = sym(round(str2double(sqp{i})*1000))/1000; pr = W .* sqr; okp = true; bad = '';
    for j = 1:6
        if ~isAlways(abs(pr(j) - sym(round(str2double(wp{i}{j})*1000))/1000) <= sym(5)/10^4), okp = false; bad = [bad sprintf(' term%d=%s', j, char(pr(j)))]; end %#ok<AGROW>
    end
    ge_check(ID, ln(i)+1, okp, sprintf('Weighted terms opt %s (on rounded squares)', opts{i}), bad);
    d1near(ID, ln(i)+2, sprintf('Weighted step sqrt(%s) ~ %s', wsum{i}, wd{i}), sqrt(sym(round(str2double(wsum{i})*1000))/1000), wd{i});
    d1near(ID, ln(i)+2, sprintf('Weighted d_W(O_%s) end-to-end ~ %s', opts{i}, wd{i}), sqrt(sum(W .* sq{i})), wd{i}, sqrt(sum(W .* sq{i})) - sqrt(sum(W .* sq{i}) - (sum(W)+7)*sym(1)/2000));
    d1near(ID, ln(i)+2, sprintf('Weighted sum opt %s ~ %s', opts{i}, wsum{i}), sum(W .* sq{i}), wsum{i}, (sum(W)+6)*sym(1)/2000);
end
dE = [sqrt(sum(sq{1})) sqrt(sum(sq{2})) sqrt(sum(sq{3}))];
ge_check(ID, 39075, isAlways(dE(2) < dE(1)) && isAlways(dE(2) < dE(3)) && isAlways(dE(3) > dE(1)), 'Euclid: beta closest, gamma farthest', '');
dW = [sqrt(sum(W.*sq{1})) sqrt(sum(W.*sq{2})) sqrt(sum(W.*sq{3}))];
ge_check(ID, 39095, isAlways(dW(2) < dW(1)) && isAlways(dW(2) < dW(3)), 'Weighted: beta still wins', '');
ge_check(ID, 39101, Ob(1) > Oa(1) && Oa(1) > Og(1), 'Lexicographic welfare beta>alpha>gamma', '');

% Step 10 Bond index (L39197) and DEME audit (L39213-39279)
ge_check(ID, 39208, sym(0)/q(0.01) == 0, 'Bd = 0.0/0.01 = 0.0', '');
ge_check(ID, 39260, 44 + 3 == 47, 'transforms 44 invariance-preserving + 3 bond-changing = 47', '');
ge_check(ID, 39235, isequal(Mtab(:,1).', q([0.703 0.820 0.644])) && Mtab(2,1) > Mtab(1,1) && Mtab(1,1) > Mtab(3,1), 'TriageProtocolEM ranking = physician column, b>a>g', '');
ge_check(ID, 39240, isequal(Mtab(:,5).', q([0.632 0.758 0.588])) && Mtab(2,5) > Mtab(1,5) && Mtab(1,5) > Mtab(3,5), 'RightsFirstEM scores equal the committee column (0.758/0.632/0.588), b>a>g', '');
ge_check(ID, 39245, isequal(Mtab(:,4).', q([0.557 0.792 0.561])) && Mtab(2,4) > Mtab(3,4) && Mtab(3,4) > Mtab(1,4), 'FairnessEM scores = C-family column, b>g>a (v1.25 order)', '');
ge_check(ID, 39245, M(2,4) > M(3,4) && M(3,4) > M(1,4), 'FairnessEM order b>g>a also on exact entries', char(vpa(M(:,4).', 6)));
gw = q([0.40 0.30 0.30]);
fs = [Mtab(:,1) Mtab(:,5) Mtab(:,4)] * gw.';
ge_check(ID, 39252, sum(gw) == 1 && fs(2) == max(fs), sprintf('governance final scores a=%s b=%s g=%s, beta selected', char(fs(1)), char(fs(2)), char(fs(3))), '');
fprintf('INFO  App.D.1 governance final_scores (book leaves unevaluated): a=%.4f b=%.4f g=%.4f\n', double(fs));

function d1near(id, line, label, exact, printed, extra)
% PASS if |exact - printed| <= half a unit of the last printed digit (+ extra,
% the propagated rounding of the book's own printed intermediates, when the
% book computes from rounded intermediates). A pass that needs `extra` is
% flagged with an INFO line giving the exact value.
if nargin < 6, extra = sym(0); end
d = numel(printed) - find(printed == '.', 1);
tol = sym(5) / 10^(d+1);
pv = sym(round(str2double(printed) * 10^d)) / 10^d;
dif = abs(exact - pv);
if extra ~= 0, lab2 = [label ' (tol = half last digit + propagated rounding of printed intermediates)']; else, lab2 = label; end
ge_check(id, line, isAlways(dif <= tol + extra), lab2, sprintf('exact %s (|diff| %s > tol %s)', char(vpa(exact, 8)), char(vpa(dif, 3)), char(vpa(tol + extra, 3))));
if isAlways(dif > tol) && isAlways(dif <= tol + extra)
    fprintf('INFO  %-16s L%-6d rounding-chain: book %s, exact %s\n', id, line, printed, char(vpa(exact, 8)));
end
end

function ok = termsok(pr, strs)
ok = true;
for j = 1:numel(strs)
    d = numel(strs{j}) - find(strs{j} == '.', 1);
    pv = sym(round(str2double(strs{j}) * 10^d)) / 10^d;
    if ~isAlways(abs(pr(j) - pv) <= sym(5)/10^(d+1)), ok = false; end
end
end
