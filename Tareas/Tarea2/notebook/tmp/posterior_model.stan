data{
    int<lower=0> N;
    int<lower=0,upper=N> q[N];
    int<lower=0,upper=1> alpha[7];
}
parameters{
    real <lower=0,upper=1> p[7];
}
model{
    p ~ Dirichlet(alpha);
    q ~ Multinomial(N,p); 
}