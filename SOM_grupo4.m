close all
clear all
clc

%% Inicializa��o dos Dados
tic;
dado = load('grupo4.txt');                    %matriz de caracteristicas
dim = size(dado);                               %dimensoes da matriz 
N_Lin = dim(1);                                 %numero de vetores de caracteristicas
N_Col = dim(2);                                  %numero de caracteristicas por vetor de caracteristica
Nclasses = 4;

%% Inicializa��o dos Par�metros
Neulinhas = 1;                             %numero de linhas de neuronios
Neucolunas = 7;                            %numero de colunas de neuronios
Neuronios = Neulinhas*Neucolunas;          %numero de neuronios totais
Nepocas = 800;                             
Nvizinhos = 1;                             %numero de vizinhos
escolha1 = 1;                              %Inicializado dos Neuronios
escolha2 = 2;                              %Passo de Aprendizagem
escolha3 = 2;                              %Fun��o de Vizinhan�a
Nt = 1;
No = 1;
Vt = 0.001;
Vo = 1;

%% Separa��o Treinamento e Teste
percTrein   = 70;
qtdTrein    = round(N_Lin*percTrein*0.01); %arrendodar valores
qtdTeste    = N_Lin-qtdTrein;
    
tmax = qtdTrein*Nepocas;                     %tempo maximo de qtdTrein
t = 0;                                       %tempo atual do qtdTrein

%% Pre-processamento - M�dia e Desvio Padr�o

dp = std(dado(:,1:N_Col-1));             %vetor dos desvios padroes de cada caracteristica
for j = 1:N_Col-1,                               
    soma = 0;                                   
    for i = 1:N_Lin,
        soma = soma + dado(i,j);                
    end
    media(j) = soma/N_Lin;                      
end


for j = 1:N_Col-1,
    for i = 1:N_Lin,
        dadoF(i,j) = (dado(i,j) - media(j))/dp(j);
    end
end
dadoF(:,N_Col) = dado(:,N_Col);

%% Separa��o das Sa�das para Classifica��o 
Classe1 = dadoF(1:26,:);
Classe2 = dadoF(27:29,:);
Classe3 = dadoF(30:39,:);
Classe4 = dadoF(40:42,:);

%% Aleatorizar e Separar Dados - Teste e Treinamento
Vrandom = randperm(N_Lin);                      
for i = 1:qtdTrein,
    Mtreino(i,:) = dadoF(Vrandom(i),:);
end
for i = 1:qtdTeste,
    MTeste(i,:) = dadoF(Vrandom(i+qtdTrein),:);
end

%% Inicializacao da matriz de pesos dos neuronios 
[Vrandom,Mpesos] = inicializa2(escolha1,Neulinhas,Neucolunas,N_Col,dadoF,N_Lin);

%% Treinamento
for epoca = 1:Nepocas,

Vrandom = randperm(qtdTrein);                
Erro(epoca) = 0;                                

for aux1 = 1:qtdTrein,                       
    
    t = t+1;
    N = aprendizagem (escolha2,tmax,t,No,Nt);   %passo de aprendizagem
    Vc = Mtreino(Vrandom(aux1),:);              %vetor de caracteristica aleatorio
    [Nlvenc, Ncvenc] = vencedor2 (Mpesos,Vc);   %funcao para descobrir neuronio vencedor

    %loop para atualizar matriz de pesos
    for i = 1:Neulinhas,
        for j = 1:Neucolunas,
            [V,h] = vizinhanca2 (escolha3,Nlvenc,Ncvenc,i,j,Nvizinhos,tmax,t,Vo,Vt);
            for c = 1:N_Col-1,
                Mpesos(i,j,c) = Mpesos(i,j,c) + N*h*( Vc(c) - Mpesos(i,j,c) );
            end
        end
    end
end

%Erro (uma epoca)
for aux1 = 1:qtdTrein,
    
    Vc = Mtreino(Vrandom(aux1),:);              %vetor de caracteristica aleatorio
    [Nlvenc, Ncvenc] = vencedor2 (Mpesos,Vc);   %funcao para descobrir neuronio vencedor

    %distancia entre neuronio vencedor e Vc
    dist = 0;                                   %inicializar distancia
    for c = 1:N_Col-1,
        dist = dist + (Mpesos(Nlvenc,Ncvenc,c) - Vc(c))^2;
    end
    %atualizacao do erro
    Erro(epoca) = Erro(epoca) + dist;
  end
