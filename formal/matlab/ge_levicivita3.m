function e = ge_levicivita3(a, b, c)
%GE_LEVICIVITA3  Levi-Civita symbol eps_abc for indices in 1..3.
I = eye(3);
e = round(det(I([a b c], :)));
end
