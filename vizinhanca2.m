function [V,h] = vizinhanca2 (escolha,Nlvenc,Ncvenc,Ni,Nj,Nvizinhos,tmax,t,Vo,Vt)
%calcula a funcao de vizinhanca dependendo da escolha do usuario
%utilizacao -> escolha: 1 2 -> (tmax = treinamento*Nepocas)
%1: se neuronio for o vencedor ou vizinho: h = 1, se nao h = 0;
%2: se neuronio nao for vencedor ou vizinho: h = 0, se for:
%h = exp (-(||ri - ri*||^2)/(V^2)), onde V = Vo*((Vt/Vo)^(t/tmax)) 

if escolha == 1,
    V = 0;
    if ((abs(Nlvenc - Ni) > Nvizinhos) | (abs(Ncvenc - Nj) > Nvizinhos)),
        h = 0;
    else
        h = 1;
    end
else
    V = Vo*((Vt/Vo)^(t/tmax));
    if ((abs(Nlvenc - Ni) > Nvizinhos) | (abs(Ncvenc - Nj) > Nvizinhos)),
        h = 0;
    else
        h = exp(-((Nlvenc - Ni)^2+(Ncvenc-Nj)^2)/(V^2));
    end
end