SELECT *
		    FROM TM_GET_RELEVANT_TERMS (
			DOCUMENT IN FULLTEXT INDEX WHERE "pk_ID" = 2
			SEARCH "Description" FROM "SYSTEM"."t_sr" 
			RETURN TOP 200
			) AS T;
			

---testing fucntion			

drop type "TT_MT";
CREATE TYPE TT_MT AS TABLE ("SR" INT, "RANK" INT, "NORMALIZED_TERM" NVARCHAR(100));

delete from "T_MT";
drop table "T_MT";
create table "T_MT" like "TT_MT";

DROP PROCEDURE "P_MT";			
CREATE PROCEDURE "P_MT" (IN    ID2    INTEGER) LANGUAGE SQLSCRIPT AS
/*********BEGIN PROCEDURE SCRIPT ************/
BEGIN
			declare OID TT_MT;  
			--OID = select :ID2 as SR from DUMMY;
	    --insert into "T_MT" --values (RANK, NORMALIZED_TERM)
		     OID = SELECT :ID2 as SR, T.RANK, T.NORMALIZED_TERM
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
	DECLARE START_ID INT = 29;
	
	WHILE (START_ID <= 31)
	DO
		call "P_MT"(:START_ID);
		START_ID = :START_ID + 1;
	END WHILE;

END;

-----

call "P_MT2"();


---testing
SELECT T.RANK, T.NORMALIZED_TERM
		    FROM TM_GET_RELEVANT_TERMS (
			DOCUMENT IN FULLTEXT INDEX WHERE "pk_ID" = 29
			SEARCH "Description" FROM "SYSTEM"."t_sr" 
			RETURN TOP 200
			) AS T;
