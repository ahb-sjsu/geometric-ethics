function Gam = ge_christoffel(G, X)
%GE_CHRISTOFFEL  Gam(k,i,j) = Gamma^k_{ij} of the Levi-Civita connection,
%   using exactly the book's formula (Def 4.4 / eq. after L13614):
%   Gamma^k_ij = 1/2 g^kl (d_j g_il + d_i g_jl - d_l g_ij).
n = numel(X); Gi = simplify(inv(G));
Gam = sym(zeros(n,n,n));
for k = 1:n, for i = 1:n, for j = 1:n
    s = sym(0);
    for l = 1:n
        s = s + Gi(k,l) * (diff(G(i,l), X(j)) + diff(G(j,l), X(i)) - diff(G(i,j), X(l)));
    end
    Gam(k,i,j) = simplify(s/2);
end, end, end
end
