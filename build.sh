#!/bin/bash
echo "Compilando..."
mkdir -p dist/
jar -cvf dist/pod-stats.war index.jsp estilo.css WEB-INF
echo
echo "Pronto"
