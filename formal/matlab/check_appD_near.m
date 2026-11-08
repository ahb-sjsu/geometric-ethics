function ok = check_appD_near(id, line, label, exact, printed, extra)
%CHECK_APPD_NEAR  Helper for the Appendix D / Ch 29-30 checks.
%   PASS if |exact - printed| <= half a unit of the last printed digit
%   (+ extra: the propagated rounding of the book's own printed intermediates,
%   used only where the book computes from rounded intermediates). A pass that
%   needs `extra` prints an INFO line with the exact value.
%   exact: sym (exact rational) ; printed: char, the book's printed number.
if nargin < 6, extra = sym(0); end
printed = strrep(strrep(printed, char(8722), '-'), '+', '');
k = find(printed == '.', 1);
if isempty(k), d = 0; else, d = numel(printed) - k; end
tol = sym(5) / 10^(d+1);
pv = sym(round(str2double(printed) * 10^d)) / 10^d;
dif = abs(sym(exact) - pv);
lab2 = label;
if ~isequal(extra, 0) && ~isequal(extra, sym(0))
    lab2 = [label ' (tol = half last digit + propagated rounding of printed intermediates)'];
end
ok = ge_check(id, line, isAlways(dif <= tol + extra), lab2, ...
    sprintf('exact %s (|diff| %s > tol %s)', char(vpa(exact, 8)), char(vpa(dif, 3)), char(vpa(tol + extra, 3))));
if isAlways(dif > tol) && isAlways(dif <= tol + extra)
    fprintf('INFO  %-16s L%-6d rounding-chain: book %s, exact %s\n', id, line, printed, char(vpa(exact, 8)));
end
end
