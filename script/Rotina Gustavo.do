* Trabalho Gustavo "Qualidade de Água no Brasil"

** 1°) Passo: Avaliar o banco

*a) Identificando o Painel

xtset cod ano, yearly 

*b) Lendo as variaveis do banco 

tis ano
iis cod

** 2°) Passo: Estimar os modelos em painel

*a) Modelo agregado ou POOL ( MQO normal)
reg IN084 invprestpercap invmunpercap investpercap, robust
outreg2 using E:\GUSTAVO\TCC\Dados\Arquivos Stata\Resultado32.doc, replace ctitle(variável IN084) label
xtreg IN084 invprestpercap invmunpercap investpercap, fe robust
outreg2 using E:\GUSTAVO\TCC\Dados\Arquivos Stata\Resultado32.doc, append ctitle(variável IN084) label
xtreg IN084 invprestpercap invmunpercap investpercap, re robust 
outreg2 using E:\GUSTAVO\TCC\Dados\Arquivos Stata\Resultado32.doc, append ctitle(variável IN084) label
reg IN084 invprestpercap invmunpercap investpercap ano1-ano13, robust
outreg2 using E:\GUSTAVO\TCC\Dados\Arquivos Stata\Resultado32.doc, append ctitle(variável IN084) label
xtreg IN084 invprestpercap invmunpercap investpercap ano1-ano13, fe robust
outreg2 using E:\GUSTAVO\TCC\Dados\Arquivos Stata\Resultado32.doc, append ctitle(variável IN084) label
xtreg IN084 invprestpercap invmunpercap investpercap ano1-ano13, re robust 
outreg2 using E:\GUSTAVO\TCC\Dados\Arquivos Stata\Resultado32.doc, append ctitle(variável IN084) label

*b) Modelo de regressão com a insersão de variáveis binárias

*b1) caso em que os coeficientes angulares são constantes, mas o intercepto varia entre as unidades, isto é: Yit= b1i + b2x2it + b3x3it + eit

tabulate id, gen(d)

reg y x2 x3 d1 d2 d3 d4
predict resid1
histogram resid1,normal

*b2) caso em que os coeficientes angulares são constantes, mas o intercepto varia entre os anos, isto é (dummy de ano). Yit= b1i + b2x2it + b3x3it + soma b4.ano + eit

tabulate ano, gen(ano)

reg y x2 x3 ano1-ano19

*b3) caso em que os coeficientes angulares são constantes, mas o intercepto varia entre os indivíduos e os anos.

reg y x2 x3 d2 d3 d4 ano1-ano19
predict resid2
histogram resid2, normal

*c) Modelo de Efeito Fixo (considerando o alpha constante entre as unidades)

xtreg y x2 x3, fe

*Prevendo os efeitos fixos das unidades

predict fe_id, u
list fe_id
histogram fe_id, normal

* Prevendo os efeitos fixos para tempo

tis id
iis ano
qui xtreg y x2 x3, fe
predict ano_fe, u
list ano_fe


*d) Modelo de Efeitos Aleatórios

tis ano
iis id
xtreg y x2 x3, re

*Prevendo os efeitos aleatorios das unidades

predict re_id, u
list re_id
histogram re_id, normal

* Prevendo os efeitos aleatorios para tempo

tis id
iis ano
qui xtreg y x2 x3, re
predict ano_re, u
list ano_re


 
 **3°) Passo: Checagem e escolha entre os modelos
 
*a) Teste de Chow (Avalia o melhor modelo entre POOl e EFeito Fixo). Aceita H0= o POOL(modelo restrito) é o melhor. Rejeita H0= EF (modelo irrestrito é o melhor).
 
xtreg IN084 invprestpercap invmunpercap investpercap, fe

*b) Teste de Hausman (Avalia o melhor modelo entre Efeito Fixo e Aleatório). Aceita H0= o EA (modelo diferença não sistemática) é o melhor. Rejeita H0=EF(modelo diferença sistemática é o melhor).
 
 qui xtreg IN084 invprestpercap invmunpercap investpercap, fe
 estimates store fe
 qui xtreg IN084 invprestpercap invmunpercap investpercap, re
 estimates store re
 hausman fe re
 
*c)Teste LM de Breuch-Pagan (Avalia o melhor modelo entre POOL e Efeito Aleatório). Aceita H0= o POOL é o melhor. Rejeita H0= EA (modelo de efeitos aleatórios é o melhor).
 
 qui xtreg IN084 invprestpercap invmunpercap investpercap, re
 xttest0
 
 
*d) Detecção de autocorrelação em Painel: Teste de Wooldridge. Aceita H0= não existe autocorrelação serial no painel. Rejeita H0= existe autocorrelação serial no painel.
 
 xtserial y x2 x3, output
 
 *d1) Correção autocorrelação, utilizar o comando cluster para indivíduos
 
 xtreg y x2 x3, cluster(id)
 predict residcd,u
 histogram residcd, normal
 
*e) Detecção de heterocedasticidade em Painel: Teste de Wald para grupos (efeitos fixos entre os grupos). Aceita H0= ausência de heterocedasticidade. Rejeita H0= existência de heterocedasticidade.
 
 qui xtreg y x2 x3, fe
 xttest3
 
*e1) Correção heterocedasticidade (Robust ou bootstrap)
 
xtreg y x2 x3, re robust
bootstrap: xtreg y x2 x3

* 4° Passo: Salvando os resultados

reg y x2 x3,robust
outreg2 using C:\Users\gibran\Desktop\resultado1.doc, replace ctitle(variável y) label 
xtreg y x2 x3, fe robust
outreg2 using C:\Users\gibran\Desktop\resultado1.doc, append ctitle(variável y) label 
xtreg y x2 x3, re robust
outreg2 using C:\Users\gibran\Desktop\resultado1.doc, append ctitle(variável y) label 
xtreg y x2 x3, cluster(id)
outreg2 using C:\Users\gibran\Desktop\resultado1.doc, append ctitle(variável y) label 
