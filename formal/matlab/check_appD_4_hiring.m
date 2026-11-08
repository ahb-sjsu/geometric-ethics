% check_appD_4_hiring.m -- Appendix D.4 "Algorithmic Hiring" (tex L40314-40843).
fprintf('\n--- check_appD_4_hiring: App. D.4 Algorithmic Hiring ---\n');
ID = 'TEXT-AppD';
q = @(x) sym(round(x*1e6))/1e6;

% Biased-system Bond Index (L40440-40467)
J = q([82.1 85.9 84.8 84.2 83.1 86.1]); K = q([86.7 84.3 83.9 84.5 85.2 83.8]);
D = K - J;
check_appD_near(ID, 40451, 'Delta_orig = 86.7 - 82.1 = +4.6', D(1), '4.6');
lab = {'-1.6','-0.9','0.3','2.1','-2.3'};
for t = 1:5, check_appD_near(ID, 40452+t, sprintf('Delta_T%d = %s', t, lab{t}), D(t+1), lab{t}); end
ge_check(ID, 40441, D(2) < 0 && D(3) < 0 && D(4) > 0 && D(5) > 0 && D(5) < D(1) && D(6) < 0, ...
    'annotations: T1 J higher, T2 flipped, T3 K slightly, T4 K higher with smaller margin, T5 flipped', '');
ge_check(ID, 40443, abs(D(4)) == min(abs(D(2:6))), 'T3 "nearly equal" is the smallest |Delta|', '');
ad = abs(D(1) - D(2:6)); lab = {'6.2','5.5','4.3','2.5','6.9'};
okp = true; for t = 1:5, okp = okp && isAlways(ad(t) == sym(lab{t}(1)-'0') + sym(str2double(lab{t}(3)))/10); end
ge_check(ID, 40461, okp, '|Delta_orig - Delta_Ti| = 6.2, 5.5, 4.3, 2.5, 6.9', char(ad));
check_appD_near(ID, 40462, 'sum = 25.4', sum(ad), '25.4');
Dop = sum(ad) / 5;
check_appD_near(ID, 40462, 'D_op = (1/5)(25.4) = 5.08', Dop, '5.08');
Bd = Dop / 100 * (1 / q(0.01));
check_appD_near(ID, 40464, 'Bd = D_op/tau = 5.08 / 100 x (1/0.01) = 0.51', Bd, '0.51');
ge_check(ID, 40467, Bd > q(0.10), 'Bd >> 0.10 threshold (bias detected)', char(Bd));
ge_check(ID, 40732, Bd >= q(0.10) && Bd <= 1, 'biased system falls in tier "0.10-1.0: Remediate" (L40726)', ...
    sprintf('Bd as computed by the stated formula = %s, which is the "> 1.0: Fundamental redesign required" tier (L40727)', char(Bd)));
ge_check(ID, 40418, abs(34-27) <= 10 && abs(25-31) <= 10, 'T4 age moves 27->34, 31->25 are within +/-10 years', '');

