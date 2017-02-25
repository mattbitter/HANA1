---structure Prep		
DROP FULLTEXT INDEX DEC_IDX;

CREATE FULLTEXT INDEX DEC_IDX ON
"t_sr"("Description") FAST
PREPROCESS OFF 
TEXT ANALYSIS ON
TEXT MINING ON;

drop type "TT_MT";
CREATE TYPE TT_MT AS TABLE ("SR" INT, "RANK" DECIMAL, "NORMALIZED_TERM" NVARCHAR(100));

delete from "T_MT";
drop table "T_MT";
create table "T_MT" like "TT_MT";

DROP PROCEDURE "P_MT";	

--create table for SVM load step 1
		
CREATE PROCEDURE "P_MT" (IN    ID2    INTEGER) LANGUAGE SQLSCRIPT AS
/*********BEGIN PROCEDURE SCRIPT ************/
BEGIN
			declare OID TT_MT;  
			--OID = select :ID2 as SR from DUMMY;
	    --insert into "T_MT" --values (RANK, NORMALIZED_TERM)
		     OID = SELECT :ID2 as SR, (T.SCORE*100) as RANK, T.NORMALIZED_TERM
		    FROM TM_GET_RELEVANT_TERMS (
			DOCUMENT IN FULLTEXT INDEX WHERE "pk_ID" = :ID2
			SEARCH "Description" FROM "SYSTEM"."t_sr" 
			RETURN TOP 200
			) AS T;
			
		insert into "T_MT" select * from :OID;
		
END;
call "P_MT"(2);

---step 2

DROP PROCEDURE "P_MT2";
CREATE PROCEDURE "P_MT2" () LANGUAGE SQLSCRIPT AS
/*********BEGIN PROCEDURE SCRIPT ************/
BEGIN
	DECLARE START_ID INT = 1;
	
	WHILE (START_ID <= 737)
	DO
		call "P_MT"(:START_ID);
		START_ID = :START_ID + 1;
	END WHILE;

END;

call "P_MT2"();


---
--select distinct values into table.
drop type "TT_LFT";
CREATE TYPE TT_LFT AS TABLE ("F" NVARCHAR(4), "NORMALIZED_TERM" NVARCHAR(100));

delete from "T_LFT";
CREATE TABLE "T_LFT" like "TT_LFT";

DROP PROCEDURE "P_LFT";	
CREATE PROCEDURE "P_LFT" () LANGUAGE SQLSCRIPT AS
BEGIN
	--declare v_temp TT_LFT;
	declare i int = 1;
	declare v int;
	declare T_LFT TT_LFT;
	v_temp = select distinct NORMALIZED_TERM from "SYSTEM"."T_MT" ;
	select count (*) into v from :v_temp;
	begin
		DECLARE CURSOR cur FOR SELECT * FROM :v_temp;
		
		for cur_row as cur DO
			--v_out = select i as F, cur_row.NORMALIZED_TERM from dummy;
			insert into "T_LFT" select i as F, cur_row.NORMALIZED_TERM from dummy;
			i = i + 1;
		END FOR;
		
	end;
	
	--upsert into "T_LFT" select * from :v_out;
	
END;
call "P_LFT"();

---transpose the distinct values into a column table using dynamic sql
drop table "T_TFT";
CREATE column table "T_TFT" (F1 int);
delete from "T_TFT";

DROP PROCEDURE "P_TFT";	
CREATE PROCEDURE "P_TFT" () LANGUAGE SQLSCRIPT AS
BEGIN
	declare v_cname varchar(6);
	declare i int = 3;
	declare v_temp int;
	select count(*) into v_temp from "SYSTEM"."T_LFT";
	for i in 3 .. :v_temp DO
		v_cname = concat ('F',:i);
	    call P_DSQL(:v_cname);
	END FOR;
END;

DROP PROCEDURE "P_DSQL";	
CREATE PROCEDURE "P_DSQL" (in string varchar(6)) LANGUAGE SQLSCRIPT AS
BEGIN

	EXEC 'ALTER TABLE "SYSTEM"."T_TFT" ADD ("'|| :string || '"int)';

