SELECT *
		    FROM TM_GET_RELEVANT_TERMS (
			DOCUMENT IN FULLTEXT INDEX WHERE "pk_ID" = 2
			SEARCH "Description" FROM "SYSTEM"."t_sr" 
			RETURN TOP 200
			) AS T;
			

---testing fucntion			

drop table "T_MT";
drop type "TT_MT";
CREATE TYPE TT_MT AS TABLE ("SR" INT, "RANK" INT, "NORMALIZED_TERM" NVARCHAR(100));
create table "T_MT" like "TT_MT";

			
CREATE PROCEDURE "P_MT" (IN    ID2    INTEGER) LANGUAGE SQLSCRIPT AS
/*********BEGIN PROCEDURE SCRIPT ************/
BEGIN
			
	    --insert into "T_MT" --values (RANK, NORMALIZED_TERM)
		    OID = (:ID2) as ("SR");

			
		insert into "T_MT" select * from :OID;
		
END;


---copied out

		    OID = SELECT T.RANK, T.NORMALIZED_TERM
		    FROM TM_GET_RELEVANT_TERMS (
			DOCUMENT IN FULLTEXT INDEX WHERE "pk_ID" = :ID2
			SEARCH "Description" FROM "SYSTEM"."t_sr" 
			RETURN TOP 200
			) AS T;