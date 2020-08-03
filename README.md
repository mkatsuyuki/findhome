# Findhome - AG
Paulo Katsuyuki Muraishi Kamimura - 10277040
Afonso Henrique Piacentini Garcia - 9795272
Felipe Barbosa de Oliveira - 10276928

# Resumo
Nesse projeto desenvolvemos um algoritmo genético onde uma população de moscas evoluem para chegar em um ponto destino em um mapa com obstáculos. Utilizamos a linguagem de programação Processing (baseada em Javascript), e os resultados foram satisfatórios.

# Método
Cada mosca se movimenta baseada em um vetor de direções (um vetor de acelerações da mosca, uma por iteração), de modo que seja gerado um caminho. Como todas as moscas são inicializadas no mesmo ponto, um vetor de direções igual implica em um caminho igual. É então gerado uma população de moscas, e elas são avaliadas (gerando a função fitness) pela distância até o ponto destino (quanto menor, melhor). Então, para cada nova mosca da próxima geração, é apanhado uma quantidade de moscas aleatórias da população, e as melhores serão o pai e a mãe na reprodução que era a mosca nova. Desse modo, obtivemos uma convergência para o melhor caminho natural porém rápida. Houveram situações onde as moscas se prenderam em máximos locais como explicado no vídeo, porém na maioria das vezes foi solucionado por mutação.

# Vídeo
https://drive.google.com/file/d/16oWcgsK3OwWNtjOEo3IY6gBCXxKfihYS/view?usp=sharing

# Ambiente
Foi utilizado Processing 3.0, uma plataforma aberta que simplifica a implementação da parte gráfica do programa. O seu funcionamento é baseado em Java, dessa forma facilitando o desenvolvimento e ainda facilitando a execução do programa em outros dispositivos.




# Referência código de colisão
http://www.jeffreythompson.org/collision-detection/line-circle.php
