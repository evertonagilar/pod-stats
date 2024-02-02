## Imagem docker de teste para exibir informações de diagnóstico da requisição HTTP

### Funcionalidades

- Permite passar um token para obter informações sobre o consumo de memória e alguns parâmetros do kernel expostos para o container
- Permite definir a cor do fundo da página. Isso serve para identificar visualmente o container acessado através de um proxy reverso
- Permite visualizar as variáveis de ambiente do container
- Permite visualizar os parâmetros da querystring
- Permite visualizar o /proc/1/cmdline do container


### Como usar

```bash
# Gera um token para obter informações completas do ambiente
export TOKEN=$(head -c 20 /dev/urandom | base64)
echo $TOKEN

# Subir um container com o token e opcionalmente um cor de background da página
docker run --env TOKEN=$TOKEN ---env COLOR=silver -p 8080:8080 evertonagilar/pod-stats
# Execute no browser
curl "http://localhost:8080/pod-stats/index.jsp?token=$TOKEN"
```

### Tela

![alt text for screen readers](screen.png "Exemplo de tela do portal").


