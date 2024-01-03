#!/bin/bash
echo "Compilando..."
jar -cvf dist/pod-stats.war index.jsp estilo.css WEB-INF
echo
echo "Pronto"
