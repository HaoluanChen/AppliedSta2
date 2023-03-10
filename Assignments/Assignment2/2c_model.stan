/* Simple linear regression */
data {
  int<lower=1> N;       // number of observations
  int <lower=0>  death[N];    // 
  vector[N] pop;     // 
  vector[N] age;

}
parameters {
  real<lower=0> beta;           // coefs
  real<lower=0> alpha;
}

transformed parameters {
  vector[N] mu;
  for (i in 1:N){
    mu[i] = alpha * exp(beta * age[i]);
  }
  
}
model {
  // Log-likelihood
  for (i in 1:N){
      target += poisson_lpmf(death[i] | mu[i]*pop[i]);
  }


  //priors
  target += normal_lpdf(alpha | 700, 500)
          + normal_lpdf(beta | 0.036, 0.05);
}

//generated quantities {
//  vector[N] log_lik;    // pointwise log-likelihood for LOO
//  vector[N] log_weight_rep; // replications from posterior predictive dist

//  for (n in 1:N) {
//    real log_weight_hat_n = mu[n]*pop[n];
//    log_lik[n] = poisson_log_lpmf(death[n] | log_weight_hat_n);
//    log_weight_rep[n] =poisson_log_rng(log_weight_hat_n);
//  }
//}
