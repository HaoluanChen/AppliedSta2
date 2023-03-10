data {
  int<lower=0> N;
  vector[N] a; // loged arsenic level 
  vector[N] d; // distance
  vector[N] da; // loged arsenic level * distance 
  int<lower=0, upper=1> y[N]; 
}

parameters {
  vector[4] beta;
}

transformed parameters {
  vector[N] logitp;
  logitp= beta[1] + beta[2] * a + beta[3] * d + beta[4] * da;
}

model {
  y ~ bernoulli_logit(logitp);

  beta ~ normal(0,1);
}

generated quantities {
  vector[N] log_lik;    // pointwise log-likelihood for LOO
  vector[N] y_rep; // replications from posterior predictive dist

  for (n in 1:N) {
    real logit_hat_n = beta[1] + beta[2] * a[n] + beta[3] * d[n] + beta[4] * da[n];
    log_lik[n] = bernoulli_logit_lpmf(y[n] | logit_hat_n);
    y_rep[n] = bernoulli_logit_rng(logit_hat_n);
  }
}
