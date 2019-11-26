function [Nlvenc, Ncvenc] = vencedor2 (Mpesos,Vc)
%calcula o neuronio mais proximo ao vetor de caracteristica de entrada
%utilizacao: [Nlvenc, Ncvenc] = vencedor (Matriz de neuronios,Vetor de
%caracteristicas aleatorio)

dim1 = size(Mpesos);    %dimensoes da matriz de pesos
Nlinhas = dim1(1);      %linhas da matriz de pesos
Ncol = dim1(2);         %colunas da matriz de pesos
Ncaract = dim1(3)-1;    %caracteristicas de cada neuronio
%nao foi preciso calcular as dimensoes do vetor de caracteristicas por ele
%possuir o mesmo numero de colunas da matriz de pesos.

Mdist = zeros(Nlinhas,Ncol); % inicializando matriz das distancias entre vetor aleatorio e neuronio

%loop para calcular as distancias entre os neuronios e o vetor de entrada 
for i = 1:Nlinhas,
    for j = 1:Ncol,
        for c = 1:Ncaract,
            Mdist(i,j) = Mdist(i,j) + (Vc(c) - Mpesos(i,j,c))^2;   
        end
    end
end

%loop para escolha do "neuronio vencedor"
dmin = Mdist(1,1);
for i = 1:Nlinhas,
    for j = 1:Ncol,
        if Mdist(i,j) <= dmin
            Nl = i;
            Nc = j;
            dmin = Mdist(i,j);
        end
    end
end
Nlvenc = Nl;
Ncvenc = Nc;
            