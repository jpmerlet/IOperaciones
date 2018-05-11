using PyPlot;
N = 2;# cantidad de alumnos a entrevistar
V = zeros(N+1,7); # almacenar el el valor maximo de la calidad dada una etapa n y calidad i
X = zeros(N,7); # matriz que almacenará las decisiones
for etapa = N:-1:1
    for I_N = 1:7
        # calcular valor esperado de la opcion futura
        E = (1/7)*sum(V[etapa+1,:]);
        if I_N <= E
            V[etapa,I_N] = E;
            X[etapa,I_N] = 0;
        else
            V[etapa,I_N] = I_N;
            X[:,I_N] = zeros(N,1); # dejar un 1 solo donde se escogió al estudiante por primera vez
            X[etapa,I_N] = 1;

        end
    end
end
# imprimir el valor maximo esperado
print((1/7)*sum(V[1,:]))

# hacer el mismo calculo para varios N y despues plotear
V_max = zeros(90,1);
for N=90:-1:1
    V = zeros(N+1,7);
    for etapa = N:-1:1
        for I_N = 1:7
            # calcular valor esperado de la opcion futura
            E = (1/7)*sum(V[etapa+1,:]);
            if I_N <= E
                V[etapa,I_N] = E;
            else
                V[etapa,I_N] = I_N;
            end
        end
    end
    V_max[N] = (1/7)*sum(V[1,:]);
end
x = -2pi:0.1:2pi;
plot(x, sin(x.^2)./x);
