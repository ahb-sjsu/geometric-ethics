function R = ge_riemann(Gam, X)
%GE_RIEMANN  R(l,k,i,j) = R^l_{kij} with the book's component formula
%   (Def 4.5, L7062):  d_i Gamma^l_kj - d_j Gamma^l_ki
%                      + Gamma^l_im Gamma^m_kj - Gamma^l_jm Gamma^m_ki.
n = numel(X); R = sym(zeros(n,n,n,n));
for l = 1:n, for k = 1:n, for i = 1:n, for j = 1:n
    s = diff(Gam(l,k,j), X(i)) - diff(Gam(l,k,i), X(j));
    for m = 1:n
        s = s + Gam(l,i,m)*Gam(m,k,j) - Gam(l,j,m)*Gam(m,k,i);
    end
    R(l,k,i,j) = simplify(s);
end, end, end, end
end
