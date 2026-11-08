function ok = ge_check(id, line, cond, book, got)
%GE_CHECK  Record and print one PASS/FAIL line for a Geometric Ethics claim.
%   ge_check(id, line, cond, book, got)
%     id   : ledger claim id (or "TEXT-<chapter>" for an untagged worked example)
%     line : line number in source/Geometric-Ethics-v1.24.tex
%     cond : logical (symbolic conditions are passed through isAlways)
%            cond = [] records an uncounted NOTE: an observation that is not
%            a pass/fail claim (e.g. depends on a value the book leaves open).
%     book : what the book states (char)
%     got  : what the algebra gives (char)
%   ge_check('reset') zeroes the tallies; ge_check('summary') prints them.
persistent nPass nFail nNote fails
if isempty(nPass), nPass = 0; nFail = 0; nNote = 0; fails = {}; end
if ischar(id) && strcmp(id, 'reset')
    nPass = 0; nFail = 0; nNote = 0; fails = {}; ok = true; return
end
if ischar(id) && strcmp(id, 'summary')
    fprintf('\n==== SUMMARY: %d PASS, %d FAIL, %d checks (+%d NOTE) ====\n', ...
        nPass, nFail, nPass + nFail, nNote);
    for k = 1:numel(fails), fprintf('  FAIL %s\n', fails{k}); end
    ok = (nFail == 0); return
end
if nargin < 5, got = ''; end
if isempty(cond)
    nNote = nNote + 1; ok = true;
    fprintf('NOTE  %-16s L%-6d %s | %s\n', id, line, book, got);
    return
end
if isa(cond, 'sym'), cond = isAlways(cond, 'Unknown', 'false'); end
ok = all(logical(cond(:)));
if ok
    nPass = nPass + 1;
    fprintf('PASS  %-16s L%-6d %s\n', id, line, book);
else
    nFail = nFail + 1;
    fprintf('FAIL  %-16s L%-6d book: %s | algebra: %s\n', id, line, book, got);
    fails{end+1} = sprintf('%s L%d book: %s | algebra: %s', id, line, book, got);
end
end
