using Distributions

# No sabía como hacer un "count if. Mala mía"
function countpos(x,y)
    z = x-y
    count = 0
    for i = 1: length(z)
        if z[i] > 0
            count = count+1
        end
    end
    return count
end

# Función para estimar la diferencia de 2 distribuciones beta
function proDifBeta(e1,f1,e2,f2)
    r = 10000 # Número de "simulaciones"
    x = rand(Beta(e1,f1),r)
    y = rand(Beta(e2,f2),r)
    q = countpos(x,y)/r
    p = max(q,1-q)
    return p
end

alfa1 = 1
beta1 = 1
alfa2 = 1
beta2 = 1

N = 10

V = zeros(N+1,N+1,N+1,N+1,N+1)
A = zeros(N+1,N+1,N+1,N+1,N+1)

# Valor residual

ti = time()
for e1 = 0:N
    for f1 = 0:(N-e1)
        for e2 = 0:(N - e1 - f1)
            f2 = N - e1 - e2 - f1
            V[e1+1,f1+1,e2+1,f2+1,N+1] = proDifBeta(alfa1+e1,beta1+f1,alfa2+e2,beta2+f2)
        end
    end
end

for n=N:-1:1
    for e1=0:n-1
        for f1=0:n-1-e1
            for e2=0:n-1-e1-f1
                f2 = n-1-e1-f1-e2
                aux_1 = ((alfa1+e1)*V[e1+2,f1+1,e2+1,f2+1,n+1]+(beta1+f1)*V[e1+1,f1+2,e2+1,f2+1,n+1])/(alfa1+e1+beta1+f1)
                aux_2 = ((alfa2+e2)*V[e1+1,f1+1,e2+2,f2+1,n+1]+(beta2+f2)*V[e1+1,f1+1,e2+1,f2+2,n+1])/(alfa2+e2+beta2+f2)
                if aux_1 > aux_2
                    V[e1+1,f1+1,e2+1,f2+1,n] = aux_1
                    A[e1+1,f1+1,e2+1,f2+1,n] = 1
                else
                    V[e1+1,f1+1,e2+1,f2+1,n] = aux_2
                    A[e1+1,f1+1,e2+1,f2+1,n] = 2
                end
            end
        end
    end
end
tf = time()
# Imprimimos el óptimo
print(V[1,1,1,1,1], tf - ti)
