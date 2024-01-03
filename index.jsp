<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.io.File, java.io.BufferedReader, java.io.InputStreamReader" %>
<%@page import="java.text.SimpleDateFormat, java.util.*" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>app-info</title>
    <%!
        String title = "Informações do pod/container";
        String loadAvg;
    %>

    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <style>
        /* Estilos para mostrar o payload */
        .payload-box {
            border: 1px solid #ccc;
            background-color: #f9f9f9;
            padding: 10px;
            margin: 10px 0;
            font-family: 'Courier New', Courier, monospace;
            white-space: pre-wrap;
        }

        /* Estilos para a banda com rolagem vertical */
        .scrollable-band {
            max-height: 400px;  /* Altura máxima */
            overflow-y: auto;   /* Rolagem vertical */
            border: 1px solid #ccc;  /* Borda para visualização */
            padding: 10px;     /* Espaçamento interno */
        }

        /* Estilos para o painel estilo Bash */
        .bash-panel {
            background-color: #2e3436;
            color: #ffffff;
            font-family: 'Courier New', Courier, monospace;
            padding: 10px;
            border-radius: 5px;
            white-space: pre-wrap; /* Manter quebras de linha */
        }
        .bash-panel pre {
            margin: 0; /* Remover margens padrão */
        }
    </style>
</head>
<body>
<div class="container mt-5">


    <div class="d-md-flex flex-md-row-reverse align-items-center justify-content-between">
        <div class="mb-3 mb-md-0 d-flex text-nowrap"><a class="btn btn-sm btn-bd-light rounded-2" href="https://evertonagilar/breadcrumb.md" title="View and edit this file on GitHub" target="_blank" rel="noopener">
            View on GitHub
        </a>
        </div>
        <h1 class="bd-title mb-0" id="content"><%= title %></h1>
    </div>

    <%
        try{
            Process loadAvgProcess = Runtime.getRuntime().exec("cat /proc/loadavg");
            try (java.util.Scanner scanner = new java.util.Scanner(loadAvgProcess.getInputStream()).useDelimiter("\\A")) {
                loadAvg = scanner.hasNext() ? scanner.next() : "";
                loadAvg = loadAvg.replaceAll(" ", "&nbsp;&nbsp;&nbsp;");
            } catch (Exception e) {
                out.println("Erro ao executar o comando: " + e.getMessage());
            }
        } catch (Exception e) {
            out.println("Erro ao executar o comando: " + e.getMessage());
        }
    %>

    <p class="mt-2">
        <b>Data da requisição: </b> <%=new SimpleDateFormat("dd/M/yyyy hh:mm:ss").format(new java.util.Date())%>
        <span style="display:inline-block; width: 20px"></span>
        <b>Load-avg: </b> <%=loadAvg%>
    </p>


    <div class="card mt-4">
        <div class="card-header">
            Informações do host
        </div>

        <div class="card-body">
            <p><strong>Nome do Host:</strong> <%=java.net.InetAddress.getLocalHost().getHostName()%> </p>
            <p><strong>Endereço IP do Host:</strong> <%=java.net.InetAddress.getLocalHost().getHostAddress()%> </p>
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


    <div class="card mt-4">
        <div class="card-header">
            Informações do locale
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

            <p class="card-text"><strong>Total de Espaço em Disco (MB/GB):</strong> <%=totalSpaceInMB%> MB /
                <%=totalSpaceInGB%> GB</p>
            <p class="card-text"><strong>Espaço em Disco Livre (MB/GB):</strong> <%=freeSpaceInMB%> MB / <
            %=freeSpaceInGB%> GB</p>
            <p class="card-text"><strong>Espaço em Disco Utilizável (MB/GB):</strong> <%=usableSpaceInMB%> MB / <
            %=usableSpaceInGB%> GB</p>
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
            Variáveis de Ambiente
        </div>

        <div class="card-body">
            <ul>
                <%
                    // Obter e exibir variáveis de ambiente
                    Map<String, String> envVariables = new HashMap<>(System.getenv());

                    for (Map.Entry<String, String> entry : envVariables.entrySet()) {
                        out.println("<li><strong>" + entry.getKey() + ":</strong> " + entry.getValue() + "</li>");
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
                        try {
                            Process cmdLineProcess = Runtime.getRuntime().exec("cat /proc/1/cmdline");
                            try (java.util.Scanner scanner = new java.util.Scanner(cmdLineProcess.getInputStream()).useDelimiter("\\A")) {
                                String content = scanner.hasNext() ? scanner.next() : "Nenhuma saída disponível.";
                                // Substituir caracteres nulos por espaços e adicionar novas linhas
                                content = content.replaceAll("\0", " ");
                                out.println(content);
                            }
                        } catch (Exception e) {
                            out.println("Erro ao executar o comando: " + e.getMessage());
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
                        try {
                            Process process = Runtime.getRuntime().exec("df -h");
                            try (java.util.Scanner scanner = new java.util.Scanner(process.getInputStream()).useDelimiter("\\A")) {
                                String dfContent = scanner.hasNext() ? scanner.next() : "Nenhuma saída disponível.";
                                out.println(dfContent);
                            }
                        } catch (Exception e) {
                            out.println("Erro ao executar o comando: " + e.getMessage());
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <div style="text-align:center" class="mt-4">
        <p>Portal para apresentar informações de diagnóstico sobre pod/container</p>
        <p>Desenvolvido por Everton de Vargas Agilar</p>
    </div>


</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
</body>
</html>

