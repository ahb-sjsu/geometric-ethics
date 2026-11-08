function dy = ge_pt_rhs(GmF, y, dirv)
%GE_PT_RHS  ODE right-hand side for moving along a coordinate direction dirv
%   while parallel-transporting a 2-vector: dx/ds = dirv,
%   dO^m/ds = -Gamma^m_{ab} dirv^a O^b (book eq. L13670).
G = GmF(y(1), y(2));
O = y(3:4); dO = zeros(2,1);
for m = 1:2, for a = 1:2, for b = 1:2
    dO(m) = dO(m) - G(m,a,b)*dirv(a)*O(b);
end, end, end
dy = [dirv; dO];
end
