update "T_TFT2" set INCIDENT = 1 where SR = 37;
update "T_TFT2" set INCIDENT = 1 where SR = 68;
update "T_TFT2" set INCIDENT = 1 where SR = 138;
update "T_TFT2" set INCIDENT = 1 where SR = 156;
update "T_TFT2" set INCIDENT = 1 where SR = 159;
update "T_TFT2" set INCIDENT = 1 where SR = 177;
update "T_TFT2" set INCIDENT = 1 where SR = 185;
update "T_TFT2" set INCIDENT = 1 where SR = 199;
update "T_TFT2" set INCIDENT = 1 where SR = 231;
update "T_TFT2" set INCIDENT = 1 where SR = 257;
update "T_TFT2" set INCIDENT = 1 where SR = 268;
update "T_TFT2" set INCIDENT = 1 where SR = 334;
update "T_TFT2" set INCIDENT = 1 where SR = 363;
update "T_TFT2" set INCIDENT = 1 where SR = 410;
update "T_TFT2" set INCIDENT = 1 where SR = 422;
update "T_TFT2" set INCIDENT = 1 where SR = 442;
update "T_TFT2" set INCIDENT = 1 where SR = 465;
update "T_TFT2" set INCIDENT = 1 where SR = 474;
update "T_TFT2" set INCIDENT = 1 where SR = 485;
update "T_TFT2" set INCIDENT = 1 where SR = 488;
update "T_TFT2" set INCIDENT = 1 where SR = 496;
update "T_TFT2" set INCIDENT = 1 where SR = 499;
update "T_TFT2" set INCIDENT = 1 where SR = 500;
update "T_TFT2" set INCIDENT = 1 where SR = 501;
update "T_TFT2" set INCIDENT = 1 where SR = 510;
update "T_TFT2" set INCIDENT = 1 where SR = 521;
update "T_TFT2" set INCIDENT = 1 where SR = 541;
update "T_TFT2" set INCIDENT = 1 where SR = 565;
update "T_TFT2" set INCIDENT = 1 where SR = 579;
update "T_TFT2" set INCIDENT = 1 where SR = 586;
update "T_TFT2" set INCIDENT = 1 where SR = 592;
update "T_TFT2" set INCIDENT = 1 where SR = 607;
update "T_TFT2" set INCIDENT = 1 where SR = 608;
update "T_TFT2" set INCIDENT = 1 where SR = 648;
update "T_TFT2" set INCIDENT = 1 where SR = 657;
update "T_TFT2" set INCIDENT = 1 where SR = 660;
update "T_TFT2" set INCIDENT = 1 where SR = 666;
update "T_TFT2" set INCIDENT = 1 where SR = 672;
update "T_TFT2" set INCIDENT = 1 where SR = 686;
update "T_TFT2" set INCIDENT = 1 where SR = 695;
update "T_TFT2" set INCIDENT = 1 where SR = 719;
update "T_TFT2" set INCIDENT = 1 where SR = 730;


------TEST SET filter out for the training where XVALF = 1
update "T_TFT2" set XVALF = 1 where SR = 660;
update "T_TFT2" set XVALF = 1 where SR = 666;
update "T_TFT2" set XVALF = 1 where SR = 672;
update "T_TFT2" set XVALF = 1 where SR = 686;
update "T_TFT2" set XVALF = 1 where SR = 695;
update "T_TFT2" set XVALF = 1 where SR = 719;
update "T_TFT2" set XVALF = 1 where SR = 730;

CREATE column table T_TFT_DATA like T_TFT2;
insert into T_TFT_DATA select * from T_TFT2;
select SR,F1,F2,F3,F4,F25,F50,INCIDENT,XVALF from "T_TFT_DATA" where SR = 37;

alter table "T_TFT_DATA" drop ("COLUMN_1");
alter table "T_TFT_DATA" drop ("XVALF");
