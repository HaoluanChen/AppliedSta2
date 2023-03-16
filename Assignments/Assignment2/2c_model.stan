data {
  int<lower=0> N;                   // number of observations
  int<lower=0> y[N];        // response (count or death)
  vector[N] age;
  vector[N] population;
}
parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
}
model {
  //priors
  alpha ~ normal(0, 0.01);
  beta ~ normal(0,0.01);

  //likelihood:
  target += poisson_log_lpmf(y | log(alpha*exp(beta*age).*population));
}
generated quantities {
  vector[N] log_lik;    // pointwise log-likelihood for LOO
  vector[N] death_rep; // replications from posterior predictive dist

  for (n in 1:N) {
    real death_hat_n = log(alpha*exp(beta*age[n]).*population[n]);
    log_lik[n] = poisson_log_lpmf(y[n] | death_hat_n);
    if (death_hat_n > 20) {
      death_rep[n] = poisson_log_rng(20);
      }
    else{
      death_rep[n] = poisson_log_rng(death_hat_n);
      }
  }
}

