/*
 * Farley Balasuriya (farley@questor.ch)
 * created: 2006-09-27 00:44:29
 */

-- switch to master database
USE [master];

-- create database: BranchDB
IF DB_ID (N'BranchDB') IS NOT NULL
 DROP DATABASE BranchDB;
create database [BranchDB] on PRIMARY
(
 -- create the first data device
 NAME = N'BranchDB_D01',
 FILENAME = N'd:\data\BranchDB_D01.mdf',
 SIZE = 100MB,
 FILEGROWTH = 20%
)
LOG ON
(
 -- create the first log device
 NAME = N'BranchDB_L01',
 FILENAME = N'd:\data\BranchDB_L01.ldf',
 SIZE = 50MB,
 FILEGROWTH = 20%
)
COLLATE Latin1_General_CI_AS;

ALTER DATABASE BranchDB SET RECOVERY FULL;


-- create database: SiteDB
IF DB_ID (N'SiteDB') IS NOT NULL
 DROP DATABASE SiteDB;
create database [SiteDB] on PRIMARY
(
 -- create the first data device
 NAME = N'SiteDB_D01',
 FILENAME = N'd:\data\SiteDB_D01.mdf',
 SIZE = 100MB,
 FILEGROWTH = 20%
)
LOG ON
(
 -- create the first log device
 NAME = N'SiteDB_L01',
 FILENAME = N'd:\data\SiteDB_L01.ldf',
 SIZE = 50MB,
 FILEGROWTH = 20%
)
COLLATE Latin1_General_CI_AS;

ALTER DATABASE SiteDB SET RECOVERY FULL;


-- create database: VODLiveBackend
IF DB_ID (N'VODLiveBackend') IS NOT NULL
 DROP DATABASE VODLiveBackend;
create database [VODLiveBackend] on PRIMARY
(
 -- create the first data device
 NAME = N'VODLiveBackend_D01',
 FILENAME = N'd:\data\VODLiveBackend_D01.mdf',
 SIZE = 100MB,
 FILEGROWTH = 20%
)
LOG ON
(
 -- create the first log device
 NAME = N'VODLiveBackend_L01',
 FILENAME = N'd:\data\VODLiveBackend_L01.ldf',
 SIZE = 50MB,
 FILEGROWTH = 20%
)
COLLATE Latin1_General_CI_AS;

ALTER DATABASE VODLiveBackend SET RECOVERY FULL;


