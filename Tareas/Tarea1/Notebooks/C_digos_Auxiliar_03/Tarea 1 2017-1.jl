#using Gadfly

# PARAMETROS DE ENUNCIADO #
alfaL = 0.5
alfaV = 0.3
abarUL = 0.4
abarDL = 0
abarUV = 0.5
abarDV = 0.1
dbarUL = 0.3
dbarDL = 0.1
dbarUV = 0.4
dbarDV = 0.1

# Discretizacion del partido

N = 7
T = 2^N

# Matrices para almacenar utilidades y decisiones optimas
V = zeros(2*T + 1,T+1) # t=1 -> (0), t=2 -> (-1,0,1), t=3 -> (-2,-1,0,1,2)...etc

X = zeros(2*T + 1,T) # Lo mismo de antes

# Condicion de borde de la utilidad
for i = (T + 2):(2*T + 1)
    V[i,T+1] = 1
end



# Funciones que dependen del nivel de agresividad del equipo local
function attL(x)
    return abarUL*x + abarDL*(1-x)
end

function defL(x)
    return dbarUL*(1-x) + dbarDL*x
end


# Estas son fijas porque el DT visitante ocupa siempre x = 0.5
attV = (abarUV + abarDV)/2
defV = (dbarUV + dbarDV)/2

function probL(x)
    return (alfaL + attL(x) - defV)/T
end


function probV(x)
    return (alfaV + attV - defL(x))/T
end

# Funcion de probabilidad
function Prob(L,V,x)
    return ((probL(x)^L)*(1-probL(x))^(1-L))*((probV(x)^V)*(1-probV(x))^(1-V))
end

ti = time()
for t = T:-1:1
    for d = -(t-1):(t-1)
        Vmax = -100000000000 # Valor arbitrariamente bajo para que podamos guardar el primer resultado
        for y = 0:10
            x = y/10
            Vsum = 0
            for l = 0:1
                for v = 0:1
                    Vsum = Vsum + Prob(l,v,x)*V[T + d + l - v + 1,t+1]
                end
            end
            if Vsum > Vmax
                Vmax = Vsum
                V[T+d+1,t] = Vmax
                X[T+d+1,t] = x+1
            end
        end
    end
end
tf = time()

print("Probabilidad de ganar = ",V[T+1,1],"   Tiempo resolución = ", tf - ti)
