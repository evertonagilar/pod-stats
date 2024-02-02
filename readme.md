# Projeto web para mostrar informações de diagnóstico sobre pod/containers

### Basta deployar o pacote pod-stats.war em um container com um servidor de aplicação Java EE e acessar a aplicação pod-stats


```bash
export TOKEN=$(head -c 20 /dev/urandom | base64)
echo $TOKEN
docker run --env TOKEN=$TOKEN -p 8080:8080 evertonagilar/pod-stats
# Execute no browser
curl "http://localhost:8080/pod-stats/index.jsp?token=$TOKEN"
```


![alt text for screen readers](screen.png "Exemplo de tela do portal").


