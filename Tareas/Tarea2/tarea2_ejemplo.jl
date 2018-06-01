using Stan, Mamba;
tmp = "/Users/juanpablodonosomerlet/Desktop/IOperaciones/Tareas/Tarea2/notebook/tmp/";
const bernoullistanmodel = "
data {
  int<lower=0> N;
  int<lower=0,upper=1> y[N];
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  theta ~ beta(1,1);
    y ~ bernoulli(theta);
}
";

stanmodel_bernoulli = Stanmodel(name="bernoulli", model=bernoullistanmodel);
stanmodel_bernoulli |> display

const bernoullidata = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]);

rc, sim1 = stan(stanmodel_bernoulli, [bernoullidata], tmp, CmdStanDir=CMDSTAN_HOME);
sim = sim1[1:1000, ["theta"], :];
describe(sim)

#p = plot(sim, [:trace, :mean, :density, :autocor], legend=true);
p = plot(sim, [:mean], legend=true);
draw(p, ncol=1, filename="summaryplot", fmt=:svg)
draw(p, ncol=1, filename="summaryplot", fmt=:png)
