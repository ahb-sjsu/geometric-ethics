% run_all.m -- run every Geometric Ethics v1.24 symbolic/arithmetic check.
% Usage on Atlas (headless): matlab -batch "addpath(<dir>); run_all"
% Prints one PASS/FAIL/NOTE line per check (claim id, tex line) and a summary.
fprintf('Geometric Ethics v1.24 -- MATLAB Symbolic Math checks (%s, MATLAB %s)\n', ...
    char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm')), version);
fprintf('Source: source/Geometric-Ethics-v1.24.tex (line numbers = grep -n)\n');
fprintf('PASS/FAIL are counted; NOTE and INFO lines are observations, not counted.\n');
ge_check('reset');
GE_SCRIPTS = {'check_ch02_05', 'check_ch06', 'check_ch07', 'check_ch08_09', 'check_ch10_12', ...
    'check_ch13_quantum', 'check_ch14_collective', 'check_ch15_contraction', 'check_ch16_uncertainty', ...
    'check_ch17_empirical', 'check_ch18_19_alignment', 'check_ch20_21_econ_clinical', ...
    'check_ch23_finance', 'check_ch25_environment', 'check_ch26_ai', 'check_ch27_28_bio_military', ...
    'check_ch29_30', 'check_appD_1_triage', 'check_appD_2_whistleblower', 'check_appD_3_av', ...
    'check_appD_4_hiring', 'check_appD_5_climate'};
for GE_K = 1:numel(GE_SCRIPTS)
    clearvars -except GE_SCRIPTS GE_K     % no variables carried between scripts
    reset(symengine);                      % no symbolic assumptions carried over
    try
        run(GE_SCRIPTS{GE_K});
    catch err
        fprintf('ERROR in %s: %s (%s line %d)\n', GE_SCRIPTS{GE_K}, err.message, ...
            err.stack(1).name, err.stack(1).line);
    end
end
ge_check('summary');
