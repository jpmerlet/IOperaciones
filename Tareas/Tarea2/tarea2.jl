using Distributions, Stan, Mamba, Gadfly;

# definir semilla para replicar resultados y generar realizacion de p
srand(123);
alpha = ones(7);
dirichlet = Dirichlet(alpha);
p = rand(dirichlet);

# generara calidades de los alumnos en
# diccionario con keyword N in {10:10:N_max}
N_max = 100;
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

# # definir diccionario con los datos
# const MultinomialData = Dict("N" => N_max,
# "q" => quality_samples[string(N_max)], "alpha" => alpha);
#
# # correr MCMC
# rc, sim1 = stan(stanmodel, [MultinomialData], tmp, CmdStanDir=CMDSTAN_HOME);

# correr MCMC para los diferentes N's
dicc_sim = Dict();
tmp = "/Users/juanpablodonosomerlet/Desktop/IOperaciones/Tareas/Tarea2/notebook/tmp/";
nombres_param = ["p.1", "p.2", "p.3", "p.4", "p.5", "p.6", "p.7"];
for i in 10:10:N_max
    const MultinomialData = Dict("N" => i,
    "q" => quality_samples[string(i)], "alpha" => alpha);
    _,sim_i = stan(stanmodel, [MultinomialData], tmp, CmdStanDir=CMDSTAN_HOME);
    dicc_sim[string(i)] = sim_i[:,nombres_param,:];
end

# concatenar las simulaciones para comparar
cadena_1 = dicc_sim[string(10)][:,:,1];
cadena_summary = cadena_1;
for i in 20:10:N_max
    cadena_i = dicc_sim[string(i)][:,:,1];
    cadena_summary = cat(3,cadena_summary, cadena_i);
end
cadena_summary = cadena_summary[:,nombres_param,:];

# graficar densidades con el valor de p destacado
graficos = plot(cadena_summary, [:mean, :density], legend=true);

for i in 1:7
    file_name = "densidad_"*"p_"*string(i)*".png";
    push!(graficos[2,i].layers,
    layer(xintercept=[p[i]],Geom.vline(color = "black", size = [0.5mm]))[1]);
#    draw(graficos[2,i], filename=file_name,fmt=:png);
    draw(PNG(file_name), graficos[2,i]);
end
