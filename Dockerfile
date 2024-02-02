# Estágio 1: build do pacote pod-stats.war
FROM azul/zulu-openjdk-alpine:21-latest as build

WORKDIR /app

COPY index.jsp /app/
COPY estilo.css /app/
COPY WEB-INF /app/WEB-INF

RUN jar -cvf /app/pod-stats.war index.jsp estilo.css WEB-INF

# Estágio 2: build da imagem
FROM tomcat:jre21-temurin

# Copie o arquivo WAR para o diretório webapps do Tomcat, o que automaticamente fará o deploy
COPY --from=build /app/pod-stats.war /usr/local/tomcat/webapps/

# Exponha a porta padrão do Tomcat
EXPOSE 8080

# Comando para iniciar o Tomcat quando o contêiner for iniciado
CMD ["catalina.sh", "run"]
