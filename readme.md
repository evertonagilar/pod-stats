# [pod-stats](https://hub.docker.com/r/evertonagilar/pod-stats)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-46a2f1?logo=docker&logoColor=white)](https://hub.docker.com/r/evertonagilar/pod-stats)


Imagem docker de teste para exibir informações de diagnóstico de requisições HTTP

[Acesso o projeto no dockerhub](https://hub.docker.com/r/evertonagilar/pod-stats).


### Funcionalidades

- Permite passar um token para obter informações sobre o consumo de memória e alguns parâmetros do kernel expostos para o container
- Permite definir a cor do fundo da página. Isso serve para identificar visualmente o container acessado através de um proxy reverso
- Permite visualizar as variáveis de ambiente do container
- Permite visualizar os parâmetros da querystring
- Permite visualizar o /proc/1/cmdline do container


### Subir container Docker

```bash
# Gerar um token para servir de credencial para obter informações completas do container
export TOKEN=$(head -c 20 /dev/urandom | base64)
echo $TOKEN

# Subir um container com o token e opcionalmente um cor de background da página
# A cor também pode ser passado via querystring color na url. ?color=silver
docker run --env TOKEN=$TOKEN ---env COLOR=silver -p 8080:8080 evertonagilar/pod-stats

# Abra a url no browser passando o token
curl "http://localhost:8080/pod-stats/index.jsp?token=$TOKEN"
```


### Apenas gerar o pacote pod-stats.war

```bash
mkdir -p dist/
# Só tem um index.jsp de código fonte, portanto o build é muito simples! 
jar -cvf dist/pod-stats.war index.jsp estilo.css WEB-INF
```


### Tela

![alt text for screen readers](screen.png "Exemplo de tela do portal").


### Autor

Copyright 2024 - Everton de Vargas Agilar




