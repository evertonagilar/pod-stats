#!/bin/bash
echo "Compilando..."
jar -cvf dist/pod-stats.war index.jsp WEB-INF
echo
echo "Pronto"
