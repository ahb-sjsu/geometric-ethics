% check_appD_2_whistleblower.m -- Appendix D.2 "Whistleblower's Dilemma" (tex L39307-39779).
fprintf('\n--- check_appD_2_whistleblower: App. D.2 Whistleblower ---\n');
ID = 'TEXT-AppD';
q = @(x) sym(round(x*1e6))/1e6;
OR = [0.75 0.90 0.85 0.80 0.40 0.90 0.92];
OS = [0.45 0.10 0.10 0.30 0.90 0.10 0.92];
Ia = [0.30 0.10 0.05 0.20 0.25 0.05 0.05];
Ii = [0.15 0.30 0.25 0.05 0.05 0.15 0.05];
Ir = [0.10 0.15 0.15 0.05 0.05 0.30 0.20];
Ic = [0.25 0.05 0.05 0.10 0.40 0.05 0.10];
ge_check(ID, 39395, q(0.92) >= q(0.70), 'gate fires: evidence_quality 0.92 >= tau_fraud 0.70', '');
ge_check(ID, 39673, q(0.30) < q(0.70), 'Transform 4: 0.30 < tau 0.70, gate does not fire', '');
ge_check(ID, 39417, q(0.85)+q(0.15) == 1 && q(0.50)+q(0.50) == 1 && q(0.02)+q(0.98) == 1, ...
    'penumbral |a|^2+|b|^2 = 1 at all three stages', '');
check_appD_near(ID, 39700, 'pre_gate amplitude 0.14 = sqrt(|a|^2=0.02)', sqrt(q(0.02)), '0.14');
check_appD_near(ID, 39700, 'pre_gate amplitude 0.99 = sqrt(|b|^2=0.98)', sqrt(q(0.98)), '0.99');
nm = {'analyst','invest','reg','company'}; Iv = {Ia, Ii, Ir, Ic}; Ln = [39517 39525 39531 39537];
for k = 1:4, ge_check(ID, Ln(k), sum(q(Iv{k})) == 1, sprintf('I_%s weights sum to 1', nm{k}), char(sum(q(Iv{k})))); end
ge_check(ID, 39520, all(q(Ia([1 5])) > max(q(Ia([2 3 4 6 7])))), 'analyst weights welfare (0.30) and privacy (0.25) most', '');

MR = sym(zeros(1,4)); MS = MR;
MR(1) = check_appD_dot(ID, 39546, 'M_{R,analyst}', Ia, OR, {'0.225','0.090','0.043','0.160','0.100','0.045','0.046'}, '0.709');
MR(2) = check_appD_dot(ID, 39549, 'M_{R,invest}',  Ii, OR, {'0.113','0.270','0.213','0.040','0.020','0.135','0.046'}, '0.837');
MR(3) = check_appD_dot(ID, 39552, 'M_{R,reg}',     Ir, OR, {'0.075','0.135','0.128','0.040','0.020','0.270','0.184'}, '0.852');
MR(4) = check_appD_dot(ID, 39555, 'M_{R,company}', Ic, OR, {'0.188','0.045','0.043','0.080','0.160','0.045','0.092'}, '0.653');
MS(1) = check_appD_dot(ID, 39563, 'M_{S,analyst}', Ia, OS, {'0.135','0.010','0.005','0.060','0.225','0.005','0.046'}, '0.486');
MS(2) = check_appD_dot(ID, 39566, 'M_{S,invest}',  Ii, OS, {'0.068','0.030','0.025','0.015','0.045','0.015','0.046'}, '0.244');
MS(3) = check_appD_dot(ID, 39569, 'M_{S,reg}',     Ir, OS, {'0.045','0.015','0.015','0.015','0.045','0.030','0.184'}, '0.349');
MS(4) = check_appD_dot(ID, 39572, 'M_{S,company}', Ic, OS, {'0.113','0.005','0.005','0.030','0.360','0.005','0.092'}, '0.610');
ge_check(ID, 39605, isAlways(MR(1) > MS(1)), 'analyst prefers Report (0.709 > 0.486)', '');
ge_check(ID, 39608, isAlways(MR(4) > MS(4)) && isAlways(MR(4)-MS(4) == min(MR-MS)), 'company is the closest perspective (0.653 vs 0.610)', '');
Rt = q([0.709 0.837 0.852 0.653]);
check_appD_near(ID, 39620, 'Utilitarian S_R = 3.051', sum(Rt), '3.051');
check_appD_near(ID, 39621, 'Rawlsian S_R = 0.653', min(Rt), '0.653');
ew = q([0.35 0.30 0.20 0.15]);
ge_check(ID, 39622, sum(ew) == 1, 'expert weights 0.35+0.30+0.20+0.15 = 1', '');
check_appD_near(ID, 39622, 'Expert-weighted S_R = 0.35(0.852)+0.30(0.837)+0.20(0.709)+0.15(0.653) = 0.787', ...
    ew * Rt([3 2 1 4]).', '0.787');
check_appD_near(ID, 39649, 'privacy loss 0.90 - 0.40 = 0.50', q(0.90) - q(0.40), '0.50');
check_appD_near(ID, 39744, 'audit: privacy Delta = O_R - O_S = -0.50', q(OR(5)) - q(OS(5)), '-0.50');
ge_check(ID, 39741, [], 'audit: welfare Delta = -0.30, autonomy Delta = -0.20', ...
    sprintf('book gives no baseline; O_R-O_S: welfare %+.2f, autonomy %+.2f; O_R vs 1: welfare %.2f, autonomy %.2f; text L39450 "reduces from 0.90": welfare -0.15', ...
    OR(1)-OS(1), OR(4)-OS(4), OR(1)-1, OR(4)-1));
ge_check(ID, 39732, 49 + 3 == 52, 'transforms 49 + 3 = 52', '');
