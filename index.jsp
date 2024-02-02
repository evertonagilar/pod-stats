<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.io.File, java.io.BufferedReader, java.io.InputStreamReader" %>
<%@page import="java.text.SimpleDateFormat, java.util.*" %>
<%@ page import="java.lang.management.MemoryMXBean" %>
<%@ page import="java.lang.management.ManagementFactory" %>
<%@ page import="java.lang.management.MemoryUsage" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <%
        String title = "pod-stats :: Informações de diagnóstico";
        String token = System.getenv("TOKEN");
        String colorBg = request.getParameter("color");
        if (colorBg == null){
            colorBg = System.getenv("COLOR");
            if (colorBg == null) {
                colorBg = "white";
            }
        }
        String headerAuthorization = request.getHeader("Authorization");
        String qsToken = request.getParameter("token");
        boolean tokenValidado = false;
        if (token != null && headerAuthorization != null && headerAuthorization.startsWith("Bearer ")) {
            String encodedToken = headerAuthorization.substring(7).trim();
            String decodedToken = new String(Base64.getDecoder().decode(encodedToken));
            if (!token.equals(decodedToken)) {
                tokenValidado = true;
            }
        } else if (qsToken != null && token.equals(qsToken)) {
            tokenValidado = true;
        }
    %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=title%></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="estilo.css" rel="stylesheet" />