Erro(epoca) = Erro(epoca)/N_Lin;
Acerto_Treine(epoca) = 100 - Erro(epoca);
end
Acerto_TreiMed = mean(Acerto_Treine) - mean(Erro)
Desviop_Treine = std(Acerto_Treine)


%% Plotar Curva de Erro de qtdTrein
% figure (1), hold on
% title('Erro por �poca')
% xlabel('�pocas');
% ylabel('Valor do Erro');
% epocas = 1:Nepocas;
% plot(epocas,Erro, 'r');

%% Plotar Pontos
aux1 = 1;
for i = 1:Neulinhas,
    for j = 1:Neucolunas,
        Vneu(aux1,:) = Mpesos(i,j,:);
        aux1 = aux1 + 1;
    end
end

% figure (2), hold on
% title('Separa��o dos Dados de Classifica��o')
% plot (Classe1(:,4),Classe1(:,5),'r.',Classe2(:,4),Classe2(:,5),'b.');
% legend('ICC','Saud�veis','Location','NorthEastOutside')
%% Votacao e Plotar Neuronios Graficamente
votacao = zeros (Neulinhas,Neucolunas,Nclasses);
for aux1 = 1:N_Lin,
    
    Vc = dadoF(aux1,:); %Varre todos os vetores de caracteristicas
    [Nlvenc, Ncvenc] = vencedor2 (Mpesos,Vc);   %funcao para descobrir neuronio vencedor
   
    if (aux1 <= 26),
        votacao(Nlvenc,Ncvenc,1) = votacao(Nlvenc,Ncvenc,1) + 1;
    end
    if (aux1 > 26 & aux1 <= 29),
         votacao(Nlvenc,Ncvenc,2) = votacao(Nlvenc,Ncvenc,2) + 1;
    end
    if (aux1 > 29 & aux1 <= 39),
         votacao(Nlvenc,Ncvenc,3) = votacao(Nlvenc,Ncvenc,3) + 1;
   end
    if(aux1 > 39),
        votacao(Nlvenc,Ncvenc,4) = votacao(Nlvenc,Ncvenc,4) + 1;
    end
end

% figure (5)
% hold on
for i = 1:Neulinhas,
    for j = 1:Neucolunas,
        if ((votacao(i,j,1) > votacao (i,j,2)) && (votacao(i,j,1) > votacao (i,j,3)) && (votacao(i,j,1) > votacao (i,j,4)))                   
            %plot (j,i,'r.');
            Mpesos(i,j,N_Col) = 1;
        end
        if ((votacao(i,j,2) > votacao (i,j,1)) && (votacao(i,j,2) > votacao (i,j,3)) && (votacao(i,j,2) > votacao (i,j,4))) 
            %plot (j,i,'b.');
            Mpesos(i,j,N_Col) = 2;
        end
       if ((votacao(i,j,3) > votacao (i,j,1)) && (votacao(i,j,3) > votacao (i,j,2)) && (votacao(i,j,3) > votacao (i,j,4))) 
            %plot (j,i,'w.');
            Mpesos(i,j,N_Col) = 3;
       if ((votacao(i,j,4) > votacao (i,j,1)) && (votacao(i,j,4) > votacao (i,j,2)) && (votacao(i,j,4) > votacao (i,j,3)))
            Mpesos(i,j,N_Col) = 4;
       end
        end
    end
end

%% Classificacao - TESTE

certos = 0;
errados = 0;

for aux2 = 1:qtdTeste,
    [Nlvenc, Ncvenc] = vencedor2 (Mpesos,MTeste(aux2,:)); %funcao para descobrir neuronio vencedor
    if ( Mpesos(Nlvenc,Ncvenc,N_Col) == MTeste(aux2,N_Col) ),
        certos = certos + 1;
    else
        errados = errados + 1;
    end
end
Acerto_Teste = (certos/(certos+errados))*100
tempo = toc
