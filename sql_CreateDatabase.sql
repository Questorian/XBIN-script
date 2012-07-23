/*
 * Farley Balasuriya (farley@questor.ch)
 * created: 
 */

USE [master]
GO

-- create database: ReferenceDB
create database [ReferenceDB] on PRIMARY
(
 NAME = N'ReferenceDB_D01',
 FILENAME = N'c:\temp\ReferenceDB_D01.mdf',
 SIZE = 100MB,
 FILEGROWTH = 20%
)
LOG ON
(
 NAME = N'ReferenceDB_L01',
 FILENAME = N'c:\temp\ReferenceDB_L01.ldf',
 SIZE = 50MB,
 FILEGROWTH = 20%
)
 COLLATE Latin1_General_CI_AS
go