% Merit-based obligation vectors / covectors
OJ = [0.88 0.85 0.80 0.90 0.75 0.70 0.85 0.80];
OK = [0.82 0.85 0.80 0.90 0.75 0.55 0.85 0.75];
Ic = [0.30 0.15 0.10 0.05 0.10 0.05 0.15 0.10]; Id = [0.10 0.20 0.25 0.25 0.05 0.05 0.05 0.05];
Ir = [0.05 0.25 0.20 0.10 0.10 0.10 0.15 0.05]; Is = [0.10 0.10 0.20 0.05 0.05 0.30 0.10 0.10];
Ip = [0.35 0.15 0.15 0.15 0.05 0.00 0.10 0.05];
nm = {'comp','cand','reg','soc','pure'}; Iv = {Ic, Id, Ir, Is, Ip}; IL = [40550 40556 40562 40568 40696];
for k = 1:5, ge_check(ID, IL(k), sum(q(Iv{k})) == 1, sprintf('I_%s weights sum to 1', nm{k}), char(sum(q(Iv{k})))); end
MJ = sym(zeros(1,4)); MK = MJ;
MJ(1) = check_appD_dot(ID, 40577, 'M_{J,comp}', Ic, OJ, {'0.264','0.128','0.080','0.045','0.075','0.035','0.128','0.080'}, '0.835');
MJ(2) = check_appD_dot(ID, 40580, 'M_{J,cand}', Id, OJ, {'0.088','0.170','0.200','0.225','0.038','0.035','0.043','0.040'}, '0.839');
MJ(3) = check_appD_dot(ID, 40583, 'M_{J,reg}',  Ir, OJ, {'0.044','0.213','0.160','0.090','0.075','0.070','0.128','0.040'}, '0.820');
MJ(4) = check_appD_dot(ID, 40586, 'M_{J,soc}',  Is, OJ, {'0.088','0.085','0.160','0.045','0.038','0.210','0.085','0.080'}, '0.791');
MK(1) = check_appD_dot(ID, 40593, 'M_{K,comp}', Ic, OK, {'0.246','0.128','0.080','0.045','0.075','0.028','0.128','0.075'}, '0.805');
MK(2) = check_appD_dot(ID, 40596, 'M_{K,cand}', Id, OK, {'0.082','0.170','0.200','0.225','0.038','0.028','0.043','0.038'}, '0.824');
MK(3) = check_appD_dot(ID, 40599, 'M_{K,reg}',  Ir, OK, {'0.041','0.213','0.160','0.090','0.075','0.055','0.128','0.038'}, '0.800');
MK(4) = check_appD_dot(ID, 40602, 'M_{K,soc}',  Is, OK, {'0.082','0.085','0.160','0.045','0.038','0.165','0.085','0.075'}, '0.735');
ge_check(ID, 40636, all(isAlways(MJ > MK)), 'J dominates K across all four perspectives', '');
dif = find(q(OJ) ~= q(OK));
ge_check(ID, 40637, [], 'margin "driven by two factors" (welfare 0.88 vs 0.82, societal 0.70 vs 0.55)', ...
    sprintf('O_J and O_K differ in 8-vector positions %s = dims 1, 6, 9 (welfare, societal AND epistemic 0.80 vs 0.75); epistemic adds e.g. 0.005 to the company margin', mat2str(dif)));
Jt = q([0.835 0.839 0.820 0.791]); Kt = q([0.805 0.824 0.800 0.735]);
check_appD_near(ID, 40646, 'Utilitarian S_J = 3.285', sum(Jt), '3.285');
check_appD_near(ID, 40647, 'Utilitarian S_K = 3.164', sum(Kt), '3.164');
check_appD_near(ID, 40650, 'Rawlsian S_J = 0.791', min(Jt), '0.791');
check_appD_near(ID, 40651, 'Rawlsian S_K = 0.735', min(Kt), '0.735');
ew = [0.30 0.10 0.40 0.20];  % comp, cand, reg, soc
ge_check(ID, 40654, sum(q(ew)) == 1, 'expert weights 0.40+0.30+0.20+0.10 = 1', '');
check_appD_dot(ID, 40655, 'Expert-weighted S_J', [0.40 0.30 0.20 0.10], [0.820 0.835 0.791 0.839], {'0.328','0.251','0.158','0.084'}, '0.821');
check_appD_dot(ID, 40656, 'Expert-weighted S_K', [0.40 0.30 0.20 0.10], [0.800 0.805 0.735 0.824], {'0.320','0.242','0.147','0.082'}, '0.791');
SJ = check_appD_dot(ID, 40700, 'pure-meritocracy S_J', Ip, OJ, {'0.308','0.128','0.120','0.135','0.038','0.000','0.085','0.040'}, '0.854');
SK = check_appD_dot(ID, 40703, 'pure-meritocracy S_K', Ip, OK, {'0.287','0.128','0.120','0.135','0.038','0.000','0.085','0.038'}, '0.831');
ge_check(ID, 40707, isAlways(SJ > SK), 'J still wins with zero societal weight', '');
ge_check(ID, 40684, 92 - 85 == 7, '7-point gap (92 vs 85)', '');
ge_check(ID, 40771, q(0.94) >= q(0.80), 'disparate impact 0.94 >= four-fifths 0.80 (PASS)', '');
