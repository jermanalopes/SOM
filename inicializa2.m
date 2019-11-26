function [Vrandom,Mpesos] = inicializa2 (escolha,Neulinhas,Neucolunas,caracteristicas,dadoF,Nvetc)
%inicializa a matriz de pesos, ou com 0 ou com um valor do banco de dados
%utilizacao: 
%Mpesos = inicializa (escolha,neuronios,caracteristicas,dadoF,treinamento)
%se escolha = 1, Mpesos igual a 0
%se escolha != 1, Mpesos igual a vetores de caracteristicas do banco de dados
Vrandom = randperm(Nvetc);
if (escolha == 1)
    for i = 1:Neulinhas,
        for j = 1:Neucolunas,
            for c = 1:caracteristicas,
                Mpesos(i,j,c) = 0;
            end
        end
    end
else
    aux1 = 1;
    for i = 1:Neulinhas,
        for j = 1:Neucolunas,
            Mpesos(i,j,:) = dadoF(Vrandom(aux1),:); %inicializar matriz de pesos com valores randomicos
            aux1 = aux1+1;
        end
    end
end