END;

ALTER TABLE "SYSTEM"."T_TFT" ADD (SR int);

call "P_TFT"();

--create rows of SRs in the feature table - WIP
DROP PROCEDURE "P_TFT_ROW";	
CREATE PROCEDURE "P_TFT_ROW" () LANGUAGE SQLSCRIPT AS
BEGIN

	declare i int = 1;
	declare v int;
	select count(*) from "SYSTEM"."t_sr";
	v = select count(*) from "SYSTEM"."t_sr";
	--select count (*) into v from :v_temp;
	begin
		DECLARE CURSOR cur FOR SELECT * FROM :v;
		
		for cur_row as cur DO
			--v_out = select i as F, cur_row.NORMALIZED_TERM from dummy;
			insert into "T_LFT" select i as F, cur_row.NORMALIZED_TERM from dummy;
			i = i + 1;
		END FOR;
		
	end;
	
	--upsert into "T_LFT" select * from :v_out;
	
END;
call "P_LFT"();

insert into "T_TFT"(SR) VALUES ('2');
select SR from "T_TFT";

--think how to fix this
insert into T_TFT(concat('F',select F from "T_LFT" where T_MT(SR)=T_LFT(F))) VALUES (select T_MT(RANK) where T_MT(SR)=T_LFT(F)) where T_TFT(SR) = T_MT(SR);


---select only for testing
select count(*) from "SYSTEM"."T_TFT";

SELECT T.RANK, T.NORMALIZED_TERM
		    FROM TM_GET_RELEVANT_TERMS (
			DOCUMENT IN FULLTEXT INDEX WHERE "pk_ID" = 156
			SEARCH "Description" FROM "SYSTEM"."t_sr" 
			RETURN TOP 200
			) AS T;
			
			
SELECT *
		    FROM TM_GET_RELEVANT_TERMS (
			DOCUMENT IN FULLTEXT INDEX WHERE "pk_ID" = 199
			SEARCH "Description" FROM "SYSTEM"."t_sr" 
			RETURN TOP 300
			) AS T;
			
SELECT "pk_ID", TA_RULE,
TA_COUNTER, TA_TOKEN,
TA_TYPE, TA_NORMALIZED,
TA_STEM, TA_PARAGRAPH,
TA_SENTENCE, TA_PARENT
FROM
"$TA_DEC_IDX"
WHERE TA_LANGUAGE = 'en' and "pk_ID" = 195
ORDER BY "pk_ID", TA_COUNTER;

-----Testing out alternative text moning configuratio to see if it gives a better list to count from
---maybe change config of VOC to max break at one word and then filter on specific types and then use those for columns
--or use standnd text mining and use the score from the function with another feature from voc on ohw many problems there are
--after that then do a BPNN and compare the results . also there is a tf-idf table in hana in sps 12
---also maybe try bi grams as well after. convolutional NN are not in HANA

DROP FULLTEXT INDEX DEC_IDX;

CREATE FULLTEXT INDEX
DEC_IDX ON
"t_sr"("Description") 
FAST PREPROCESS OFF
LANGUAGE DETECTION ('EN', 'DE', 'FR') TEXT ANALYSIS ON 
CONFIGURATION 'EXTRACTION_CORE_VOICEOFCUSTOMER'
TEXT MINING ON;

CREATE FULLTEXT INDEX
DEC_IDX ON
"t_sr"("Description") 
FAST PREPROCESS OFF
LANGUAGE DETECTION ('EN', 'DE', 'FR') TEXT ANALYSIS ON 
CONFIGURATION 'EXTRACTION_CORE_ENTERPRISE';

CREATE FULLTEXT INDEX
DEC_IDX ON
"t_sr"("Description") 
FAST PREPROCESS OFF
LANGUAGE DETECTION ('EN', 'DE', 'FR') TEXT ANALYSIS ON
TEXT MINING ON;

SELECT *
FROM
"$TA_DEC_IDX"
WHERE TA_LANGUAGE = 'en' and "pk_ID" = 199
ORDER BY "pk_ID", TA_TYPE;

