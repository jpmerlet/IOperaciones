using Distributions;

# definir semilla para replicar resultados y generar realizacion de p
srand(123);
alpha = ones(7);
dirichlet = Dirichlet(alpha);
p = rand(dirichlet);
println("El valor de la realización de p es:",p)

# generara calidades de los alumnos en
# diccionario con keyword N in {10:10:N_max}
N_max = 100;
quality_samples = Dict(string(i) => rand(Multinomial(i,p)) for i = 10:10:N_max);
