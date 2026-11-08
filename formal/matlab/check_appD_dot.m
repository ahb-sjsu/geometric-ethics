function val = check_appD_dot(id, line, label, w, o, prods, total)
%CHECK_APPD_DOT  Recompute a book line "sum_k w_k*o_k = p_1 + ... + p_n = total".
%   w, o : numeric vectors (converted to exact rationals, 6 decimals)
%   prods: cellstr of the printed products ({} if the book prints none)
%   total: char, printed total. Returns the exact value.
q = @(x) sym(round(x * 1e6)) / 1e6;
pr = q(w) .* q(o);
val = sum(pr);
if ~isempty(prods)
    bad = '';
    for j = 1:numel(prods)
        s = prods{j}; k = find(s == '.', 1); d = numel(s) - k;
        pv = sym(round(str2double(s) * 10^d)) / 10^d;
        if ~isAlways(abs(pr(j) - pv) <= sym(5) / 10^(d+1))
            bad = [bad sprintf(' term%d book %s exact %s;', j, s, char(vpa(pr(j), 6)))]; %#ok<AGROW>
        end
    end
    ge_check(id, line, isempty(bad), [label ' products'], bad);
    k = find(prods{1} == '.', 1); d = numel(prods{1}) - k;
    extra = numel(prods) * sym(5) / 10^(d+1);
else
    extra = sym(0);
end
check_appD_near(id, line, [label ' = ' total], val, total, extra);
end
