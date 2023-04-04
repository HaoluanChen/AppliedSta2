
data {
  int<lower=0> N; //number of regions
  int y[N];//detahs 
  vector[N] log_e; //log of expcted deaths 
  vector[N] x;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[N] alpha;
  real beta;
}

transformed parameters{
  vector[N] log_theta;
  log_theta = alpha + beta*x;
}

model {
  y ~ poisson_log(log_theta+log_e);
  alpha ~ normal(0,1);
  beta ~ normal(0,1);
}

