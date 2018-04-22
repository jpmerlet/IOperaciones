N = 2;
V = zeros(N+1,7); # esta variable guarda si ya se escogió a alguien o no
for etapa = N:-1:1
    for I_N = 1:7
        # calcular valor esperado de la opcion futura
        E = (1/7)*sum(V[etapa+1,:]);
        if I_N/7 <= E
            V[etapa,I_N] = E;
        else
            V[etapa,I_N] = I_N/7;
        end
    end
end
# calcular
print((1/7)*sum(V[1,:]))