</head>
<body style="background-color: <%= colorBg %>">
<div class="container mt-5">

    <div class="d-md-flex flex-md-row-reverse align-items-center justify-content-between">
        <div class="mb-3 mb-md-0 d-flex text-nowrap"><a class="btn btn-sm btn-bd-light rounded-2" href="https://github.com/evertonagilar/pod-stats" title="View and edit this file on GitHub" target="_blank" rel="noopener">
            View on GitHub
        </a>
        </div>
        <h1 class="bd-title mb-0" id="content"><%=title%></h1>
    </div>


    <p class="mt-2">
        <b>Data da requisição: </b> <%=new SimpleDateFormat("dd/M/yyyy hh:mm:ss").format(new java.util.Date())%>
        <% if (tokenValidado) {
            final String loadAvgCommand = "cat /proc/loadavg";
            String loadAvg = "";
            try {
                Process loadAvgProcess = Runtime.getRuntime().exec(loadAvgCommand);
                try (java.util.Scanner scanner = new java.util.Scanner(loadAvgProcess.getInputStream()).useDelimiter("\\A")) {
                    loadAvg = scanner.hasNext() ? scanner.next() : "";
                    loadAvg = loadAvg.replaceAll(" ", "&nbsp;&nbsp;&nbsp;");
                }
            } catch (Exception e) {
                out.println("Erro ao executar o comando: " + loadAvgCommand);
                out.println(e.getMessage());
            }
        %>
        <span style="display:inline-block; width: 20px"></span>
        <b>Load-avg: </b> <%=loadAvg%>
        <% } %>
    </p>


    <div class="card mt-4">
        <div class="card-header">
            Informações do host
        </div>

        <div class="card-body">
            <p><strong>Nome do Host:</strong> <%=java.net.InetAddress.getLocalHost().getHostName()%> </p>
            <p><strong>Endereço IP do Host:</strong> <%=java.net.InetAddress.getLocalHost().getHostAddress()%> </p>
            <% if (tokenValidado) {
                String forwardedFor = request.getHeader("X-Forwarded-For");
                if (forwardedFor != null && !forwardedFor.isEmpty()) {
            %>
            <p><strong>Proxy de Forward: </strong> <%= forwardedFor %></p>
            <% } else{ %>
            <p><strong>Proxy de Forward: </strong> Não detectado</p>
            <% }} %>
        </div>
    </div>

    <div class="card mt-4">
        <div class="card-header">
            Informações da requisição
        </div>

        <div class="card-body">
            <p><strong>URI da Requisição:</strong> <%=request.getRequestURI()%></p>
            <p><strong>Método da Requisição:</strong> <%=request.getMethod()%></p>
            <p><strong>Endereço IP do Cliente:</strong> <%=request.getRemoteAddr()%></p>
            <p><strong>Porta do Cliente:</strong> <%=request.getRemotePort()%></p>
            <p><strong>Agente do Usuário:</strong> <%=request.getHeader("User-Agent")%></p>
        </div>
    </div>

    <% if (tokenValidado) { %>

    <div class="card mt-4">
        <div class="card-header">
            Informações do locale da requisição
        </div>

        <div class="card-body">
            <p><strong>Locale da Requisição:</strong> <%=request.getLocale()%></p>
            <p><strong>Língua:</strong> <%=request.getLocale().getLanguage()%></p>
            <p><strong>País:</strong> <%=request.getLocale().getCountry()%></p>
        </div>
    </div>


    <div class="card mt-4">
        <div class="card-header">
            Informações da configuração regional de data/hora
        </div>

        <div class="card-body">
            <%
                Locale currentLocale = Locale.getDefault();
                SimpleDateFormat dateFormat = (SimpleDateFormat) SimpleDateFormat.getDateInstance(SimpleDateFormat.SHORT, currentLocale);
            %>

            <p><strong>País/Região:</strong> <%=currentLocale.getDisplayCountry()%></p>
            <p><strong>Idioma:</strong> <%=currentLocale.getDisplayLanguage()%></p>
            <p><strong>Formato da Data Curta:</strong> <%=dateFormat.toPattern()%></p>
        </div>
    </div>


    <div class="card mt-4">
        <div class="card-header">
            Informações do runtime do Java
        </div>

        <div class="card-body">
            <p><strong>Versão do Java:</strong> <%=System.getProperty("java.version")%></p>
            <p><strong>Memória Total (MB):</strong> <%=(Runtime.getRuntime().totalMemory() / (1024 * 1024))%></p>
            <p><strong>Memória Livre (MB):</strong> <%=(Runtime.getRuntime().freeMemory() / (1024 * 1024))%></p>
            <p><strong>Memória Máxima (MB):</strong> <%=(Runtime.getRuntime().maxMemory() / (1024 * 1024))%></p>
            <p><strong>Quantidade de Threads Ativas:</strong> <%=Thread.activeCount()%></p>

            <%
                MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
                MemoryUsage heapMemoryUsage = memoryBean.getHeapMemoryUsage();
                MemoryUsage nonHeapMemoryUsage = memoryBean.getNonHeapMemoryUsage();

                out.println("<hr>");
                out.println("<p><strong>Heap Memory:</strong></p>");
                out.println("<p>   Initial: " + heapMemoryUsage.getInit() / (1024 * 1024) + " MB</p>");
                out.println("<p>   Used: " + heapMemoryUsage.getUsed() / (1024 * 1024) + " MB</p>");
                out.println("<p>   Committed: " + heapMemoryUsage.getCommitted() / (1024 * 1024) + " MB</p>");
                out.println("<p>   Max: " + heapMemoryUsage.getMax() / (1024 * 1024) + " MB</p>");

                out.println("<p><strong>Non-Heap Memory:</strong></p>");
                out.println("<p>   Initial: " + nonHeapMemoryUsage.getInit() / (1024 * 1024) + " MB</p>");
                out.println("<p>   Used: " + nonHeapMemoryUsage.getUsed() / (1024 * 1024) + " MB</p>");
                out.println("<p>   Committed: " + nonHeapMemoryUsage.getCommitted() / (1024 * 1024) + " MB</p>");
                out.println("<p>   Max: " + nonHeapMemoryUsage.getMax() / (1024 * 1024) + " MB</p>");


                out.println("<p><strong>Informações do SO ( -XshowSettings )</strong></p>");

                final String showSettingsCmd = "java -XshowSettings:system --version";
                try {
                    Process showSettingsProcess = Runtime.getRuntime().exec(showSettingsCmd);
                    BufferedReader reader = new BufferedReader(new InputStreamReader(showSettingsProcess.getErrorStream()));
                    String line;
                    while ((line = reader.readLine()) != null) {
                        if (!line.startsWith("NOTE") && !line.startsWith("Operating") && !line.startsWith("List") && line.length() > 10) {
                            out.println("<p>" + line + "</p>");
                        }
                    }
                } catch (Exception e) {
                    out.println("Erro ao executar o comando: " + showSettingsCmd);
                    out.println(e.getMessage());
                }

            %>

        </div>
    </div>


    <div class="card mt-4">
        <div class="card-header">
            Informações do espaço em disco
        </div>

        <div class="card-body">
            <%
                File root = new File("/");
                long totalSpaceInBytes = root.getTotalSpace();
                long freeSpaceInBytes = root.getFreeSpace();
                long usableSpaceInBytes = root.getUsableSpace();

                // Convertendo para MB e GB
                long totalSpaceInMB = totalSpaceInBytes / (1024 * 1024);
                long freeSpaceInMB = freeSpaceInBytes / (1024 * 1024);
                long usableSpaceInMB = usableSpaceInBytes / (1024 * 1024);

                long totalSpaceInGB = totalSpaceInBytes / (1024 * 1024 * 1024);
                long freeSpaceInGB = freeSpaceInBytes / (1024 * 1024 * 1024);
                long usableSpaceInGB = usableSpaceInBytes / (1024 * 1024 * 1024);
            %>

            <p class="card-text"><strong>Total de Espaço em Disco (MB/GB):</strong> <%=totalSpaceInMB%> MB / <%=totalSpaceInGB%> GB</p>
            <p class="card-text"><strong>Espaço em Disco Livre (MB/GB):</strong> <%=freeSpaceInMB%> MB / <%=freeSpaceInGB%> GB</p>
            <p class="card-text"><strong>Espaço em Disco Utilizável (MB/GB):</strong> <%=usableSpaceInMB%> MB / <%=usableSpaceInGB%> GB</p>
        </div>
    </div>

    <div class="card mt-4">
        <div class="card-header">
            Parâmetros da querystring
        </div>

        <div class="card-body">
            <ul>
                <%
                    // Informações da query string
                    String queryString = request.getQueryString();

                    // Processar a query string para exibir cada par chave-valor
                    Map<String, String> queryParams = new HashMap<>();
                    if (queryString != null && !queryString.isEmpty()) {
                        String[] params = queryString.split("&");
                        for (String param : params) {
                            String[] keyValue = param.split("=");
                            if (keyValue.length == 2) {
                                queryParams.put(keyValue[0], keyValue[1]);
                            }
                        }
                    }
                    for (Map.Entry<String, String> entry : queryParams.entrySet()) {
                        out.println("<li><strong>" + entry.getKey() + ":</strong> " + entry.getValue() + "</li>");
                    }
                %>
            </ul>
        </div>
    </div>


    <div class="card mt-4">
        <div class="card-header">
            Payload da requisição ( Somente os primeiros 600 bytes )
        </div>

        <div class="card-body">
            <%
                BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));
                StringBuilder payload = new StringBuilder();
                String line;
                int bytesRead = 0;
                while ((line = reader.readLine()) != null && bytesRead < 600) {
                    payload.append(line);
                    bytesRead += line.length();
                }
            %>

            <div class="payload-box">
                <%=payload%>
            </div>
        </div>
    </div>


    <div class="card mt-4">
        <div class="card-header">
            Cabeçalhos da requisição que começam com "X" ( custom headers )
        </div>

        <div class="card-body">
            <ul>
                <%
                    // Obter cabeçalhos da requisição que começam com "X"
                    Map<String, String> xHeaders = new HashMap<>();
                    Enumeration<String> headerNames = request.getHeaderNames();
                    while (headerNames.hasMoreElements()) {
                        String headerName = headerNames.nextElement();
                        if (headerName.startsWith("X")) {
                            String headerValue = request.getHeader(headerName);
                            xHeaders.put(headerName, headerValue);
                        }
                    }

                    for (Map.Entry<String, String> entry : xHeaders.entrySet()) {
                        out.println("<li><strong>" + entry.getKey() + ":</strong> " + entry.getValue() + "</li>");
                    }
                %>
            </ul>
        </div>
    </div>


    <div class="card mt-4">
        <div class="card-header">
            Variáveis de ambiente
        </div>

        <div class="card-body">
            <ul>
                <%
                    // Definição de cores para alguns prefixo de cores
                    Map<String, String> colors = new HashMap<>();
                    colors.put("DEFAULT", "black");
                    colors.put("KUBERNETES_", "navy");
                    colors.put("DB_", "blue");
                    colors.put("JDBC_", "DarkRed");
                    colors.put("EJB_", "brown");
                    colors.put("HTTP_", "OrangeRed");
                    colors.put("TCP_", "teal");
                    colors.put("THREAD_", "teal");
                    colors.put("PAYARA_", "#900C3F");
                    colors.put("SERVER_", "Tomato");
                    colors.put("TIMER_", "Light#900C3F");
                    colors.put("JMS_", "DarkSalmon");
                    colors.put("LOG_", "indigo");
                    colors.put("JAVA_", "#900C3F");
                    colors.put("MEM_", "brown");
                    colors.put("LC_", "darkgreen");
                    colors.put("JVM_", "magenta");
                    colors.put("IS_", "sienna");
                    colors.put("LDAP_", "olive");
                    colors.put("METRICS_", "Tomato");
                    colors.put("MONITOR_", "Tomato");
                    colors.put("POSTBOOT_", "MediumSlateBlue");
                    colors.put("PREBOOT_", "MediumSlateBlue");
                    colors.put("TZ_", "MediumSlateBlue");
                    colors.put("USA_", "MediumSlateBlue");
                    colors.put("SCRIPT_", "MediumSlateBlue");
                    colors.put("PORT_", "MediumSlateBlue");
                    colors.put("HISTLOG_", "MediumSlateBlue");
                    colors.put("GLASSFISH_", "MediumSlateBlue");
                    colors.put("TOMCAT_", "#900C3F");
                    colors.put("CATALINA_", "#900C3F");
                    colors.put("DOMAIN_", "MediumSlateBlue");
                    colors.put("DOCROOT_", "MediumSlateBlue");
                    Map<String, String> envVariables = new HashMap<>(System.getenv());
                    List<Map.Entry<String, String>> envVariablesSorted = new ArrayList<>(envVariables.entrySet());
                    Collections.sort(envVariablesSorted, Map.Entry.comparingByKey());
                    for (Map.Entry<String, String> entry : envVariablesSorted) {
                        String key = entry.getKey();
                        String value = entry.getValue();
                        String prefix = key.contains("_") ? key.substring(0, key.indexOf('_') + 1).toUpperCase() : "DEFAULT";
                        String colorVar = colors.getOrDefault(prefix, "black");
                        out.println("<li><strong style='colorBg:" + colorVar + "'>" + key + ":</strong> " + value + "</li>");
                    }
                %>
            </ul>
        </div>
    </div>


    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                Entrypoint ( /proc/1/cmdline )
            </div>
            <div class="card-body">
                <div class="bash-panel">
                    <%
                        final String cmdLineCommand = "cat /proc/1/cmdline";
                        try {
                            Process cmdLineProcess = Runtime.getRuntime().exec(cmdLineCommand);
                            try (java.util.Scanner scanner = new java.util.Scanner(cmdLineProcess.getInputStream()).useDelimiter("\\A")) {
                                String content = scanner.hasNext() ? scanner.next() : "Nenhuma saída disponível.";
                                // Substituir caracteres nulos por espaços e adicionar novas linhas
                                content = content.replaceAll("\0", " ");
                                out.println(content);
                            }
                        } catch (Exception e) {
                            out.println("Erro ao executar o comando: "+ cmdLineCommand);
                            out.println(e.getMessage());
                        }
                    %>
                </div>
            </div>
        </div>
    </div>


    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                Informações sobre volume
            </div>
            <div class="card-body">
                <div class="bash-panel">
                    <%
                        final String cmdDfCommand = "df -h";
                        try {
                            Process process = Runtime.getRuntime().exec(cmdDfCommand);
                            try (java.util.Scanner scanner = new java.util.Scanner(process.getInputStream()).useDelimiter("\\A")) {
                                String dfContent = scanner.hasNext() ? scanner.next() : "Nenhuma saída disponível.";
                                out.println(dfContent);
                            }
                        } catch (Exception e) {
                            out.println("Erro ao executar o comando: " + cmdDfCommand);
                            out.println(e.getMessage());
                        }
                    %>
                </div>
            </div>
        </div>
    </div>


    <%
        boolean metricsEnabled = System.getenv("METRICS_ENABLED") != null && System.getenv("METRICS_ENABLED").equals("true");
        if (metricsEnabled){
    %>
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                Métricas do servidor de aplicação
            </div>
            <div class="card-body">
                <div class="bash-panel">
                    <%
                        String metricsCmd = System.getenv("AS_ASADMIN") + " get -m 'server.*'";
                        try {
                            Process cmdMetricsProcess = Runtime.getRuntime().exec(metricsCmd);
                            try (java.util.Scanner scanner = new java.util.Scanner(cmdMetricsProcess.getInputStream()).useDelimiter("\\A")) {
                                String content = scanner.hasNext() ? scanner.next() : "Nenhuma saída disponível.";
                                // Substituir caracteres nulos por espaços e adicionar novas linhas
                                content = content.replaceAll("\0", " ");
                                out.println(content);
                            }
                        } catch (Exception e) {
                            out.println("Erro ao executar o comando: " + metricsCmd);
                            out.println(e.getMessage());
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
    <%
        }
    %>

    <!-- fecha if token válido -->
    <% } %>

    <div style="text-align:center" class="mt-4">
        <p>Portal para apresentar informações de diagnóstico do container</p>
        <p>Desenvolvido por Everton de Vargas Agilar</p>
    </div>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
</body>
</html>

