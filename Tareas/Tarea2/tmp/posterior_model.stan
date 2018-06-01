data{
    int<lower=0> N;
    int <lower=0,upper=N> q[7];
    vector[7] alpha;
}
parameters{
    simplex[7] p;
}
model{
    p ~ dirichlet(alpha);
    q ~ multinomial(p);
}