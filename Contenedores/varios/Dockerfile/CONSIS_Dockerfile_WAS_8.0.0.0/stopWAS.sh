#!/bin/bash

echo "Deteniendo el WAS....!!!"
/opt/IBM/WebSphere/profiles/D9080/bin/stopServer.sh server1
rm -rf /opt/IBM/WebSphere/profiles/D9080/wstemp/*
rm -rf /opt/IBM/WebSphere/profiles/D9080/temp/*

echo "" > /opt/IBM/WebSphere/profiles/D9080/acsele.log



