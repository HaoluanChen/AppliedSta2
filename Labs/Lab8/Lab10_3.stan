
data {
  int<lower=0> N; // number of observations
  int<lower=0> T; //number of years
  int<lower=0> mid_year; // mid-year of study
  vector[N] y; //log ratio
  vector[N] se; // standard error around observations
  vector[T] years; // unique years of study
  int<lower=0> year_i[N]; // year index of observations
  int<lower=0> P;
  
}

parameters {
  vector[T] mu;
  real<lower=0> sigma;

}


model {
  
  y ~ normal(mu[year_i], se);
  mu[1] ~ normal(0,sigma);
  mu[2] ~ normal(0,sigma);
  mu[3:T] ~ normal(2*mu[2:(T-1)]-mu[1:(T-2)], sigma); // change this to second order RW for Q3 and change this to mu[3-T] ~normal(2*mu[2:T]....)
  // put model on mu2 
  sigma ~ normal(0, 1);
}

generated quantities{
  vector[P] mu_p;
  mu_p[1] = normal_rng(y[N], sigma);
  
  for(i in 2:P){
    mu_p[i] = normal_rng(mu_p[i-1], sigma);
  }
  
  
}
