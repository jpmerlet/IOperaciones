using Distributions, Stan, Mamba,Plots;

# definir semilla para replicar resultados
srand(123);
N_max = 100;
alpha = ones(7);
tmp = "/Users/juanpablodonosomerlet/Desktop/IOperaciones/Tareas/Tarea2/notebook/tmp/";
# generar vector aleatorio p
dirichlet = Dirichlet(alpha);
p = rand(dirichlet);

# generara calidades de los alumnos en
# diccionario con keyword N in {10:10:N_max}
quality_samples = Dict(string(i) => rand(Multinomial(i,p)) for i = 10:10:N_max);

# definir modelo de Stan
const MultinomialBayesian = "
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
";
stanmodel = Stanmodel(name = "posterior_model", model = MultinomialBayesian);

# definir diccionario con los datos
const MultinomialData = Dict("N" => N_max,
"q" => quality_samples[string(N_max)], "alpha" => alpha);

# correr MCMC
rc, sim1 = stan(stanmodel, [MultinomialData], tmp, CmdStanDir=CMDSTAN_HOME);

# correr MCMC para los diferentes N's
dicc_sim = Dict();
nombres_parametros = ["p.1", "p.2", "p.3", "p.4", "p.5", "p.6", "p.7"];
for i in 10:10:N_max
    const MultinomialData = Dict("N" => i, "q" => quality_samples[string(i)], "alpha" => alpha);
    _,sim_i = stan(stanmodel, [MultinomialData], tmp, CmdStanDir=CMDSTAN_HOME);
    dicc_sim[string(i)] = sim_i[:,nombres_parametros,:];
end

sim = sim1[:, nombres_parametros, :];
describe(sim)

# diccionario para almacenar resultados por cada N in 10:10:N_max
dicc_prom_by_N = Dict();
for j in 10:10:N_max
    N_str = string(j);
    array_p = zeros(0);
    for i in 1:7
        param = "p." * string(i);
        cadena = dicc_sim[N_str][: , [param], :];
        append!(array_p, mean(cadena.value));
    end
    dicc_prom_by_N[j] = array_p;
end
#hold(true)
eje_x = 1:7;
#grafico =plot(eje_x, y=dicc_prom_by_N[10],Geom.bar);
#plot!(y = dicc_prom_by_N[20],Geom.bar);
#img = PNG("prueba.png");
#draw(img,grafico);
#hold(off)
p = plot(eje_x, y=dicc_prom_by_N[10])
savefig(p,"tutorial_plot.png");
