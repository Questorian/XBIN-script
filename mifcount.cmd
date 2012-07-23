@echo off
net use z: /del
net use z:  \\%1\SMS_SHRD ski12345! /user:swiss-dd\t007407
z:
cd \SITE.SRV\dataload.box\deltamif.col
net use z: /del