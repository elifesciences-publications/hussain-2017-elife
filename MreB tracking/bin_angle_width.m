bin = 0.5;
j=1;
v=a;
for i = 0:bin:3
    a = find(v(:,2) >= i);
    b = find(v(:,2) < i+bin);
    c = intersect(a,b);
    m(j) =mean(v(c,1));
    st(j) = std(v(c,1));
    figure
    hist(v(c,1))
    j=j+1;
end
    