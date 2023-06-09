PGDMP     ;                    {            lsfusionafs    15.2    15.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    153509    lsfusionafs    DATABASE        CREATE DATABASE lsfusionafs WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE lsfusionafs;
                postgres    false            �           0    0    lsfusionafs    DATABASE PROPERTIES     ;   ALTER DATABASE lsfusionafs SET "TimeZone" TO 'Asia/Tomsk';
                     postgres    false                        3079    153566    pg_trgm 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
    DROP EXTENSION pg_trgm;
                   false            �           0    0    EXTENSION pg_trgm    COMMENT     e   COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';
                        false    2            �           1247    218600 	   propdistr    TYPE     s   CREATE TYPE public.propdistr AS (
	this double precision,
	running double precision,
	trunning double precision
);
    DROP TYPE public.propdistr;
       public          postgres    false            �           1247    218592 	   winddistr    TYPE     W   CREATE TYPE public.winddistr AS (
	this double precision,
	running double precision
);
    DROP TYPE public.winddistr;
       public          postgres    false            �           1255    153524     array_setadd(anyarray, anyarray)    FUNCTION     �  CREATE FUNCTION public.array_setadd(anyarray, anyarray) RETURNS anyarray
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
	DECLARE length1 int;
	DECLARE length2 int;
	DECLARE i int;
	DECLARE j int;
BEGIN
	length1 = array_upper($1,1);
	length2 = array_upper($2,1);
	IF length1 IS NULL OR length1 = 0 THEN
		RETURN $2;
	END IF;
	IF length2 IS NULL OR length2 = 0 THEN
		RETURN $1;
	END IF;

	j=1;
	i=1;
	IF length1 < length2 THEN
		WHILE i<=length1 LOOP
			IF NOT ($1[i] = ANY ($2)) THEN
				$2[length2+j] = $1[i];
				j=j+1;
			END IF;
			i=i+1;
		END LOOP;
		RETURN $2;
	ELSE
		WHILE i<=length2 LOOP
			IF NOT ($2[i] = ANY ($1)) THEN
				$1[length1+j] = $2[i];
				j=j+1;
			END IF;
			i=i+1;
		END LOOP;
		RETURN $1;
	END IF;
END
$_$;
 7   DROP FUNCTION public.array_setadd(anyarray, anyarray);
       public          postgres    false            �           1255    153545     cast_dynamic_file_to_json(bytea)    FUNCTION     �   CREATE FUNCTION public.cast_dynamic_file_to_json(file bytea) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN convert_from(substring(file, (get_byte(file, 0) + 2)),'UTF-8')::jsonb; -- index in substring is 1-based
END;
$$;
 <   DROP FUNCTION public.cast_dynamic_file_to_json(file bytea);
       public          postgres    false            �           1255    153554 9   cast_dynamic_file_to_named_file(bytea, character varying)    FUNCTION     �   CREATE FUNCTION public.cast_dynamic_file_to_named_file(file bytea, name character varying) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
name = COALESCE(name, 'file');
RETURN chr(length(name))::bytea || name::bytea || file;
END;
$$;
 Z   DROP FUNCTION public.cast_dynamic_file_to_named_file(file bytea, name character varying);
       public          postgres    false            �           1255    153543 '   cast_dynamic_file_to_static_file(bytea)    FUNCTION     �   CREATE FUNCTION public.cast_dynamic_file_to_static_file(file bytea) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN substring(file, (get_byte(file, 0) + 2)); -- index in substring is 1-based
END;
$$;
 C   DROP FUNCTION public.cast_dynamic_file_to_static_file(file bytea);
       public          postgres    false            �           1255    153548    cast_file_to_string(bytea)    FUNCTION     �   CREATE FUNCTION public.cast_file_to_string(file bytea) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN convert_from(file, 'UTF-8');
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;
$$;
 6   DROP FUNCTION public.cast_file_to_string(file bytea);
       public          postgres    false            �           1255    153544     cast_json_to_dynamic_file(jsonb)    FUNCTION     �   CREATE FUNCTION public.cast_json_to_dynamic_file(json jsonb) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN chr(octet_length('json'))::bytea || convert_to('json', 'UTF-8') || convert_to(json::text,'UTF-8');
END;
$$;
 <   DROP FUNCTION public.cast_json_to_dynamic_file(json jsonb);
       public          postgres    false            �           1255    153546    cast_json_to_static_file(jsonb)    FUNCTION     �   CREATE FUNCTION public.cast_json_to_static_file(json jsonb) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN convert_to(json::text,'UTF-8');
END;
$$;
 ;   DROP FUNCTION public.cast_json_to_static_file(json jsonb);
       public          postgres    false            �           1255    153553 &   cast_named_file_to_dynamic_file(bytea)    FUNCTION     �   CREATE FUNCTION public.cast_named_file_to_dynamic_file(file bytea) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
RETURN substring(file, (get_byte(file, 0) + 2));
END;
$$;
 B   DROP FUNCTION public.cast_named_file_to_dynamic_file(file bytea);
       public          postgres    false            �           1255    153555 %   cast_named_file_to_static_file(bytea)    FUNCTION     4  CREATE FUNCTION public.cast_named_file_to_static_file(file bytea) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
extLengthPosition INTEGER;
BEGIN
extLengthPosition = get_byte(file, 0) + 2;
RETURN substring(file, extLengthPosition + get_byte(file, extLengthPosition - 1) + 1);
END;
$$;
 A   DROP FUNCTION public.cast_named_file_to_static_file(file bytea);
       public          postgres    false            �           1255    153542 :   cast_static_file_to_dynamic_file(bytea, character varying)    FUNCTION     �  CREATE FUNCTION public.cast_static_file_to_dynamic_file(file bytea, ext character varying) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    ext = COALESCE(ext, 'dat');
	if ((ext = 'doc' or ext = 'xls') and (length(file) > 3) and (get_byte(file, 0) = 80) and (get_byte(file, 1) = 75) and (get_byte(file, 2) = 3) and (get_byte(file, 3) = 4)) then
		ext = ext || 'x';
	end if;

	if ((ext = 'jpg') and (length(file) > 1)) then
		if (get_byte(file, 0) = 137 and get_byte(file, 1) = 80) then
		    ext = 'png';
        end if;
        if (get_byte(file, 0) = 66 and get_byte(file, 1) = 77) then
            ext = 'bmp';
        end if;
    end if;

	RETURN chr(octet_length(ext))::bytea || convert_to(ext, 'UTF-8') || file;
END;
$$;
 Z   DROP FUNCTION public.cast_static_file_to_dynamic_file(file bytea, ext character varying);
       public          postgres    false            �           1255    153547    cast_static_file_to_json(bytea)    FUNCTION     �   CREATE FUNCTION public.cast_static_file_to_json(file bytea) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN convert_from(file,'UTF-8')::jsonb;
END;
$$;
 ;   DROP FUNCTION public.cast_static_file_to_json(file bytea);
       public          postgres    false            �           1255    153556 K   cast_static_file_to_named_file(bytea, character varying, character varying)    FUNCTION     Y  CREATE FUNCTION public.cast_static_file_to_named_file(file bytea, name character varying, ext character varying) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
name = COALESCE(name, 'file');
ext = COALESCE(ext, 'dat');
RETURN chr(length(name))::bytea || name::bytea || chr(length(ext))::bytea || ext::bytea || file;
END;
$$;
 p   DROP FUNCTION public.cast_static_file_to_named_file(file bytea, name character varying, ext character varying);
       public          postgres    false            �           1255    153549 &   cast_string_to_file(character varying)    FUNCTION     �   CREATE FUNCTION public.cast_string_to_file(string character varying) RETURNS bytea
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN convert_to(string, 'UTF-8');
END;
$$;
 D   DROP FUNCTION public.cast_string_to_file(string character varying);
       public          postgres    false            �           1255    153557    completebarcode(text)    FUNCTION     O  CREATE FUNCTION public.completebarcode(text) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
	DECLARE
		evenSum INTEGER := 0;
		oddSum INTEGER := 0;
		checkDigit INTEGER := 0;
		is12 BOOLEAN;
		sum INTEGER;
	BEGIN
		IF char_length($1) = 7 THEN
			is12 = FALSE;
		ELSEIF char_length($1) = 12 THEN
			is12 = TRUE;
		ELSE 
			RETURN $1;
		END IF;
		FOR i IN 1..char_length($1) LOOP
			IF mod(i, 2) = 0 THEN
				evenSum = evenSum + CAST(substr($1, i, 1) as INTEGER);
			ELSE
				oddSum = oddSum + CAST(substr($1, i, 1) as INTEGER);
			END IF;
		END LOOP;
		sum = CASE WHEN is12 THEN evenSum * 3 + oddSum ELSE evenSum + oddSum * 3 END;
		IF mod(sum, 10) != 0 THEN
			checkDigit = 10 - mod(sum, 10);
		END IF;
		RETURN $1 || checkDigit;
    EXCEPTION
        WHEN invalid_text_representation THEN RETURN $1;
	END;
$_$;
 ,   DROP FUNCTION public.completebarcode(text);
       public          postgres    false            �           1255    153541 "   convert_numeric_to_string(numeric)    FUNCTION     �  CREATE FUNCTION public.convert_numeric_to_string(num numeric) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
  DECLARE
v_result_field VARCHAR(42);

BEGIN
IF (num = NULL) THEN RETURN NULL;
END IF;
v_result_field = TRIM(TO_CHAR(num, 'FM99999999999999999999D99999999999999999999'));
IF(SUBSTR(v_result_field, LENGTH(v_result_field), 1) = ',' OR SUBSTR(v_result_field, LENGTH(v_result_field), 1) = '.') THEN
  v_result_field = SUBSTR(v_result_field, 0, LENGTH(v_result_field));
END IF;
IF((SUBSTR(v_result_field, 1, 1) = ',' OR SUBSTR(v_result_field, 1, 1) = '.')) THEN
  v_result_field = '0' || v_result_field;
END IF;

RETURN v_result_field;
END;

$$;
 =   DROP FUNCTION public.convert_numeric_to_string(num numeric);
       public          postgres    false            �           1255    153538    convert_to_integer(text)    FUNCTION     +  CREATE FUNCTION public.convert_to_integer(v_input text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE v_int_value INTEGER DEFAULT NULL;
BEGIN
    BEGIN
        v_int_value := v_input::INTEGER;
    EXCEPTION WHEN OTHERS THEN
        RETURN 0;
    END;
RETURN v_int_value;
END;
$$;
 7   DROP FUNCTION public.convert_to_integer(v_input text);
       public          postgres    false            �           1255    153539    convert_to_numeric(text)    FUNCTION     +  CREATE FUNCTION public.convert_to_numeric(v_input text) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE v_int_value NUMERIC DEFAULT NULL;
BEGIN
    BEGIN
        v_int_value := v_input::NUMERIC;
    EXCEPTION WHEN OTHERS THEN
        RETURN 0;
    END;
RETURN v_int_value;
END;
$$;
 7   DROP FUNCTION public.convert_to_numeric(v_input text);
       public          postgres    false            �           1255    153540    convert_to_numeric_null(text)    FUNCTION     3  CREATE FUNCTION public.convert_to_numeric_null(v_input text) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE v_int_value NUMERIC DEFAULT NULL;
BEGIN
    BEGIN
        v_int_value := v_input::NUMERIC;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END;
RETURN v_int_value;
END;
$$;
 <   DROP FUNCTION public.convert_to_numeric_null(v_input text);
       public          postgres    false            �           1255    153532 !   first_agg(anyelement, anyelement)    FUNCTION     �   CREATE FUNCTION public.first_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE
    AS $_$
        SELECT $1;
$_$;
 8   DROP FUNCTION public.first_agg(anyelement, anyelement);
       public          postgres    false            �           1255    153550    get_extension(bytea)    FUNCTION     �   CREATE FUNCTION public.get_extension(file bytea) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN convert_from(substring(file, 2, get_byte(file, 0)), 'UTF-8');  -- index in substring is 1-based
END;
$$;
 0   DROP FUNCTION public.get_extension(file bytea);
       public          postgres    false            �           1255    153552    get_named_file_extension(bytea)    FUNCTION     P  CREATE FUNCTION public.get_named_file_extension(file bytea) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
extLengthPosition INTEGER;
BEGIN
extLengthPosition = get_byte(file, 0) + 2;
RETURN convert_from(substring(file, extLengthPosition + 1, get_byte(file, extLengthPosition - 1)), 'UTF-8');
END;
$$;
 ;   DROP FUNCTION public.get_named_file_extension(file bytea);
       public          postgres    false            �           1255    153551    get_named_file_name(bytea)    FUNCTION     �   CREATE FUNCTION public.get_named_file_name(file bytea) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
RETURN convert_from(substring(file, 2, get_byte(file, 0)), 'UTF-8');
END;
$$;
 6   DROP FUNCTION public.get_named_file_name(file bytea);
       public          postgres    false            �           1255    153558 %   getanynotnull(anyelement, anyelement)    FUNCTION     �   CREATE FUNCTION public.getanynotnull(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql STRICT
    AS $_$
  SELECT CASE WHEN $1 = NULL THEN $2 ELSE $1 END;
$_$;
 <   DROP FUNCTION public.getanynotnull(anyelement, anyelement);
       public          postgres    false            �           1255    153530 #   jsonb_recursive_merge(jsonb, jsonb)    FUNCTION     �  CREATE FUNCTION public.jsonb_recursive_merge(a jsonb, b jsonb) RETURNS jsonb
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT jsonb_object_agg(
            COALESCE(ka, kb), CASE
                WHEN va ISNULL THEN vb
                WHEN vb ISNULL THEN va
                WHEN jsonb_typeof(va) <> 'object' or jsonb_typeof(vb) <> 'object' THEN vb
                ELSE jsonb_recursive_merge(va, vb) END)
    FROM jsonb_each(a) e1(ka, va)
             FULL JOIN jsonb_each(b) e2(kb, vb) ON ka = kb
$$;
 >   DROP FUNCTION public.jsonb_recursive_merge(a jsonb, b jsonb);
       public          postgres    false            �           1255    153534     last_agg(anyelement, anyelement)    FUNCTION     �   CREATE FUNCTION public.last_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE
    AS $_$
        SELECT $2;
$_$;
 7   DROP FUNCTION public.last_agg(anyelement, anyelement);
       public          postgres    false            �           1255    153528    max(anyelement, anyelement)    FUNCTION     �   CREATE FUNCTION public.max(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT CASE WHEN $1 IS NULL OR $1 < $2 THEN $2 ELSE $1 END;
$_$;
 2   DROP FUNCTION public.max(anyelement, anyelement);
       public          postgres    false            �           1255    153527    min(anyelement, anyelement)    FUNCTION     �   CREATE FUNCTION public.min(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT CASE WHEN $1 IS NULL OR $1 > $2 THEN $2 ELSE $1 END;
$_$;
 2   DROP FUNCTION public.min(anyelement, anyelement);
       public          postgres    false            �           1255    218602 S   nextcumprop(public.propdistr, double precision, double precision, double precision)    FUNCTION     �  CREATE FUNCTION public.nextcumprop(public.propdistr, double precision, double precision, double precision) RETURNS public.propdistr
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
    DECLARE result propdistr;
    BEGIN
      result.this = round(CAST(($3 * ($2 - COALESCE($1.running, 0)) / ($4 - COALESCE($1.trunning, 0))) as numeric), 0);
      result.running = COALESCE($1.running, 0) + result.this;
      result.trunning = COALESCE($1.trunning, 0) + $3;

        RETURN result;
    END
$_$;
 j   DROP FUNCTION public.nextcumprop(public.propdistr, double precision, double precision, double precision);
       public          postgres    false    1418            �           1255    218594 ?   nextdistr(public.winddistr, double precision, double precision)    FUNCTION     �  CREATE FUNCTION public.nextdistr(public.winddistr, double precision, double precision) RETURNS public.winddistr
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
    DECLARE result winddistr;
    BEGIN
                IF $1.running >= $2 THEN
                               -- if no need
                               result.this = NULL;
                               result.running = $1.running;
                ELSE
                               IF $2-$1.running >= $3 THEN
                                               result.this = $3;
                                               result.running = $1.running + $3;
                               ELSE
                                               result.this = $2-$1.running;
                                               result.running = $2;
                               END IF;
                END IF;

                RETURN result;
    END
$_$;
 V   DROP FUNCTION public.nextdistr(public.winddistr, double precision, double precision);
       public          postgres    false    1415            �           1255    218596 U   nextdistrover(public.winddistr, double precision, double precision, double precision)    FUNCTION     �  CREATE FUNCTION public.nextdistrover(public.winddistr, double precision, double precision, double precision) RETURNS public.winddistr
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
    DECLARE result winddistr;
    BEGIN
                IF $1.running >= $2 THEN
                               -- if no need
                               result.this = NULL;
                               result.running = $1.running;
                ELSE
                               IF $2-$1.running >= $3 THEN
                                               result.this = $3;
                                               result.running = $1.running + $3;

                                               IF result.running = $4 THEN -- all 've run out
                                                    result.this = result.this + $2 - result.running;
                                                    result.running = $2;
                                               END IF;
                               ELSE
                                               result.this = $2-$1.running;
                                               result.running = $2;
                               END IF;
                END IF;

                RETURN result;
    END
$_$;
 l   DROP FUNCTION public.nextdistrover(public.winddistr, double precision, double precision, double precision);
       public          postgres    false    1415            �           1255    153531    notempty(jsonb)    FUNCTION     �   CREATE FUNCTION public.notempty(jsonb) RETURNS jsonb
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT CASE WHEN $1 = jsonb_build_object() THEN NULL ELSE $1 END;
$_$;
 &   DROP FUNCTION public.notempty(jsonb);
       public          postgres    false            �           1255    153526    notzero(anyelement)    FUNCTION     �   CREATE FUNCTION public.notzero(anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT CASE WHEN $1 > -0.000005 AND $1 < 0.000005 THEN NULL ELSE $1 END;
$_$;
 *   DROP FUNCTION public.notzero(anyelement);
       public          postgres    false            �           1255    153564    prefixsearch(regconfig, text)    FUNCTION     Y  CREATE FUNCTION public.prefixsearch(config regconfig, querytext text) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT CASE
           -- use websearch if query contains special characters or is empty
           WHEN queryText ~ '^.*(\(|\)|\&|\:|\*|\!|''|<|>).*$' OR querytext = '' IS NOT FALSE THEN websearch_to_tsquery(config, querytext)
        ELSE to_tsquery(config,
            CONCAT (
                REPLACE(
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(
                                queryText,
                                '[\s\|]*\|[\s\|]*','|', 'g'), -- 1. replace spaces + '|' to '|'
                        '\s+', ':* & ', 'g'), -- 2. replace spaces to '':* & '
                    '|', ':* | '), -- 3. replace '|' to ':* | '
            ':*')) END; -- 4. add ':*' in the end
$_$;
 E   DROP FUNCTION public.prefixsearch(config regconfig, querytext text);
       public          postgres    false            �           1255    153565 #   prefixsearch(regconfig, text, text)    FUNCTION     �   CREATE FUNCTION public.prefixsearch(config regconfig, querytext text, separator text) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT prefixSearch(config, prefixSearchPrepareQuery(querytext, separator));
$$;
 U   DROP FUNCTION public.prefixsearch(config regconfig, querytext text, separator text);
       public          postgres    false            �           1255    153561     prefixsearchold(regconfig, text)    FUNCTION     �  CREATE FUNCTION public.prefixsearchold(config regconfig, querytext text) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT CASE
           -- use plainto_tsquery if query contains special characters or is empty
           -- use plainto_tsquery for old pgsql (websearch_to_tsquery appeared in pgsql 11)
           WHEN queryText ~ '^.*(\(|\)|\&|\:|\*|\!|''|<|>).*$' OR querytext = '' IS NOT FALSE THEN plainto_tsquery(config, querytext)
        ELSE to_tsquery(config,
            CONCAT (
                REPLACE(
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(
                                queryText,
                                '[\s\|]*\|[\s\|]*','|', 'g'), -- 1. replace spaces + '|' to '|'
                        '\s+', ':* & ', 'g'), -- 2. replace spaces to '':* & '
                    '|', ':* | '), -- 3. replace '|' to ':* | '
            ':*')) END; -- 4. add ':*' in the end
$_$;
 H   DROP FUNCTION public.prefixsearchold(config regconfig, querytext text);
       public          postgres    false            �           1255    153562 &   prefixsearchold(regconfig, text, text)    FUNCTION     �   CREATE FUNCTION public.prefixsearchold(config regconfig, querytext text, separator text) RETURNS tsquery
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT prefixSearchOld(config, prefixSearchOldPrepareQuery(querytext, separator));
$$;
 X   DROP FUNCTION public.prefixsearchold(config regconfig, querytext text, separator text);
       public          postgres    false            �           1255    153560 '   prefixsearcholdpreparequery(text, text)    FUNCTION     �  CREATE FUNCTION public.prefixsearcholdpreparequery(querytext text, separator text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT TRIM(BOTH e' \r\n\t\|' FROM -- 3. trim leading and trailing spaces, new lines, tabs and '|'
            REPLACE(
                    REGEXP_REPLACE(querytext, CONCAT('(?<!\\)', separator), '|', 'g'), -- 1. replace unquoted separator to '|'
            CONCAT('\', separator), separator) -- 2. replace quoted separator to unquoted
           )
;
$$;
 R   DROP FUNCTION public.prefixsearcholdpreparequery(querytext text, separator text);
       public          postgres    false            �           1255    153563 $   prefixsearchpreparequery(text, text)    FUNCTION     �  CREATE FUNCTION public.prefixsearchpreparequery(querytext text, separator text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT TRIM(BOTH e' \r\n\t\|' FROM -- 3. trim leading and trailing spaces, new lines, tabs and '|'
         REPLACE(
                 REGEXP_REPLACE(querytext, CONCAT('(?<!\\)', separator), '|', 'g'), -- 1. replace unquoted separator to '|'
         CONCAT('\', separator), separator) -- 2. replace quoted separator to unquoted
       )
;
$$;
 O   DROP FUNCTION public.prefixsearchpreparequery(querytext text, separator text);
       public          postgres    false            i           1255    218593    resultdistr(public.winddistr)    FUNCTION     �   CREATE FUNCTION public.resultdistr(public.winddistr) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT  $1.this;
$_$;
 4   DROP FUNCTION public.resultdistr(public.winddistr);
       public          postgres    false    1415            �           1255    218601    resultprop(public.propdistr)    FUNCTION     �   CREATE FUNCTION public.resultprop(public.propdistr) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT  $1.this;
$_$;
 3   DROP FUNCTION public.resultprop(public.propdistr);
       public          postgres    false    1418            �           1255    155399    scast_integer(anyelement)    FUNCTION     �   CREATE FUNCTION public.scast_integer(anyelement) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
    RETURN CAST($1 AS integer);
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END
$_$;
 0   DROP FUNCTION public.scast_integer(anyelement);
       public          postgres    false            h           1255    154670    scast_integer_int(anyelement)    FUNCTION     �   CREATE FUNCTION public.scast_integer_int(anyelement) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT CASE WHEN $1 BETWEEN -2147483648 AND 2147483647 THEN CAST($1 AS integer) ELSE NULL END;
$_$;
 4   DROP FUNCTION public.scast_integer_int(anyelement);
       public          postgres    false            g           1255    154669    scast_long_int(anyelement)    FUNCTION     �   CREATE FUNCTION public.scast_long_int(anyelement) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT CASE WHEN $1 BETWEEN -9223372036854775808 AND 9223372036854775807 THEN CAST($1 AS int8) ELSE NULL END;
$_$;
 1   DROP FUNCTION public.scast_long_int(anyelement);
       public          postgres    false            �           1255    153529 @   stringc(character varying, character varying, character varying)    FUNCTION       CREATE FUNCTION public.stringc(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE sql IMMUTABLE
    AS $_$
        SELECT CASE WHEN $1 IS NOT NULL THEN $1 || (CASE WHEN $2 IS NOT NULL THEN $3 || $2 ELSE '' END) ELSE $2 END
$_$;
 W   DROP FUNCTION public.stringc(character varying, character varying, character varying);
       public          postgres    false            �           1255    218604    aggar_setadd(anyarray) 	   AGGREGATE        CREATE AGGREGATE public.aggar_setadd(anyarray) (
    SFUNC = public.array_setadd,
    STYPE = anyarray,
    INITCOND = '{}'
);
 .   DROP AGGREGATE public.aggar_setadd(anyarray);
       public          postgres    false    422            �           1255    218609    anyvalue(anyelement) 	   AGGREGATE     k   CREATE AGGREGATE public.anyvalue(anyelement) (
    SFUNC = public.getanynotnull,
    STYPE = anyelement
);
 ,   DROP AGGREGATE public.anyvalue(anyelement);
       public          postgres    false    391            �           1255    218603 J   distr_cum_proportion(double precision, double precision, double precision) 	   AGGREGATE     �   CREATE AGGREGATE public.distr_cum_proportion(double precision, double precision, double precision) (
    SFUNC = public.nextcumprop,
    STYPE = public.propdistr,
    FINALFUNC = public.resultprop
);
 b   DROP AGGREGATE public.distr_cum_proportion(double precision, double precision, double precision);
       public          postgres    false    421    420            �           1255    218595 2   distr_restrict(double precision, double precision) 	   AGGREGATE     �   CREATE AGGREGATE public.distr_restrict(double precision, double precision) (
    SFUNC = public.nextdistr,
    STYPE = public.winddistr,
    FINALFUNC = public.resultdistr
);
 J   DROP AGGREGATE public.distr_restrict(double precision, double precision);
       public          postgres    false    361    418            �           1255    218597 I   distr_restrict_over(double precision, double precision, double precision) 	   AGGREGATE     �   CREATE AGGREGATE public.distr_restrict_over(double precision, double precision, double precision) (
    SFUNC = public.nextdistrover,
    STYPE = public.winddistr,
    FINALFUNC = public.resultdistr
);
 a   DROP AGGREGATE public.distr_restrict_over(double precision, double precision, double precision);
       public          postgres    false    419    361            �           1255    218605    first(anyelement) 	   AGGREGATE     d   CREATE AGGREGATE public.first(anyelement) (
    SFUNC = public.first_agg,
    STYPE = anyelement
);
 )   DROP AGGREGATE public.first(anyelement);
       public          postgres    false    429            �           1255    218606    last(anyelement) 	   AGGREGATE     b   CREATE AGGREGATE public.last(anyelement) (
    SFUNC = public.last_agg,
    STYPE = anyelement
);
 (   DROP AGGREGATE public.last(anyelement);
       public          postgres    false    430            �           1255    218607    maxc(anyelement) 	   AGGREGATE     ]   CREATE AGGREGATE public.maxc(anyelement) (
    SFUNC = public.max,
    STYPE = anyelement
);
 (   DROP AGGREGATE public.maxc(anyelement);
       public          postgres    false    425            �           1255    218608    minc(anyelement) 	   AGGREGATE     ]   CREATE AGGREGATE public.minc(anyelement) (
    SFUNC = public.min,
    STYPE = anyelement
);
 (   DROP AGGREGATE public.minc(anyelement);
       public          postgres    false    424                       1259    153857    _auto    TABLE     �  CREATE TABLE public._auto (
    dumb integer DEFAULT 0 NOT NULL,
    reflection_maxstatsproperty integer,
    reflection_webserverurl character(100),
    chat_sendrestartmessage integer,
    geo_showusermapprovider bigint,
    service_scheduledrestart integer,
    backup_threadcount integer,
    service_uploaddb character varying(100),
    authentication_passwordminlength integer,
    authentication_servertimeformat text,
    system_focusedcellbackgroundcolor integer,
    service_countdaysclearemail integer,
    system_hashmodules character varying(200),
    numerator_useupperedseries integer,
    system_previousscripttype bigint,
    system_datalogicsname character varying(100),
    i18n_translationcode integer,
    service_forbidlogin integer,
    time_currentdatetimesnapshot timestamp without time zone,
    authentication_defaultusertimezone character varying(30),
    service_droplrupercent double precision,
    geo_calculateusermapprovider bigint,
    authentication_passwordcontainssymbols integer,
    security_vmargs character varying(100),
    backup_binpath character varying(100),
    system_datadisplayname character varying(100),
    authentication_defaultusertimeformat text,
    system_logicscaption character varying(100),
    system_customreportrowheight integer,
    system_datascripttype bigint,
    service_uploadtype bigint,
    service_servercomputer bigint,
    systemevents_revisionversion integer,
    authentication_passwordcontainsdigits integer,
    authentication_defaultusercountry character varying(3),
    systemevents_openedformid text,
    system_logicsicon bytea,
    systemevents_apiversion integer,
    backup_savemondaybackups integer,
    system_selectedcellbackgroundcolor integer,
    system_defaultforegroundcolor integer,
    system_defaultoverrideforegroundcolor integer,
    document_documentscloseddate date,
    integration_showids integer,
    authentication_defaultuserlanguage character varying(3),
    service_restartpushed integer,
    systemevents_currentlaunch bigint,
    service_uploadpassword character varying(100),
    scheduler_isstartedscheduler integer,
    system_topmodule character varying(100),
    service_uploadinstance character varying(100),
    service_reupdatemode integer,
    service_maxquantityovercalculate integer,
    security_newpermissionpolicy integer,
    authentication_useldap integer,
    authentication_webclientsecretkey text,
    system_defaultbackgroundcolor integer,
    service_countdaysclearfusiontempfiles integer,
    profiler_explaincompile integer,
    profiler_explainnoanalyze integer,
    profiler_explainjavastack integer,
    profiler_explainthreshold integer,
    security_initheapsize character varying(100),
    geo_usetor integer,
    service_disabletilmode integer,
    service_randomdroplru integer,
    email_imapsmigrated integer,
    system_defaultoverridebackgroundcolor integer,
    service_uploadhost character varying(100),
    systemevents_platformversion text,
    backup_dumpdir character varying(100),
    authentication_userdnsuffixldap character varying(100),
    system_selectedrowbackgroundcolor integer,
    authentication_servertwodigityearstart integer,
    security_minheapfreeratio character varying(100),
    service_migratedranges integer,
    systemevents_countdaysclearexception integer,
    i18n_languagetotranslation bigint,
    profiler_isstartedprofiler integer,
    sqlutils_secondschangealldates integer,
    geo_autosynchronizecoordinates integer,
    time_currentzdatetimesnapshot timestamp with time zone,
    authentication_secret text,
    system_reportnottostretch integer,
    systemevents_limitmaxusedmemory integer,
    backup_maxquantitybackups integer,
    security_maxheapsize character varying(100),
    geo_googleautocompletecountry text,
    time_currentdate date,
    scheduler_countdaysclearscheduledtasklog integer,
    system_customreportcharwidth integer,
    service_uploaduser character varying(100),
    authentication_portldap integer,
    service_singletransaction integer,
    numerator_uselowerednumber integer,
    authentication_serverldap character varying(100),
    authentication_defaultuserdateformat text,
    systemevents_limitping integer,
    systemevents_countdaysclearpings integer,
    security_maxheapfreeratio character varying(100),
    authentication_servercountry character varying(3),
    systemevents_countdaysclearconnection integer,
    systemevents_countdaysclearlaunch integer,
    scheduler_threadcountscheduler integer,
    authentication_serverlanguage character varying(3),
    system_focusedcellbordercolor integer,
    i18n_translateapikey text,
    system_tablegridcolor integer,
    systemevents_limitmaxtotalmemory integer,
    authentication_defaultusertwodigityearstart integer,
    systemevents_countdaysclearsession integer,
    systemevents_evalserverresult text,
    numerator_generatenumberonform integer,
    authentication_passwordcontainsupper integer,
    backup_savefirstdaybackups integer,
    numerator_keepnumberspaces integer,
    authentication_servertimezone character varying(30),
    i18n_languagefromtranslation bigint,
    authentication_basednldap character varying(100),
    system_logicslogo bytea,
    opencv_tessdatpath character varying(200),
    authentication_serverdateformat text,
    scanner_numeratorscanner bigint
);
    DROP TABLE public._auto;
       public         heap    postgres    false                       1259    153967 ?   _auto_authentication_customuser_time_datetimeintervalpickerrang    TABLE     �   CREATE TABLE public._auto_authentication_customuser_time_datetimeintervalpickerrang (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    authentication_isintervalrangeselected_datetimeintervalpickerra integer
);
 S   DROP TABLE public._auto_authentication_customuser_time_datetimeintervalpickerrang;
       public         heap    postgres    false            5           1259    154112 9   _auto_authentication_customuser_time_datetimepickerranges    TABLE     �   CREATE TABLE public._auto_authentication_customuser_time_datetimepickerranges (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    authentication_isdatetimerangeselected_datetimepickerranges_cus integer
);
 M   DROP TABLE public._auto_authentication_customuser_time_datetimepickerranges;
       public         heap    postgres    false            <           1259    154150    _auto_authentication_oauth2    TABLE     o  CREATE TABLE public._auto_authentication_oauth2 (
    key0 bigint NOT NULL,
    authentication_id_oauth2 text,
    authentication_tokenuri_oauth2 text,
    authentication_clientname_oauth2 text,
    system__class__auto_authentication_oauth2 bigint,
    authentication_clientauthenticationmethod_oauth2 text,
    authentication_authorizationuri_oauth2 text,
    authentication_scope_oauth2 text,
    authentication_usernameattributename_oauth2 text,
    authentication_clientid_oauth2 text,
    authentication_jwkseturi_oauth2 text,
    authentication_userinfouri_oauth2 text,
    authentication_clientsecret_oauth2 text
);
 /   DROP TABLE public._auto_authentication_oauth2;
       public         heap    postgres    false            1           1259    154092    _auto_chat_messagestatus    TABLE     ~   CREATE TABLE public._auto_chat_messagestatus (
    key0 bigint NOT NULL,
    system__class__auto_chat_messagestatus bigint
);
 ,   DROP TABLE public._auto_chat_messagestatus;
       public         heap    postgres    false            N           1259    154246    _auto_geo_mapprovider    TABLE     �   CREATE TABLE public._auto_geo_mapprovider (
    key0 bigint NOT NULL,
    geo_apikey_mapprovider text,
    system__class__auto_geo_mapprovider bigint
);
 )   DROP TABLE public._auto_geo_mapprovider;
       public         heap    postgres    false            ;           1259    154145    _auto_i18n_multilanguagenamed    TABLE     �   CREATE TABLE public._auto_i18n_multilanguagenamed (
    key0 bigint NOT NULL,
    system__class__auto_i18n_multilanguagenamed bigint
);
 1   DROP TABLE public._auto_i18n_multilanguagenamed;
       public         heap    postgres    false            *           1259    154057    _auto_messenger_chattype    TABLE     ~   CREATE TABLE public._auto_messenger_chattype (
    key0 bigint NOT NULL,
    system__class__auto_messenger_chattype bigint
);
 ,   DROP TABLE public._auto_messenger_chattype;
       public         heap    postgres    false                       1259    153995    _auto_messenger_messenger    TABLE     �   CREATE TABLE public._auto_messenger_messenger (
    key0 bigint NOT NULL,
    system__class__auto_messenger_messenger bigint
);
 -   DROP TABLE public._auto_messenger_messenger;
       public         heap    postgres    false            �            1259    153820     _auto_processmonitor_processtype    TABLE     �   CREATE TABLE public._auto_processmonitor_processtype (
    key0 bigint NOT NULL,
    system__class__auto_processmonitor_processtype bigint
);
 4   DROP TABLE public._auto_processmonitor_processtype;
       public         heap    postgres    false            �            1259    153740 !   _auto_processmonitor_stateprocess    TABLE     �   CREATE TABLE public._auto_processmonitor_stateprocess (
    key0 bigint NOT NULL,
    system__class__auto_processmonitor_stateprocess bigint
);
 5   DROP TABLE public._auto_processmonitor_stateprocess;
       public         heap    postgres    false            U           1259    154281    _auto_profiler_profilerindex    TABLE     �   CREATE TABLE public._auto_profiler_profilerindex (
    key0 bigint NOT NULL,
    system__class__auto_profiler_profilerindex bigint
);
 0   DROP TABLE public._auto_profiler_profilerindex;
       public         heap    postgres    false            M           1259    154241    _auto_rabbitmq_channel    TABLE     r  CREATE TABLE public._auto_rabbitmq_channel (
    key0 bigint NOT NULL,
    rabbitmq_password_channel text,
    rabbitmq_local_channel integer,
    rabbitmq_queue_channel text,
    rabbitmq_isconsumer_channel integer,
    system__class__auto_rabbitmq_channel bigint,
    rabbitmq_user_channel text,
    rabbitmq_host_channel text,
    rabbitmq_started_channel integer
);
 *   DROP TABLE public._auto_rabbitmq_channel;
       public         heap    postgres    false                       1259    153878    _auto_room_room    TABLE     s  CREATE TABLE public._auto_room_room (
    key0 bigint NOT NULL,
    _deleted_room_number_room character varying(3),
    system__class__auto_room_room bigint,
    room_location_room character varying(60),
    room_container_room numeric(4,0),
    room_desc_room character varying(30),
    room_sumscan_room character varying(2),
    room_name_room character varying(3)
);
 #   DROP TABLE public._auto_room_room;
       public         heap    postgres    false                       1259    153873    _auto_scanner_scanner    TABLE     �  CREATE TABLE public._auto_scanner_scanner (
    key0 bigint NOT NULL,
    _deleted_scanner_number_scanner character varying(60),
    scanner_model_scanner character varying(40),
    scanner_class_scanner bigint,
    _deleted_scanner_serviceability_scanner integer,
    system__class__auto_scanner_scanner bigint,
    scanner_date2_scanner date,
    scanner_date1_scanner date,
    scanner_staff_scanner bigint,
    scannerrepair_canceled_scanner integer,
    scannerfaulty_done_scanner integer,
    scanner_status_scanner bigint,
    scanner_date3_scanner date,
    scanner_manufacture_scanner character varying(40),
    scanner_type_scanner character varying(40),
    scanner_format_scanner character varying(10),
    scanner_id_scanner character varying(50)
);
 )   DROP TABLE public._auto_scanner_scanner;
       public         heap    postgres    false            W           1259    210778    _auto_scanner_scannerstatus    TABLE     �   CREATE TABLE public._auto_scanner_scannerstatus (
    key0 bigint NOT NULL,
    system__class__auto_scanner_scannerstatus bigint
);
 /   DROP TABLE public._auto_scanner_scannerstatus;
       public         heap    postgres    false            �            1259    153763    _auto_schedule_holidays    TABLE     |   CREATE TABLE public._auto_schedule_holidays (
    key0 bigint NOT NULL,
    system__class__auto_schedule_holidays bigint
);
 +   DROP TABLE public._auto_schedule_holidays;
       public         heap    postgres    false            K           1259    154231    _auto_schedule_schedule    TABLE     �   CREATE TABLE public._auto_schedule_schedule (
    key0 bigint NOT NULL,
    system__class__auto_schedule_schedule bigint,
    schedule_name_schedule character varying(100)
);
 +   DROP TABLE public._auto_schedule_schedule;
       public         heap    postgres    false            �            1259    153681    _auto_schedule_scheduledetail    TABLE     >  CREATE TABLE public._auto_schedule_scheduledetail (
    key0 bigint NOT NULL,
    schedule_schedule_scheduledetail bigint,
    schedule_dowto_scheduledetail bigint,
    schedule_holidays_scheduledetail bigint,
    schedule_timeto_scheduledetail time without time zone,
    schedule_captiondateto_scheduledetail character varying(100),
    schedule_dowfrom_scheduledetail bigint,
    schedule_dateto_scheduledetail date,
    schedule_timefrom_scheduledetail time without time zone,
    schedule_datefrom_scheduledetail date,
    schedule_ndoyfrom_scheduledetail integer,
    schedule_ndowfrom_scheduledetail integer,
    schedule_ndoyto_scheduledetail integer,
    schedule_captiondatefrom_scheduledetail character varying(100),
    schedule_ndowto_scheduledetail integer,
    system__class__auto_schedule_scheduledetail bigint
);
 1   DROP TABLE public._auto_schedule_scheduledetail;
       public         heap    postgres    false                       1259    153946    _auto_security_permission    TABLE     �   CREATE TABLE public._auto_security_permission (
    key0 bigint NOT NULL,
    system__class__auto_security_permission bigint
);
 -   DROP TABLE public._auto_security_permission;
       public         heap    postgres    false            .           1259    154077    _auto_slack_user    TABLE     �   CREATE TABLE public._auto_slack_user (
    key0 bigint NOT NULL,
    slack_userid_user text,
    system__class__auto_slack_user bigint,
    slack_username_user text
);
 $   DROP TABLE public._auto_slack_user;
       public         heap    postgres    false            '           1259    154042    _auto_staff_staff    TABLE     �  CREATE TABLE public._auto_staff_staff (
    key0 bigint NOT NULL,
    staff_name_staff character varying(60),
    staff_post_staff character varying(30),
    _deleted_staff_office_staff numeric(3,0),
    staff_email_staff character varying(40),
    system__class__auto_staff_staff bigint,
    staff_phone_staff numeric(11,0),
    staff_departament_staff character varying(30),
    staff_class_staff bigint
);
 %   DROP TABLE public._auto_staff_staff;
       public         heap    postgres    false            0           1259    154087    _auto_system_listviewtype    TABLE     �   CREATE TABLE public._auto_system_listviewtype (
    key0 bigint NOT NULL,
    system__class__auto_system_listviewtype bigint
);
 -   DROP TABLE public._auto_system_listviewtype;
       public         heap    postgres    false            �            1259    153730    _auto_system_object    TABLE     o   CREATE TABLE public._auto_system_object (
    key0 bigint NOT NULL,
    authentication_locked_object bigint
);
 '   DROP TABLE public._auto_system_object;
       public         heap    postgres    false            
           1259    153888    _auto_system_scripttype    TABLE     |   CREATE TABLE public._auto_system_scripttype (
    key0 bigint NOT NULL,
    system__class__auto_system_scripttype bigint
);
 +   DROP TABLE public._auto_system_scripttype;
       public         heap    postgres    false                       1259    154000 '   _auto_time_datetimeintervalpickerranges    TABLE     �   CREATE TABLE public._auto_time_datetimeintervalpickerranges (
    key0 bigint NOT NULL,
    system__class__auto_time_datetimeintervalpickerranges bigint
);
 ;   DROP TABLE public._auto_time_datetimeintervalpickerranges;
       public         heap    postgres    false                       1259    153956    _auto_time_datetimepickerranges    TABLE     �   CREATE TABLE public._auto_time_datetimepickerranges (
    key0 bigint NOT NULL,
    system__class__auto_time_datetimepickerranges bigint
);
 3   DROP TABLE public._auto_time_datetimepickerranges;
       public         heap    postgres    false            �            1259    153692    authentication_colortheme    TABLE     �   CREATE TABLE public.authentication_colortheme (
    key0 bigint NOT NULL,
    system__class_authentication_colortheme bigint
);
 -   DROP TABLE public.authentication_colortheme;
       public         heap    postgres    false            D           1259    154195    authentication_computer    TABLE     �   CREATE TABLE public.authentication_computer (
    key0 bigint NOT NULL,
    authentication_hostname_computer character varying(100),
    system__class_authentication_computer bigint
);
 +   DROP TABLE public.authentication_computer;
       public         heap    postgres    false            �            1259    153735    authentication_contact    TABLE     �  CREATE TABLE public.authentication_contact (
    key0 bigint NOT NULL,
    authentication_firstname_contact character varying(100),
    authentication_lastname_contact character varying(100),
    authentication_postaddress_contact character varying(150),
    authentication_email_contact character varying(400),
    authentication_phone_contact character varying(100),
    authentication_birthday_contact date
);
 *   DROP TABLE public.authentication_contact;
       public         heap    postgres    false                       1259    153914    authentication_customuser    TABLE     �  CREATE TABLE public.authentication_customuser (
    key0 bigint NOT NULL,
    authentication_login_customuser character varying(100),
    authentication_colortheme_customuser bigint,
    service_allowexcessallocatedbytes_customuser integer,
    authentication_userlanguage_customuser character varying(3),
    system__class_authentication_customuser bigint,
    authentication_useclientdatetimeformat_customuser integer,
    security_dataforbidchangepassword_customuser integer,
    service_devmode_customuser integer,
    authentication_userdateformat_customuser text,
    authentication_changepasswordonnextlogin_customuser integer,
    authentication_clienttimezone_customuser character varying(30),
    systemevents_countconnection_customuser integer,
    service_userequesttimeout_customuser integer,
    authentication_clientlanguage_customuser character varying(3),
    authentication_usertimezone_customuser character varying(30),
    security_dataforbidduplicateforms_customuser integer,
    security_dataforbideditprofile_customuser integer,
    authentication_clienttimeformat_customuser text,
    authentication_usertwodigityearstart_customuser integer,
    service_usebusydialogcustom_customuser integer,
    authentication_useclientlocale_customuser integer,
    service_transacttimeout_customuser integer,
    authentication_passwordresettoken_customuser text,
    authentication_fontsize_customuser integer,
    authentication_sha256password_customuser character varying(100),
    authentication_expirypasswordresettokendate_customuser timestamp without time zone,
    document_allowededitcloseddocuments_customuser integer,
    authentication_usercountry_customuser character varying(3),
    authentication_clientcountry_customuser character varying(3),
    authentication_clientdateformat_customuser text,
    authentication_islocked_customuser integer,
    authentication_usertimeformat_customuser text
);
 -   DROP TABLE public.authentication_customuser;
       public         heap    postgres    false                        1259    154005    authentication_user    TABLE     v  CREATE TABLE public.authentication_user (
    key0 bigint NOT NULL,
    service_focusedcellbordercolor_user integer,
    profiler_id_user integer,
    service_loggerdebugenabled_user integer,
    service_selectedrowbackgroundcolor_user integer,
    service_selectedcellbackgroundcolor_user integer,
    service_explaintemporarytablesenabled_user integer,
    system__class_authentication_user bigint,
    security_mainrole_user bigint,
    service_remoteexlogenabled_user integer,
    service_remotepausablelogenabled_user integer,
    service_execenv_user bigint,
    service_explainanalyzemode_user integer,
    service_remoteloggerdebugenabled_user integer,
    service_tablegridcolor_user integer,
    service_volatilestatsenabled_user integer,
    service_focusedcellbackgroundcolor_user integer,
    service_explainappenabled_user integer,
    security_rolescount_user integer
);
 '   DROP TABLE public.authentication_user;
       public         heap    postgres    false                       1259    153990    backup_backup    TABLE     �  CREATE TABLE public.backup_backup (
    key0 bigint NOT NULL,
    backup_log_backup text,
    backup_partial_backup integer,
    backup_name_backup character varying(100),
    backup_file_backup character varying(200),
    system__class_backup_backup bigint,
    backup_filelog_backup character varying(200),
    backup_filedeleted_backup integer,
    backup_ismultithread_backup integer,
    backup_date_backup date,
    backup_time_backup time without time zone
);
 !   DROP TABLE public.backup_backup;
       public         heap    postgres    false                       1259    153961    backup_backuptable    TABLE     �   CREATE TABLE public.backup_backuptable (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    backup_exclude_backup_table integer
);
 &   DROP TABLE public.backup_backuptable;
       public         heap    postgres    false                       1259    153951 	   chat_chat    TABLE     �   CREATE TABLE public.chat_chat (
    key0 bigint NOT NULL,
    chat_id_chat character varying(100),
    chat_isdialog_chat integer,
    chat_dataname_chat character varying(100),
    system__class_chat_chat bigint
);
    DROP TABLE public.chat_chat;
       public         heap    postgres    false            �            1259    153686    chat_chatcustomuser    TABLE     �   CREATE TABLE public.chat_chatcustomuser (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    chat_in_chat_customuser integer,
    chat_readonly_chat_customuser integer
);
 '   DROP TABLE public.chat_chatcustomuser;
       public         heap    postgres    false            �            1259    153714    chat_message    TABLE     �  CREATE TABLE public.chat_message (
    key0 bigint NOT NULL,
    system__class_chat_message bigint,
    chat_datetime_message timestamp without time zone,
    chat_replyto_message bigint,
    chat_author_message bigint,
    chat_system_message integer,
    chat_attachmentname_message text,
    chat_text_message text,
    chat_chat_message bigint,
    chat_attachment_message bytea,
    chat_lasteditdatetime_message timestamp without time zone
);
     DROP TABLE public.chat_message;
       public         heap    postgres    false            %           1259    154031    chat_messagecustomuser    TABLE     �   CREATE TABLE public.chat_messagecustomuser (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    chat_status_message_customuser bigint
);
 *   DROP TABLE public.chat_messagecustomuser;
       public         heap    postgres    false            �            1259    153660    dumb    TABLE     5   CREATE TABLE public.dumb (
    id bigint NOT NULL
);
    DROP TABLE public.dumb;
       public         heap    postgres    false            �            1259    153725    email_account    TABLE     P  CREATE TABLE public.email_account (
    key0 bigint NOT NULL,
    email_fromaddress_account character varying(50),
    email_maxmessages_account integer,
    email_receivehost_account character varying(50),
    email_receiveaccounttype_account bigint,
    email_password_account character varying(50),
    email_receiveport_account integer,
    email_smtphost_account character varying(50),
    email_smtpport_account character varying(10),
    email_isdefaultinbox_account integer,
    email_disable_account integer,
    email_ignoreexceptions_account integer,
    email_unpack_account integer,
    email_deletemessages_account integer,
    email_starttls_account integer,
    email_lastdays_account integer,
    system__class_email_account bigint,
    email_name_account character varying(50),
    email_encryptedconnectiontype_account bigint
);
 !   DROP TABLE public.email_account;
       public         heap    postgres    false            R           1259    154266    email_attachmentemail    TABLE     �  CREATE TABLE public.email_attachmentemail (
    key0 bigint NOT NULL,
    email_email_attachmentemail bigint,
    email_id_attachmentemail character varying(100),
    email_name_attachmentemail character varying(255),
    email_imported_attachmentemail integer,
    email_file_attachmentemail bytea,
    email_importerror_attachmentemail integer,
    email_lasterror_attachmentemail text,
    system__class_email_attachmentemail bigint
);
 )   DROP TABLE public.email_attachmentemail;
       public         heap    postgres    false            �            1259    153773    email_email    TABLE     �  CREATE TABLE public.email_email (
    key0 bigint NOT NULL,
    email_account_email bigint,
    email_id_email text,
    email_uid_email bigint,
    email_message_email text,
    email_fromaddress_email character varying(100),
    email_subject_email text,
    email_datetimesent_email timestamp without time zone,
    email_toaddress_email character varying(100),
    email_emlfile_email bytea,
    email_datetimereceived_email timestamp without time zone,
    system__class_email_email bigint
);
    DROP TABLE public.email_email;
       public         heap    postgres    false            4           1259    154107 #   email_encryptedconnectiontypestatus    TABLE     �   CREATE TABLE public.email_encryptedconnectiontypestatus (
    key0 bigint NOT NULL,
    system__class_email_encryptedconnectiontypestatus bigint
);
 7   DROP TABLE public.email_encryptedconnectiontypestatus;
       public         heap    postgres    false            �            1259    153703    email_receiveaccounttype    TABLE     ~   CREATE TABLE public.email_receiveaccounttype (
    key0 bigint NOT NULL,
    system__class_email_receiveaccounttype bigint
);
 ,   DROP TABLE public.email_receiveaccounttype;
       public         heap    postgres    false            �            1259    153665    empty    TABLE     6   CREATE TABLE public.empty (
    id bigint NOT NULL
);
    DROP TABLE public.empty;
       public         heap    postgres    false            /           1259    154082    excel_template    TABLE     �   CREATE TABLE public.excel_template (
    key0 bigint NOT NULL,
    excel_name_template character varying(100),
    excel_id_template character varying(100),
    system__class_excel_template bigint,
    excel_file_template bytea
);
 "   DROP TABLE public.excel_template;
       public         heap    postgres    false            T           1259    154276    excel_templateentry    TABLE     �  CREATE TABLE public.excel_templateentry (
    key0 bigint NOT NULL,
    excel_istable_templateentry integer,
    excel_isnumeric_templateentry integer,
    system__class_excel_templateentry bigint,
    excel_format_templateentry character varying(20),
    excel_description_templateentry character varying(100),
    excel_key_templateentry character varying(100),
    excel_datarowseparator_templateentry character varying(20),
    excel_template_templateentry bigint
);
 '   DROP TABLE public.excel_templateentry;
       public         heap    postgres    false                       1259    153930    geo_poi    TABLE     �   CREATE TABLE public.geo_poi (
    key0 bigint NOT NULL,
    geo_name_poi character varying(200),
    geo_additionaladdress_poi character varying(150),
    geo_mainaddress_poi character varying(150),
    geo_namecountry_poi character varying(100)
);
    DROP TABLE public.geo_poi;
       public         heap    postgres    false            7           1259    154123 
   geo_poipoi    TABLE        CREATE TABLE public.geo_poipoi (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    geo_distancepoipoi_poi_poi integer
);
    DROP TABLE public.geo_poipoi;
       public         heap    postgres    false            �            1259    153652    global    TABLE     V   CREATE TABLE public.global (
    dumb integer DEFAULT 0 NOT NULL,
    struct bytea
);
    DROP TABLE public.global;
       public         heap    postgres    false            �            1259    153830    i18n_dictionary    TABLE       CREATE TABLE public.i18n_dictionary (
    key0 bigint NOT NULL,
    i18n_insensitive_dictionary integer,
    i18n_languageto_dictionary bigint,
    system__class_i18n_dictionary bigint,
    i18n_name_dictionary character varying(50),
    i18n_languagefrom_dictionary bigint
);
 #   DROP TABLE public.i18n_dictionary;
       public         heap    postgres    false            ?           1259    154166    i18n_dictionaryentry    TABLE       CREATE TABLE public.i18n_dictionaryentry (
    key0 bigint NOT NULL,
    i18n_dictionary_dictionaryentry bigint,
    i18n_term_dictionaryentry character varying(50),
    i18n_translation_dictionaryentry character varying(50),
    system__class_i18n_dictionaryentry bigint
);
 (   DROP TABLE public.i18n_dictionaryentry;
       public         heap    postgres    false            �            1259    153798    i18n_language    TABLE     �   CREATE TABLE public.i18n_language (
    key0 bigint NOT NULL,
    system__class_i18n_language bigint,
    i18n_locale_language character(5),
    i18n_name_language character varying(50)
);
 !   DROP TABLE public.i18n_language;
       public         heap    postgres    false            �            1259    153757    i18n_multilanguagenamedlanguage    TABLE     �   CREATE TABLE public.i18n_multilanguagenamedlanguage (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    i18n_languagename_multilanguagenamed_language character varying(110)
);
 3   DROP TABLE public.i18n_multilanguagenamedlanguage;
       public         heap    postgres    false            �            1259    153647    idtable    TABLE     K   CREATE TABLE public.idtable (
    id integer NOT NULL,
    value bigint
);
    DROP TABLE public.idtable;
       public         heap    postgres    false                       1259    153973    messenger_account    TABLE     r  CREATE TABLE public.messenger_account (
    key0 bigint NOT NULL,
    messenger_token_account text,
    messenger_messenger_account bigint,
    system__class_messenger_account bigint,
    skype_accesstokenskype_account text,
    skype_accesstokendateskype_account timestamp without time zone,
    messenger_name_account text,
    skype_clientsecretskype_account text
);
 %   DROP TABLE public.messenger_account;
       public         heap    postgres    false            �            1259    153676    messenger_chat    TABLE     ,  CREATE TABLE public.messenger_chat (
    key0 bigint NOT NULL,
    messenger_account_chat bigint,
    messenger_id_chat text,
    messenger_name_chat text,
    messenger_title_chat text,
    system__class_messenger_chat bigint,
    messenger_chattype_chat bigint,
    skype_baseurlskype_chat text
);
 "   DROP TABLE public.messenger_chat;
       public         heap    postgres    false            �            1259    153783    messenger_messages    TABLE     1  CREATE TABLE public.messenger_messages (
    key0 bigint NOT NULL,
    system__class_messenger_messages bigint,
    messenger_message_message text,
    messenger_datetime_message timestamp without time zone,
    messenger_chat_message bigint,
    slack_ts_message text,
    messenger_from_message text
);
 &   DROP TABLE public.messenger_messages;
       public         heap    postgres    false                       1259    153841    numerator_numerator    TABLE     �  CREATE TABLE public.numerator_numerator (
    key0 bigint NOT NULL,
    numerator_name_numerator character varying(100),
    numerator_series_numerator character varying(10),
    numerator_maxvalue_numerator bigint,
    numerator_minvalue_numerator bigint,
    system__class_numerator_numerator bigint,
    numerator_stringlength_numerator integer,
    numerator_curvalue_numerator bigint
);
 '   DROP TABLE public.numerator_numerator;
       public         heap    postgres    false            B           1259    154182    profiler_profiledata    TABLE     �  CREATE TABLE public.profiler_profiledata (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    key2 bigint NOT NULL,
    key3 bigint NOT NULL,
    profiler_callcount_profileobject_profileobject_user_form bigint,
    profiler_totaltime_profileobject_profileobject_user_form bigint,
    profiler_totaluserinteractiontime_profileobject_profileobject_u bigint,
    profiler_maxtime_profileobject_profileobject_user_form bigint,
    profiler_totalsqltime_profileobject_profileobject_user_form bigint,
    profiler_squaressum_profileobject_profileobject_user_form double precision,
    profiler_mintime_profileobject_profileobject_user_form bigint
);
 (   DROP TABLE public.profiler_profiledata;
       public         heap    postgres    false            �            1259    153809    profiler_profileobject    TABLE     �   CREATE TABLE public.profiler_profileobject (
    key0 bigint NOT NULL,
    profiler_text_profileobject text,
    system__class_profiler_profileobject bigint
);
 *   DROP TABLE public.profiler_profileobject;
       public         heap    postgres    false                       1259    153904    reflection_action    TABLE     �   CREATE TABLE public.reflection_action (
    key0 bigint NOT NULL,
    reflection_canonicalname_action bpchar,
    system__class_reflection_action bigint
);
 %   DROP TABLE public.reflection_action;
       public         heap    postgres    false                       1259    153868    reflection_actionorproperty    TABLE     J  CREATE TABLE public.reflection_actionorproperty (
    key0 bigint NOT NULL,
    reflection_parent_actionorproperty bigint,
    security_dataforbidchange_actionorproperty integer,
    reflection_caption_actionorproperty character varying(250),
    reflection_number_actionorproperty integer,
    security_datapermitview_actionorproperty integer,
    reflection_annotation_actionorproperty character varying(100),
    security_dataforbidview_actionorproperty integer,
    security_datapermitchange_actionorproperty integer,
    reflection_class_actionorproperty character varying(100)
);
 /   DROP TABLE public.reflection_actionorproperty;
       public         heap    postgres    false            F           1259    154205    reflection_dropcolumn    TABLE     _  CREATE TABLE public.reflection_dropcolumn (
    key0 bigint NOT NULL,
    reflection_sid_dropcolumn character varying(100),
    system__class_reflection_dropcolumn bigint,
    reflection_time_dropcolumn timestamp without time zone,
    reflection_revision_dropcolumn character varying(10),
    reflection_sidtable_dropcolumn character varying(100)
);
 )   DROP TABLE public.reflection_dropcolumn;
       public         heap    postgres    false            -           1259    154072    reflection_form    TABLE     �   CREATE TABLE public.reflection_form (
    key0 bigint NOT NULL,
    reflection_canonicalname_form character varying(100),
    reflection_caption_form character varying(250),
    system__class_reflection_form bigint
);
 #   DROP TABLE public.reflection_form;
       public         heap    postgres    false            8           1259    154129    reflection_formgrouping    TABLE       CREATE TABLE public.reflection_formgrouping (
    key0 bigint NOT NULL,
    reflection_groupobject_formgrouping bigint,
    reflection_name_formgrouping character varying(100),
    system__class_reflection_formgrouping bigint,
    reflection_itemquantity_formgrouping integer
);
 +   DROP TABLE public.reflection_formgrouping;
       public         heap    postgres    false            9           1259    154134 #   reflection_formgroupingpropertydraw    TABLE     Q  CREATE TABLE public.reflection_formgroupingpropertydraw (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    reflection_pivot_formgrouping_propertydraw integer,
    reflection_grouporder_formgrouping_propertydraw integer,
    reflection_max_formgrouping_propertydraw integer,
    reflection_sum_formgrouping_propertydraw integer
);
 7   DROP TABLE public.reflection_formgroupingpropertydraw;
       public         heap    postgres    false            !           1259    154010    reflection_formnames    TABLE     z   CREATE TABLE public.reflection_formnames (
    key0 character varying(100) NOT NULL,
    reflection_form_string bigint
);
 (   DROP TABLE public.reflection_formnames;
       public         heap    postgres    false            A           1259    154176    reflection_formpropertydraw    TABLE     h   CREATE TABLE public.reflection_formpropertydraw (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL
);
 /   DROP TABLE public.reflection_formpropertydraw;
       public         heap    postgres    false            �            1259    153793    reflection_groupobject    TABLE     �  CREATE TABLE public.reflection_groupobject (
    key0 bigint NOT NULL,
    reflection_form_groupobject bigint,
    reflection_sid_groupobject character varying(100),
    reflection_hasuserpreferences_groupobject integer,
    reflection_isfontitalic_groupobject integer,
    reflection_fontsize_groupobject integer,
    reflection_pagesize_groupobject integer,
    reflection_headerheight_groupobject integer,
    reflection_isfontbold_groupobject integer,
    system__class_reflection_groupobject bigint
);
 *   DROP TABLE public.reflection_groupobject;
       public         heap    postgres    false            �            1259    153670     reflection_groupobjectcustomuser    TABLE     �  CREATE TABLE public.reflection_groupobjectcustomuser (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    reflection_hasuserpreferences_groupobject_customuser integer,
    reflection_fontsize_groupobject_customuser integer,
    reflection_headerheight_groupobject_customuser integer,
    reflection_isfontitalic_groupobject_customuser integer,
    reflection_pagesize_groupobject_customuser integer,
    reflection_isfontbold_groupobject_customuser integer
);
 4   DROP TABLE public.reflection_groupobjectcustomuser;
       public         heap    postgres    false            H           1259    154216    reflection_navigatorelement    TABLE        CREATE TABLE public.reflection_navigatorelement (
    key0 bigint NOT NULL,
    reflection_canonicalname_navigatorelement character varying(100),
    reflection_parent_navigatorelement bigint,
    security_forbid_navigatorelement integer,
    reflection_form_navigatorelement bigint,
    system__class_reflection_navigatorelement bigint,
    reflection_number_navigatorelement integer,
    reflection_caption_navigatorelement character varying(250),
    reflection_action_navigatoraction bigint,
    security_permit_navigatorelement integer
);
 /   DROP TABLE public.reflection_navigatorelement;
       public         heap    postgres    false            �            1259    153719 +   reflection_navigatorelementnavigatorelement    TABLE     �   CREATE TABLE public.reflection_navigatorelementnavigatorelement (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    reflection_level_navigatorelement_navigatorelement bigint
);
 ?   DROP TABLE public.reflection_navigatorelementnavigatorelement;
       public         heap    postgres    false            (           1259    154047    reflection_property    TABLE     H  CREATE TABLE public.reflection_property (
    key0 bigint NOT NULL,
    reflection_canonicalname_property bpchar,
    reflection_userloggable_property integer,
    reflection_stats_property integer,
    reflection_dbname_property character varying(100),
    reflection_tablesid_property character varying(100),
    reflection_stored_property integer,
    system__class_reflection_property bigint,
    reflection_complexity_property bigint,
    reflection_loggable_property integer,
    reflection_disableinputlist_property integer,
    reflection_quantitytop_property integer,
    reflection_issetnotnull_property integer,
    reflection_notnullquantity_property integer,
    reflection_return_property character varying(100),
    reflection_lastrecalculate_property timestamp without time zone,
    reflection_quantity_property integer
);
 '   DROP TABLE public.reflection_property;
       public         heap    postgres    false                       1259    153863    reflection_propertydraw    TABLE     �  CREATE TABLE public.reflection_propertydraw (
    key0 bigint NOT NULL,
    reflection_form_propertydraw bigint,
    reflection_sid_propertydraw character varying(100),
    reflection_groupobject_propertydraw bigint,
    reflection_show_propertydraw bigint,
    system__class_reflection_propertydraw bigint,
    reflection_columnascendingsort_propertydraw integer,
    reflection_columnwidth_propertydraw integer,
    reflection_columnorder_propertydraw integer,
    reflection_columnsort_propertydraw integer,
    reflection_columncaption_propertydraw character varying(100),
    reflection_columnpattern_propertydraw character varying(100),
    reflection_caption_propertydraw character varying(250)
);
 +   DROP TABLE public.reflection_propertydraw;
       public         heap    postgres    false                       1259    153984 !   reflection_propertydrawcustomuser    TABLE     3  CREATE TABLE public.reflection_propertydrawcustomuser (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    reflection_show_propertydraw_customuser bigint,
    reflection_columncaption_propertydraw_customuser character varying(100),
    reflection_columnwidth_propertydraw_customuser integer,
    reflection_columnsort_propertydraw_customuser integer,
    reflection_columnpattern_propertydraw_customuser character varying(100),
    reflection_columnascendingsort_propertydraw_customuser integer,
    reflection_columnorder_propertydraw_customuser integer
);
 5   DROP TABLE public.reflection_propertydrawcustomuser;
       public         heap    postgres    false            =           1259    154155 !   reflection_propertydrawshowstatus    TABLE     �   CREATE TABLE public.reflection_propertydrawshowstatus (
    key0 bigint NOT NULL,
    system__class_reflection_propertydrawshowstatus bigint
);
 5   DROP TABLE public.reflection_propertydrawshowstatus;
       public         heap    postgres    false            Q           1259    154261    reflection_propertygroup    TABLE       CREATE TABLE public.reflection_propertygroup (
    key0 bigint NOT NULL,
    reflection_parent_propertygroup bigint,
    reflection_sid_propertygroup character varying(100),
    reflection_caption_propertygroup character varying(250),
    security_datapermitchange_propertygroup integer,
    security_dataforbidchange_propertygroup integer,
    security_dataforbidview_propertygroup integer,
    security_datapermitview_propertygroup integer,
    system__class_reflection_propertygroup bigint,
    reflection_number_propertygroup integer
);
 ,   DROP TABLE public.reflection_propertygroup;
       public         heap    postgres    false                       1259    153978 %   reflection_propertygrouppropertygroup    TABLE     �   CREATE TABLE public.reflection_propertygrouppropertygroup (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    reflection_level_propertygroup_propertygroup bigint
);
 9   DROP TABLE public.reflection_propertygrouppropertygroup;
       public         heap    postgres    false            �            1259    153778    reflection_tablecolumn    TABLE     |  CREATE TABLE public.reflection_tablecolumn (
    key0 bigint NOT NULL,
    reflection_table_tablecolumn bigint,
    reflection_sid_tablecolumn character varying(100),
    reflection_notrecalculate_tablecolumn integer,
    reflection_disableclasses_tablecolumn integer,
    system__class_reflection_tablecolumn bigint,
    reflection_disablestatstablecolumn_tablecolumn integer
);
 *   DROP TABLE public.reflection_tablecolumn;
       public         heap    postgres    false            �            1259    153788    reflection_tablekey    TABLE     �  CREATE TABLE public.reflection_tablekey (
    key0 bigint NOT NULL,
    reflection_table_tablekey bigint,
    reflection_sid_tablekey character varying(100),
    reflection_quantitytop_tablekey integer,
    reflection_name_tablekey character varying(20),
    reflection_quantity_tablekey integer,
    reflection_classsid_tablekey character varying(100),
    reflection_class_tablekey character varying(40),
    system__class_reflection_tablekey bigint
);
 '   DROP TABLE public.reflection_tablekey;
       public         heap    postgres    false                       1259    153935    reflection_tables    TABLE     n  CREATE TABLE public.reflection_tables (
    key0 bigint NOT NULL,
    reflection_sid_table character varying(100),
    backup_exclude_table integer,
    reflection_skipvacuum_table integer,
    system__class_reflection_tables bigint,
    reflection_disableclasses_table integer,
    reflection_notrecalculatestats_table integer,
    reflection_rows_table integer
);
 %   DROP TABLE public.reflection_tables;
       public         heap    postgres    false            G           1259    154210    scheduler_dowscheduledtask    TABLE     �   CREATE TABLE public.scheduler_dowscheduledtask (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    scheduler_in_dow_userscheduledtask integer
);
 .   DROP TABLE public.scheduler_dowscheduledtask;
       public         heap    postgres    false                       1259    153846     scheduler_scheduledclienttasklog    TABLE     �  CREATE TABLE public.scheduler_scheduledclienttasklog (
    key0 bigint NOT NULL,
    scheduler_scheduledtasklog_scheduledclienttasklog bigint,
    scheduler_failed_scheduledclienttasklog integer,
    system__class_scheduler_scheduledclienttasklog bigint,
    scheduler_lsfstack_scheduledclienttasklog text,
    scheduler_date_scheduledclienttasklog timestamp without time zone,
    scheduler_message_scheduledclienttasklog text
);
 4   DROP TABLE public.scheduler_scheduledclienttasklog;
       public         heap    postgres    false            P           1259    154256    scheduler_scheduledtask    TABLE     �  CREATE TABLE public.scheduler_scheduledtask (
    key0 bigint NOT NULL,
    scheduler_name_userscheduledtask character varying(100),
    scheduler_startdate_userscheduledtask timestamp without time zone,
    system__class_scheduler_scheduledtask bigint,
    scheduler_active_userscheduledtask integer,
    scheduler_daysofmonth_userscheduledtask character varying(255),
    scheduler_period_userscheduledtask integer,
    scheduler_runatstart_userscheduledtask integer,
    scheduler_schedulerstarttype_userscheduledtask bigint,
    scheduler_timefrom_userscheduledtask time without time zone,
    scheduler_timeto_userscheduledtask time without time zone
);
 +   DROP TABLE public.scheduler_scheduledtask;
       public         heap    postgres    false            O           1259    154251    scheduler_scheduledtaskdetail    TABLE     D  CREATE TABLE public.scheduler_scheduledtaskdetail (
    key0 bigint NOT NULL,
    scheduler_scheduledtask_userscheduledtaskdetail bigint,
    scheduler_action_userscheduledtaskdetail bigint,
    scheduler_script_userscheduledtaskdetail text,
    system__class_scheduler_scheduledtaskdetail bigint,
    scheduler_active_userscheduledtaskdetail integer,
    scheduler_ignoreexceptions_userscheduledtaskdetail integer,
    scheduler_order_userscheduledtaskdetail integer,
    scheduler_parameter_userscheduledtaskdetail text,
    scheduler_timeout_userscheduledtaskdetail integer
);
 1   DROP TABLE public.scheduler_scheduledtaskdetail;
       public         heap    postgres    false            +           1259    154062    scheduler_scheduledtasklog    TABLE     �  CREATE TABLE public.scheduler_scheduledtasklog (
    key0 bigint NOT NULL,
    scheduler_scheduledtask_scheduledtasklog bigint,
    scheduler_date_scheduledtasklog timestamp without time zone,
    system__class_scheduler_scheduledtasklog bigint,
    scheduler_exceptionoccurred_scheduledtasklog integer,
    scheduler_result_scheduledtasklog character varying(200),
    scheduler_property_scheduledtasklog character varying(200)
);
 .   DROP TABLE public.scheduler_scheduledtasklog;
       public         heap    postgres    false                       1259    153898 '   scheduler_scheduledtaskscheduledtasklog    TABLE     t   CREATE TABLE public.scheduler_scheduledtaskscheduledtasklog (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL
);
 ;   DROP TABLE public.scheduler_scheduledtaskscheduledtasklog;
       public         heap    postgres    false            6           1259    154118    scheduler_schedulerstarttype    TABLE     �   CREATE TABLE public.scheduler_schedulerstarttype (
    key0 bigint NOT NULL,
    system__class_scheduler_schedulerstarttype bigint
);
 0   DROP TABLE public.scheduler_schedulerstarttype;
       public         heap    postgres    false                        1259    153835    security_customuserrole    TABLE     �   CREATE TABLE public.security_customuserrole (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    security_in_customuser_userrole integer
);
 +   DROP TABLE public.security_customuserrole;
       public         heap    postgres    false            :           1259    154140    security_memorylimit    TABLE     !  CREATE TABLE public.security_memorylimit (
    key0 bigint NOT NULL,
    security_maxheapsize_memorylimit character varying(10),
    security_name_memorylimit character varying(100),
    system__class_security_memorylimit bigint,
    security_vmargs_memorylimit character varying(1000)
);
 (   DROP TABLE public.security_memorylimit;
       public         heap    postgres    false            I           1259    154221    security_policy    TABLE       CREATE TABLE public.security_policy (
    key0 bigint NOT NULL,
    security_id_policy character varying(100),
    security_name_policy character varying(100),
    system__class_security_policy bigint,
    security_description_policy character varying(100)
);
 #   DROP TABLE public.security_policy;
       public         heap    postgres    false            �            1259    153745    security_userrole    TABLE     a  CREATE TABLE public.security_userrole (
    key0 bigint NOT NULL,
    security_sid_userrole character varying(30),
    security_maximizedefaultforms_userrole integer,
    security_disablerole_userrole integer,
    security_forbideditprofile_userrole integer,
    security_forbidallforms_userrole integer,
    security_forbideditobjects_userrole integer,
    security_forbidchangeallproperty_userrole integer,
    security_name_userrole character varying(100),
    security_forbidchangepassword_userrole integer,
    system__class_security_userrole bigint,
    security_permitallforms_userrole integer,
    security_forbidduplicateforms_userrole integer,
    security_permitchangeallproperty_userrole integer,
    security_showdetailedinfo_userrole integer,
    security_forbidviewallproperty_userrole integer,
    security_permitviewallproperty_userrole integer
);
 %   DROP TABLE public.security_userrole;
       public         heap    postgres    false            �            1259    153803 !   security_userroleactionorproperty    TABLE     =  CREATE TABLE public.security_userroleactionorproperty (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    security_datapermissionview_userrole_actionorproperty bigint,
    security_datapermissioneditobjects_userrole_actionorproperty bigint,
    security_dataforbidchange_userrole_actionorproperty integer,
    security_datapermissionchange_userrole_actionorproperty bigint,
    security_dataforbidview_userrole_actionorproperty integer,
    security_datapermitchange_userrole_actionorproperty integer,
    security_datapermitview_userrole_actionorproperty integer
);
 5   DROP TABLE public.security_userroleactionorproperty;
       public         heap    postgres    false            �            1259    153814 !   security_userrolenavigatorelement    TABLE     �  CREATE TABLE public.security_userrolenavigatorelement (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    security_datapermission_userrole_navigatorelement bigint,
    security_nearestparentpermission_userrole_navigatorelement bigint,
    security_permit_userrole_navigatorelement integer,
    security_mobileonly_userrole_navigatorelement bigint,
    security_defaultnumber_userrole_navigatorelement integer,
    security_forbid_userrole_navigatorelement integer
);
 5   DROP TABLE public.security_userrolenavigatorelement;
       public         heap    postgres    false            "           1259    154015    security_userrolepolicy    TABLE     �   CREATE TABLE public.security_userrolepolicy (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    security_order_userrole_policy integer
);
 +   DROP TABLE public.security_userrolepolicy;
       public         heap    postgres    false                       1259    153919    security_userrolepropertygroup    TABLE       CREATE TABLE public.security_userrolepropertygroup (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    security_datapermissionchange_userrole_propertygroup bigint,
    security_datapermissionview_userrole_propertygroup bigint,
    security_nearestparentpermissionview_userrole_propertygroup bigint,
    security_datapermissioneditobjects_userrole_propertygroup bigint,
    security_nearestparentpermissioneditobjects_userrole_propertygr bigint,
    security_datapermitview_userrole_propertygroup integer,
    security_datapermitchange_userrole_propertygroup integer,
    security_dataforbidchange_userrole_propertygroup integer,
    security_nearestparentpermissionchange_userrole_propertygroup bigint,
    security_dataforbidview_userrole_propertygroup integer
);
 2   DROP TABLE public.security_userrolepropertygroup;
       public         heap    postgres    false                       1259    153851    security_useruserrole    TABLE     �   CREATE TABLE public.security_useruserrole (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    security_has_user_userrole integer
);
 )   DROP TABLE public.security_useruserrole;
       public         heap    postgres    false            @           1259    154171    service_dbtype    TABLE     j   CREATE TABLE public.service_dbtype (
    key0 bigint NOT NULL,
    system__class_service_dbtype bigint
);
 "   DROP TABLE public.service_dbtype;
       public         heap    postgres    false                       1259    153893    service_setting    TABLE       CREATE TABLE public.service_setting (
    key0 bigint NOT NULL,
    service_name_setting character varying(100),
    service_defaultvalue_setting character varying(100),
    service_basevalue_setting character varying(100),
    system__class_service_setting bigint
);
 #   DROP TABLE public.service_setting;
       public         heap    postgres    false            V           1259    154286    service_settinguserrole    TABLE     �   CREATE TABLE public.service_settinguserrole (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    service_basevalue_setting_userrole character varying(100)
);
 +   DROP TABLE public.service_settinguserrole;
       public         heap    postgres    false            S           1259    154271    service_typeexecenv    TABLE     t   CREATE TABLE public.service_typeexecenv (
    key0 bigint NOT NULL,
    system__class_service_typeexecenv bigint
);
 '   DROP TABLE public.service_typeexecenv;
       public         heap    postgres    false            2           1259    154097    system_customobjectclass    TABLE     �   CREATE TABLE public.system_customobjectclass (
    key0 bigint NOT NULL,
    system__class_system_customobjectclass bigint,
    system_stat_customobjectclass integer
);
 ,   DROP TABLE public.system_customobjectclass;
       public         heap    postgres    false                       1259    153909 
   system_row    TABLE     W  CREATE TABLE public.system_row (
    key0 bigint NOT NULL,
    system_numeric2_row numeric(20,7),
    system_date2_row date,
    system_string10_row character varying(1000),
    system_string4_row character varying(1000),
    system_numeric1_row numeric(20,7),
    system_date3_row date,
    system_string7_row character varying(1000),
    system_string5_row character varying(1000),
    system_numeric5_row numeric(20,7),
    system_date1_row date,
    system__class_system_row bigint,
    system_string1_row character varying(1000),
    system_string2_row character varying(1000),
    system_string8_row character varying(1000),
    system_string9_row character varying(1000),
    system_string6_row character varying(1000),
    system_string3_row character varying(1000),
    system_numeric4_row numeric(20,7),
    system_numeric3_row numeric(20,7)
);
    DROP TABLE public.system_row;
       public         heap    postgres    false            �            1259    153825    system_script    TABLE     *  CREATE TABLE public.system_script (
    key0 bigint NOT NULL,
    system_text_script text,
    system_name_script character varying(100),
    system__class_system_script bigint,
    system_datetime_script timestamp without time zone,
    system_datetimechange_script timestamp without time zone
);
 !   DROP TABLE public.system_script;
       public         heap    postgres    false            J           1259    154226    system_staticobject    TABLE     �   CREATE TABLE public.system_staticobject (
    key0 bigint NOT NULL,
    system_staticcaption_staticobject character(100),
    system_staticname_staticobject character(250)
);
 '   DROP TABLE public.system_staticobject;
       public         heap    postgres    false            ,           1259    154067    systemevents_clienttype    TABLE     |   CREATE TABLE public.systemevents_clienttype (
    key0 bigint NOT NULL,
    system__class_systemevents_clienttype bigint
);
 +   DROP TABLE public.systemevents_clienttype;
       public         heap    postgres    false            &           1259    154037    systemevents_connection    TABLE     �  CREATE TABLE public.systemevents_connection (
    key0 bigint NOT NULL,
    service_fileuserlogs_connection bytea,
    service_filethreaddump_connection bytea,
    systemevents_contextpath_connection text,
    systemevents_architecture_connection character varying(10),
    systemevents_connectionstatus_connection bigint,
    systemevents_user_connection bigint,
    systemevents_computer_connection bigint,
    systemevents_webhost_connection text,
    system__class_systemevents_connection bigint,
    systemevents_cores_connection integer,
    systemevents_maximummemory_connection integer,
    systemevents_is64java_connection integer,
    systemevents_lastactivity_connection timestamp without time zone,
    systemevents_webport_connection integer,
    systemevents_freememory_connection integer,
    systemevents_disconnecttime_connection timestamp without time zone,
    systemevents_physicalmemory_connection integer,
    systemevents_processor_connection character varying(100),
    systemevents_clienttype_connection bigint,
    systemevents_totalmemory_connection integer,
    systemevents_javaversion_connection character varying(100),
    systemevents_osversion_connection character varying(100),
    systemevents_connecttime_connection timestamp without time zone,
    systemevents_launch_connection bigint,
    systemevents_screensize_connection character varying(20),
    systemevents_remoteaddress_connection character varying(40)
);
 +   DROP TABLE public.systemevents_connection;
       public         heap    postgres    false            �            1259    153697    systemevents_connectionform    TABLE     �   CREATE TABLE public.systemevents_connectionform (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL,
    systemevents_connectionformcount_connection_form integer
);
 /   DROP TABLE public.systemevents_connectionform;
       public         heap    postgres    false            >           1259    154160 '   systemevents_connectionnavigatorelement    TABLE     t   CREATE TABLE public.systemevents_connectionnavigatorelement (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL
);
 ;   DROP TABLE public.systemevents_connectionnavigatorelement;
       public         heap    postgres    false            )           1259    154052    systemevents_connectionstatus    TABLE     �   CREATE TABLE public.systemevents_connectionstatus (
    key0 bigint NOT NULL,
    system__class_systemevents_connectionstatus bigint
);
 1   DROP TABLE public.systemevents_connectionstatus;
       public         heap    postgres    false            #           1259    154021    systemevents_exception    TABLE     �  CREATE TABLE public.systemevents_exception (
    key0 bigint NOT NULL,
    systemevents_client_clientexception character varying(100),
    systemevents_message_exception text,
    systemevents_type_exception character varying(250),
    systemevents_reqid_handledexception bigint,
    system__class_systemevents_exception bigint,
    systemevents_login_clientexception character varying(100),
    systemevents_ertrace_exception text,
    systemevents_abandoned_nonfatalhandledexception integer,
    systemevents_count_nonfatalhandledexception integer,
    systemevents_lsfstacktrace_exception text,
    systemevents_date_exception timestamp without time zone
);
 *   DROP TABLE public.systemevents_exception;
       public         heap    postgres    false                       1259    153925    systemevents_launch    TABLE     �   CREATE TABLE public.systemevents_launch (
    key0 bigint NOT NULL,
    systemevents_computer_launch bigint,
    systemevents_revision_launch text,
    system__class_systemevents_launch bigint,
    systemevents_time_launch timestamp without time zone
);
 '   DROP TABLE public.systemevents_launch;
       public         heap    postgres    false            �            1259    153750    systemevents_pingtable    TABLE       CREATE TABLE public.systemevents_pingtable (
    key0 bigint NOT NULL,
    key1 timestamp without time zone NOT NULL,
    key2 timestamp without time zone NOT NULL,
    systemevents_maxtotalmemoryfromto_computer_datetime_datetime integer,
    systemevents_mintotalmemoryfromto_computer_datetime_datetime integer,
    systemevents_maxusedmemoryfromto_computer_datetime_datetime integer,
    systemevents_pingfromto_computer_datetime_datetime integer,
    systemevents_minusedmemoryfromto_computer_datetime_datetime integer
);
 *   DROP TABLE public.systemevents_pingtable;
       public         heap    postgres    false            E           1259    154200    systemevents_session    TABLE     �  CREATE TABLE public.systemevents_session (
    key0 bigint NOT NULL,
    systemevents_user_session bigint,
    systemevents_datetime_session timestamp without time zone,
    systemevents_changes_session text,
    systemevents_quantityaddedclasses_session integer,
    system__class_systemevents_session bigint,
    systemevents_quantitychangedclasses_session integer,
    systemevents_connection_session bigint,
    systemevents_form_session bigint,
    systemevents_quantityremovedclasses_session integer
);
 (   DROP TABLE public.systemevents_session;
       public         heap    postgres    false            �            1259    153708    systemevents_sessioncontact    TABLE     h   CREATE TABLE public.systemevents_sessioncontact (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL
);
 /   DROP TABLE public.systemevents_sessioncontact;
       public         heap    postgres    false                       1259    153940    systemevents_sessionobject    TABLE     g   CREATE TABLE public.systemevents_sessionobject (
    key0 bigint NOT NULL,
    key1 bigint NOT NULL
);
 .   DROP TABLE public.systemevents_sessionobject;
       public         heap    postgres    false            C           1259    154190    time_dow    TABLE     �   CREATE TABLE public.time_dow (
    key0 bigint NOT NULL,
    time_number_dow integer,
    time_numberm_dow integer,
    system__class_time_dow bigint
);
    DROP TABLE public.time_dow;
       public         heap    postgres    false            3           1259    154102 
   time_month    TABLE     �   CREATE TABLE public.time_month (
    key0 bigint NOT NULL,
    time_number_month integer,
    system__class_time_month bigint
);
    DROP TABLE public.time_month;
       public         heap    postgres    false            	           1259    153883    utils_yesno    TABLE     d   CREATE TABLE public.utils_yesno (
    key0 bigint NOT NULL,
    system__class_utils_yesno bigint
);
    DROP TABLE public.utils_yesno;
       public         heap    postgres    false            L           1259    154236    word_template    TABLE     �   CREATE TABLE public.word_template (
    key0 bigint NOT NULL,
    word_id_template character varying(100),
    word_file_template bytea,
    system__class_word_template bigint,
    word_name_template character varying(100)
);
 !   DROP TABLE public.word_template;
       public         heap    postgres    false            �            1259    153768    word_templateentry    TABLE     �  CREATE TABLE public.word_templateentry (
    key0 bigint NOT NULL,
    word_key_templateentry character varying(100),
    word_template_templateentry bigint,
    word_type_templateentry bigint,
    word_datacolumnseparator_templateentry character varying(20),
    word_description_templateentry character varying(100),
    system__class_word_templateentry bigint,
    word_datarowseparator_templateentry character varying(20)
);
 &   DROP TABLE public.word_templateentry;
       public         heap    postgres    false            $           1259    154026 	   word_type    TABLE     `   CREATE TABLE public.word_type (
    key0 bigint NOT NULL,
    system__class_word_type bigint
);
    DROP TABLE public.word_type;
       public         heap    postgres    false            �          0    153857    _auto 
   TABLE DATA           �  COPY public._auto (dumb, reflection_maxstatsproperty, reflection_webserverurl, chat_sendrestartmessage, geo_showusermapprovider, service_scheduledrestart, backup_threadcount, service_uploaddb, authentication_passwordminlength, authentication_servertimeformat, system_focusedcellbackgroundcolor, service_countdaysclearemail, system_hashmodules, numerator_useupperedseries, system_previousscripttype, system_datalogicsname, i18n_translationcode, service_forbidlogin, time_currentdatetimesnapshot, authentication_defaultusertimezone, service_droplrupercent, geo_calculateusermapprovider, authentication_passwordcontainssymbols, security_vmargs, backup_binpath, system_datadisplayname, authentication_defaultusertimeformat, system_logicscaption, system_customreportrowheight, system_datascripttype, service_uploadtype, service_servercomputer, systemevents_revisionversion, authentication_passwordcontainsdigits, authentication_defaultusercountry, systemevents_openedformid, system_logicsicon, systemevents_apiversion, backup_savemondaybackups, system_selectedcellbackgroundcolor, system_defaultforegroundcolor, system_defaultoverrideforegroundcolor, document_documentscloseddate, integration_showids, authentication_defaultuserlanguage, service_restartpushed, systemevents_currentlaunch, service_uploadpassword, scheduler_isstartedscheduler, system_topmodule, service_uploadinstance, service_reupdatemode, service_maxquantityovercalculate, security_newpermissionpolicy, authentication_useldap, authentication_webclientsecretkey, system_defaultbackgroundcolor, service_countdaysclearfusiontempfiles, profiler_explaincompile, profiler_explainnoanalyze, profiler_explainjavastack, profiler_explainthreshold, security_initheapsize, geo_usetor, service_disabletilmode, service_randomdroplru, email_imapsmigrated, system_defaultoverridebackgroundcolor, service_uploadhost, systemevents_platformversion, backup_dumpdir, authentication_userdnsuffixldap, system_selectedrowbackgroundcolor, authentication_servertwodigityearstart, security_minheapfreeratio, service_migratedranges, systemevents_countdaysclearexception, i18n_languagetotranslation, profiler_isstartedprofiler, sqlutils_secondschangealldates, geo_autosynchronizecoordinates, time_currentzdatetimesnapshot, authentication_secret, system_reportnottostretch, systemevents_limitmaxusedmemory, backup_maxquantitybackups, security_maxheapsize, geo_googleautocompletecountry, time_currentdate, scheduler_countdaysclearscheduledtasklog, system_customreportcharwidth, service_uploaduser, authentication_portldap, service_singletransaction, numerator_uselowerednumber, authentication_serverldap, authentication_defaultuserdateformat, systemevents_limitping, systemevents_countdaysclearpings, security_maxheapfreeratio, authentication_servercountry, systemevents_countdaysclearconnection, systemevents_countdaysclearlaunch, scheduler_threadcountscheduler, authentication_serverlanguage, system_focusedcellbordercolor, i18n_translateapikey, system_tablegridcolor, systemevents_limitmaxtotalmemory, authentication_defaultusertwodigityearstart, systemevents_countdaysclearsession, systemevents_evalserverresult, numerator_generatenumberonform, authentication_passwordcontainsupper, backup_savefirstdaybackups, numerator_keepnumberspaces, authentication_servertimezone, i18n_languagefromtranslation, authentication_basednldap, system_logicslogo, opencv_tessdatpath, authentication_serverdateformat, scanner_numeratorscanner) FROM stdin;
    public          postgres    false    260   �J      �          0    153967 ?   _auto_authentication_customuser_time_datetimeintervalpickerrang 
   TABLE DATA           �   COPY public._auto_authentication_customuser_time_datetimeintervalpickerrang (key0, key1, authentication_isintervalrangeselected_datetimeintervalpickerra) FROM stdin;
    public          postgres    false    281   �K      �          0    154112 9   _auto_authentication_customuser_time_datetimepickerranges 
   TABLE DATA           �   COPY public._auto_authentication_customuser_time_datetimepickerranges (key0, key1, authentication_isdatetimerangeselected_datetimepickerranges_cus) FROM stdin;
    public          postgres    false    309   	L      �          0    154150    _auto_authentication_oauth2 
   TABLE DATA           �  COPY public._auto_authentication_oauth2 (key0, authentication_id_oauth2, authentication_tokenuri_oauth2, authentication_clientname_oauth2, system__class__auto_authentication_oauth2, authentication_clientauthenticationmethod_oauth2, authentication_authorizationuri_oauth2, authentication_scope_oauth2, authentication_usernameattributename_oauth2, authentication_clientid_oauth2, authentication_jwkseturi_oauth2, authentication_userinfouri_oauth2, authentication_clientsecret_oauth2) FROM stdin;
    public          postgres    false    316   SL      �          0    154092    _auto_chat_messagestatus 
   TABLE DATA           `   COPY public._auto_chat_messagestatus (key0, system__class__auto_chat_messagestatus) FROM stdin;
    public          postgres    false    305   �M      �          0    154246    _auto_geo_mapprovider 
   TABLE DATA           r   COPY public._auto_geo_mapprovider (key0, geo_apikey_mapprovider, system__class__auto_geo_mapprovider) FROM stdin;
    public          postgres    false    334   �M      �          0    154145    _auto_i18n_multilanguagenamed 
   TABLE DATA           j   COPY public._auto_i18n_multilanguagenamed (key0, system__class__auto_i18n_multilanguagenamed) FROM stdin;
    public          postgres    false    315   �M      �          0    154057    _auto_messenger_chattype 
   TABLE DATA           `   COPY public._auto_messenger_chattype (key0, system__class__auto_messenger_chattype) FROM stdin;
    public          postgres    false    298   N      �          0    153995    _auto_messenger_messenger 
   TABLE DATA           b   COPY public._auto_messenger_messenger (key0, system__class__auto_messenger_messenger) FROM stdin;
    public          postgres    false    286   AN      �          0    153820     _auto_processmonitor_processtype 
   TABLE DATA           p   COPY public._auto_processmonitor_processtype (key0, system__class__auto_processmonitor_processtype) FROM stdin;
    public          postgres    false    253   oN      �          0    153740 !   _auto_processmonitor_stateprocess 
   TABLE DATA           r   COPY public._auto_processmonitor_stateprocess (key0, system__class__auto_processmonitor_stateprocess) FROM stdin;
    public          postgres    false    238   �N      �          0    154281    _auto_profiler_profilerindex 
   TABLE DATA           h   COPY public._auto_profiler_profilerindex (key0, system__class__auto_profiler_profilerindex) FROM stdin;
    public          postgres    false    341   �N      �          0    154241    _auto_rabbitmq_channel 
   TABLE DATA             COPY public._auto_rabbitmq_channel (key0, rabbitmq_password_channel, rabbitmq_local_channel, rabbitmq_queue_channel, rabbitmq_isconsumer_channel, system__class__auto_rabbitmq_channel, rabbitmq_user_channel, rabbitmq_host_channel, rabbitmq_started_channel) FROM stdin;
    public          postgres    false    333   	O      �          0    153878    _auto_room_room 
   TABLE DATA           �   COPY public._auto_room_room (key0, _deleted_room_number_room, system__class__auto_room_room, room_location_room, room_container_room, room_desc_room, room_sumscan_room, room_name_room) FROM stdin;
    public          postgres    false    264   &O      �          0    153873    _auto_scanner_scanner 
   TABLE DATA           �  COPY public._auto_scanner_scanner (key0, _deleted_scanner_number_scanner, scanner_model_scanner, scanner_class_scanner, _deleted_scanner_serviceability_scanner, system__class__auto_scanner_scanner, scanner_date2_scanner, scanner_date1_scanner, scanner_staff_scanner, scannerrepair_canceled_scanner, scannerfaulty_done_scanner, scanner_status_scanner, scanner_date3_scanner, scanner_manufacture_scanner, scanner_type_scanner, scanner_format_scanner, scanner_id_scanner) FROM stdin;
    public          postgres    false    263   P      �          0    210778    _auto_scanner_scannerstatus 
   TABLE DATA           f   COPY public._auto_scanner_scannerstatus (key0, system__class__auto_scanner_scannerstatus) FROM stdin;
    public          postgres    false    343   �Q      �          0    153763    _auto_schedule_holidays 
   TABLE DATA           ^   COPY public._auto_schedule_holidays (key0, system__class__auto_schedule_holidays) FROM stdin;
    public          postgres    false    242   �Q      �          0    154231    _auto_schedule_schedule 
   TABLE DATA           v   COPY public._auto_schedule_schedule (key0, system__class__auto_schedule_schedule, schedule_name_schedule) FROM stdin;
    public          postgres    false    331   R      {          0    153681    _auto_schedule_scheduledetail 
   TABLE DATA           F  COPY public._auto_schedule_scheduledetail (key0, schedule_schedule_scheduledetail, schedule_dowto_scheduledetail, schedule_holidays_scheduledetail, schedule_timeto_scheduledetail, schedule_captiondateto_scheduledetail, schedule_dowfrom_scheduledetail, schedule_dateto_scheduledetail, schedule_timefrom_scheduledetail, schedule_datefrom_scheduledetail, schedule_ndoyfrom_scheduledetail, schedule_ndowfrom_scheduledetail, schedule_ndoyto_scheduledetail, schedule_captiondatefrom_scheduledetail, schedule_ndowto_scheduledetail, system__class__auto_schedule_scheduledetail) FROM stdin;
    public          postgres    false    227   9R      �          0    153946    _auto_security_permission 
   TABLE DATA           b   COPY public._auto_security_permission (key0, system__class__auto_security_permission) FROM stdin;
    public          postgres    false    277   VR      �          0    154077    _auto_slack_user 
   TABLE DATA           x   COPY public._auto_slack_user (key0, slack_userid_user, system__class__auto_slack_user, slack_username_user) FROM stdin;
    public          postgres    false    302   �R      �          0    154042    _auto_staff_staff 
   TABLE DATA           �   COPY public._auto_staff_staff (key0, staff_name_staff, staff_post_staff, _deleted_staff_office_staff, staff_email_staff, system__class__auto_staff_staff, staff_phone_staff, staff_departament_staff, staff_class_staff) FROM stdin;
    public          postgres    false    295   �R      �          0    154087    _auto_system_listviewtype 
   TABLE DATA           b   COPY public._auto_system_listviewtype (key0, system__class__auto_system_listviewtype) FROM stdin;
    public          postgres    false    304   +U      �          0    153730    _auto_system_object 
   TABLE DATA           Q   COPY public._auto_system_object (key0, authentication_locked_object) FROM stdin;
    public          postgres    false    236   \U      �          0    153888    _auto_system_scripttype 
   TABLE DATA           ^   COPY public._auto_system_scripttype (key0, system__class__auto_system_scripttype) FROM stdin;
    public          postgres    false    266   yU      �          0    154000 '   _auto_time_datetimeintervalpickerranges 
   TABLE DATA           ~   COPY public._auto_time_datetimeintervalpickerranges (key0, system__class__auto_time_datetimeintervalpickerranges) FROM stdin;
    public          postgres    false    287   �U      �          0    153956    _auto_time_datetimepickerranges 
   TABLE DATA           n   COPY public._auto_time_datetimepickerranges (key0, system__class__auto_time_datetimepickerranges) FROM stdin;
    public          postgres    false    279   �U      }          0    153692    authentication_colortheme 
   TABLE DATA           b   COPY public.authentication_colortheme (key0, system__class_authentication_colortheme) FROM stdin;
    public          postgres    false    229   #V      �          0    154195    authentication_computer 
   TABLE DATA           �   COPY public.authentication_computer (key0, authentication_hostname_computer, system__class_authentication_computer) FROM stdin;
    public          postgres    false    324   KV      �          0    153735    authentication_contact 
   TABLE DATA           �   COPY public.authentication_contact (key0, authentication_firstname_contact, authentication_lastname_contact, authentication_postaddress_contact, authentication_email_contact, authentication_phone_contact, authentication_birthday_contact) FROM stdin;
    public          postgres    false    237   �V      �          0    153914    authentication_customuser 
   TABLE DATA           �  COPY public.authentication_customuser (key0, authentication_login_customuser, authentication_colortheme_customuser, service_allowexcessallocatedbytes_customuser, authentication_userlanguage_customuser, system__class_authentication_customuser, authentication_useclientdatetimeformat_customuser, security_dataforbidchangepassword_customuser, service_devmode_customuser, authentication_userdateformat_customuser, authentication_changepasswordonnextlogin_customuser, authentication_clienttimezone_customuser, systemevents_countconnection_customuser, service_userequesttimeout_customuser, authentication_clientlanguage_customuser, authentication_usertimezone_customuser, security_dataforbidduplicateforms_customuser, security_dataforbideditprofile_customuser, authentication_clienttimeformat_customuser, authentication_usertwodigityearstart_customuser, service_usebusydialogcustom_customuser, authentication_useclientlocale_customuser, service_transacttimeout_customuser, authentication_passwordresettoken_customuser, authentication_fontsize_customuser, authentication_sha256password_customuser, authentication_expirypasswordresettokendate_customuser, document_allowededitcloseddocuments_customuser, authentication_usercountry_customuser, authentication_clientcountry_customuser, authentication_clientdateformat_customuser, authentication_islocked_customuser, authentication_usertimeformat_customuser) FROM stdin;
    public          postgres    false    271   �V      �          0    154005    authentication_user 
   TABLE DATA           �  COPY public.authentication_user (key0, service_focusedcellbordercolor_user, profiler_id_user, service_loggerdebugenabled_user, service_selectedrowbackgroundcolor_user, service_selectedcellbackgroundcolor_user, service_explaintemporarytablesenabled_user, system__class_authentication_user, security_mainrole_user, service_remoteexlogenabled_user, service_remotepausablelogenabled_user, service_execenv_user, service_explainanalyzemode_user, service_remoteloggerdebugenabled_user, service_tablegridcolor_user, service_volatilestatsenabled_user, service_focusedcellbackgroundcolor_user, service_explainappenabled_user, security_rolescount_user) FROM stdin;
    public          postgres    false    288   0W      �          0    153990    backup_backup 
   TABLE DATA             COPY public.backup_backup (key0, backup_log_backup, backup_partial_backup, backup_name_backup, backup_file_backup, system__class_backup_backup, backup_filelog_backup, backup_filedeleted_backup, backup_ismultithread_backup, backup_date_backup, backup_time_backup) FROM stdin;
    public          postgres    false    285   uW      �          0    153961    backup_backuptable 
   TABLE DATA           U   COPY public.backup_backuptable (key0, key1, backup_exclude_backup_table) FROM stdin;
    public          postgres    false    280   �W      �          0    153951 	   chat_chat 
   TABLE DATA           x   COPY public.chat_chat (key0, chat_id_chat, chat_isdialog_chat, chat_dataname_chat, system__class_chat_chat) FROM stdin;
    public          postgres    false    278   �W      |          0    153686    chat_chatcustomuser 
   TABLE DATA           q   COPY public.chat_chatcustomuser (key0, key1, chat_in_chat_customuser, chat_readonly_chat_customuser) FROM stdin;
    public          postgres    false    228   �W      �          0    153714    chat_message 
   TABLE DATA             COPY public.chat_message (key0, system__class_chat_message, chat_datetime_message, chat_replyto_message, chat_author_message, chat_system_message, chat_attachmentname_message, chat_text_message, chat_chat_message, chat_attachment_message, chat_lasteditdatetime_message) FROM stdin;
    public          postgres    false    233   X      �          0    154031    chat_messagecustomuser 
   TABLE DATA           \   COPY public.chat_messagecustomuser (key0, key1, chat_status_message_customuser) FROM stdin;
    public          postgres    false    293   X      w          0    153660    dumb 
   TABLE DATA           "   COPY public.dumb (id) FROM stdin;
    public          postgres    false    223   ;X      �          0    153725    email_account 
   TABLE DATA             COPY public.email_account (key0, email_fromaddress_account, email_maxmessages_account, email_receivehost_account, email_receiveaccounttype_account, email_password_account, email_receiveport_account, email_smtphost_account, email_smtpport_account, email_isdefaultinbox_account, email_disable_account, email_ignoreexceptions_account, email_unpack_account, email_deletemessages_account, email_starttls_account, email_lastdays_account, system__class_email_account, email_name_account, email_encryptedconnectiontype_account) FROM stdin;
    public          postgres    false    235   ZX      �          0    154266    email_attachmentemail 
   TABLE DATA           -  COPY public.email_attachmentemail (key0, email_email_attachmentemail, email_id_attachmentemail, email_name_attachmentemail, email_imported_attachmentemail, email_file_attachmentemail, email_importerror_attachmentemail, email_lasterror_attachmentemail, system__class_email_attachmentemail) FROM stdin;
    public          postgres    false    338   wX      �          0    153773    email_email 
   TABLE DATA           #  COPY public.email_email (key0, email_account_email, email_id_email, email_uid_email, email_message_email, email_fromaddress_email, email_subject_email, email_datetimesent_email, email_toaddress_email, email_emlfile_email, email_datetimereceived_email, system__class_email_email) FROM stdin;
    public          postgres    false    244   �X      �          0    154107 #   email_encryptedconnectiontypestatus 
   TABLE DATA           v   COPY public.email_encryptedconnectiontypestatus (key0, system__class_email_encryptedconnectiontypestatus) FROM stdin;
    public          postgres    false    308   �X                0    153703    email_receiveaccounttype 
   TABLE DATA           `   COPY public.email_receiveaccounttype (key0, system__class_email_receiveaccounttype) FROM stdin;
    public          postgres    false    231   �X      x          0    153665    empty 
   TABLE DATA           #   COPY public.empty (id) FROM stdin;
    public          postgres    false    224   Y      �          0    154082    excel_template 
   TABLE DATA           �   COPY public.excel_template (key0, excel_name_template, excel_id_template, system__class_excel_template, excel_file_template) FROM stdin;
    public          postgres    false    303   !Y      �          0    154276    excel_templateentry 
   TABLE DATA           ,  COPY public.excel_templateentry (key0, excel_istable_templateentry, excel_isnumeric_templateentry, system__class_excel_templateentry, excel_format_templateentry, excel_description_templateentry, excel_key_templateentry, excel_datarowseparator_templateentry, excel_template_templateentry) FROM stdin;
    public          postgres    false    340   >Y      �          0    153930    geo_poi 
   TABLE DATA           z   COPY public.geo_poi (key0, geo_name_poi, geo_additionaladdress_poi, geo_mainaddress_poi, geo_namecountry_poi) FROM stdin;
    public          postgres    false    274   [Y      �          0    154123 
   geo_poipoi 
   TABLE DATA           L   COPY public.geo_poipoi (key0, key1, geo_distancepoipoi_poi_poi) FROM stdin;
    public          postgres    false    311   xY      v          0    153652    global 
   TABLE DATA           .   COPY public.global (dumb, struct) FROM stdin;
    public          postgres    false    222   �Y      �          0    153830    i18n_dictionary 
   TABLE DATA           �   COPY public.i18n_dictionary (key0, i18n_insensitive_dictionary, i18n_languageto_dictionary, system__class_i18n_dictionary, i18n_name_dictionary, i18n_languagefrom_dictionary) FROM stdin;
    public          postgres    false    255   6�      �          0    154166    i18n_dictionaryentry 
   TABLE DATA           �   COPY public.i18n_dictionaryentry (key0, i18n_dictionary_dictionaryentry, i18n_term_dictionaryentry, i18n_translation_dictionaryentry, system__class_i18n_dictionaryentry) FROM stdin;
    public          postgres    false    319   S�      �          0    153798    i18n_language 
   TABLE DATA           t   COPY public.i18n_language (key0, system__class_i18n_language, i18n_locale_language, i18n_name_language) FROM stdin;
    public          postgres    false    249   p�      �          0    153757    i18n_multilanguagenamedlanguage 
   TABLE DATA           t   COPY public.i18n_multilanguagenamedlanguage (key0, key1, i18n_languagename_multilanguagenamed_language) FROM stdin;
    public          postgres    false    241   ��      u          0    153647    idtable 
   TABLE DATA           ,   COPY public.idtable (id, value) FROM stdin;
    public          postgres    false    221   ��      �          0    153973    messenger_account 
   TABLE DATA             COPY public.messenger_account (key0, messenger_token_account, messenger_messenger_account, system__class_messenger_account, skype_accesstokenskype_account, skype_accesstokendateskype_account, messenger_name_account, skype_clientsecretskype_account) FROM stdin;
    public          postgres    false    282   ��      z          0    153676    messenger_chat 
   TABLE DATA           �   COPY public.messenger_chat (key0, messenger_account_chat, messenger_id_chat, messenger_name_chat, messenger_title_chat, system__class_messenger_chat, messenger_chattype_chat, skype_baseurlskype_chat) FROM stdin;
    public          postgres    false    226   ��      �          0    153783    messenger_messages 
   TABLE DATA           �   COPY public.messenger_messages (key0, system__class_messenger_messages, messenger_message_message, messenger_datetime_message, messenger_chat_message, slack_ts_message, messenger_from_message) FROM stdin;
    public          postgres    false    246   �      �          0    153841    numerator_numerator 
   TABLE DATA             COPY public.numerator_numerator (key0, numerator_name_numerator, numerator_series_numerator, numerator_maxvalue_numerator, numerator_minvalue_numerator, system__class_numerator_numerator, numerator_stringlength_numerator, numerator_curvalue_numerator) FROM stdin;
    public          postgres    false    257   )�      �          0    154182    profiler_profiledata 
   TABLE DATA           �  COPY public.profiler_profiledata (key0, key1, key2, key3, profiler_callcount_profileobject_profileobject_user_form, profiler_totaltime_profileobject_profileobject_user_form, profiler_totaluserinteractiontime_profileobject_profileobject_u, profiler_maxtime_profileobject_profileobject_user_form, profiler_totalsqltime_profileobject_profileobject_user_form, profiler_squaressum_profileobject_profileobject_user_form, profiler_mintime_profileobject_profileobject_user_form) FROM stdin;
    public          postgres    false    322   ^�      �          0    153809    profiler_profileobject 
   TABLE DATA           y   COPY public.profiler_profileobject (key0, profiler_text_profileobject, system__class_profiler_profileobject) FROM stdin;
    public          postgres    false    251   {�      �          0    153904    reflection_action 
   TABLE DATA           s   COPY public.reflection_action (key0, reflection_canonicalname_action, system__class_reflection_action) FROM stdin;
    public          postgres    false    269   ��      �          0    153868    reflection_actionorproperty 
   TABLE DATA           �  COPY public.reflection_actionorproperty (key0, reflection_parent_actionorproperty, security_dataforbidchange_actionorproperty, reflection_caption_actionorproperty, reflection_number_actionorproperty, security_datapermitview_actionorproperty, reflection_annotation_actionorproperty, security_dataforbidview_actionorproperty, security_datapermitchange_actionorproperty, reflection_class_actionorproperty) FROM stdin;
    public          postgres    false    262   ��      �          0    154205    reflection_dropcolumn 
   TABLE DATA           �   COPY public.reflection_dropcolumn (key0, reflection_sid_dropcolumn, system__class_reflection_dropcolumn, reflection_time_dropcolumn, reflection_revision_dropcolumn, reflection_sidtable_dropcolumn) FROM stdin;
    public          postgres    false    326   ��      �          0    154072    reflection_form 
   TABLE DATA           �   COPY public.reflection_form (key0, reflection_canonicalname_form, reflection_caption_form, system__class_reflection_form) FROM stdin;
    public          postgres    false    301   ��      �          0    154129    reflection_formgrouping 
   TABLE DATA           �   COPY public.reflection_formgrouping (key0, reflection_groupobject_formgrouping, reflection_name_formgrouping, system__class_reflection_formgrouping, reflection_itemquantity_formgrouping) FROM stdin;
    public          postgres    false    312   ��      �          0    154134 #   reflection_formgroupingpropertydraw 
   TABLE DATA           �   COPY public.reflection_formgroupingpropertydraw (key0, key1, reflection_pivot_formgrouping_propertydraw, reflection_grouporder_formgrouping_propertydraw, reflection_max_formgrouping_propertydraw, reflection_sum_formgrouping_propertydraw) FROM stdin;
    public          postgres    false    313   �      �          0    154010    reflection_formnames 
   TABLE DATA           L   COPY public.reflection_formnames (key0, reflection_form_string) FROM stdin;
    public          postgres    false    289   ,�      �          0    154176    reflection_formpropertydraw 
   TABLE DATA           A   COPY public.reflection_formpropertydraw (key0, key1) FROM stdin;
    public          postgres    false    321   U�      �          0    153793    reflection_groupobject 
   TABLE DATA           o  COPY public.reflection_groupobject (key0, reflection_form_groupobject, reflection_sid_groupobject, reflection_hasuserpreferences_groupobject, reflection_isfontitalic_groupobject, reflection_fontsize_groupobject, reflection_pagesize_groupobject, reflection_headerheight_groupobject, reflection_isfontbold_groupobject, system__class_reflection_groupobject) FROM stdin;
    public          postgres    false    248   r�      y          0    153670     reflection_groupobjectcustomuser 
   TABLE DATA           b  COPY public.reflection_groupobjectcustomuser (key0, key1, reflection_hasuserpreferences_groupobject_customuser, reflection_fontsize_groupobject_customuser, reflection_headerheight_groupobject_customuser, reflection_isfontitalic_groupobject_customuser, reflection_pagesize_groupobject_customuser, reflection_isfontbold_groupobject_customuser) FROM stdin;
    public          postgres    false    225   ��      �          0    154216    reflection_navigatorelement 
   TABLE DATA           �  COPY public.reflection_navigatorelement (key0, reflection_canonicalname_navigatorelement, reflection_parent_navigatorelement, security_forbid_navigatorelement, reflection_form_navigatorelement, system__class_reflection_navigatorelement, reflection_number_navigatorelement, reflection_caption_navigatorelement, reflection_action_navigatoraction, security_permit_navigatorelement) FROM stdin;
    public          postgres    false    328   ��      �          0    153719 +   reflection_navigatorelementnavigatorelement 
   TABLE DATA           �   COPY public.reflection_navigatorelementnavigatorelement (key0, key1, reflection_level_navigatorelement_navigatorelement) FROM stdin;
    public          postgres    false    234   ��      �          0    154047    reflection_property 
   TABLE DATA           7  COPY public.reflection_property (key0, reflection_canonicalname_property, reflection_userloggable_property, reflection_stats_property, reflection_dbname_property, reflection_tablesid_property, reflection_stored_property, system__class_reflection_property, reflection_complexity_property, reflection_loggable_property, reflection_disableinputlist_property, reflection_quantitytop_property, reflection_issetnotnull_property, reflection_notnullquantity_property, reflection_return_property, reflection_lastrecalculate_property, reflection_quantity_property) FROM stdin;
    public          postgres    false    296   ��      �          0    153863    reflection_propertydraw 
   TABLE DATA           �  COPY public.reflection_propertydraw (key0, reflection_form_propertydraw, reflection_sid_propertydraw, reflection_groupobject_propertydraw, reflection_show_propertydraw, system__class_reflection_propertydraw, reflection_columnascendingsort_propertydraw, reflection_columnwidth_propertydraw, reflection_columnorder_propertydraw, reflection_columnsort_propertydraw, reflection_columncaption_propertydraw, reflection_columnpattern_propertydraw, reflection_caption_propertydraw) FROM stdin;
    public          postgres    false    261   D�      �          0    153984 !   reflection_propertydrawcustomuser 
   TABLE DATA           �  COPY public.reflection_propertydrawcustomuser (key0, key1, reflection_show_propertydraw_customuser, reflection_columncaption_propertydraw_customuser, reflection_columnwidth_propertydraw_customuser, reflection_columnsort_propertydraw_customuser, reflection_columnpattern_propertydraw_customuser, reflection_columnascendingsort_propertydraw_customuser, reflection_columnorder_propertydraw_customuser) FROM stdin;
    public          postgres    false    284   a�      �          0    154155 !   reflection_propertydrawshowstatus 
   TABLE DATA           r   COPY public.reflection_propertydrawshowstatus (key0, system__class_reflection_propertydrawshowstatus) FROM stdin;
    public          postgres    false    317   ~�      �          0    154261    reflection_propertygroup 
   TABLE DATA           �  COPY public.reflection_propertygroup (key0, reflection_parent_propertygroup, reflection_sid_propertygroup, reflection_caption_propertygroup, security_datapermitchange_propertygroup, security_dataforbidchange_propertygroup, security_dataforbidview_propertygroup, security_datapermitview_propertygroup, system__class_reflection_propertygroup, reflection_number_propertygroup) FROM stdin;
    public          postgres    false    337   ��      �          0    153978 %   reflection_propertygrouppropertygroup 
   TABLE DATA           y   COPY public.reflection_propertygrouppropertygroup (key0, key1, reflection_level_propertygroup_propertygroup) FROM stdin;
    public          postgres    false    283   ��      �          0    153778    reflection_tablecolumn 
   TABLE DATA             COPY public.reflection_tablecolumn (key0, reflection_table_tablecolumn, reflection_sid_tablecolumn, reflection_notrecalculate_tablecolumn, reflection_disableclasses_tablecolumn, system__class_reflection_tablecolumn, reflection_disablestatstablecolumn_tablecolumn) FROM stdin;
    public          postgres    false    245   ��      �          0    153788    reflection_tablekey 
   TABLE DATA             COPY public.reflection_tablekey (key0, reflection_table_tablekey, reflection_sid_tablekey, reflection_quantitytop_tablekey, reflection_name_tablekey, reflection_quantity_tablekey, reflection_classsid_tablekey, reflection_class_tablekey, system__class_reflection_tablekey) FROM stdin;
    public          postgres    false    247   ��      �          0    153935    reflection_tables 
   TABLE DATA           �   COPY public.reflection_tables (key0, reflection_sid_table, backup_exclude_table, reflection_skipvacuum_table, system__class_reflection_tables, reflection_disableclasses_table, reflection_notrecalculatestats_table, reflection_rows_table) FROM stdin;
    public          postgres    false    275   ��      �          0    154210    scheduler_dowscheduledtask 
   TABLE DATA           d   COPY public.scheduler_dowscheduledtask (key0, key1, scheduler_in_dow_userscheduledtask) FROM stdin;
    public          postgres    false    327         �          0    153846     scheduler_scheduledclienttasklog 
   TABLE DATA           H  COPY public.scheduler_scheduledclienttasklog (key0, scheduler_scheduledtasklog_scheduledclienttasklog, scheduler_failed_scheduledclienttasklog, system__class_scheduler_scheduledclienttasklog, scheduler_lsfstack_scheduledclienttasklog, scheduler_date_scheduledclienttasklog, scheduler_message_scheduledclienttasklog) FROM stdin;
    public          postgres    false    258   0      �          0    154256    scheduler_scheduledtask 
   TABLE DATA           �  COPY public.scheduler_scheduledtask (key0, scheduler_name_userscheduledtask, scheduler_startdate_userscheduledtask, system__class_scheduler_scheduledtask, scheduler_active_userscheduledtask, scheduler_daysofmonth_userscheduledtask, scheduler_period_userscheduledtask, scheduler_runatstart_userscheduledtask, scheduler_schedulerstarttype_userscheduledtask, scheduler_timefrom_userscheduledtask, scheduler_timeto_userscheduledtask) FROM stdin;
    public          postgres    false    336   M      �          0    154251    scheduler_scheduledtaskdetail 
   TABLE DATA           �  COPY public.scheduler_scheduledtaskdetail (key0, scheduler_scheduledtask_userscheduledtaskdetail, scheduler_action_userscheduledtaskdetail, scheduler_script_userscheduledtaskdetail, system__class_scheduler_scheduledtaskdetail, scheduler_active_userscheduledtaskdetail, scheduler_ignoreexceptions_userscheduledtaskdetail, scheduler_order_userscheduledtaskdetail, scheduler_parameter_userscheduledtaskdetail, scheduler_timeout_userscheduledtaskdetail) FROM stdin;
    public          postgres    false    335   j      �          0    154062    scheduler_scheduledtasklog 
   TABLE DATA           %  COPY public.scheduler_scheduledtasklog (key0, scheduler_scheduledtask_scheduledtasklog, scheduler_date_scheduledtasklog, system__class_scheduler_scheduledtasklog, scheduler_exceptionoccurred_scheduledtasklog, scheduler_result_scheduledtasklog, scheduler_property_scheduledtasklog) FROM stdin;
    public          postgres    false    299   �      �          0    153898 '   scheduler_scheduledtaskscheduledtasklog 
   TABLE DATA           M   COPY public.scheduler_scheduledtaskscheduledtasklog (key0, key1) FROM stdin;
    public          postgres    false    268   �      �          0    154118    scheduler_schedulerstarttype 
   TABLE DATA           h   COPY public.scheduler_schedulerstarttype (key0, system__class_scheduler_schedulerstarttype) FROM stdin;
    public          postgres    false    310   �      �          0    153835    security_customuserrole 
   TABLE DATA           ^   COPY public.security_customuserrole (key0, key1, security_in_customuser_userrole) FROM stdin;
    public          postgres    false    256   �      �          0    154140    security_memorylimit 
   TABLE DATA           �   COPY public.security_memorylimit (key0, security_maxheapsize_memorylimit, security_name_memorylimit, system__class_security_memorylimit, security_vmargs_memorylimit) FROM stdin;
    public          postgres    false    314         �          0    154221    security_policy 
   TABLE DATA           �   COPY public.security_policy (key0, security_id_policy, security_name_policy, system__class_security_policy, security_description_policy) FROM stdin;
    public          postgres    false    329   6      �          0    153745    security_userrole 
   TABLE DATA           r  COPY public.security_userrole (key0, security_sid_userrole, security_maximizedefaultforms_userrole, security_disablerole_userrole, security_forbideditprofile_userrole, security_forbidallforms_userrole, security_forbideditobjects_userrole, security_forbidchangeallproperty_userrole, security_name_userrole, security_forbidchangepassword_userrole, system__class_security_userrole, security_permitallforms_userrole, security_forbidduplicateforms_userrole, security_permitchangeallproperty_userrole, security_showdetailedinfo_userrole, security_forbidviewallproperty_userrole, security_permitviewallproperty_userrole) FROM stdin;
    public          postgres    false    239   S      �          0    153803 !   security_userroleactionorproperty 
   TABLE DATA           �  COPY public.security_userroleactionorproperty (key0, key1, security_datapermissionview_userrole_actionorproperty, security_datapermissioneditobjects_userrole_actionorproperty, security_dataforbidchange_userrole_actionorproperty, security_datapermissionchange_userrole_actionorproperty, security_dataforbidview_userrole_actionorproperty, security_datapermitchange_userrole_actionorproperty, security_datapermitview_userrole_actionorproperty) FROM stdin;
    public          postgres    false    250         �          0    153814 !   security_userrolenavigatorelement 
   TABLE DATA           m  COPY public.security_userrolenavigatorelement (key0, key1, security_datapermission_userrole_navigatorelement, security_nearestparentpermission_userrole_navigatorelement, security_permit_userrole_navigatorelement, security_mobileonly_userrole_navigatorelement, security_defaultnumber_userrole_navigatorelement, security_forbid_userrole_navigatorelement) FROM stdin;
    public          postgres    false    252   :      �          0    154015    security_userrolepolicy 
   TABLE DATA           ]   COPY public.security_userrolepolicy (key0, key1, security_order_userrole_policy) FROM stdin;
    public          postgres    false    290   W      �          0    153919    security_userrolepropertygroup 
   TABLE DATA           j  COPY public.security_userrolepropertygroup (key0, key1, security_datapermissionchange_userrole_propertygroup, security_datapermissionview_userrole_propertygroup, security_nearestparentpermissionview_userrole_propertygroup, security_datapermissioneditobjects_userrole_propertygroup, security_nearestparentpermissioneditobjects_userrole_propertygr, security_datapermitview_userrole_propertygroup, security_datapermitchange_userrole_propertygroup, security_dataforbidchange_userrole_propertygroup, security_nearestparentpermissionchange_userrole_propertygroup, security_dataforbidview_userrole_propertygroup) FROM stdin;
    public          postgres    false    272   t      �          0    153851    security_useruserrole 
   TABLE DATA           W   COPY public.security_useruserrole (key0, key1, security_has_user_userrole) FROM stdin;
    public          postgres    false    259   �      �          0    154171    service_dbtype 
   TABLE DATA           L   COPY public.service_dbtype (key0, system__class_service_dbtype) FROM stdin;
    public          postgres    false    320   �      �          0    153893    service_setting 
   TABLE DATA           �   COPY public.service_setting (key0, service_name_setting, service_defaultvalue_setting, service_basevalue_setting, system__class_service_setting) FROM stdin;
    public          postgres    false    267   �      �          0    154286    service_settinguserrole 
   TABLE DATA           a   COPY public.service_settinguserrole (key0, key1, service_basevalue_setting_userrole) FROM stdin;
    public          postgres    false    342   �      �          0    154271    service_typeexecenv 
   TABLE DATA           V   COPY public.service_typeexecenv (key0, system__class_service_typeexecenv) FROM stdin;
    public          postgres    false    339   �      �          0    154097    system_customobjectclass 
   TABLE DATA              COPY public.system_customobjectclass (key0, system__class_system_customobjectclass, system_stat_customobjectclass) FROM stdin;
    public          postgres    false    306   �      �          0    153909 
   system_row 
   TABLE DATA           �  COPY public.system_row (key0, system_numeric2_row, system_date2_row, system_string10_row, system_string4_row, system_numeric1_row, system_date3_row, system_string7_row, system_string5_row, system_numeric5_row, system_date1_row, system__class_system_row, system_string1_row, system_string2_row, system_string8_row, system_string9_row, system_string6_row, system_string3_row, system_numeric4_row, system_numeric3_row) FROM stdin;
    public          postgres    false    270   �      �          0    153825    system_script 
   TABLE DATA           �   COPY public.system_script (key0, system_text_script, system_name_script, system__class_system_script, system_datetime_script, system_datetimechange_script) FROM stdin;
    public          postgres    false    254   �      �          0    154226    system_staticobject 
   TABLE DATA           v   COPY public.system_staticobject (key0, system_staticcaption_staticobject, system_staticname_staticobject) FROM stdin;
    public          postgres    false    330         �          0    154067    systemevents_clienttype 
   TABLE DATA           ^   COPY public.systemevents_clienttype (key0, system__class_systemevents_clienttype) FROM stdin;
    public          postgres    false    300   �.      �          0    154037    systemevents_connection 
   TABLE DATA           �  COPY public.systemevents_connection (key0, service_fileuserlogs_connection, service_filethreaddump_connection, systemevents_contextpath_connection, systemevents_architecture_connection, systemevents_connectionstatus_connection, systemevents_user_connection, systemevents_computer_connection, systemevents_webhost_connection, system__class_systemevents_connection, systemevents_cores_connection, systemevents_maximummemory_connection, systemevents_is64java_connection, systemevents_lastactivity_connection, systemevents_webport_connection, systemevents_freememory_connection, systemevents_disconnecttime_connection, systemevents_physicalmemory_connection, systemevents_processor_connection, systemevents_clienttype_connection, systemevents_totalmemory_connection, systemevents_javaversion_connection, systemevents_osversion_connection, systemevents_connecttime_connection, systemevents_launch_connection, systemevents_screensize_connection, systemevents_remoteaddress_connection) FROM stdin;
    public          postgres    false    294   /      ~          0    153697    systemevents_connectionform 
   TABLE DATA           s   COPY public.systemevents_connectionform (key0, key1, systemevents_connectionformcount_connection_form) FROM stdin;
    public          postgres    false    230   �0      �          0    154160 '   systemevents_connectionnavigatorelement 
   TABLE DATA           M   COPY public.systemevents_connectionnavigatorelement (key0, key1) FROM stdin;
    public          postgres    false    318   1      �          0    154052    systemevents_connectionstatus 
   TABLE DATA           j   COPY public.systemevents_connectionstatus (key0, system__class_systemevents_connectionstatus) FROM stdin;
    public          postgres    false    297   )1      �          0    154021    systemevents_exception 
   TABLE DATA           �  COPY public.systemevents_exception (key0, systemevents_client_clientexception, systemevents_message_exception, systemevents_type_exception, systemevents_reqid_handledexception, system__class_systemevents_exception, systemevents_login_clientexception, systemevents_ertrace_exception, systemevents_abandoned_nonfatalhandledexception, systemevents_count_nonfatalhandledexception, systemevents_lsfstacktrace_exception, systemevents_date_exception) FROM stdin;
    public          postgres    false    291   T1      �          0    153925    systemevents_launch 
   TABLE DATA           �   COPY public.systemevents_launch (key0, systemevents_computer_launch, systemevents_revision_launch, system__class_systemevents_launch, systemevents_time_launch) FROM stdin;
    public          postgres    false    273   �3      �          0    153750    systemevents_pingtable 
   TABLE DATA           l  COPY public.systemevents_pingtable (key0, key1, key2, systemevents_maxtotalmemoryfromto_computer_datetime_datetime, systemevents_mintotalmemoryfromto_computer_datetime_datetime, systemevents_maxusedmemoryfromto_computer_datetime_datetime, systemevents_pingfromto_computer_datetime_datetime, systemevents_minusedmemoryfromto_computer_datetime_datetime) FROM stdin;
    public          postgres    false    240   N4      �          0    154200    systemevents_session 
   TABLE DATA           q  COPY public.systemevents_session (key0, systemevents_user_session, systemevents_datetime_session, systemevents_changes_session, systemevents_quantityaddedclasses_session, system__class_systemevents_session, systemevents_quantitychangedclasses_session, systemevents_connection_session, systemevents_form_session, systemevents_quantityremovedclasses_session) FROM stdin;
    public          postgres    false    325   k4      �          0    153708    systemevents_sessioncontact 
   TABLE DATA           A   COPY public.systemevents_sessioncontact (key0, key1) FROM stdin;
    public          postgres    false    232   	P      �          0    153940    systemevents_sessionobject 
   TABLE DATA           @   COPY public.systemevents_sessionobject (key0, key1) FROM stdin;
    public          postgres    false    276   &P      �          0    154190    time_dow 
   TABLE DATA           c   COPY public.time_dow (key0, time_number_dow, time_numberm_dow, system__class_time_dow) FROM stdin;
    public          postgres    false    323   CP      �          0    154102 
   time_month 
   TABLE DATA           W   COPY public.time_month (key0, time_number_month, system__class_time_month) FROM stdin;
    public          postgres    false    307   }P      �          0    153883    utils_yesno 
   TABLE DATA           F   COPY public.utils_yesno (key0, system__class_utils_yesno) FROM stdin;
    public          postgres    false    265   �P      �          0    154236    word_template 
   TABLE DATA           �   COPY public.word_template (key0, word_id_template, word_file_template, system__class_word_template, word_name_template) FROM stdin;
    public          postgres    false    332   �P      �          0    153768    word_templateentry 
   TABLE DATA             COPY public.word_templateentry (key0, word_key_templateentry, word_template_templateentry, word_type_templateentry, word_datacolumnseparator_templateentry, word_description_templateentry, system__class_word_templateentry, word_datarowseparator_templateentry) FROM stdin;
    public          postgres    false    243   	Q      �          0    154026 	   word_type 
   TABLE DATA           B   COPY public.word_type (key0, system__class_word_type) FROM stdin;
    public          postgres    false    292   &Q      R           2606    153971    _auto_authentication_customuser_time_datetimeintervalpickerrang _auto_authentication_customuser_time_datetimeintervalpicke_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_authentication_customuser_time_datetimeintervalpickerrang
    ADD CONSTRAINT _auto_authentication_customuser_time_datetimeintervalpicke_pkey PRIMARY KEY (key0, key1);
 �   ALTER TABLE ONLY public._auto_authentication_customuser_time_datetimeintervalpickerrang DROP CONSTRAINT _auto_authentication_customuser_time_datetimeintervalpicke_pkey;
       public            postgres    false    281    281            �           2606    154116 x   _auto_authentication_customuser_time_datetimepickerranges _auto_authentication_customuser_time_datetimepickerranges_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_authentication_customuser_time_datetimepickerranges
    ADD CONSTRAINT _auto_authentication_customuser_time_datetimepickerranges_pkey PRIMARY KEY (key0, key1);
 �   ALTER TABLE ONLY public._auto_authentication_customuser_time_datetimepickerranges DROP CONSTRAINT _auto_authentication_customuser_time_datetimepickerranges_pkey;
       public            postgres    false    309    309            �           2606    154154 <   _auto_authentication_oauth2 _auto_authentication_oauth2_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public._auto_authentication_oauth2
    ADD CONSTRAINT _auto_authentication_oauth2_pkey PRIMARY KEY (key0);
 f   ALTER TABLE ONLY public._auto_authentication_oauth2 DROP CONSTRAINT _auto_authentication_oauth2_pkey;
       public            postgres    false    316            �           2606    154096 6   _auto_chat_messagestatus _auto_chat_messagestatus_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public._auto_chat_messagestatus
    ADD CONSTRAINT _auto_chat_messagestatus_pkey PRIMARY KEY (key0);
 `   ALTER TABLE ONLY public._auto_chat_messagestatus DROP CONSTRAINT _auto_chat_messagestatus_pkey;
       public            postgres    false    305            �           2606    154250 0   _auto_geo_mapprovider _auto_geo_mapprovider_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public._auto_geo_mapprovider
    ADD CONSTRAINT _auto_geo_mapprovider_pkey PRIMARY KEY (key0);
 Z   ALTER TABLE ONLY public._auto_geo_mapprovider DROP CONSTRAINT _auto_geo_mapprovider_pkey;
       public            postgres    false    334            �           2606    154149 @   _auto_i18n_multilanguagenamed _auto_i18n_multilanguagenamed_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_i18n_multilanguagenamed
    ADD CONSTRAINT _auto_i18n_multilanguagenamed_pkey PRIMARY KEY (key0);
 j   ALTER TABLE ONLY public._auto_i18n_multilanguagenamed DROP CONSTRAINT _auto_i18n_multilanguagenamed_pkey;
       public            postgres    false    315            }           2606    154061 6   _auto_messenger_chattype _auto_messenger_chattype_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public._auto_messenger_chattype
    ADD CONSTRAINT _auto_messenger_chattype_pkey PRIMARY KEY (key0);
 `   ALTER TABLE ONLY public._auto_messenger_chattype DROP CONSTRAINT _auto_messenger_chattype_pkey;
       public            postgres    false    298            _           2606    153999 8   _auto_messenger_messenger _auto_messenger_messenger_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public._auto_messenger_messenger
    ADD CONSTRAINT _auto_messenger_messenger_pkey PRIMARY KEY (key0);
 b   ALTER TABLE ONLY public._auto_messenger_messenger DROP CONSTRAINT _auto_messenger_messenger_pkey;
       public            postgres    false    286                        2606    153862    _auto _auto_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public._auto
    ADD CONSTRAINT _auto_pkey PRIMARY KEY (dumb);
 :   ALTER TABLE ONLY public._auto DROP CONSTRAINT _auto_pkey;
       public            postgres    false    260                       2606    153824 F   _auto_processmonitor_processtype _auto_processmonitor_processtype_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_processmonitor_processtype
    ADD CONSTRAINT _auto_processmonitor_processtype_pkey PRIMARY KEY (key0);
 p   ALTER TABLE ONLY public._auto_processmonitor_processtype DROP CONSTRAINT _auto_processmonitor_processtype_pkey;
       public            postgres    false    253            �           2606    153744 H   _auto_processmonitor_stateprocess _auto_processmonitor_stateprocess_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_processmonitor_stateprocess
    ADD CONSTRAINT _auto_processmonitor_stateprocess_pkey PRIMARY KEY (key0);
 r   ALTER TABLE ONLY public._auto_processmonitor_stateprocess DROP CONSTRAINT _auto_processmonitor_stateprocess_pkey;
       public            postgres    false    238            �           2606    154285 >   _auto_profiler_profilerindex _auto_profiler_profilerindex_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public._auto_profiler_profilerindex
    ADD CONSTRAINT _auto_profiler_profilerindex_pkey PRIMARY KEY (key0);
 h   ALTER TABLE ONLY public._auto_profiler_profilerindex DROP CONSTRAINT _auto_profiler_profilerindex_pkey;
       public            postgres    false    341            �           2606    154245 2   _auto_rabbitmq_channel _auto_rabbitmq_channel_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public._auto_rabbitmq_channel
    ADD CONSTRAINT _auto_rabbitmq_channel_pkey PRIMARY KEY (key0);
 \   ALTER TABLE ONLY public._auto_rabbitmq_channel DROP CONSTRAINT _auto_rabbitmq_channel_pkey;
       public            postgres    false    333            +           2606    153882 $   _auto_room_room _auto_room_room_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public._auto_room_room
    ADD CONSTRAINT _auto_room_room_pkey PRIMARY KEY (key0);
 N   ALTER TABLE ONLY public._auto_room_room DROP CONSTRAINT _auto_room_room_pkey;
       public            postgres    false    264            '           2606    153877 0   _auto_scanner_scanner _auto_scanner_scanner_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public._auto_scanner_scanner
    ADD CONSTRAINT _auto_scanner_scanner_pkey PRIMARY KEY (key0);
 Z   ALTER TABLE ONLY public._auto_scanner_scanner DROP CONSTRAINT _auto_scanner_scanner_pkey;
       public            postgres    false    263            �           2606    210782 <   _auto_scanner_scannerstatus _auto_scanner_scannerstatus_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public._auto_scanner_scannerstatus
    ADD CONSTRAINT _auto_scanner_scannerstatus_pkey PRIMARY KEY (key0);
 f   ALTER TABLE ONLY public._auto_scanner_scannerstatus DROP CONSTRAINT _auto_scanner_scannerstatus_pkey;
       public            postgres    false    343            �           2606    153767 4   _auto_schedule_holidays _auto_schedule_holidays_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public._auto_schedule_holidays
    ADD CONSTRAINT _auto_schedule_holidays_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public._auto_schedule_holidays DROP CONSTRAINT _auto_schedule_holidays_pkey;
       public            postgres    false    242            �           2606    154235 4   _auto_schedule_schedule _auto_schedule_schedule_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public._auto_schedule_schedule
    ADD CONSTRAINT _auto_schedule_schedule_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public._auto_schedule_schedule DROP CONSTRAINT _auto_schedule_schedule_pkey;
       public            postgres    false    331            �           2606    153685 @   _auto_schedule_scheduledetail _auto_schedule_scheduledetail_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_schedule_scheduledetail
    ADD CONSTRAINT _auto_schedule_scheduledetail_pkey PRIMARY KEY (key0);
 j   ALTER TABLE ONLY public._auto_schedule_scheduledetail DROP CONSTRAINT _auto_schedule_scheduledetail_pkey;
       public            postgres    false    227            H           2606    153950 8   _auto_security_permission _auto_security_permission_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public._auto_security_permission
    ADD CONSTRAINT _auto_security_permission_pkey PRIMARY KEY (key0);
 b   ALTER TABLE ONLY public._auto_security_permission DROP CONSTRAINT _auto_security_permission_pkey;
       public            postgres    false    277            �           2606    154081 &   _auto_slack_user _auto_slack_user_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public._auto_slack_user
    ADD CONSTRAINT _auto_slack_user_pkey PRIMARY KEY (key0);
 P   ALTER TABLE ONLY public._auto_slack_user DROP CONSTRAINT _auto_slack_user_pkey;
       public            postgres    false    302            w           2606    154046 (   _auto_staff_staff _auto_staff_staff_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public._auto_staff_staff
    ADD CONSTRAINT _auto_staff_staff_pkey PRIMARY KEY (key0);
 R   ALTER TABLE ONLY public._auto_staff_staff DROP CONSTRAINT _auto_staff_staff_pkey;
       public            postgres    false    295            �           2606    154091 8   _auto_system_listviewtype _auto_system_listviewtype_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public._auto_system_listviewtype
    ADD CONSTRAINT _auto_system_listviewtype_pkey PRIMARY KEY (key0);
 b   ALTER TABLE ONLY public._auto_system_listviewtype DROP CONSTRAINT _auto_system_listviewtype_pkey;
       public            postgres    false    304            �           2606    153734 ,   _auto_system_object _auto_system_object_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public._auto_system_object
    ADD CONSTRAINT _auto_system_object_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public._auto_system_object DROP CONSTRAINT _auto_system_object_pkey;
       public            postgres    false    236            /           2606    153892 4   _auto_system_scripttype _auto_system_scripttype_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public._auto_system_scripttype
    ADD CONSTRAINT _auto_system_scripttype_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public._auto_system_scripttype DROP CONSTRAINT _auto_system_scripttype_pkey;
       public            postgres    false    266            a           2606    154004 T   _auto_time_datetimeintervalpickerranges _auto_time_datetimeintervalpickerranges_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_time_datetimeintervalpickerranges
    ADD CONSTRAINT _auto_time_datetimeintervalpickerranges_pkey PRIMARY KEY (key0);
 ~   ALTER TABLE ONLY public._auto_time_datetimeintervalpickerranges DROP CONSTRAINT _auto_time_datetimeintervalpickerranges_pkey;
       public            postgres    false    287            M           2606    153960 D   _auto_time_datetimepickerranges _auto_time_datetimepickerranges_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public._auto_time_datetimepickerranges
    ADD CONSTRAINT _auto_time_datetimepickerranges_pkey PRIMARY KEY (key0);
 n   ALTER TABLE ONLY public._auto_time_datetimepickerranges DROP CONSTRAINT _auto_time_datetimepickerranges_pkey;
       public            postgres    false    279            �           2606    153696 8   authentication_colortheme authentication_colortheme_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.authentication_colortheme
    ADD CONSTRAINT authentication_colortheme_pkey PRIMARY KEY (key0);
 b   ALTER TABLE ONLY public.authentication_colortheme DROP CONSTRAINT authentication_colortheme_pkey;
       public            postgres    false    229            �           2606    154199 4   authentication_computer authentication_computer_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.authentication_computer
    ADD CONSTRAINT authentication_computer_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public.authentication_computer DROP CONSTRAINT authentication_computer_pkey;
       public            postgres    false    324            �           2606    153739 2   authentication_contact authentication_contact_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.authentication_contact
    ADD CONSTRAINT authentication_contact_pkey PRIMARY KEY (key0);
 \   ALTER TABLE ONLY public.authentication_contact DROP CONSTRAINT authentication_contact_pkey;
       public            postgres    false    237            :           2606    153918 8   authentication_customuser authentication_customuser_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.authentication_customuser
    ADD CONSTRAINT authentication_customuser_pkey PRIMARY KEY (key0);
 b   ALTER TABLE ONLY public.authentication_customuser DROP CONSTRAINT authentication_customuser_pkey;
       public            postgres    false    271            c           2606    154009 ,   authentication_user authentication_user_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.authentication_user
    ADD CONSTRAINT authentication_user_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.authentication_user DROP CONSTRAINT authentication_user_pkey;
       public            postgres    false    288            ]           2606    153994     backup_backup backup_backup_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.backup_backup
    ADD CONSTRAINT backup_backup_pkey PRIMARY KEY (key0);
 J   ALTER TABLE ONLY public.backup_backup DROP CONSTRAINT backup_backup_pkey;
       public            postgres    false    285            O           2606    153965 *   backup_backuptable backup_backuptable_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.backup_backuptable
    ADD CONSTRAINT backup_backuptable_pkey PRIMARY KEY (key0, key1);
 T   ALTER TABLE ONLY public.backup_backuptable DROP CONSTRAINT backup_backuptable_pkey;
       public            postgres    false    280    280            J           2606    153955    chat_chat chat_chat_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.chat_chat
    ADD CONSTRAINT chat_chat_pkey PRIMARY KEY (key0);
 B   ALTER TABLE ONLY public.chat_chat DROP CONSTRAINT chat_chat_pkey;
       public            postgres    false    278            �           2606    153690 ,   chat_chatcustomuser chat_chatcustomuser_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.chat_chatcustomuser
    ADD CONSTRAINT chat_chatcustomuser_pkey PRIMARY KEY (key0, key1);
 V   ALTER TABLE ONLY public.chat_chatcustomuser DROP CONSTRAINT chat_chatcustomuser_pkey;
       public            postgres    false    228    228            �           2606    153718    chat_message chat_message_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT chat_message_pkey PRIMARY KEY (key0);
 H   ALTER TABLE ONLY public.chat_message DROP CONSTRAINT chat_message_pkey;
       public            postgres    false    233            p           2606    154035 2   chat_messagecustomuser chat_messagecustomuser_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.chat_messagecustomuser
    ADD CONSTRAINT chat_messagecustomuser_pkey PRIMARY KEY (key0, key1);
 \   ALTER TABLE ONLY public.chat_messagecustomuser DROP CONSTRAINT chat_messagecustomuser_pkey;
       public            postgres    false    293    293            �           2606    153664    dumb dumb_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.dumb
    ADD CONSTRAINT dumb_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.dumb DROP CONSTRAINT dumb_pkey;
       public            postgres    false    223            �           2606    153729     email_account email_account_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.email_account
    ADD CONSTRAINT email_account_pkey PRIMARY KEY (key0);
 J   ALTER TABLE ONLY public.email_account DROP CONSTRAINT email_account_pkey;
       public            postgres    false    235            �           2606    154270 0   email_attachmentemail email_attachmentemail_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.email_attachmentemail
    ADD CONSTRAINT email_attachmentemail_pkey PRIMARY KEY (key0);
 Z   ALTER TABLE ONLY public.email_attachmentemail DROP CONSTRAINT email_attachmentemail_pkey;
       public            postgres    false    338            �           2606    153777    email_email email_email_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.email_email
    ADD CONSTRAINT email_email_pkey PRIMARY KEY (key0);
 F   ALTER TABLE ONLY public.email_email DROP CONSTRAINT email_email_pkey;
       public            postgres    false    244            �           2606    154111 L   email_encryptedconnectiontypestatus email_encryptedconnectiontypestatus_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.email_encryptedconnectiontypestatus
    ADD CONSTRAINT email_encryptedconnectiontypestatus_pkey PRIMARY KEY (key0);
 v   ALTER TABLE ONLY public.email_encryptedconnectiontypestatus DROP CONSTRAINT email_encryptedconnectiontypestatus_pkey;
       public            postgres    false    308            �           2606    153707 6   email_receiveaccounttype email_receiveaccounttype_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.email_receiveaccounttype
    ADD CONSTRAINT email_receiveaccounttype_pkey PRIMARY KEY (key0);
 `   ALTER TABLE ONLY public.email_receiveaccounttype DROP CONSTRAINT email_receiveaccounttype_pkey;
       public            postgres    false    231            �           2606    153669    empty empty_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.empty
    ADD CONSTRAINT empty_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.empty DROP CONSTRAINT empty_pkey;
       public            postgres    false    224            �           2606    154086 "   excel_template excel_template_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.excel_template
    ADD CONSTRAINT excel_template_pkey PRIMARY KEY (key0);
 L   ALTER TABLE ONLY public.excel_template DROP CONSTRAINT excel_template_pkey;
       public            postgres    false    303            �           2606    154280 ,   excel_templateentry excel_templateentry_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.excel_templateentry
    ADD CONSTRAINT excel_templateentry_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.excel_templateentry DROP CONSTRAINT excel_templateentry_pkey;
       public            postgres    false    340            A           2606    153934    geo_poi geo_poi_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.geo_poi
    ADD CONSTRAINT geo_poi_pkey PRIMARY KEY (key0);
 >   ALTER TABLE ONLY public.geo_poi DROP CONSTRAINT geo_poi_pkey;
       public            postgres    false    274            �           2606    154127    geo_poipoi geo_poipoi_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.geo_poipoi
    ADD CONSTRAINT geo_poipoi_pkey PRIMARY KEY (key0, key1);
 D   ALTER TABLE ONLY public.geo_poipoi DROP CONSTRAINT geo_poipoi_pkey;
       public            postgres    false    311    311            �           2606    153657    global global_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.global
    ADD CONSTRAINT global_pkey PRIMARY KEY (dumb);
 <   ALTER TABLE ONLY public.global DROP CONSTRAINT global_pkey;
       public            postgres    false    222                       2606    153834 $   i18n_dictionary i18n_dictionary_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.i18n_dictionary
    ADD CONSTRAINT i18n_dictionary_pkey PRIMARY KEY (key0);
 N   ALTER TABLE ONLY public.i18n_dictionary DROP CONSTRAINT i18n_dictionary_pkey;
       public            postgres    false    255            �           2606    154170 .   i18n_dictionaryentry i18n_dictionaryentry_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.i18n_dictionaryentry
    ADD CONSTRAINT i18n_dictionaryentry_pkey PRIMARY KEY (key0);
 X   ALTER TABLE ONLY public.i18n_dictionaryentry DROP CONSTRAINT i18n_dictionaryentry_pkey;
       public            postgres    false    319                       2606    153802     i18n_language i18n_language_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.i18n_language
    ADD CONSTRAINT i18n_language_pkey PRIMARY KEY (key0);
 J   ALTER TABLE ONLY public.i18n_language DROP CONSTRAINT i18n_language_pkey;
       public            postgres    false    249            �           2606    153761 D   i18n_multilanguagenamedlanguage i18n_multilanguagenamedlanguage_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.i18n_multilanguagenamedlanguage
    ADD CONSTRAINT i18n_multilanguagenamedlanguage_pkey PRIMARY KEY (key0, key1);
 n   ALTER TABLE ONLY public.i18n_multilanguagenamedlanguage DROP CONSTRAINT i18n_multilanguagenamedlanguage_pkey;
       public            postgres    false    241    241            �           2606    153651    idtable idtable_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.idtable
    ADD CONSTRAINT idtable_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.idtable DROP CONSTRAINT idtable_pkey;
       public            postgres    false    221            U           2606    153977 (   messenger_account messenger_account_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.messenger_account
    ADD CONSTRAINT messenger_account_pkey PRIMARY KEY (key0);
 R   ALTER TABLE ONLY public.messenger_account DROP CONSTRAINT messenger_account_pkey;
       public            postgres    false    282            �           2606    153680 "   messenger_chat messenger_chat_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.messenger_chat
    ADD CONSTRAINT messenger_chat_pkey PRIMARY KEY (key0);
 L   ALTER TABLE ONLY public.messenger_chat DROP CONSTRAINT messenger_chat_pkey;
       public            postgres    false    226            �           2606    153787 *   messenger_messages messenger_messages_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.messenger_messages
    ADD CONSTRAINT messenger_messages_pkey PRIMARY KEY (key0);
 T   ALTER TABLE ONLY public.messenger_messages DROP CONSTRAINT messenger_messages_pkey;
       public            postgres    false    246                       2606    153845 ,   numerator_numerator numerator_numerator_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.numerator_numerator
    ADD CONSTRAINT numerator_numerator_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.numerator_numerator DROP CONSTRAINT numerator_numerator_pkey;
       public            postgres    false    257            �           2606    154186 .   profiler_profiledata profiler_profiledata_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.profiler_profiledata
    ADD CONSTRAINT profiler_profiledata_pkey PRIMARY KEY (key0, key1, key2, key3);
 X   ALTER TABLE ONLY public.profiler_profiledata DROP CONSTRAINT profiler_profiledata_pkey;
       public            postgres    false    322    322    322    322            
           2606    153813 2   profiler_profileobject profiler_profileobject_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.profiler_profileobject
    ADD CONSTRAINT profiler_profileobject_pkey PRIMARY KEY (key0);
 \   ALTER TABLE ONLY public.profiler_profileobject DROP CONSTRAINT profiler_profileobject_pkey;
       public            postgres    false    251            6           2606    153908 (   reflection_action reflection_action_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.reflection_action
    ADD CONSTRAINT reflection_action_pkey PRIMARY KEY (key0);
 R   ALTER TABLE ONLY public.reflection_action DROP CONSTRAINT reflection_action_pkey;
       public            postgres    false    269            %           2606    153872 <   reflection_actionorproperty reflection_actionorproperty_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.reflection_actionorproperty
    ADD CONSTRAINT reflection_actionorproperty_pkey PRIMARY KEY (key0);
 f   ALTER TABLE ONLY public.reflection_actionorproperty DROP CONSTRAINT reflection_actionorproperty_pkey;
       public            postgres    false    262            �           2606    154209 0   reflection_dropcolumn reflection_dropcolumn_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.reflection_dropcolumn
    ADD CONSTRAINT reflection_dropcolumn_pkey PRIMARY KEY (key0);
 Z   ALTER TABLE ONLY public.reflection_dropcolumn DROP CONSTRAINT reflection_dropcolumn_pkey;
       public            postgres    false    326            �           2606    154076 $   reflection_form reflection_form_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.reflection_form
    ADD CONSTRAINT reflection_form_pkey PRIMARY KEY (key0);
 N   ALTER TABLE ONLY public.reflection_form DROP CONSTRAINT reflection_form_pkey;
       public            postgres    false    301            �           2606    154133 4   reflection_formgrouping reflection_formgrouping_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.reflection_formgrouping
    ADD CONSTRAINT reflection_formgrouping_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public.reflection_formgrouping DROP CONSTRAINT reflection_formgrouping_pkey;
       public            postgres    false    312            �           2606    154138 L   reflection_formgroupingpropertydraw reflection_formgroupingpropertydraw_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.reflection_formgroupingpropertydraw
    ADD CONSTRAINT reflection_formgroupingpropertydraw_pkey PRIMARY KEY (key0, key1);
 v   ALTER TABLE ONLY public.reflection_formgroupingpropertydraw DROP CONSTRAINT reflection_formgroupingpropertydraw_pkey;
       public            postgres    false    313    313            f           2606    154014 .   reflection_formnames reflection_formnames_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.reflection_formnames
    ADD CONSTRAINT reflection_formnames_pkey PRIMARY KEY (key0);
 X   ALTER TABLE ONLY public.reflection_formnames DROP CONSTRAINT reflection_formnames_pkey;
       public            postgres    false    289            �           2606    154180 <   reflection_formpropertydraw reflection_formpropertydraw_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.reflection_formpropertydraw
    ADD CONSTRAINT reflection_formpropertydraw_pkey PRIMARY KEY (key0, key1);
 f   ALTER TABLE ONLY public.reflection_formpropertydraw DROP CONSTRAINT reflection_formpropertydraw_pkey;
       public            postgres    false    321    321                       2606    153797 2   reflection_groupobject reflection_groupobject_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.reflection_groupobject
    ADD CONSTRAINT reflection_groupobject_pkey PRIMARY KEY (key0);
 \   ALTER TABLE ONLY public.reflection_groupobject DROP CONSTRAINT reflection_groupobject_pkey;
       public            postgres    false    248            �           2606    153674 F   reflection_groupobjectcustomuser reflection_groupobjectcustomuser_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.reflection_groupobjectcustomuser
    ADD CONSTRAINT reflection_groupobjectcustomuser_pkey PRIMARY KEY (key0, key1);
 p   ALTER TABLE ONLY public.reflection_groupobjectcustomuser DROP CONSTRAINT reflection_groupobjectcustomuser_pkey;
       public            postgres    false    225    225            �           2606    154220 <   reflection_navigatorelement reflection_navigatorelement_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.reflection_navigatorelement
    ADD CONSTRAINT reflection_navigatorelement_pkey PRIMARY KEY (key0);
 f   ALTER TABLE ONLY public.reflection_navigatorelement DROP CONSTRAINT reflection_navigatorelement_pkey;
       public            postgres    false    328            �           2606    153723 \   reflection_navigatorelementnavigatorelement reflection_navigatorelementnavigatorelement_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.reflection_navigatorelementnavigatorelement
    ADD CONSTRAINT reflection_navigatorelementnavigatorelement_pkey PRIMARY KEY (key0, key1);
 �   ALTER TABLE ONLY public.reflection_navigatorelementnavigatorelement DROP CONSTRAINT reflection_navigatorelementnavigatorelement_pkey;
       public            postgres    false    234    234            y           2606    154051 ,   reflection_property reflection_property_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.reflection_property
    ADD CONSTRAINT reflection_property_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.reflection_property DROP CONSTRAINT reflection_property_pkey;
       public            postgres    false    296            #           2606    153867 4   reflection_propertydraw reflection_propertydraw_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.reflection_propertydraw
    ADD CONSTRAINT reflection_propertydraw_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public.reflection_propertydraw DROP CONSTRAINT reflection_propertydraw_pkey;
       public            postgres    false    261            [           2606    153988 H   reflection_propertydrawcustomuser reflection_propertydrawcustomuser_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.reflection_propertydrawcustomuser
    ADD CONSTRAINT reflection_propertydrawcustomuser_pkey PRIMARY KEY (key0, key1);
 r   ALTER TABLE ONLY public.reflection_propertydrawcustomuser DROP CONSTRAINT reflection_propertydrawcustomuser_pkey;
       public            postgres    false    284    284            �           2606    154159 H   reflection_propertydrawshowstatus reflection_propertydrawshowstatus_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.reflection_propertydrawshowstatus
    ADD CONSTRAINT reflection_propertydrawshowstatus_pkey PRIMARY KEY (key0);
 r   ALTER TABLE ONLY public.reflection_propertydrawshowstatus DROP CONSTRAINT reflection_propertydrawshowstatus_pkey;
       public            postgres    false    317            �           2606    154265 6   reflection_propertygroup reflection_propertygroup_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.reflection_propertygroup
    ADD CONSTRAINT reflection_propertygroup_pkey PRIMARY KEY (key0);
 `   ALTER TABLE ONLY public.reflection_propertygroup DROP CONSTRAINT reflection_propertygroup_pkey;
       public            postgres    false    337            X           2606    153982 P   reflection_propertygrouppropertygroup reflection_propertygrouppropertygroup_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.reflection_propertygrouppropertygroup
    ADD CONSTRAINT reflection_propertygrouppropertygroup_pkey PRIMARY KEY (key0, key1);
 z   ALTER TABLE ONLY public.reflection_propertygrouppropertygroup DROP CONSTRAINT reflection_propertygrouppropertygroup_pkey;
       public            postgres    false    283    283            �           2606    153782 2   reflection_tablecolumn reflection_tablecolumn_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.reflection_tablecolumn
    ADD CONSTRAINT reflection_tablecolumn_pkey PRIMARY KEY (key0);
 \   ALTER TABLE ONLY public.reflection_tablecolumn DROP CONSTRAINT reflection_tablecolumn_pkey;
       public            postgres    false    245                       2606    153792 ,   reflection_tablekey reflection_tablekey_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.reflection_tablekey
    ADD CONSTRAINT reflection_tablekey_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.reflection_tablekey DROP CONSTRAINT reflection_tablekey_pkey;
       public            postgres    false    247            C           2606    153939 (   reflection_tables reflection_tables_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.reflection_tables
    ADD CONSTRAINT reflection_tables_pkey PRIMARY KEY (key0);
 R   ALTER TABLE ONLY public.reflection_tables DROP CONSTRAINT reflection_tables_pkey;
       public            postgres    false    275            �           2606    154214 :   scheduler_dowscheduledtask scheduler_dowscheduledtask_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.scheduler_dowscheduledtask
    ADD CONSTRAINT scheduler_dowscheduledtask_pkey PRIMARY KEY (key0, key1);
 d   ALTER TABLE ONLY public.scheduler_dowscheduledtask DROP CONSTRAINT scheduler_dowscheduledtask_pkey;
       public            postgres    false    327    327                       2606    153850 F   scheduler_scheduledclienttasklog scheduler_scheduledclienttasklog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.scheduler_scheduledclienttasklog
    ADD CONSTRAINT scheduler_scheduledclienttasklog_pkey PRIMARY KEY (key0);
 p   ALTER TABLE ONLY public.scheduler_scheduledclienttasklog DROP CONSTRAINT scheduler_scheduledclienttasklog_pkey;
       public            postgres    false    258            �           2606    154260 4   scheduler_scheduledtask scheduler_scheduledtask_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.scheduler_scheduledtask
    ADD CONSTRAINT scheduler_scheduledtask_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public.scheduler_scheduledtask DROP CONSTRAINT scheduler_scheduledtask_pkey;
       public            postgres    false    336            �           2606    154255 @   scheduler_scheduledtaskdetail scheduler_scheduledtaskdetail_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.scheduler_scheduledtaskdetail
    ADD CONSTRAINT scheduler_scheduledtaskdetail_pkey PRIMARY KEY (key0);
 j   ALTER TABLE ONLY public.scheduler_scheduledtaskdetail DROP CONSTRAINT scheduler_scheduledtaskdetail_pkey;
       public            postgres    false    335            �           2606    154066 :   scheduler_scheduledtasklog scheduler_scheduledtasklog_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.scheduler_scheduledtasklog
    ADD CONSTRAINT scheduler_scheduledtasklog_pkey PRIMARY KEY (key0);
 d   ALTER TABLE ONLY public.scheduler_scheduledtasklog DROP CONSTRAINT scheduler_scheduledtasklog_pkey;
       public            postgres    false    299            4           2606    153902 T   scheduler_scheduledtaskscheduledtasklog scheduler_scheduledtaskscheduledtasklog_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.scheduler_scheduledtaskscheduledtasklog
    ADD CONSTRAINT scheduler_scheduledtaskscheduledtasklog_pkey PRIMARY KEY (key0, key1);
 ~   ALTER TABLE ONLY public.scheduler_scheduledtaskscheduledtasklog DROP CONSTRAINT scheduler_scheduledtaskscheduledtasklog_pkey;
       public            postgres    false    268    268            �           2606    154122 >   scheduler_schedulerstarttype scheduler_schedulerstarttype_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.scheduler_schedulerstarttype
    ADD CONSTRAINT scheduler_schedulerstarttype_pkey PRIMARY KEY (key0);
 h   ALTER TABLE ONLY public.scheduler_schedulerstarttype DROP CONSTRAINT scheduler_schedulerstarttype_pkey;
       public            postgres    false    310                       2606    153839 4   security_customuserrole security_customuserrole_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.security_customuserrole
    ADD CONSTRAINT security_customuserrole_pkey PRIMARY KEY (key0, key1);
 ^   ALTER TABLE ONLY public.security_customuserrole DROP CONSTRAINT security_customuserrole_pkey;
       public            postgres    false    256    256            �           2606    154144 .   security_memorylimit security_memorylimit_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.security_memorylimit
    ADD CONSTRAINT security_memorylimit_pkey PRIMARY KEY (key0);
 X   ALTER TABLE ONLY public.security_memorylimit DROP CONSTRAINT security_memorylimit_pkey;
       public            postgres    false    314            �           2606    154225 $   security_policy security_policy_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.security_policy
    ADD CONSTRAINT security_policy_pkey PRIMARY KEY (key0);
 N   ALTER TABLE ONLY public.security_policy DROP CONSTRAINT security_policy_pkey;
       public            postgres    false    329            �           2606    153749 (   security_userrole security_userrole_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.security_userrole
    ADD CONSTRAINT security_userrole_pkey PRIMARY KEY (key0);
 R   ALTER TABLE ONLY public.security_userrole DROP CONSTRAINT security_userrole_pkey;
       public            postgres    false    239                       2606    153807 H   security_userroleactionorproperty security_userroleactionorproperty_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.security_userroleactionorproperty
    ADD CONSTRAINT security_userroleactionorproperty_pkey PRIMARY KEY (key0, key1);
 r   ALTER TABLE ONLY public.security_userroleactionorproperty DROP CONSTRAINT security_userroleactionorproperty_pkey;
       public            postgres    false    250    250                       2606    153818 H   security_userrolenavigatorelement security_userrolenavigatorelement_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.security_userrolenavigatorelement
    ADD CONSTRAINT security_userrolenavigatorelement_pkey PRIMARY KEY (key0, key1);
 r   ALTER TABLE ONLY public.security_userrolenavigatorelement DROP CONSTRAINT security_userrolenavigatorelement_pkey;
       public            postgres    false    252    252            i           2606    154019 4   security_userrolepolicy security_userrolepolicy_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.security_userrolepolicy
    ADD CONSTRAINT security_userrolepolicy_pkey PRIMARY KEY (key0, key1);
 ^   ALTER TABLE ONLY public.security_userrolepolicy DROP CONSTRAINT security_userrolepolicy_pkey;
       public            postgres    false    290    290            =           2606    153923 B   security_userrolepropertygroup security_userrolepropertygroup_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.security_userrolepropertygroup
    ADD CONSTRAINT security_userrolepropertygroup_pkey PRIMARY KEY (key0, key1);
 l   ALTER TABLE ONLY public.security_userrolepropertygroup DROP CONSTRAINT security_userrolepropertygroup_pkey;
       public            postgres    false    272    272                       2606    153855 0   security_useruserrole security_useruserrole_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.security_useruserrole
    ADD CONSTRAINT security_useruserrole_pkey PRIMARY KEY (key0, key1);
 Z   ALTER TABLE ONLY public.security_useruserrole DROP CONSTRAINT security_useruserrole_pkey;
       public            postgres    false    259    259            �           2606    154175 "   service_dbtype service_dbtype_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.service_dbtype
    ADD CONSTRAINT service_dbtype_pkey PRIMARY KEY (key0);
 L   ALTER TABLE ONLY public.service_dbtype DROP CONSTRAINT service_dbtype_pkey;
       public            postgres    false    320            1           2606    153897 $   service_setting service_setting_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.service_setting
    ADD CONSTRAINT service_setting_pkey PRIMARY KEY (key0);
 N   ALTER TABLE ONLY public.service_setting DROP CONSTRAINT service_setting_pkey;
       public            postgres    false    267            �           2606    154290 4   service_settinguserrole service_settinguserrole_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.service_settinguserrole
    ADD CONSTRAINT service_settinguserrole_pkey PRIMARY KEY (key0, key1);
 ^   ALTER TABLE ONLY public.service_settinguserrole DROP CONSTRAINT service_settinguserrole_pkey;
       public            postgres    false    342    342            �           2606    154275 ,   service_typeexecenv service_typeexecenv_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.service_typeexecenv
    ADD CONSTRAINT service_typeexecenv_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.service_typeexecenv DROP CONSTRAINT service_typeexecenv_pkey;
       public            postgres    false    339            �           2606    154101 6   system_customobjectclass system_customobjectclass_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.system_customobjectclass
    ADD CONSTRAINT system_customobjectclass_pkey PRIMARY KEY (key0);
 `   ALTER TABLE ONLY public.system_customobjectclass DROP CONSTRAINT system_customobjectclass_pkey;
       public            postgres    false    306            8           2606    153913    system_row system_row_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.system_row
    ADD CONSTRAINT system_row_pkey PRIMARY KEY (key0);
 D   ALTER TABLE ONLY public.system_row DROP CONSTRAINT system_row_pkey;
       public            postgres    false    270                       2606    153829     system_script system_script_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.system_script
    ADD CONSTRAINT system_script_pkey PRIMARY KEY (key0);
 J   ALTER TABLE ONLY public.system_script DROP CONSTRAINT system_script_pkey;
       public            postgres    false    254            �           2606    154230 ,   system_staticobject system_staticobject_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.system_staticobject
    ADD CONSTRAINT system_staticobject_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.system_staticobject DROP CONSTRAINT system_staticobject_pkey;
       public            postgres    false    330            �           2606    154071 4   systemevents_clienttype systemevents_clienttype_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.systemevents_clienttype
    ADD CONSTRAINT systemevents_clienttype_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public.systemevents_clienttype DROP CONSTRAINT systemevents_clienttype_pkey;
       public            postgres    false    300            s           2606    154041 4   systemevents_connection systemevents_connection_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.systemevents_connection
    ADD CONSTRAINT systemevents_connection_pkey PRIMARY KEY (key0);
 ^   ALTER TABLE ONLY public.systemevents_connection DROP CONSTRAINT systemevents_connection_pkey;
       public            postgres    false    294            �           2606    153701 <   systemevents_connectionform systemevents_connectionform_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.systemevents_connectionform
    ADD CONSTRAINT systemevents_connectionform_pkey PRIMARY KEY (key0, key1);
 f   ALTER TABLE ONLY public.systemevents_connectionform DROP CONSTRAINT systemevents_connectionform_pkey;
       public            postgres    false    230    230            �           2606    154164 T   systemevents_connectionnavigatorelement systemevents_connectionnavigatorelement_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.systemevents_connectionnavigatorelement
    ADD CONSTRAINT systemevents_connectionnavigatorelement_pkey PRIMARY KEY (key0, key1);
 ~   ALTER TABLE ONLY public.systemevents_connectionnavigatorelement DROP CONSTRAINT systemevents_connectionnavigatorelement_pkey;
       public            postgres    false    318    318            {           2606    154056 @   systemevents_connectionstatus systemevents_connectionstatus_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.systemevents_connectionstatus
    ADD CONSTRAINT systemevents_connectionstatus_pkey PRIMARY KEY (key0);
 j   ALTER TABLE ONLY public.systemevents_connectionstatus DROP CONSTRAINT systemevents_connectionstatus_pkey;
       public            postgres    false    297            l           2606    154025 2   systemevents_exception systemevents_exception_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.systemevents_exception
    ADD CONSTRAINT systemevents_exception_pkey PRIMARY KEY (key0);
 \   ALTER TABLE ONLY public.systemevents_exception DROP CONSTRAINT systemevents_exception_pkey;
       public            postgres    false    291            ?           2606    153929 ,   systemevents_launch systemevents_launch_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.systemevents_launch
    ADD CONSTRAINT systemevents_launch_pkey PRIMARY KEY (key0);
 V   ALTER TABLE ONLY public.systemevents_launch DROP CONSTRAINT systemevents_launch_pkey;
       public            postgres    false    273            �           2606    153754 2   systemevents_pingtable systemevents_pingtable_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.systemevents_pingtable
    ADD CONSTRAINT systemevents_pingtable_pkey PRIMARY KEY (key0, key1, key2);
 \   ALTER TABLE ONLY public.systemevents_pingtable DROP CONSTRAINT systemevents_pingtable_pkey;
       public            postgres    false    240    240    240            �           2606    154204 .   systemevents_session systemevents_session_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.systemevents_session
    ADD CONSTRAINT systemevents_session_pkey PRIMARY KEY (key0);
 X   ALTER TABLE ONLY public.systemevents_session DROP CONSTRAINT systemevents_session_pkey;
       public            postgres    false    325            �           2606    153712 <   systemevents_sessioncontact systemevents_sessioncontact_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.systemevents_sessioncontact
    ADD CONSTRAINT systemevents_sessioncontact_pkey PRIMARY KEY (key0, key1);
 f   ALTER TABLE ONLY public.systemevents_sessioncontact DROP CONSTRAINT systemevents_sessioncontact_pkey;
       public            postgres    false    232    232            F           2606    153944 :   systemevents_sessionobject systemevents_sessionobject_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.systemevents_sessionobject
    ADD CONSTRAINT systemevents_sessionobject_pkey PRIMARY KEY (key0, key1);
 d   ALTER TABLE ONLY public.systemevents_sessionobject DROP CONSTRAINT systemevents_sessionobject_pkey;
       public            postgres    false    276    276            �           2606    154194    time_dow time_dow_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.time_dow
    ADD CONSTRAINT time_dow_pkey PRIMARY KEY (key0);
 @   ALTER TABLE ONLY public.time_dow DROP CONSTRAINT time_dow_pkey;
       public            postgres    false    323            �           2606    154106    time_month time_month_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.time_month
    ADD CONSTRAINT time_month_pkey PRIMARY KEY (key0);
 D   ALTER TABLE ONLY public.time_month DROP CONSTRAINT time_month_pkey;
       public            postgres    false    307            -           2606    153887    utils_yesno utils_yesno_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.utils_yesno
    ADD CONSTRAINT utils_yesno_pkey PRIMARY KEY (key0);
 F   ALTER TABLE ONLY public.utils_yesno DROP CONSTRAINT utils_yesno_pkey;
       public            postgres    false    265            �           2606    154240     word_template word_template_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.word_template
    ADD CONSTRAINT word_template_pkey PRIMARY KEY (key0);
 J   ALTER TABLE ONLY public.word_template DROP CONSTRAINT word_template_pkey;
       public            postgres    false    332            �           2606    153772 *   word_templateentry word_templateentry_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.word_templateentry
    ADD CONSTRAINT word_templateentry_pkey PRIMARY KEY (key0);
 T   ALTER TABLE ONLY public.word_templateentry DROP CONSTRAINT word_templateentry_pkey;
       public            postgres    false    243            n           2606    154030    word_type word_type_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.word_type
    ADD CONSTRAINT word_type_pkey PRIMARY KEY (key0);
 B   ALTER TABLE ONLY public.word_type DROP CONSTRAINT word_type_pkey;
       public            postgres    false    292            �           1259    154353 "   chat_chat_message_idx_chat_message    INDEX     t   CREATE INDEX chat_chat_message_idx_chat_message ON public.chat_message USING btree (chat_chat_message NULLS FIRST);
 6   DROP INDEX public.chat_chat_message_idx_chat_message;
       public            postgres    false    233            K           1259    154356    chat_id_chat_key0_idx_chat_chat    INDEX     o   CREATE INDEX chat_id_chat_key0_idx_chat_chat ON public.chat_chat USING btree (chat_id_chat NULLS FIRST, key0);
 3   DROP INDEX public.chat_id_chat_key0_idx_chat_chat;
       public            postgres    false    278    278            S           1259    153972 ?   key1_idx__auto_authentication_customuser_time_datetimeintervalp    INDEX     �   CREATE INDEX key1_idx__auto_authentication_customuser_time_datetimeintervalp ON public._auto_authentication_customuser_time_datetimeintervalpickerrang USING btree (key1);
 S   DROP INDEX public.key1_idx__auto_authentication_customuser_time_datetimeintervalp;
       public            postgres    false    281            �           1259    154117 ?   key1_idx__auto_authentication_customuser_time_datetimepickerran    INDEX     �   CREATE INDEX key1_idx__auto_authentication_customuser_time_datetimepickerran ON public._auto_authentication_customuser_time_datetimepickerranges USING btree (key1);
 S   DROP INDEX public.key1_idx__auto_authentication_customuser_time_datetimepickerran;
       public            postgres    false    309            P           1259    153966    key1_idx_backup_backuptable    INDEX     Z   CREATE INDEX key1_idx_backup_backuptable ON public.backup_backuptable USING btree (key1);
 /   DROP INDEX public.key1_idx_backup_backuptable;
       public            postgres    false    280            �           1259    153691    key1_idx_chat_chatcustomuser    INDEX     \   CREATE INDEX key1_idx_chat_chatcustomuser ON public.chat_chatcustomuser USING btree (key1);
 0   DROP INDEX public.key1_idx_chat_chatcustomuser;
       public            postgres    false    228            q           1259    154036    key1_idx_chat_messagecustomuser    INDEX     b   CREATE INDEX key1_idx_chat_messagecustomuser ON public.chat_messagecustomuser USING btree (key1);
 3   DROP INDEX public.key1_idx_chat_messagecustomuser;
       public            postgres    false    293            �           1259    154128    key1_idx_geo_poipoi    INDEX     J   CREATE INDEX key1_idx_geo_poipoi ON public.geo_poipoi USING btree (key1);
 '   DROP INDEX public.key1_idx_geo_poipoi;
       public            postgres    false    311            �           1259    153762 (   key1_idx_i18n_multilanguagenamedlanguage    INDEX     t   CREATE INDEX key1_idx_i18n_multilanguagenamedlanguage ON public.i18n_multilanguagenamedlanguage USING btree (key1);
 <   DROP INDEX public.key1_idx_i18n_multilanguagenamedlanguage;
       public            postgres    false    241            �           1259    154139 ,   key1_idx_reflection_formgroupingpropertydraw    INDEX     |   CREATE INDEX key1_idx_reflection_formgroupingpropertydraw ON public.reflection_formgroupingpropertydraw USING btree (key1);
 @   DROP INDEX public.key1_idx_reflection_formgroupingpropertydraw;
       public            postgres    false    313            �           1259    154181 $   key1_idx_reflection_formpropertydraw    INDEX     l   CREATE INDEX key1_idx_reflection_formpropertydraw ON public.reflection_formpropertydraw USING btree (key1);
 8   DROP INDEX public.key1_idx_reflection_formpropertydraw;
       public            postgres    false    321            �           1259    153675 )   key1_idx_reflection_groupobjectcustomuser    INDEX     v   CREATE INDEX key1_idx_reflection_groupobjectcustomuser ON public.reflection_groupobjectcustomuser USING btree (key1);
 =   DROP INDEX public.key1_idx_reflection_groupobjectcustomuser;
       public            postgres    false    225            �           1259    153724 4   key1_idx_reflection_navigatorelementnavigatorelement    INDEX     �   CREATE INDEX key1_idx_reflection_navigatorelementnavigatorelement ON public.reflection_navigatorelementnavigatorelement USING btree (key1);
 H   DROP INDEX public.key1_idx_reflection_navigatorelementnavigatorelement;
       public            postgres    false    234            Y           1259    153989 *   key1_idx_reflection_propertydrawcustomuser    INDEX     x   CREATE INDEX key1_idx_reflection_propertydrawcustomuser ON public.reflection_propertydrawcustomuser USING btree (key1);
 >   DROP INDEX public.key1_idx_reflection_propertydrawcustomuser;
       public            postgres    false    284            V           1259    153983 .   key1_idx_reflection_propertygrouppropertygroup    INDEX     �   CREATE INDEX key1_idx_reflection_propertygrouppropertygroup ON public.reflection_propertygrouppropertygroup USING btree (key1);
 B   DROP INDEX public.key1_idx_reflection_propertygrouppropertygroup;
       public            postgres    false    283            �           1259    154215 #   key1_idx_scheduler_dowscheduledtask    INDEX     j   CREATE INDEX key1_idx_scheduler_dowscheduledtask ON public.scheduler_dowscheduledtask USING btree (key1);
 7   DROP INDEX public.key1_idx_scheduler_dowscheduledtask;
       public            postgres    false    327            2           1259    153903 0   key1_idx_scheduler_scheduledtaskscheduledtasklog    INDEX     �   CREATE INDEX key1_idx_scheduler_scheduledtaskscheduledtasklog ON public.scheduler_scheduledtaskscheduledtasklog USING btree (key1);
 D   DROP INDEX public.key1_idx_scheduler_scheduledtaskscheduledtasklog;
       public            postgres    false    268                       1259    153840     key1_idx_security_customuserrole    INDEX     d   CREATE INDEX key1_idx_security_customuserrole ON public.security_customuserrole USING btree (key1);
 4   DROP INDEX public.key1_idx_security_customuserrole;
       public            postgres    false    256                       1259    153808 *   key1_idx_security_userroleactionorproperty    INDEX     x   CREATE INDEX key1_idx_security_userroleactionorproperty ON public.security_userroleactionorproperty USING btree (key1);
 >   DROP INDEX public.key1_idx_security_userroleactionorproperty;
       public            postgres    false    250                       1259    153819 *   key1_idx_security_userrolenavigatorelement    INDEX     x   CREATE INDEX key1_idx_security_userrolenavigatorelement ON public.security_userrolenavigatorelement USING btree (key1);
 >   DROP INDEX public.key1_idx_security_userrolenavigatorelement;
       public            postgres    false    252            g           1259    154020     key1_idx_security_userrolepolicy    INDEX     d   CREATE INDEX key1_idx_security_userrolepolicy ON public.security_userrolepolicy USING btree (key1);
 4   DROP INDEX public.key1_idx_security_userrolepolicy;
       public            postgres    false    290            ;           1259    153924 '   key1_idx_security_userrolepropertygroup    INDEX     r   CREATE INDEX key1_idx_security_userrolepropertygroup ON public.security_userrolepropertygroup USING btree (key1);
 ;   DROP INDEX public.key1_idx_security_userrolepropertygroup;
       public            postgres    false    272                       1259    153856    key1_idx_security_useruserrole    INDEX     `   CREATE INDEX key1_idx_security_useruserrole ON public.security_useruserrole USING btree (key1);
 2   DROP INDEX public.key1_idx_security_useruserrole;
       public            postgres    false    259            �           1259    154291     key1_idx_service_settinguserrole    INDEX     d   CREATE INDEX key1_idx_service_settinguserrole ON public.service_settinguserrole USING btree (key1);
 4   DROP INDEX public.key1_idx_service_settinguserrole;
       public            postgres    false    342            �           1259    153702 $   key1_idx_systemevents_connectionform    INDEX     l   CREATE INDEX key1_idx_systemevents_connectionform ON public.systemevents_connectionform USING btree (key1);
 8   DROP INDEX public.key1_idx_systemevents_connectionform;
       public            postgres    false    230            �           1259    154165 0   key1_idx_systemevents_connectionnavigatorelement    INDEX     �   CREATE INDEX key1_idx_systemevents_connectionnavigatorelement ON public.systemevents_connectionnavigatorelement USING btree (key1);
 D   DROP INDEX public.key1_idx_systemevents_connectionnavigatorelement;
       public            postgres    false    318            �           1259    153713 $   key1_idx_systemevents_sessioncontact    INDEX     l   CREATE INDEX key1_idx_systemevents_sessioncontact ON public.systemevents_sessioncontact USING btree (key1);
 8   DROP INDEX public.key1_idx_systemevents_sessioncontact;
       public            postgres    false    232            D           1259    153945 #   key1_idx_systemevents_sessionobject    INDEX     j   CREATE INDEX key1_idx_systemevents_sessionobject ON public.systemevents_sessionobject USING btree (key1);
 7   DROP INDEX public.key1_idx_systemevents_sessionobject;
       public            postgres    false    276            �           1259    153755 $   key1_key2_idx_systemevents_pingtable    INDEX     m   CREATE INDEX key1_key2_idx_systemevents_pingtable ON public.systemevents_pingtable USING btree (key1, key2);
 8   DROP INDEX public.key1_key2_idx_systemevents_pingtable;
       public            postgres    false    240    240            �           1259    154187 '   key1_key2_key3_idx_profiler_profiledata    INDEX     t   CREATE INDEX key1_key2_key3_idx_profiler_profiledata ON public.profiler_profiledata USING btree (key1, key2, key3);
 ;   DROP INDEX public.key1_key2_key3_idx_profiler_profiledata;
       public            postgres    false    322    322    322            �           1259    153756    key2_idx_systemevents_pingtable    INDEX     b   CREATE INDEX key2_idx_systemevents_pingtable ON public.systemevents_pingtable USING btree (key2);
 3   DROP INDEX public.key2_idx_systemevents_pingtable;
       public            postgres    false    240            �           1259    154188 "   key2_key3_idx_profiler_profiledata    INDEX     i   CREATE INDEX key2_key3_idx_profiler_profiledata ON public.profiler_profiledata USING btree (key2, key3);
 6   DROP INDEX public.key2_key3_idx_profiler_profiledata;
       public            postgres    false    322    322            �           1259    154189    key3_idx_profiler_profiledata    INDEX     ^   CREATE INDEX key3_idx_profiler_profiledata ON public.profiler_profiledata USING btree (key3);
 1   DROP INDEX public.key3_idx_profiler_profiledata;
       public            postgres    false    322            d           1259    154357 -   profiler_id_user_key0_idx_authentication_user    INDEX     �   CREATE INDEX profiler_id_user_key0_idx_authentication_user ON public.authentication_user USING btree (profiler_id_user NULLS FIRST, key0);
 A   DROP INDEX public.profiler_id_user_key0_idx_authentication_user;
       public            postgres    false    288    288            !           1259    154355 8   reflection_form_propertydraw_idx_reflection_propertydraw    INDEX     �   CREATE INDEX reflection_form_propertydraw_idx_reflection_propertydraw ON public.reflection_propertydraw USING btree (reflection_form_propertydraw NULLS FIRST);
 L   DROP INDEX public.reflection_form_propertydraw_idx_reflection_propertydraw;
       public            postgres    false    261            (           1259    217986 1   scanner_id_scanner_key0_idx__auto_scanner_scanner    INDEX     �   CREATE INDEX scanner_id_scanner_key0_idx__auto_scanner_scanner ON public._auto_scanner_scanner USING btree (scanner_id_scanner NULLS FIRST, key0);
 E   DROP INDEX public.scanner_id_scanner_key0_idx__auto_scanner_scanner;
       public            postgres    false    263    263            )           1259    210787 0   scanner_status_scanner_idx__auto_scanner_scanner    INDEX     �   CREATE INDEX scanner_status_scanner_idx__auto_scanner_scanner ON public._auto_scanner_scanner USING btree (scanner_status_scanner NULLS FIRST);
 D   DROP INDEX public.scanner_status_scanner_idx__auto_scanner_scanner;
       public            postgres    false    263            �           1259    154352 ?   schedule_schedule_scheduledetail_idx__auto_schedule_scheduledet    INDEX     �   CREATE INDEX schedule_schedule_scheduledetail_idx__auto_schedule_scheduledet ON public._auto_schedule_scheduledetail USING btree (schedule_schedule_scheduledetail NULLS FIRST);
 S   DROP INDEX public.schedule_schedule_scheduledetail_idx__auto_schedule_scheduledet;
       public            postgres    false    227            ~           1259    154361 ?   scheduler_scheduledtask_scheduledtasklog_idx_scheduler_schedule    INDEX     �   CREATE INDEX scheduler_scheduledtask_scheduledtasklog_idx_scheduler_schedule ON public.scheduler_scheduledtasklog USING btree (scheduler_scheduledtask_scheduledtasklog NULLS FIRST);
 S   DROP INDEX public.scheduler_scheduledtask_scheduledtasklog_idx_scheduler_schedule;
       public            postgres    false    299                       1259    154354 ?   scheduler_scheduledtasklog_scheduledclienttasklog_idx_scheduler    INDEX     �   CREATE INDEX scheduler_scheduledtasklog_scheduledclienttasklog_idx_scheduler ON public.scheduler_scheduledclienttasklog USING btree (scheduler_scheduledtasklog_scheduledclienttasklog NULLS FIRST);
 S   DROP INDEX public.scheduler_scheduledtasklog_scheduledclienttasklog_idx_scheduler;
       public            postgres    false    258            �           1259    154362 1   system__class_reflection_form_idx_reflection_form    INDEX     �   CREATE INDEX system__class_reflection_form_idx_reflection_form ON public.reflection_form USING btree (system__class_reflection_form NULLS FIRST);
 E   DROP INDEX public.system__class_reflection_form_idx_reflection_form;
       public            postgres    false    301            �           1259    154364 ?   system__class_reflection_navigatorelement_idx_reflection_naviga    INDEX     �   CREATE INDEX system__class_reflection_navigatorelement_idx_reflection_naviga ON public.reflection_navigatorelement USING btree (system__class_reflection_navigatorelement NULLS FIRST);
 S   DROP INDEX public.system__class_reflection_navigatorelement_idx_reflection_naviga;
       public            postgres    false    328            j           1259    154358 ?   system__class_systemevents_exception_idx_systemevents_exception    INDEX     �   CREATE INDEX system__class_systemevents_exception_idx_systemevents_exception ON public.systemevents_exception USING btree (system__class_systemevents_exception NULLS FIRST);
 S   DROP INDEX public.system__class_systemevents_exception_idx_systemevents_exception;
       public            postgres    false    291            �           1259    154365 >   system_staticcaption_staticobject_key0_idx_system_staticobject    INDEX     �   CREATE INDEX system_staticcaption_staticobject_key0_idx_system_staticobject ON public.system_staticobject USING btree (system_staticcaption_staticobject NULLS FIRST, key0);
 R   DROP INDEX public.system_staticcaption_staticobject_key0_idx_system_staticobject;
       public            postgres    false    330    330            �           1259    154363 8   systemevents_connection_session_idx_systemevents_session    INDEX     �   CREATE INDEX systemevents_connection_session_idx_systemevents_session ON public.systemevents_session USING btree (systemevents_connection_session NULLS FIRST);
 L   DROP INDEX public.systemevents_connection_session_idx_systemevents_session;
       public            postgres    false    325            t           1259    154359 ?   systemevents_connectionstatus_connection_idx_systemevents_conne    INDEX     �   CREATE INDEX systemevents_connectionstatus_connection_idx_systemevents_conne ON public.systemevents_connection USING btree (systemevents_connectionstatus_connection NULLS FIRST);
 S   DROP INDEX public.systemevents_connectionstatus_connection_idx_systemevents_conne;
       public            postgres    false    294            u           1259    154360 ?   systemevents_user_connection_systemevents_connectionstatus_conn    INDEX     �   CREATE INDEX systemevents_user_connection_systemevents_connectionstatus_conn ON public.systemevents_connection USING btree (systemevents_user_connection NULLS FIRST, systemevents_connectionstatus_connection NULLS FIRST);
 S   DROP INDEX public.systemevents_user_connection_systemevents_connectionstatus_conn;
       public            postgres    false    294    294            �   �   x�3���Î<�rs��T��s��dt%FFƺ��Ff
��V�fVƦz�ffff8ME�54�&jd�[�1P�!p����>�A���P`�������JdAm�jX<'?91'#����T�9���]ms΀b�,g������<ς���0��P?OC�pw�bWܦA�qz=(�.*%��ř��!����(�))z��z�@ ~C�=... �oz�      �   ?   x�=̱  ��� ؅��@���wߍ�Fx�Ғ�%�j�4X��%M)J���]Np;7~      �   :   x�=̱	  E��#�'����s�_w�I��Z�M%��h?���$4Q�@��t3�\#�      �   ?  x��R�n� <��D�:�+R�[�S�"Eج�UlN�~}1$nR�Rn��ff�/nYMT���[	q8xI����	��or�_
O;�l��7��ˑ*˒z�ݑ��#;Á��jf,U��:�-s}�6o�xX��w�A{uEA;���Sj#7yr�ӽ'�$�o�p%�_�Z�Q���f�B�2�Ŋ�~�ݱJ�P�Fpm�i�i��s��lU�s������9Q�TA�N�3}�b��\���f:x�Z�P͵�`��1ϒ�蛰�Q ^#1��W�5��@��w�߂T�a�L����}�3��HD��e�7�(�      �      x�347�44�24��P� *F��� 8��      �      x�342���4�242��b���� ;f:      �      x������ � �      �      x�34��47�24�S� *F��� 9�       �      x�320�45�220�P��D��qqq V��      �      x�324ⴰ�224�P&�D��qqq Z      �      x�340�43�24� Q1z\\\ �      �   4   x�%̹  ��+a���B�u y���|�4�o8�p�`�0�%X���%}� �      �      x������ � �      �   �   x���Mn�0���)| �2��.&�Tu�O�e7,�@�H�+��Q�dYu�.�y�ߛY�z�R!nQ;�0L��i����=�v2O����t�_.Vo��=3mAW7<p�S���	1�G��,�TuM��>(��i�k&H�2+
�2U�FYU3C�"%���ܼX�dM�*���v�0��M_��j2�&�SV?�8�����/�}���i���j�`���_Rd�������{��^x      �   �  x����J�@�ϛ�����~${Qă
��K)-�CZj��qP�ҳ_��Zm}��9��ö*"�M�dg����H��.A����y;��F�٨�Z9�d��k�j��e�� �Sqr(��P��Ơ�!
p�� ���$�L*�����4���9���=��m#v�A�#�"1ijm�ػ8k��/
�jV���1X�x%+(�����(zE(8�SP��1�w~�h�_�4��̯$��*��K�O���s4
hTt˘��1��_j�A�fB�;+�+���FOV�miX�lf��R
� �C�RR�Y���_t�Di���N�ڦ1�E��俬����*�̟�
��O��TB�rfP�k�e5����m�_Q ��̍S*X?><
�o��tv��d+��c_�      �      x�3455�4455�p�%����� n�      �      x�341�45�241Q1z\\\ 2�      �      x������ � �      {      x������ � �      �      x�341�43�241�P� *F��� 8E�      �      x������ � �      �   }  x��T�n�@}6_�@)��]�O��T�)y0��o$mUUBJ��R���<WV
������zvL��v���eǞs�̙F4<��hA+��ħ�4�/h��4���ۧ��%����ȧ1�hΡ�;y�责����Ӂw�4Z	)�T��7��?���-<a��0Bx�o�9��~�e�cZ"v�H f��Atx��0�6b< 	%�1�2<<	�k$X�H��������1������Df�S��)�p���I�=��n�yh#�Ҩ^������H������	ǝ�'r�#[�0#d��T�T���8FB���@@�s ��|��kZ�����i��C��1a����=#س^h����"�S�t�ҽ�5x��h��fv�cPhq���=p��� ��Ba]E�8� ���L�����s|�ۚ:�]�0%���A�x�~M��2���Z]�]�j9�6Ɗ�ٙԙ�Kl�����.,[����T{E{4qI8e{ΞA���:��rsP�0:ێ��*	D��$�\�g�	(�m�-�����_�2�?�UjQ�!͈'t�GC���[����Oa��̉ǆ �'X��̐�+x1-��@bl�bw�1�a
!�a������T���T���Z����`�      �   !   x�34��45�24�S&�B��=... �      �      x������ � �      �       x�3�4�4�2���P� ��� D��qqq ]R-      �   -   x�34��43�244�P��BC(e
�� �9�� Q1z\\\ ��C      �   -   x�3�0�41�2�0�PF�B�@(Se��!���Q1z\\\ ���      }      x�343ഴ�243Q1z\\\ P�      �   )   x�322�,�5421�46�245��442�3 BC�H� }�)      �      x������ � �      �      x�326�L��ϫ��/-��"#�T�_�n�]^h�Q�_^����V^�Z��Qa�X�e���R�j��.##K�Ĕ��<|r,�L���-��42D����ͥ��RR�|}�*� ��=... �RU�      �   5   x�322����4�Ppdl��ņ���,!Z-	�EAF\FƆ`�"r��qqq �-&�      �      x������ � �      �      x������ � �      �   %   x�356�,�,.I����0�bㅭ�F\1z\\\ ��	c      |      x������ � �      �      x������ � �      �      x������ � �      w      x�3����� Z �      �      x������ � �      �      x������ � �      �      x������ � �      �      x�340�0�240Q1z\\\ ��            x�347�46�247�Pf *F��� 8?�      x      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      v      x��}Y��:��w�`j��${.�s܍��_"�$���qs]��nƱE����������a�y���y���.�v��ͬ����6�Y��k]�/˲ٿ��-�6�f���O���y�?�{��g��_����w&�?if�V,2�k��m�1 o�Vl�g�V��{[��_w�sʶ�����|���[j���y�߽l)���o�������j�hn+���z�~v��	H�s2��Ϸ�mX����^'�-��_�e�1X@���7��6�����S�_��~�t=30>#H1�>����,����e���r+<e����u��d}����V�N�����s4fܟ�l�����iIx7{=�$���k��ż��̘��&����#k�����qrm��<�������\m��>W�ao��Ka��6ܡ�v���}̈́e������to�>�{�����<�����0���e��1��6�{77���3?󍱭���7��}�f�6˚m��L�-V��ˆ�e��	s˼�э�c_e̬�|�ַ�����dܠ�/졝���ٵ����{Ķ�[u�X>k����_�>�����b����)�V�y�^���	c3� 	_��[h���b�-)����c��}�<͸��9>��~�UO�XMѦ�����^�έ�'��v�bu4����$�f i	�G������q��j/ag�.c��ړ�R�����5����O����8�N�<��ع^m���!�^Z:|����[�v'�+�۟��gb��{��HN!;�vׄQ���.9���v�1�I�ž뒳�����z�o�Y3��S�:�{}'rv=��nvwkh���̝�mX�����-u�{�.g��y��>m�I	��J۠�4Jc��%�q��`�>�zQ[��hH����LQS;�6v���{͠XM��
&�=II�''�L�3����B{�J�x�V/��8����k�}�*�x�����p/�ݜ��wǛ.ͭ���i�ȱz��ͱ��T��=r�'�n}���֟�2������]�'�i����l���7˜��Qr7;��F⮮���a$�w�8�J+֟m[p�3�V��_Ý3��^Gm]��V��p����Ҽ��8r7��.�w�=Ğ���m�ބ�n��מΝ�����'�v��~�����a�eB{�\dZ���Z�&�8X�&���a떋'��a�f<ӏ�|���b���@M���R���n~��޵���O���U��(�ix�V���1���U���~�j����1ؠo�607�]w�q�+jF{��h����5��,g/���z1������ƓH�3��;���������mӤ�ڈ�%k�߶���.k�qo���`��Y��8MA��vF�����S���{U��I����
���!ka���[}�p���|�A�����`�B�X��#c�_3���6mۜ�V�O.s�붿�'���`Ot�:�F����cR�>;F��&lu���Xo��=Ė	e�ݼ�د]�O���w�(wD;��F�J�-��I�ݱا�Q7`����3�)h��۳�7�<��ږp-k{��n��֠+�#�(��%��{��cQ~]��d�u�&��p`vfo�?7�/�
`Ǳ�[mv}����w��ܹ���ܙ/
���η�َ�b�j���=$�}s�n���ߤ�t�����5�����>�{<p�3h���ϣi-��+�4�EY��f�X�Z��~Fӝʅ3�uP�G�oU*΀I�}#����������~k���v�$���lG����6w��O��d^��-����}c���~��}���zq��D���Q��\S?>��8���X�ϋ�|\M=X�mP�5�;�t`w눚��
w���o�{��K�u�H-�AϿIw�F��E�lϥ�vJ�t��%X} nIǤ�w/�8+���}h�����3��Z��Ro����������x�V�>��?W�?/�!AO7A�hm��3iI��;5�$������Z�������)��ymY9���  }£*�z��5o����VnN�a�d�e�^Zn<YY{G��]�[�(��[���x:��"����d�o�ח��J���0;�x!P��6w���~۴>�[BW=(T�W�}�ҮM�,"���)g�Apv�h��Q��=vIò��X�4d�����P&���7�g�m�5�1�х� <	��b�FgG��D{���f�΀?�$�ǋ���Q�x3ە��|w��QY��,�䭲&��Pmhe�9;�?G{���_�|�F+XSU��Bd8}�j��yjo@�7��h:^��>�5��i:߂Ź��gP�U,=sNݻp�^=T����w��U���ז�1�\Ͻ��e��3�;|����`��%�7Hx����]l#č���<��)M�u.�������>���~���2?������5�1��Df��ߨ�%R�K.9�fRK���I�<9$O�9/�s~����1���^�k.��k`���,q���!�pX�7Y{��c!��8:���]��zr�L_I4EX�n�r�<��Epn`�E��.�XE3ܚ�z�%N���Zg��ߋ����k�'�����Q���7�n�Vx�:X���XD���`W��h������~��'~�DݯE��;�A(�R0�.:d!��f|[�Y�U�r+�؀c����0{�ЖΒ��N�8�<2ƍ�"ü\0�ß�K���3��-"�*��1�)�;��;�h_#��xٺ�,C�e<����o���;��߱�ۍ�8�z�?Ծ�؞��W4�-A�ݺ�>���z�1>�)#��(�f��a�x2^2k���x���6��Ю�w���>�'m��>��pF|���	3b����=��}è/��T��7;i�U��g���G_��9f��e����Q|K�'����w�-<W?��7�W/gz�I�l�;��F0��N�sm4��x��h�fݝ��S�X���e����}�љ�Βo��o�	o|k��mo�(~^��w�_=�2��JoB$"ӡS�+��6[��*���}�u*צ�V �q��w�y`���p��U���ɨwZ�WXQ�e���^?�;j��s/�����O��ڲ#/�'Z5шN���Ѷ��Y�5]z��N6��W�)
��kܾ����I�e<���ݭr��L�"mFadX�ѱ{K��x����ݥE����q�KZ�d������`�z/�}�v�wh��5��p����=�7zt�p[�7�ŷG߫!�zA����]��~R�S�鴠���զ[-�췹��-v��*�b���.��в��t�J�r����tw�z���>�-�$�I�.셊�oWǶy��f�V[{�ɍî�x�Z�v��֬�AG/�2on(�x����$h�{��ezd��h��
#��rd��U�.p���V�@�A�~}'f��[����r��f~��VWOqWN���÷ox>�R)�M����}$��0�w̥LC�̬�{�w0�;B��>��`w�粷'̓���Eʋ37�����<KCk�`��؊���c��rw�9Lpl�����ؽ4����,��3��-t�4v�p�� `6�f����B�����!����'�6���C���YS�
�>�?�:��ig����~j֏��-ښ�̝�i�K�����j+��@�t��;6nU��[�'�G�V���9A�9
����e�R�u�*�# Vn�m��>9�+�i��4G,���wv��c�͘d�x�I������E�X?��z@������?��áfg����r�B�[�Q�~\�w��_H+S�r��8�H+�����e�ڊvjk�݂��,�D�[#a�Y=��V73�����9g���o2�}:Bٍ쎈�6�Y��uܒ�빢�9N{���U�Hs�"�|+(b�`f���-����z;��:��mO����^�\g�3����s�E��X,��9�x�gJ�����%.�!
��=�z�
��j�ο2�^��]-�I�]^��@D^���z�K"���J0/a�����&�۶�b��ͩh��u��8Y?!�@h�8{�]�y�R]t�����y��������[��t��|��9Qv9Qv=Qv;Q�v��    Rv`���̋M}rj~r.����9��g��������ѯD����t��|��9Y~Qˇ�8gh1"��K��+������|�t��y�L(���l
�_&���2��޵���mvo�[p\����{���!6��¸;�L�-D�}u�h�x�R��"G�g����k��r�����KK�?������\�L��6
��`������z4ό.�\�b(�-�E��jۜn��g�o����q����������ʱ�H�3u�<�9d�R�Yp]�]
V������Ͼա�N�=�N��F[Jj5�Al� n��G�Hb�`���۲g�����X7�)�x��?V��EdNV~hb	�q�0�~��Cl��mt��ڱ2#�0�k{ό;��7k��{�fT�Zj����Lþ6������/������dc [v��\���[Z�׏�~�IP�D�#Ѐfh�B�-V<�k��'����|��U�����WK�S�YM��UC�O�J�������+�R�:�����W���M�O.�&z���k��2�!>�sT��d�X�:��+{`ċy�K�Į�q�n��Я&�<�C���5���E�uܨ��9+S{�O�-�*w�5�1�#�v�<�4���>��.9��� 1��hQN������g�R|��m�c�d�H����1��TAn�_�W�>w�1�oL���g��k�~owCJ<g�6;�����e���sXa�pZ,�ra�
�:h�v��F@�����k� ~^��>�Q�v�!�Xc�$ї�y�&��!z����I����xp~$S�E�;��p1b?��]\����x�v;�U������Oؙ7�ţR�{ȴ�iO�+��ÿ�.-���tb+����i�>z�W k��N$�}���)E�h�-ȼ�]*l�<�ޟ�y��V�QK�����7����"��E����s/NQ��,�*iC�����<�p�����E�M��z�<N�JH8Vj��jG~yhu"������d2�Rc+��X:��yI��_��Fړy?�ń��8�Y���=��jo.�i]�X2e>�������Z����9$�4^�rb����:g���'�]�6�#.Ԙ�3ٓ�]s]q}m�>$}���!��Έ5��]]�U�r+p��q%#s�m-G��V/�wR�yְ(�e��u"�P���9k�Uj�ϔZ�t��4goO?�md�[���ƷVik@h6����x�P�4���)�ʰ�	���9�W�t�%U�XK��6�^�e���hEy-l/u�ҡ~�g��"��D�r�cǍ�V���V�Z���������ش
��e�Ad#�EY�:ڍVj����*����0���~�?��r=��L����O�&��*��1B�(U`Y��,fɷb��;���w��|VDBXE*�Qǵ��A�.���&�l�7J|��D��;�=�ݷnT�m��L�J�.�jQ�wǑ������l�'�UmNpu-�s�m&#O-?���n���EA���Y0������>���۱�,��L-�(��+��VE2�}�Ѷyg*��2�b��F�ᝅ}[��yK��VX���=
5���X�*��tZ�:n�q�Mvmφ�4c�����t�ΆC{ 7mGf	w��W��F�6��kŸ(m߳�gV�o��0�/�g^⸠]���Q���\�����rT��!��C7������I]fe�NN����eR|幕����q�C�8=�5�R�����q�ј�9�-��>T7V�Ei%����vwDX5և���g���׼�~��o�{\p;��Z2�Nr��f�皊�8�r�����I��}�
7�T���M<�*�'�.����g(�w���cN��f�ެ���+�5~�{���\�	��Dٓ�,��Zx��qK�R����U���T�����F@m]�[��A.*C��|���	�im��=��ض�o�&�Kr[8��!xr�w��Ƣg6)Kv{e�-t��r���;�΄�%�%�6u�eeno4�y�gi�ab,�Ev�G��A�������h6��qho�դ�tc��9���o���>�L�o����b���s�~^F�)���^�Oְ��^R^ǉU�z�Z�������m�q���o|唳�">��|�|��֊Q$m\�����0!�_�\Z"�}F��H�ָ���GB�t)�swX���9>?�Q�c�۽�3�h8����Z����q�Cib�ޢ�<�<R�>���ēyf�b��*�9vn��p�-���'+#V !`=���I�`#>�$L�@>G�%�)@�4*m�����������
���;����snd�i=
P�G����z4[|5'�?H�e��"����w�F�|�1���k��7͈��� �#��=�>?�88^�m�8�w��r�W�O�D��wd���w��ۍ����|�-�H�ކ�_��tիc�,��(3�G꟢o5�Ю�ESi�	���S"�goz$\s����:�W1�a��~r�/-���f�Kv�Jm����g�['���z�� KT��� ǘR�GXpX����w�_.r� �ؙ��ያ��Ĭ�^���7���u��3����������K[u��=O�n�C��b--B�ڛT���ݐ�"y�	��ģ|���<Y1h-��@�^�)j4��A�0�m�,���/��I���T:�Y��_\�C?����|�Ȱ��\��oW<�}��¡X��v�*S���f��q���2S�k�&�E?%hK��������ݭ?��Gm)�<Ӕ����d�Yr�����)�~�͓�����y�V�"���ԭ�F}�:����`Dge�ޕ�V�j��:���m��18ݒG{��D0��`��Any�[���G���]O��vOF:�y���pl�����F�|�{vV����Z�1��7}r�1��ӳ�Ȳ��ֵ��ֺ5A��xʹUz���c��@�r�����Q?�60�
Uǵ϶�MZ��X/�kn�e6�%u��SQ����˸,�)�{�<��dN���ˌ��{{4̨���
�/�J0م�ިbƶ��c�fQ��OtŏO��_�e?��Z$x�˥�M|D�E�7S��+wѰ οe<+X̀��Z��z}6�r�͠ȺP��O����(s���ں��9�#�R�Eݲ������7`���jOP�T�g�N��g7��{�?^��V"j�ji���Hqui.?|��ؿ{���a6� 8:߱�1�e�����"a��F35�㙬��,�n���z�x0�i���΂��
p���LW@3���CO��T#�$�$0�|���vA����Ɉ������#�%ߡ����/�V����Dk��Id�܃���ĭ��R\NUv���w��E�>u���+��}I�W��ub�b�<�1���͆ٸ;�=�|�E��M=�i6�㋃�\J%r[ο�@��7�*���\���a03������/]���|�a�Y�1R�/kH�83��3�w`|��|����V��y��.(�����ײ�+�l�����+���2_�}�=_qa��c��T�KH{�2ۜ�﯀�+�|��\�/K��R��+�����֥�U�X9�P�8舣��TG�Qo��yא~��P|*�5��"s���UMd孕�m�}�H&\�̲��.uM����;	^yF]�I��V�V��6{*3����V�d��v=Yݒh&�˞b��T�Anp���Im�y�䳶��2+���]�M�I����n�=�$�mb�ͣz8I>X���-�d
y�uV����a�n�fZ�z�tg������مm@�Xh~����׬��Y�~�eZ�օC��>ߧ��)�F:�,�6�h)��xr{W89�;m� �::D�ر9��v.��l�}����u��O��[Ԁmt_a����)|�24�Y5�l������i�����{�9�f�e��Yba> �!�2��=��Ls$���>!$��_��R/��wO�y�t�s��~��=�T̽fc�]�(��eEnc;s1Q�Z��r�IRǜ��a�|c-mS�-�W<��FZzYۉh�z�����6�,#r);    �c�A@�����L�L�h-����tM�#(�����_�{�1��"5of�\�s1E�ǈ��=ee�`]#?$۷�HT�j�5.��c��K���mGe�hOee�W"=��5C�ّ���K ?����/U��ͭ�B�JK�<���VJ����1=gr��i�^����0��%U.}����l2w/���;F�Xs�Q}0�������Rg�Ǚ&Yb�̧�9&X��~*5۫F�v{��o��{5+��^]�L��1� I�� P���c���O�����L���
���MDn� �����\�Ge>v3�6��f�����F���&K�f	�>?7�[K���4��@Ϗ������~��d���H�b|K���oޓ:��Jt7n,F�c�qC����ƨNy�#��,N�%��~J|(w�,"��<�h�?�c`#�H�-�1��f|����u�-������o75��s��[���AF��K�%�o:��>�l�ۡ+u�9��B��DYV��ѕqWi�3�����wW�����lz[(�E�k����#���w���"�������籈 Nΐ�L�Mo�j�1FͲ�qc�Ԟ��˯���ߣ�vT{�Ғ�L/�rdoJ WI-�'Y�W��@�$�֚j3�	u�{��{��J@t[rȳ�fOqw�!��-L)<ے��p[�H�J-i�2�&���|�}�>�s=ɐkϟ�/�i_����|q6��O��o�Ɤ:�m�g�o:��i[N�/��]��;q�U�q�p�XA2÷dM�ƛZ����ȌqZK�A{4[O��Ǹ�N����r�7SOU�^α:�{jV�}�D�9�!.���=���ײ���Ɏ$�HFW�#]1�e~�:���I�IK���9��y��4����g��eX	�ݸ�ւD��;7�;-��F�����ڵ�ma�?|�iˋ� �E�)�{jMf[��-26N�F��Hy'��x�EI���Y\�� �l��+���n�7�<Gp��t2n ��2�V��r��u��y��Ed%���ɽ����ٲ�C!������y�{
#��R��f�_�kcw8+:�^����
{\qR2?Uf22i��<�*��"V��1k�K*�fKOl\Q%�LN�]��یM��Ve����D�k��^{Q�߃��}��܋c�Ж�QX�sYn��w��L�^Wk��S�8A7K�w*�RgPc �ϼe���mR
�ǲ��O� o���Vf�(vcM.
��>^����a 1��|3�UH֕�x� �[�A﹖S���P�%c�=�����vM龰<�Y9b8l�F�h�92'>=�9b}�|z�=�s��e}���;��
&��:��Y�_�h�=2ɨ��;#r-%���R\�S��WF�ǯ|�ԑ%�pc+�t�)� O"?�%f�f�dΉ��SRi��I,Z��<�z���m��-v^����-�{��?��s)z�pk�6}<�r1�֜�W��*{F�m|��Sz��%�=:���3��+s�n�T����7�h+�ޟD��5�(��{��	hx������>�2L�RZ�VK�R�
�0y�I6e�V��L�G@QZ�ռ�d���W�<3�J�r6�ˌe(��i|S;$W��"V��p+*�|ggp�7��=S�>�)�ޥ�Y�c��� ��_���60� {e=�o|ϊD�0��t�ƻ�]U�Y�c�����Hݚ��s#��\낾�����u�r�JN��|~PaD�{��y,���˹�{��V��ٌ�R}aa>@~�53��nR��No��vy'�l�c��ȥ����w��dx�OJ<�WW�t�7�}[�����ѫ�<'�`���kl�.p�Z>��o+gqކm	ZQ�
�m�7��@�N8����f\�y��Z�����׵薌Q�r�6��(%��e��n3����G��d�6I1C�9��<��R�bihZ5^C=j�~�x����~���φ�jE�[�+U���"w,k)�*���9-�SL���p.Kfo��|_�z��׼�7-;��f�ډ���b���h�ͳ�`�h����X�ѣKr�~g��YT�ϸ���'{����7ܾ�o�}��so;`��[�.Z-*-m���|����{�Ų��K-&6�C-VlV��x*��W�8�"7M�y�"�q�9�O��鈎�tp~���1z.��;�{i�~i�|�=A��3��'�?�ϹOl1�4�����؂ �Z>�֘���\�Iq�j���ll|Q粊����U��F���G3�P�p𤔳RS,�*!)��kV�_ӛ�U�'�89�弍혥�֎��z����Z��e��g��"����F��@�cEoS�^�T+����������^���70�;��������;Κ���׹���Ww�l�A{���?��{R�u���?�{�-�ǿcn.�Y����Ȅg�UصN�;#��;v�s�'�f�!��G���6*_d���՛�d1��ˏrr�=g�/�73;�p�f�����`n|'�٬U����Ѷ�M�pMv���mطӲ���*�$-�5KY��~R���")���ld7��v�Io�5z�l
��Εw~6�,��H_
~��e�ؽl�Y����ݵ��9��P)�xg�����q�H_��|r��S?���:�ܣ���g� ���ڦy�=T]�4wzey\������r�����\�gߏ��m�ծK��t�B�7�#�������K"��K��iվ!���i����3ݨ{�2|�X)�������W�y��X�j�J����1�)[v�"��|��{u�,�kaRV�Mv��%�|mf)�@\�8���;�h�1�������̂z]�ז��4�|��Y�9�����	���{{ytV�{i�@��B�;��'�P��b5mK��\նtb^v�H���9����q�y��EU&j��A���
�d�5���i���'Y�C�U���t���.m�u�I��Y�϶�~���2/F��x��𥵕��%.Ե�Ut�/���^��|�W2Fͳ�8/�F+��S�����f��3;1�Jh[Z#;��\S=\�z�Z���Z[�A�\/���;-)��GB��%g�t%@�zk�3|[!:�q�����_�٘��2�I6dh�PF�&�';~�������c%�g6a���R��_���B)ƾ?D>KkM�8��}�Y	�&��b/��U������w�9�E3ճ��d\���Z���h���v6Z�*�;8oђ��؎*�oo�O�^PT�L��]�;r<�r	�-��*Nv����v��!����W�Nǲ���̝oz��yKf{ß���V@|)e���"�y~?��Ro��YA������_�|>."yN��ד�����-%y6B4OV�kc������W�	���J9q�x����-9����5;z����a����V�p+��Ƚ��Vv��q�dT�_��Z|�J�K��ЅL�l�|/g�����!�?��"���ϴeT��>��j���𝢾C�S׌�E�������ϰ��HR�_>"]+��,�����*R�ȭu�9��W׷�1	K>:3�z\��#��%l�G�"�]�- ~4�ٜƶME݁���� �-όJb�l�0���'�L�x:W���d2����
ad�>q���븈9�|lך�{��oQ.��I��EOV;��HVnb71�ܕ^m��_��-��M�S����{����o{l��6ݛcFY���bݹb;j�����0��K�ܦdl����Y7vgV=��5�Q��]N����G >UZ��);r�C���}W�(��s�X�ۍ��m�q��v�q�7\�w�)�mv���&�T�e���<��O��'�M� l>�@�Q�������`��U|��0�'2W�Ut�Pј6�P��y4����?.G�wc�o��y�\��Kp>���W��̔З7"�5��S;s@��['��zN��Z��+�^�Hк$����p�Y΃���P�rj�J�O��2�1�G�;����DVvQl?��g���U�ۼ;�o֧z����|p[��5��ɼ��%^Ei�^��ؕ�e	S�3}�JL���+���*�;�������Co�|�
^(���
��<}'Æ��5��l7�W-�>_`c[���w�$�>z�_������V߲}MvN��uO��    	-�]#R��ygpKc�%Lf�e�S�5<�m�����Œ|��,SȆ��-J]*��,-;�d���:��/ۨt�ܳ{"jh_=f_?��+vL�$s4�4�wR�X�Q��+��� J�G_<]����dct�WB���Kqc����
��Ӿ�:[{�&O1��9Eb ���t\~��cm�ۭ�%���5I�h��r��]�k]��>>�]
���9�ɻ��ш�S���OZ��S��LNV�퍩���L�iD�E��N��jIw���{[c�:ގ�b��-{��,]!k��1�V�:�8�����h_���P�q)QBW�%����]y��M���c�,��Z
{�X��d܊��h��d�1W�ZԨ�a�̬ k��9+��k�=������GӞ�L��V+Vr�x�p��Fr�1���9�\?pr7�K
��s�V�/��g��b&|����|�e�拵��愬��ȴ㑬��Q�~��ǒ��ЁL6��fƁubK�����}h~w���qj%�=�Z��kF�O<7�0��_�<T�����팍�%��)E�._*��5ju'�}y:���(t�����[����6k���L9R������l���3�O^t�I���ksY+�Q��Le�&R�5<F.W�v��T��>O��)+qE.���.B@F��0��_�x�H�� �&���^i��u�/Mk��z�����������Zb��R<Im9�	���s�3�#^�l���i�w���X�co
�A`�^ܡ�Ӓ�m�8�.��~��̉�r����vd��gb����y]P�߄/ifrf=Q�V~,Ԕmi�/�l��ޮ��g"�y�&�͵,0b���%-7ؼw���1���pA<����ؚS	��4f��8��ű�k���{���\��=-ݥ���]�iG%h����,ɌWy_�'�.n�k힜Dt��R��4�[�ҏ6%a_����v���3���^��U��fA)z�RÕ}L"��]�7~�k��%����d\c%�Q�lh�v+����+���EM�ǹ����?�E�P�4�>C��i�Ў�O�_b4倷進z�̌����l�~��3z�VG_��`�f<E����r�6���Ѥ����+p�� ]�?����Η�{�q��N�|-5\����Yر�ܕ]� ��?�8��]߀�y�;��ӆ��M+M��k���Js���e��mW��g�C��j��fs9�M����مI�˲C�d�;�;�1��W�}/%�{����:k�� ğ����H4{�gv<)1j����������}k�e[P��3�*�� �מ^�7�^�|1�NR�9�	����e�C�s�y_b���l�+�>z9���C2[F���2߻2�y-�z�G�m�:�$���q *Z�T��Bh�9�R���Lڗ�\�=�b7��0g�;���Kju�lt��p+�V�[���(���e[���<y0�~��Y���?ͪ�al\�}=aw��v�����e�O�?Գ�JX�¿^������cm
�~F��h����2�Bd��#��]��A��:������ԛre1���ޒwlj�4�ˊe6�>+��ǽ����I����7�0�q~%��~­϶}S�np�z;����Z˕vnm��ƿ��L!m����_hX��2�P�"���-��p���Ώ��gY �bRK�y�D���[V�R<~�W��7���o����]�3�@�y��i�&U�k��n#��L�bQ��Dw������~ʲ�/�-K���,�gMr5�Q����tD3�r^Ǌ倢W,�Mg^�`I��q�UL[�}/��G��I��jb.��U�6�
A���'�+w��K�ߏV@J�3pG$�1�9b�f���4*m%����mm<YM�7����B�F��{6hTӘ ��Mg��d���?	��J�a�g�VE�+��y-�U{%<k�WyR�FW���1'>�fDR�$9�.s��.bܝoL��-����P�%.���D�(�LW�;
����S�Q�o��5}�����{�p�M5F�k���Dl�Z�CL�u���l|%���	��!�YY�OY�
�&�%��)YLK���vɟșQ���0�*��Z����es�ٕ��i牡�K�g�|�Z~��q|f���=�������g�>X�~2KSY�-@����~C���,�7+X�:��`���d�%��Zb�֚??܂��Y����+��ϣ}3�5�:���j�x-Q+=�ܱ�"�`�󋸌9Z�,Y�$�#�W�b@Kc~1�T'��*?���\U�e43��1�V��^���=f�y��T=ů���`sR��d��x�c�)�!a ��.�~�.7�����ض�_�8�����y�J���ׅ������T��gА4Ͻ�J���?��b}P���Ez�+��Xd�ޜF�8=�ls�V����m��p��&�����2��N�\1�#�5W䇔�4Ƚ�{mV#cf���0�"���~#��[D�D/�/���eQ�����a?=c�>����nX��:��o�v�ώ���&���/�X�>�N-RZ(��ߝ}W��ke����2�?k��0{�^��$�e�Yb!�β���alEi�:á=��s	���rlU�����z���a�.�V���3g�om��jد��Rm{wr�����ѯ؊8,ȉq�;lFK���;��wF�u:����~�}�����.�>�l�)}��Z���Pן��f�|��&0���	1p�)�W�G���q����ҷ��Z��_�~'d��φ�����gJ$~�7���s�S�N��b��M$0������F,��~x>���<��}O���k1�@S�o�=7�:8V�ZY�#��٭�ܮi�1�V����3(�۹�v�yT}6S�=;�t�ѽ	ۄ��<�t�I:��\�a��lKԢc����^
�Vt��37e9�K��"�G�����pnT��U��K�Y�#Z��be>f�ә���^�g��������R����V�:�HK\;��*��H�J�En����J<c��J�jWj�}g�q��Tx?b�=�*r��BA�@ I�5�J��~�b��oZ����O���|�:���p#s��
s����7u3R�]?�/E�M{~� �`\@�}�]�pT1=l,�ֱ���T�`u_ ��5*���� ��٢����w��%��Z��>��-�[=g|�K�����lf��o�u�8]=����;,� �_��
l[=|R��Z_��+��Qk�����έ��w@����^Y��p�|'8��k8+��϶���n���Ս7� Ę��CW��r����Ս�U2KV��2>W�`�v����iH��o���Q�>�������t��nI���}_b�ob^W��~��q�H{�,eTnk�_ �R��u���O�h���F�j�><�ud�߈o��N<	�'�O��У�R�y^�7t!5:�]�1���!�]�jS���hh�h�����U��_�X�u�����p��������m���ʻ��sk�s�1�1�g߂s�k	���_�YgEv@�De��`*r���Jv��}v��%���&
6d�gWJ2>U5�!�N!3��Π�t9��Wf�WJ�ìtS��-��c����,z��V��İ����{��b�R����̓�G�ѿrN��_��7o����.0v�"w��������FV۳W԰���9��VKd��Ұ����1�/��a�;��:cx�<�B)3AҘV'���fn�/�f��������P-�;�1��0;m%�cE~�;ؼ�L�����=���#8h]��L������Rи3�p�-Ӳ�J�M�e(њu���5�P����qY_����XwB$���e�j�E�p\7���ge�4V+���egRS��uID%��Z�p����C�Ѻ��)9M�J3q�'|7�!�VfV*��Ѣ��,׃���=�A���os~�/~�����Ɩr7#�ތ:Z��d�K0㲴�&���͖RƍϽ���g彘B\�.�~���"�Yj������4ˏ����ir�����}������$;�7|�5'A�'�_hQ(	,uw�,��    i8�*�@��Ȁ�e�2U�ȓ���I\�st����*�>F����*F�U:e_uB������7b��K*���@.���������Ԅ�l�i�h)M�X>�"G��/ܫq1bs�]>&���2~����%ߕo+�d�����{7c��rO2obS�d�ؑ`Y��%�R���%^�6a��fh�Ԫ���R�=���2?�Aߏ��uJ''�Õs�W�͙y��)U�B�#�p�o,u?�T�o�W������u���1�T���y�K>�1�%i%<��9Ws�Qϡ���t>�O��'g<�A�pܹ�O�Wc��Z���ϋ������Y,#��~�4�-����!
,yj��1�r����(�f%�9"�ك�*"Cfǽ�(�H�Ŕ���׫�����cԠ�k죫ˣ���\�>���eK�d� ;f%�x#?�~��@��/��]̕^?������Daޡ}��[��V��y&�v�K�.Mْ<�q?�Yd��5�?��?�$�?�d��>=@'�/&�-�lS��YI�r|�ٓ��X�%Єv�?�p.-���c��R�u��9*�`na�"����7s�樐���(�VF���m#LLU�.K���i�e�^J��7��%7M��P�yRg%s��}o����C�����ag�֮��1�ymU��t����N�G��$��%��|�-x��������s��z���j���+At7��[wG��AJ!�YW�u^�
�6��KT�	��ݔ�*��"��>��2���E����-�Do�j�]t��l|�Y�ʤ��PZ%�U�L��, ��}�UR+�̒��¬�6���VWw��Cw�"?�Z÷}��a%p�8l��0�1<M-�3�~��Rd��� ��Q�ruk�_���cȨ����9D(rL�<x���ȥ�Y��l�LTVO?����c}�??������L$���Oy$r�)�%��F��8C����e�ΐK�\8���F������?�qՂ�l�m�8����e�2�f�+k���jrJ1�J�Z�[�4B>Txc&&܏�զ�s|Us�^�?>�����[�nD5���hŖ�J�(zc�kx��o�Kϊ=[��>a���%tu��E�/�vB+y�Us?��J\��q.b�WȘb���eQ7�[�&����$g�=�/|zAݿ�;��y^�W��-�ɳ�2Z7��������L�(Fʬh�;�gV#erɂ��y�Oc�gņ�3��v=�R��0��)��8�.�!?A�����*$h%a>X߹Yc�������"{�(Q+�^xb\ձl�'蜃���M:k�|�OI�:��1	�}��S*C��(���8�C� ��~h=L��/�x���FF��?ʺ`eϢ��D0I���i����үf5��&��]�����\>��Z.�3�xY��6y�2�||J�V�-76"�F|[���'�W�S�;��A<�aWnR-���뉑V�;�W�<�ҿͣ��%�g���sl=u.���_�/o4��]]n/YM���u��@"����侷��7{��7��ļ���SDf|���oj�y�Q��4���3�寮�mQ�幯Ǜ���i���6sȝ�O�Ǿ'�Dw�G����i���OQ���7���R�~�ӵG9N-j�"�I{ԣ���x���q\���ăh%V6�(�Q+�"co����gHw`Ҫ��}�X���i�B��㑎�,I�!����d������%�WM*r^	�AC7���fs�<���a}�1��^뼐3��!{��~��C$����WRCK����Ϥ�b#�_@�+�E�{��%�;�]�l��Y��f3iЖ�m�Α c�+�R�Ƶ��{���7�{w��c��g7/�ÕE]�����՝���x��1��5��#�=��;�m@l��z���ae�W��u8|�'F����T����(���^�+w;%ގm����Z�>VɊӜ4�Q3��[ܬ�x]YH�g-�p�i�y�y��%��:���p�z)N�k�Ez���drc��{cM�1G�����������bM9��v����|�8�U��;"ܹ�_d ɣ��n>�?���}�[Ǽ~F"�6�[�u�e��$4����$-�]c�Y~����/"	��a�q�l��^�pZ~�֑KR�-�i[��-%P�4sV2h�jtk�m|
�Y����B��	�{D��%��C~��$f-Ĉ��i���3~V=C�z�e-��sf�l�-�Q�јI��ϑ̻c�D�g(�d�U���A;�r����=����[��M��%c'A�k�2ҟ"��v�b�P���,�J�I����n�)7qp��9���#���ߵSNn�ԚJq�y���F0��桒O�����n���]�x�4�[;/����h׆F��$���#�~��]G��a���Q����r�d���w�v������ø�嘵�ɏNd�)t�JI��H�, #�<�:k�I���U��E������A�I�v�x࿩�ɜ�js��=����/�-���������~Ac7�X=�Fa,s�$�q挩��-���	�fn	�_U�5A`�/a�2R��e���yi�s� �W�0M�M�&����Ȫ���!/yEL��Hw�I� wʢXZ䚾����=<ڬ	�>�j	�ĥ�t.:0��?��X(�����ky	J�*��]�`�v�i�M���4r���Qf�u3l\!�]���������g�4��,021_Bʩ4��U)�e1 ,�q=����6�h)L�$��2�0������E�褍Yt��aWr�ˬ5->�# � 42��/���ɣ�G�r����S�	��5����Ŕ�"M5\���'�6���&bY���D�bP�1-G�aF=�g5��;���dh������|"��ݹED~���b��G,��'��VZ1'��x3�X|*�櫼
�"�Hi�%�<[Z@���j������%؞~9�vI�N�GQ�z��9"��l��F��ޱY�﹦�v��|�;!�Y_��� �2jW%F��{ל��Ici�'ފyu����d'λw~�5ȿ�NǏy����ql��#Z�:~!�ۧ�m]�3�d�K13j�dNk���2�]�,��bX��m��je�"܉���.9����2�Ek���6�1,�Q{�w[3SW�#Ǝ畽G[|�~�ZH
���#H���@�h8���>�������h4�v� 9���+4o�n��	aʞ�L�$�"���e{����VԞS��1�L��/昙�ĿL�*��{�n>��t�)�+��U�����8k	Dn���b�zm�wn��8�Z�';c�㖩ZM�;���M��
d-�em�����C���ɉ���zE�ט�QD�^ِU����F��50k8"��_��Vø�����sʤ_�1\Z������r�1�]|^��,��PBM{�"���=��o�����.�r���^��Z)��U�J<�Z��`ҽ��������w����=�I����l�3}�-���t3���Es_-���}h��⮜?��/S�Y���1f�X��#�έ��g��n�_�q��6���0�g6����x2^�M�g.��㦼%7_������p��3vF=TC=��N�r�H��_=�-2�h�~L��%��}�>݋�]��� �T�5�8_˷3~	<^��e�x��\�V�]q%��y�=���'��5Z��2�7o�VN1&��(�(M�Y�;���(%S�G%��|:���wS���=����R.��1MJ�����d��m��Se���e���U��56	����׏��>�f�]����D�ϻ(j5�p+@�+W��~��3ޚQ����?&���D�q���2�9��N�wF��_���j�22g��e����h<y�x�����3�оN���C��	�/�����fav��%)α��/�.����9v�'�w�4�������O��9�{���Y˭�s<�M�����7<$�(no�["�n�}U��Ha��6�`�t���f]�k�2�<��C�N�]����� �'怔g!��������἞���p�i\ܹ�o    �	����s1^�^��@�ט����6��2�%�9��d��Eɣ|.Z�"~������2[[ߙ�w��)�*�Xf�.�ϳ���6��5+���J�?0c�����w�E����Q���U������P�6�y�N6��	1VX��w�����@�s�OQ��b��Mk������2����N����g]n���gZ��g�g�~.��H���cĕ����ȸ�h�fr.Q��5Fl��I���1�;B�:J[dW�>1M-�]-���+Z�����y[�j���O<���<i�,)j�Y鷺�Y"��$�+��_�2� ��c]���f�e��_Y�"�qNm�	�V=�q�~�-F�?I��H���C��zH2̸�}%U���칉W0�C��m�{��o{Ώd�w5V�������9����\ח��r/��/Y�3L�ʋۈ���W��o���.�=���;�~C�;F�8s��tϑ�����_����:�O��ʾ�.���)�×aY ��n��SJ1�K�\��^��噢o9���Z��c��H�-�Z��,JMw�C�%N�1������I��F���8	nu�Tfݡ��00-k/]����V+��߇h�{ y����]�%���F��V/Ň��g�7�����NF罞��%j,��p`����*���ߜn��q%��k����6x �Q�+2�P��avM��R߯��3 n���#�U�R���0m� �X����u��~̥���+ƃǕ�z���(�����i@/^;*���N��;F�Yc���	��?2L��h}vu��¯ Ǫh�����þ>�����dnt\���8<+d�%�����G����²�M��5�Y�S��𮽾��\9������mH�~׃ j�y�惙��f:�P[�l�v�5Y}·��Ŭf���Eɣ-ʲ�FT��y?�̢>r(��C��@��ܡSfsl�w��,蜭���r��M�h��\�_���%���]�B$���[�<X��k��|&ؒ�?��������'-�p�tN2��n��$����Ċ|#S�Җw@�nC���]�w"�5�_٪�>��$��|j��ð)Y�_��U"�:�CR��qF��v������(��oF8]�.�X�Z|l�� �܋�jY4)a��&չD��uR�wDH�Ѥ���-	׮�O�n�#�����#��w�)���&P���B�K�~Cӫ�:��dgQ���ݤS[�B��pD���>�L?�^�A���rZ�,�,��ەx��oӼJ�S��J�w���F�2
�\f�q��lv=���J��^����$�ch�H��E�/��� K�7=E����R
���R��:WQ�Z�������P�,0�qK�Z~)��:���:F��3"ы�z���_�t�"��#S[ݣs��:.֔uKP���h�ڝ�^��zM�U�*�}�����Wcm:��`��Ș f�ʧ�rU�tƃ�[��vr�Z�*NE�Y��[� ��j��e;B�~��|��o·摇�{��R$z(C���ƭ���%w�b�w��f!����jt�{k��o~S&�xG'�y�\|�)���xc�K��/͂�>��``��{g~�B��.ͮ7ߛ���T�2k߱��Ϲ}|n�4��B����w%D%y��0���@&/)&G���ټT���a< ��8?w��f����!��)+p��=I�Ƭg�b&�O���=��������$E_�!��k�~�3�/�M�%�"�������	A�T�?!�Z��A$�YM��r���:�;���c�rm�T[Ĉ�!S���}�/�#���>se��r��D7�ׄ���f�z��=}5]��R����[ɾّs��`���O;�#���^�Q�����_f/_I��y_wfO��$?��ϋ�rax�'@�}�m���ka(}M�^?�KJ4��c(ܯ�_����0�>�Wd~��W.<÷�r,l�d�v3"eS2���b$��@Y�%�{��G}�;h�cr�Xn�͸se�{-����5�>��i��1Y.c�nE����ȗ�d�;�.go 7W1S��V�zP%?Dw��ib�iTN�]���R9_�,m^����y���f9?�c�1�����ld��}���AcEo�3����0�h�hVk�)l�l��}h����k-���Aa�ik[����i]�75o`J	^jE��H��.�;#j��=���h�?j�����������V����jX��7�'�h�惘�l��37�V4>����V�޽maG��sm��=�|�ez��[~�?*��Ւ��yw�(L}G�En�&��_A8L�mn��	~�Iә��
gQ���5|R��7伌%��2��9�F�$��߲֎�N���e��۠1;]��_A��%�1cdb���ۀ�܂7DwBQ���t"G-Z
p�k��{4�kD��e���!�tK����'+�cU�<V�Ɣ�)��ި���A��Z��1����X��?�qgX��[�E}e_�
�����u��#���n�|�N/��ǲ�x�Ջ(ۃ�^�E��L��A�@g�c��6zQ�Sٟuˉ���b���I%�bw�I=�e<�*d��-eV)���-��7<�05����0�w��ge ���x�\X����%��-����k�װ[[����_����&bO��ૻm.�A5G�#��Ȓ.�[+�;a�C�,���"n�3���=I���&�!�ο&3�"���)�x%��`�m��7G��%�aX2-�yUd�-}\��cU�v��K����G��,�y�gݨĠ�}<��TC�71W�����<���+��0��u���r��Пk�5�uQ�6�}��!ϩ��fSsy�ä�!�!��<���J0��e��{�QXDw.��̨Z��݁���s��L�ǻ�q{{w�"��S�u���n(��Vp�vCe;{J3�27{���8����m���Ls���cf�\��%6��^q0�`.��=5]x�7:��e��� �k�k�j	�W���^7�8<��˹ƛ"�b�;Z#�D,�%���ނ=.t�I���a'��{0�-Viv��O��=?s9���q](e������<^B-_>����Н���+��$1w �-�iT%1���$��_�7V˾`�;�^�Kb_[븜%F�������a�I$��s��ƽ��!fU���7�3i����ԗ�eN"����'n��m��Ґ�{��ݭ���=9�xל�R^3��5{����]R^3N����mmZ���0Ҍ[Į�F������i�zy�$�B)��Q�p�f���i٫b��t+nb�*���v�?����M��@+�p~6e�N��c���1_��{;�]hm�/x��"�J@{9�,�{��qq\���Fv�"CC�ǺkXf!�٫��U�!i�?��b��>a�ľ
�!3�N��g��<�76���B�=�e�ͅΎ��zzy_ȁ>>Y���L��v4��l���G{L��:��e��Txw���|��e_����Ө��O�n�hsQs|�4-)�I���G����xm��#g�7��������ǂ�ć�����3`Y��f۱4y۲gP�gd}�g��1�x�$�0�y=�����fD��w�_��k�,�RL4_���X���R�����s^fL`r���뻳���dF�>��մ�Ԗ��s��8�s���n�֎ΦdK�.Ȗn��F�o��Ks�K�
�=GF�iV�G�>�%�ܫ��_�퍎����w�-�1��m\1G[G�6�gvL�^S��(�H��W�K�Z�2==��-S��:6�W{�Bj{c�d�(������y��}$��0*�Nbr���Qj�S�yA���>�
J_<�ĸ%�LJ_?)�O�1�=�YEww;��͞�&>�OCM�i�~�����_�Q�S���.�X��D��ˢCum'�j�.Ѐ�!õ�ws�Vg��ň�g�wt;��e�e�#a���V��;�as)�S��󮮿C� 禴Wʂ>>/`�g�y�Rּ��%^�
��-;���Ż��^�pU��ޢ�@a�0;Ϗ��؏�T��I���5�����7ncB��k�?��5��]�?�H�#�,ѫ�|
�_�5c�z�Z�zw�N:��cd���=\�:�p    ��<j?g;+c�w�)����tG����At��0:J��<-�M��"3���I5�߿���&�E8BT���{���H�o��7P2�w��"mg���{F�O4罤e>U������xM�lvmA����ZD��4����)y��][ċ]u��K���;�䜾��H�ut؛Yaz��[����Ԑ{0	��	�?jczp�/�aX��bDr�i�r�!Ϸa�[j��e�˞e֑���~E�����J��s���xrkm"9N�ߖ�}h9RM�'_h%�3�.E��X��u)�ɳ�'�>b����������'�#G�n!��~43ИIN25��/���f������A���F�,��ڋ�D�����qoi/�X�o��"ɵ8�!�3I���{炞�I����1����9�G�D67�Ά��U�*C�4��(v~���Q�:��Ls6�>�h¤;��)L�8S�����r���&2$9ǂ�k���'���d�U���S0�Ӄne�O��30eg[�U�Ҵdx��׼C	��{��k	��~�CZ3h��,3/��Od�	^�)Yww���Q�n�HVY*�kJ��-���`�7�ٲ퐽?�����3N�����u巢�sE�˵̃zބ���o�e��e1����yd��c�&�9r/�el��e8ϔ�	������Wأ�W���,}�8�+��%�m��/@o�`��5M���9Cy����j�}~�/S���|ߏ��g�����i}g�m��c�����������[��r>)�=]�?��q�������|��qm��QE����/�H���}�,�U���j8�<�h�2D�Y�Cd����+��B���V��{{npk�ģ�z�T��W/�K�Ɵhڐ�	�ߟ
7��V���L8��#,<�ԯK)3�cVr���R�NxWVV�5�N��g�������q��[|�en���ʆ9����i�M�[�-8�&��*��+A�FtK�^k]_�`~�+�� ��
�4����:���+�3h���X���q�:�u���L�#�Dp�u�o��LD�Ͻl����0�"���R�h���'�QR�sÜ۲��9S��+�>�F~��F�T"�Ε+_&������1w*�B66ʓ�yЙ��Y��
�á6|َf�f+Ia3˿��?��ڙDi)w2�~ģ-���<S�9+*�ã��E�6�J7�,v�LaJ2we��>�������w��e����E-KCI���V�CKk�	�bޓ��ǝ�v��,�C����"7vf-<�^�鲖f������@/��V��g�ʭ��5�9��3l���^vE?  *��[rg��u�5�K�?�/4�0hX��O�o��}�#��r6DN�3�d���k��-<��-j�4�r�n%݂����0�j+s����X�7���	N,��+�%a�i��(��-8�v��I���lik�}�
���Mz�7C[+p�+W;3u[߮��գn���D�bi�k���oҵ���$'!}����Т��}9���M�Lg;}�`b#e�"��f��xY�����g���	��)� [th77���Nc�I����� �+�3���gM�!��6���o�eϙ9o7�t��1Gڶ�8f�N�8�q�Y� ��9�'��E�|T�G�dʩ�V�0�����C�iN��-A��Šu�;��eZk�@഑#�/�ΒӌԬ��0eܞ;�{nV�<�t��v�-�#�[4�g�8ғ��/�OUku+�����E;i>��O�M��"k�"?�ȿ<��q��>��f��<�2Uj~$=S�qo��7⸓��⽆�i.�k��4��bn�9�5���>4��ѷ�ck�*�>#��?f�;��az󿴾��:�b��kj��٭�Eg*���2�o��l�h���_���c�tKyrzg�����u;�1[�;�z��v{��;��W#^C�vі��^���͜3Y]�{���<�YG�]�N�֊��R�ZAⶼ�7k�!M'c�\87oF՞��"�w����:�"�Њ�Q���nu~�����F��q5�|T�+0V�\�b�Z�g�!������4f���Tgvi�P��.����k�eP�@ky�������6xZ�����W�������/ {�Wp>��]<�I�n��}��vb��4�0�wjo;e�������G�����ҫcr��?��y����Ǜ$�<��zoQ��<��_ 2��;}"ܞnY�`����Ϛ�^�'����!��?��ȱvQ�7Ů���t>_N���-55��i���α6�g�}���~f�<2��37�-�˙p.�O.M�eɟe�||�)f\���(�*>�	��� {]�5eߌe�sv���e�g��7!��� ޵.k^ �e_��n���d�~�fz�zIe��:+G�N�53o�vnf����c +Z]s��Yՙ^)]�n�W�𦖎ܾ�'�1[N���vCv�Zv�`���MT���	���Ş���D��	�Y>�Y��eex�*�W*�iɼ-xژ��c�k��S�d[(�٨/B��d�5kDX.\F$��7h�+Z<֧��2�{@g����D��Za���㪎%�Z��X��ɘ�kgmf8�#Ё|&嘾���{�$������q(=ͬt\ ��������<���OEK1��M���g��0���r�1����}IQ��>����1�o������y�9ƶ�ɭ ��Ѻ�Z�i�,3�DV��Wٽ%JFV�~ʖbΠ)�+rlX���ɘ�޻�,����y|��ZM�[l��o!�+S��c���ş16�f-�,ˬ�a�"F���ʭJ�5%��[��q�b�Z�����e٠6�����=�~��E�L����8�d��x�T�h9���Z��Z���i��G�8�?��|>9�K��1�Z2�?p�`�IT=�#�#�!�p%Q"S��ױ�52�I�p��x����n������,��{�"���:��������s����B���=��9���z�
5���?������}7�㿙� ���n�����M2�W*�G������Ŀ{ƿ{Fߞa���G�CW�R$�����վ�����]��!zq�gjHv��b�oF6Ί�^��I�V%k(�*���8b^�ofI�����.p1L��^�[,��>['��&����6�w�q��j-c)Rj�Ks:��e�ڣ4ʷ*O��UK�m����NN⿓�9�u��Ŭ&w�}Ō~�q��g5?k��Se%{u�ߋ���)sb��v(f���C�r�W��#\�/,~l�`��J3'��Τ���l@�c�LP�"Z#7�9s;�xϷ��8��r�V���Bkm-V�VY�Y����7���7��������ߌ1A��:�R6��Q6:�Ӫ%�zg��$������'~�~�5��S�%~]ZR���g��4p�r�#�c�XL87�Y��ܳ���k}n�R6V�<��Z�3�!GL��>�F��-�����p��b�o��WaX1a��h�G��V�	�9fϱ��	��d|/�Tr�l�����w=1.m+w��;��3fXOư'sj:�{��`-�;:(���6{�n}�ע��E�Ϣ8nil����������tbVO��S���c4k9��,XB֫��ڪ$2�.[��#ٿ_dVd�����AV�}��3�ɻ�������vĂ\�ۯ�����V�I�Mu�"��y8I~���'9c+l�t66�#�_��R���F��丆��T�fh�a`�PFf�d�����ʚ`e�,�F��{�"�.��	54�˄�La�-�=;p�f�h'g����a�{���1��'��Eb�T<ό��2t�(�[��$�X�t�����֓�����C�h��jL-5�o��Q_��'���b�I�cf0��{�Ӆ曪5��5ޫ%�hT"��XAb�3�H��6�m�)ܨ��|����"��dq�Bo%15>1_���uA!�_춘���f��A�P�CA��2��Қ�s�X,���	�:g��6d��kxV����-3�Zf�,3�[b�.���,��3N�h�|��#�i�kC^��Sf����S{]���*H���B9��X ´#�i;j�]j����a��{-P�Աq���,Y㋨cf�a]s n   cuL�C̝�O�E)���_llm�����^x��[|�nj�v��M��-G���:����,�"�t��,S�Ҕ����ޛ�y8[$[i�[N�P��2c��������жk�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      u      x�3�4�2�4265����� ^1      �      x������ � �      z      x������ � �      �      x������ � �      �   %   x�32�0��N�t�0��89-8�8-�b���� �K�      �      x������ � �      �   4   x�324�0��/컰	��*\�ra녝/6v\��in����� Sv3      �      x������ � �      �      x������ � �      �   �   x�u�K
�0�ur�^�0I�ĸ�]��R*��`����W��u3����p�>�Q|��qd/yZ�Ek�E�(�"��[�=��D)"@H�x����e�0$9��]�Q��r�r�ѥ��ƹ!`n�]i|ܸ��T� 0�yn���}����KT��C��i����X������B��V�%S�4���	��� �Ch�      �      x�347���w�����46����� >��      �      x������ � �      �      x������ � �      �      x����w���447����� &��      �      x������ � �      �      x������ � �      y      x������ � �      �      x������ � �      �      x������ � �      �   N  x����j� ���IZ(�LH2�,��J�e�\$1H�`tJ߽Q��	e,����~�,OQ9O��>^��H����8Rn�R!�����e�໕�/t�T��-�h-A��Zpiե�$��,��"l[\�d�*��mCM@/��-N�M��N�����:�;玵Z0*��o>h~��މ�Ō6R�(A)��E�7D��gX��m�3����eRӞ6�Q�Un���t����#
@3����aP�@���@FْZH��n��x��q��@��lT!�C��؀G2�JG��$�Z����ǵ��y�r����D�����p;�����E�/ƶ�y      �      x������ � �      �      x������ � �      �      x�320�4��220Q1z\\\ ��      �      x������ � �      �      x������ � �      �      x��]ks㶒�<�1[	�>��3�wm���$���JEK��;��������hP�T���^J$�~�>�q�}�e�i�)�Z��j_��~٨Jm�ß?��-�_�q&�Yo�^E�K�O"Nħ�G׫�z}q�y�Z��Cߌ��]�E����������Xo�Z��X�����]�k��<�¿qZ�K6U��w���eYY���=ϙ�º�iwE�6���������0�˳O�M�[��N��'��Z�.����`A�x��>�T[�M�]��T_��п��/7E_6��S��j�/?��/&p@@��橬�����������?jӓ�~�o[�岾+�W�e��x|,����:��Z_��CV�m�8��ѧ{�T�7�'�i�;�U����L|J�D��+�Y��4����+�u�Q�W�Jd��*��C񬾵��-���b�@2�i=!O�Jx��~�]����Eu�vM���۬/������\~~��pu�u����o���gS������6����(
?%�Em��M����~��>ݏK�%ْ ��J��_�͏�~������آ��u(Zխ� =p�X���֙/�m�4�����jshK�DE_ܩvW�(j�J�ྩ���^��G��K�H�~�6m�����'�K��ar|�Z��w�ߺ׏�����͚t�g>n/�y��o����y��V������Bm�qelÞ��¥����}U�������.A���Y�@�@���7���AD3)|�k�#D�*a!P��g"�!<������U��Zk�7F>��Ė�4�aW_��l����L���p�/|)���ύyI�(�~mДT
]g��.�U�o)�8���x������BN"� 1�saۀ����W��F��)�g����0u��a����]���Fu��.��e�^T���%�,����#͂����I����? ��_����t	W�ڝW���֦þj���o`Y�؇(�r&����F�?` �Xb*[�%[=Jӯm��h���J�T���mK�JE����~�Z��m�r��8�t]o�&�܃����Uq�7/���ٖ�Ꞵi9��0�h4y�V~�Z�,I��ڂ]��w��6#�6�{i��2���j��M�\)�����J��98k�Z
my-p�����}��U�H�)�rt$��k��
��R;��1T���쾁���T�s�<Kr����:p��!Ҽ(���m<34i��aG�&x=ȸ��P�p�ڈ�-������`��8u7`�ܠ!V���!O�o�n]��H��F{�]�<����U�es� �Y���h�s�/:�r�6/��5������(�=�(��%���B���S��ȉ���y��(���|�ǢSƷ�Tߗ5U� #�p\��a��]`rG������k��@R�+��R^j�3c�m���j�(C` qA4>��}�����N��O�c޷U����rx��8�������x�]ٚ��8��Q���
�O�jߴ�m�?4��U����~�,d�C�DVT�E����<���oԨ�h�c1s>���τ����@ֶmv�Ʀ�-�,6�-b6]؜U��� ovŅia���+���3���b}6�ЄaN�1�zc�Y�G䩵X�]�h��_@�o?<���*E$�i��^9'�$�g1ewS�/�*�l.%c�g)ve��zߨ��̃��!T']5���[�x�R{֟�� �0H�u&�ߢ�u��\'b�Y�3nP�^~Ʒ�)��r1z!1��f�#|�jP�\;��w߯莊��b&y�0��gĄ�E�y){e�4ϣ�q�+ hc���,46sL׵�iO	'q`��!�����m��
��ˆ6�^,�ӹM���r�]m�.����qo�G64��O������F9�p1�c�6�0��>�GQ�p��e�����	]�Ctsnذ��-�ֿ�ޖ��xAh��4��B���}����Jd���Q�
�w*��d���s���<�^��mZ�jm�=����6����[�-O�G�K�n�YZ�z�y���yl6���ԣɿ��AP@CF"�X�p[v�V4ڡ��-����R��T]��wm�	�(mP�/���+k�E *����O@��q�_ &0�}3�$�lIX��.i��0�	�d6�k��;�b�Ƨ����DRHi��]m�֯\X�g4[����%�-�&�]����l�)�ڨ�U��t=�/!FVAJg�/8�0�+F}� �s*�k�еRc��}�
�.W3����;���-X���LmJ ���bg'�l��G����"�����0�mM��4K�ޚ����tT�T��)���b�z�~�!~8�2��*g!���._ޮOO�[�Iu��[H]΂������ó���������%:�j�P��c��. \$��S9�11����|��`"�� �:��yQF�]zXL���63�Ё������D�N����$?��B�A��X��˶�X�]s �x�� �^g� ������		�|N 8Z�Ð ��F�6��d�Cլ��%�y�{\t�I�B�̌��E�"��4�2�7x�L1$"`Y��b�p�XV1�_X��l)�����+�3�?��<izy�W(Z�7��������)����h��"d�q:�)vVA-�]n]�����xt+�<z,뻢�Q 0�9���n�7�=T���x�؍r=B�}�a��9�NB��*��n��-��(�b
��gK�x���J�P0�u򆉽m�1��dZ�b� �-`���cĘ�U��4��� &G��ͽ�,�p剛��S*!Xj�P�WH��ޝ��R�9b<���X ��b�����"B���q�m�9sC7�1�,�N�ޝ����3�淦*�g��BD~�x�c��2�X�
��0y�\ҼQP_�1slbuouk�^�] �A�����%��6���>[,�M%��g�P�F{ݫw 
�B��;��qL���C[{�O�K~����V�M�c�PB`@&��TF��V!�vR𢊭jM4� �'��y�3 �sU���;_0�l�Vv�����d�B-���N�J�� �ȯ ��px'l�3 ���܁o������<�MG*[?����}��I2��G1T��4Ń����F�t��I|u?��,�(��xօV�s���$�����C$�g
Bv��.U,�(#J	�J�s�)b��7�rة���STw%Hg���,��Y��CKE�S��#.	Z�5O�'�麉hE��7����;�0��dڶH��dD��gU�O�V3��׎C��̍_�4�*��>X*�f��d� �D�����h�%S~Հ�S~*�Qz����
���sY�E���\�G�t͟��Í���Tge"��1�4�����/� ��k��E�a��O�-8��\���0~t� {�A�j/�-4}�"��(/3��3���c���'�:̙fS���]�?�'޻s��0.�l�e0Ys��P��A��FƑ[��ѧw'b,��KubY$Q>U5���!T2MY��H��I�:���;�� ny����nLm�q��T�V?����Ug�_��<$��B/�6��ʒg�=l�s�,��e�7�4s�K��3���Na���k"�?cl�2�B�9��Lr7�ҕY>��d�9��7,sWG��.t�S�̈́���)M5��߱	M.΢��B&��*�#�yj�|�M����� j�+�a��0%L�DI'�kE�y��I\"o�)l�^��6��g;�$�z�z:�U�P#s�h�MZ(7y�Pp�߽a������ ʵ���9��=�. 0V�-��z���-�S��u���2N��©�)�ϰt����ds�/:Pחo"Y2�A�<n��,�`M/�Ii��,'1�c�W�׷���_����v��p��p�Pf4h8W5����=���B��7����[�p��X{/t����\��
��f�84D�b#p��7�a�F-G|��6j��c�~d� �����:�i�m7A&���!f����UB��    +�~?�cϜ�I\P/a8�rb2�Y!+�8���w�H��٘a���������7����C~sɽ��Q�#P
,
�i�N�cT�΀���yY��DB�#�wg ��!� �Nݫ�������]���hy@���P��3��E
�0}[k��/lNзn��`ɉ�Da@[ٿ?݀�|9�f"[ҙ�[>��Z&�?a5&����w/�S%|����E�2	Hޑi����D"�\y*�N��c\�������n 6,ʵn%�ny�T!�lY����O��|���9�ʎ��0}�a��Tg�����+�r3�/��o���,���s��qۛ#R>_���^�0�l:"���T��k6T5���4�����fsТWT�D:Z������O��d���9xz���M�&UCh�Wê#ҕDvL=~\RA����ę~�)y��E#k���E���yXk��ޮx/w���<5h���A�	=+x�U�L�&P$&.��H�c�d��´~H��@���:�Dב�<�n1�c��~�m/:�a4-�$�&Z�K�%=�#����,lP-��!�8H���j�%P%�t�<�����	��d,G��Vֿ�b��U���~y��:4&R@g{�D�A�d0��Sapn���"C2���o��z"��ݙ��M�&[qɺ"*aS�@�Υ�I�Z5ӜKv����i�p��\0�k�_���3#�_m�y���k�F��9���}a냜	!����V����1Z,.<���D���^v��9�Nw����SS�?U�ƺ���ݏr�G�9v���1\u��9�,�	��������1O����:AX�jF&-�y��n�<_�ݚu��eR��R{���ņ�/�\�����`��|��!�#�S>,��Y�r�$����rk�`Ӑ6V1�:�U������|66#���L��ԕ��/�߄�+B4)I�	���7H�-)Z��<2���2P�|��-��g]ƶ��\\�d�������2ה��-��d
�,N�Dpj�ŭ�M?�%�m���p!�B�m�+��ѻ#0���5��c���me~a�4��g��4H��
��q�/=��a�LQ}����j�̛�l=̓8��}Y�=:|$�����A�9
?��0L��D4��"���E����S������-�&��Lah�\7���Ө&�c��F=ų(�	j�������D?G�[V��#��Q�b��05��N����,�&�)�����G>��'��E���6D6$��.�����)~��O�p�2��:�j"#�D����)��}�-�'�#jX�9������^N��Bpz���A_�!A����v�2���x^K�4�cg��h������ cJ#µ�Q��-�S����N�<��ѐ$��򹱟����0Q���q`��0w��b����,L�=1�F�/�J�K�Q�t���T7τ,~��ڐ�h�������3n$"?�؀E��<�`��@if�c�x�:} ��\߀��3���g�K������!S�>�Hg�(�-!q�7�����z���	!_����G��&'4�pUo�;]��]��4.KH���m�4��m	7�����a�X�yI� ����	����ȭB3Z��J"��X���S��=JP���H@�yd���9�33^�ԣf�{鱉$���10��@4tB8����~��7sS0��T�q�3g��+s����N4p[����_l����^m��u��������0\~avVD�:o�Q/��#L\���9�%H�M��5�w�'�v�^�at�^�4)[���3x$��XNY�v%<��%OAw���`)��>MG��sd%NB����t1{�sh�%�
��C� �|��x��'����0��WO×}q,����%Zsg���H쐇Aw�T��Y ����e[�kK�=�
�p�18��F��%y6�4��Ģ'�ͼ'�Y Cg*Sl!�B��|�e�Px�c�31B�e�?ץ��:�"�0�wo�GH��f>a2Y0k6e�h�g­E�.��FN`aGؑ���8ysj� �g^a\��t�ۧ��i떼Nj�r5Nݼ�`�y권��o��M��d�fa4V���z�T���\~xP�;]���L�1�?1 	����ي~g�ޭ;�g8�|}_$<
�xr�,��%r���C�s^��:�L�Ϡ�6-8W�,�-GЄ�NX�p���<U�[b7�mOs��A�%����(ΓQ�=��ɥ�C)��2�h\�t0�s���y`���(pj�擵���L;C�,�30��p2h)�l��uW�N�=\����\d%�H��Q��ӼM���j�6h�D|I�Tkf�.o�6[Cﶯ<"���^2���X�g��2�Ͷ�x�a0Ԏl��ÞaB�<��CЧl j�<"썴�3A� +Yn*�T�]oƪr�H�хfa�zz ��,s�/pTB��'N���U��Z^�3ꦄd�܍e���M���8�%�S��)��6�fv z� -N6��R���Ӹ���^v{����8L�;��J�s^ADND�x%$˭��ۉ��@�A�F��a#�h��ܤ<P�N5�u�A*�@��fˏ;�=��s��@���k�Y�cW�R��4v$�R�o�#Z�U͝����S���[�࡫�S���Y��6��.<8�!���C�|3�Gǳc\g�m��y����#dS��]�8c�K����L��d)�1�O�R'Z�%�n4*�
c؄$�����tvQ�t�iy�s�邒Qu�l�m
E���kQ��6�����'4qՙ��z�.�غ�l���̳�p�Ѻ���mP9��xŦz8�R�H�Mt�%d��6C�S5KC��7�H����B.Y�ޙ˶��[��V��ٜ��ݔ+��3G<|�������� $��C�;x�Da6��vū�i�m��J�8������Mmǿ��%���ԣ��[�`,a�H��9Ւ\K���y��R�GA��L�����#�)oӲ�p��p�0
��v=�Z��q�p�y1k漽L��T��4�
� 8�~/̕���x48�p�-������N�.��̹#[����ˡ��,��y6K��D8������������b���r[U���\�3��[���1$Ʊ(��ݳ��?$Nb����_���K����ǀi�ܩ|���Y{��SF?D+#[��u�솆����y���c�;��Q�K�e[��m�YcA0�)ҖN����1Y`������Y��r����;K!$b�H����aQ�����_6�����W��Ì���|Ow��8!%�ɇL"�G���0�O#i��v�.���èhj��W����N��XPk0֧�!�g}I�˙�@�������;��S1�i�7��	+�y�D�V6b��0��w��>�1%o"�Pe���E�<`���>�[;��J)
k7LR�����pjwFm@��1�Q��xOF�˝S������8��>F��p�8�T4k��4� R�U����V�,2`��C�[��bgy<A&I錏�W���80F1��dNnٖݠ1ڕx�]~&��ҙ���i;r�Z>�>�f���<���4�͌$Cؽ1�;Q�<ƺq���H<���Lc�<�v�	��L���%Mq�İ2D�ǔ ���#qν#��U��X��^֡u�c�9yl�p��N�Θ��t�B�(�"r���Ce�@����q��3��� ��0�5�f��ğ&���!��m�� p'&�a��/��?9CJ���gq�g�m�$_M�<�D�0[��7t5��5��ݡ{ql9N�Z\����S����m���(���?���G�z��L�H��:=��䀘8c�����z*,�sk�(3�� #��z�=SA"��ϻ��cI�v� 9�Ǩ��Q�����V�u�]/�bCi�!w�>5�)7��x?���`>���{�	S��������s�2������ �u��w]�����s��:�[ln�S�@͎@�S�,��y)�3 �  �C�P����ްnۀ<���eƹEX'�J�h��I�%���IlD{�S<\]3�`�0;sl�v�IcQ�?!�G�!�c$ �ߖ� n�E�"9�����w�r���SDJ/
g��!�]�x��d�ҵ�]J���mv�P.X,fR�����l`��I8,A����$X���=x��g1H��8g6�Y�0��7�A\�<�t'�hF��\����9�����q�ĳs*��|X�ÏM����bh�4�3f֞=�8���L)L��&�m��)�M�r|z��(
y��6� ���@ �Y	���wὒ�~���%�p�kԟ�oW�S�+�H�PV7M��������-�S��9��ڜ�ˌ#���1���p�+!N��G ��\s�Λ����(l��e�ta�v�^����$�f��BP{�o!�I��7)[���*�Ė�=��#ԕ��.�]�����0�-
�/AD�mG���Œ�Lp�w\�ҜI�j�(H#	� KßtJ�m�&,y(���ab	EWu���a�8�uX���3� w�m�v!`�sy�$;�`�k�7em�����/�~��-�ua�3��_C$��E��N� a�L�ݜ�(�#{��v���!f)\����Ym��$X��s3D8�l�U�
G������qNԉ����g���_������C��      �   /  x��[[o��~��
��.x���XM��Ij{�(����L�F�J��{�.�n�@�^v{Cۗ��$n�q����;3CQ�J�b���\Μ��s�f�岮7���v��qz}灿�1��K�-�����ų�(y�|��yE����C�no;��D�j2u��a����C���q����$��Io�"���XzUo��[1��I|�ME���e+��CM�2	��py=Ѣ�Z׫�hrAϋ �Ub,�}|ϒC���j��F�f��Q0�������v7��tvnlvX�u���i%�i+~��o�FWѲn0�ߚ�����0�+) ��߱�Oɇ�"Z��N�'r�P�����������0�O�w�� �jT���6����B3/a'�/�O�<��#ѣF���u?���N��Wwn�`����Xt��m�7�~w:��[a߿3G�8ڿ>���n��{}9�nN��c;N�i�/`��o����]�َƮ�yQw �����񉗛�%��)�}�|����0�ً��Al��Gצ�(�7���hjsI�^��6g���-���2~��s��G�,��tt߮�^��4�X㺾�qD6?)�oABx��
�.>Aß�e��x����xg�Xj�䡩$�����-=m	E�Q��Б�f��=�߅)��^�w��x�ԅ��Y���'��S¿V�@!��<���{0u��
r�+y!Maa�[�Sc6�8�������4�������F�����n_&�Wn��ˠbA�+,�7�� /9lь��q�"Ū�;�:/�w�~��W{�p:�v�Ge�J��� �B+�0�4�
]�0GL��%��b�������z=��ſ�|�%@���ki��1A7�WO\�z�� �k��}r�֞�a��:�B랿;�#�N���7y���p3�_���w9Q��z)B>z"S9�����#$z#"N��S^�ιT*!1'5;�F�pP�^@�ɛ/�)C5eT�4�o�m�;.|US�e'�]���͝�� ���+�V��0���V�	;�	��^�$cj�θm����n7�2f�&g�s�9� �A2�9Y�
z�k)ӂ��6��c���	tCN�`�r�A!����C]�9+"8�w��{s�<�}i�Kg7������y�@�ߘ�'p��I���-ECĥ�ћw21�/劦�#��5|��w`����������;%\��%��4}3���`VI��A�������d���l�+��cy׽1���C��9�R�p����}-�2�h^�m)DF'�У"<�W�����-�K�x�03hȻ����ɼ_��b��#qp7|T��ߗj�|�Y�Cgu�0P%��>�s��b��^g�?i	$�BN��2]�gs�\�6�C>�sj����W�R:��Pq�(^C�m`L�0�i�X7�9@Piq�v��ƶ��d�d�ωP)2�>��n�5/P�";V�7�*�*\�}K��x���&�@[�
y��e6����5_�%A�� Xk^X���V�
Á�QVx�F.%�����޶�vr5�J=�$�­ �X7�C�ǃ;il�Q��,���*�� ܶ����t+�s����PA������T��P�������`��|��oP���]��4Z��ה�D�7 �_b���9J� ��F�ؒ����M�4���� �� ��\-A0ӲWw\ԫ��R�4~)C:ltf��^d�huAl�mG�Ձ�*B�A�`0��S[��AK(˰�[1J��+�ѓ�mz��u~@�-
r�@HGg*���)_BA�v�	�A�t��8�
����Er!lF����%�����%��{����w�<�@�/�y�V$@��v��6��
o��D��}�,���3�I�y�I����-��\�i���/:��.z�.��$��e5 [���cݘ늲���WT��k���k=Z|T�rH�oj���(���=����d)����(@��&�$0����&\`
���������Y�g�1N��(�<�_-i����X���R��-��C�į���Eޖ!�2o
ٗ�QU�(VM����IZEO�'��܆�񺽓���Qݫ����h����-"�ꚯ�m�J�+�Ǥ2�S�X�K&��fV��J��HH�R�VN_F=�#��4��+��͍����o��?�D��V*0�TM�ͪI�Ixмm/��u\-�H�Z��"Qs8p�0ˤ���7���rv�纱�����.��*y��������h��ԴI� ����4�D"���|$<��C�M���E�6��a*�-���Q���azt�q�nZ.{/
���?��Z��~F��Y(ҟ�EґX� d&�H}73��FM��.9ݐہY�t����r��\^.ߘK��oN��D9y�^�:_?w�y	�㶶
�?om`[�䷼�w�h�'��q��V`�U�>�
�[�[V�4�]N���v�"w$nTQ��ٺq�zW״\�V��ig�$z�ojc�\���,_n,?[8$b�+��ڵt�q�4�ʫ0:�'s���{��D	��o���<�A�ár��x(Cn��u&�߶��z�(���~�i%X�kx�����8���HVl�L+2Q���(��4Ե��м�s牀�\�J��?��ێ��;B����%U�V.ql:ǥe�e�����`TlH�B���0g2�e�1��P� ��U��7��{�S	֢#�iH�/���r�;A����|0	B����3��ֲmQtǶ�: \�V�+x�"B�yt&���p ��p`��)���ӽ:����U�ӵ~����p�}PA߈
����Ni�H� �9�m�R��A����XÑ��V�kJ(�Rjq�U���ȜC��e�="�	��z�,HՋR�X�+y���4�Du��3s�e��:�f �k�`��A�n��rqG���Sa�'��)g4�����^9y���22=}K��Bf;d�:}�M��2��RL]D� $VJH�JmzTL}�V O�=�'�� 2D_��H�)�7�BS�a��P��x�Ҏ��nI~)��Ɉ��~�l�!��v�m(ݤ�3U���%����}����C8HǸY =�7���q.���*���<?؛�$�i�?j:_�(�r�=�%�ƨ�d��Dz�Yu�܋-��������珖��bҗ+���qx7��_���fV��F��b��О�>�(t�����u�k�`;�[���m���=	��r'����/�SM�,è3�3á��[�g-P�����������h�!�O�8r ۲���
_�n[�-3��1��M�}�"�?�� x)Ȅ����@�mC��*���;W�\�e�-�      �     x��X�r�8}���M3�w6���=;/��Y��D�p�_q�t;3U),R����-B+f�V�,E���LW�������x3�G���T{F�c�T�.�"���"��i<�e5#�o=��Dp-U��"�f�����Y���<V���o[�Si�]E�˘+cb�
��^��ݚ���5��;�7aU��Lױ6�W�ԧ8W�����lO~���W���)�� ����@�Bk+S�*ӐQu��*}0�KΚXs��b{)t�����(K�
L�3N��ˊ�iU,cLF�q�a��k"�L���2)�(W
�A�!2��K�R�*�B�Чr05?0s�W�V�rʍf{w�=�cx��D`->�Hn��D����,��(�q�R8Ԏ�ĮJ��?��_v[V��8	��A���f�ٴd{pgB���c�`-��1�e�*j�k��.]����Bɘ�7�\y\^�{/4�	H�pH�M#0(ɉ�H�N��xqʵ���4�נF�{��֮� ��'��mn�T�44��SD�?0���(����?�'蚃�"���0Vf��$��^Н3��>�H���=��W���Ć�&�P.�ח���m8�	S@|���¨��a�j�۷��	�v ,�(�8WU��5$W�f�\1��y"M�oA�BE��5\��	w����x�gLk�u�i��d��8J.bm<_|
�Ȏ`\�16�2�N q\��ũHUqz��A�֪JEQ��8�G�~Q���U�6?�n�e��&�������A6�>&��l�zv6��R�m:�i$����p���O�a�u_JC��6�x��.\�#{nTި�M���Ƈ�b}#Np�n���Ԏ&]�\%U
�nO�ׄ�=��+�~ϒ��]�ܸu�;��z��{������~ţ����6���ݠ[����E*��z���[aCpJ"���ZW��`���;�5�1�x^_�
XE�7�FdFOa��+K��ZI�:n@�W,�ԝ��F��w`�J��������֒��H4��a(Ρh ��kV��i{��?�}�0r��f�l��h���Rw05�$57=p|��S�w��}sY%Z>�T&P�5e*D+�S��+�^	���b}K��o�>����}Bny�ςx�Uv�:S�Z����'�۫{:	e��.�`�'��Ƨ��e�<d;�	��R+V��C1!���O��/t+$�ڀ%xxH�����//����@@P#�~��"1`|�I�� �;D���J�L�L>�`ڨM��vsP�GA77"���?f�����r�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x�347�46�247Q1z\\\ ��      �       x�32��422�4�2��@,cC(+F��� bI,      �      x������ � �      �      x������ � �      �   �   x�322�,JML��˩��CG]�wa�Ş�.�S��~����{/츰$ih�����Ȝ�85'-(5=��$���/l���¾��@��]��
�d��.6 ��/� I�.���x,4�LL����fӄ[�6� �n��t�ᦙq���%��`3o>(�A�:����}8����� k���      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �       x�32��422�4�2��@,cC(+F��� bI,      �      x�32��4��224 Q1z\\\ +�      �   �  x��Z�r�F}��E�𑢬XY�"JN�V^ `H!10�D����һ٪$k�����=�W)�2�|���Q5���?n�ZVm]�E���;���d�z����C��5/䗏�+��l��=7O���w|�ʋ�WUͿ|T��M����T�d���J�=�vK'����Ѷ+�6bh��*Q�h2)�W��u^5O��_E]�`�P��������{x7�d��$����|�6ys��f�K��(�؞��8>�/5��>�ٮ�%�nsY����C��7���_'���򏇎w</7y�������bcJ�,X>��'�7q����$c�����>�-}_�%��8^2z���E�ˋ�������!�ۉ�u�������B���Z��s��([��:T�+�:�#m�?*yd�5%�X���Љ����ph�Ҧ0�R�n[/��ט�<>?R>n�f#�n���+(��U$ne.��̏i�߼��w�kE+Ⱥ��V*��x�z��?6ŷ�x��Cv��r��	>'����RE�N\7u�x�OB���x��]7����2�B��-����J���wl���670vKz�<�}�ݑ`��+��ʡ���}8��G^]��^#
v=��(�2V����o��Ւ>@Tx���W)���.Dy�a��6�:�{X�q5��/<X���[��qs�e�S�P(uUT�aw��Ŧ��`zn[�A�|��Ư�;�"+�x��C�2���9*hwP�`�)硉_��'Q�wy#z�ˣxGL���JD�*�3�Z�O��u�������2EdG�׃Tl>�&AJ�VI&6�<V�P5���3|��V�P�w{/�=�X����D�\).���{�F-^�?�����T#x���tl��J�/�[Չ�����X���e�V�n����#���(�۶>na8%���yhb��S�~�����A�2�/���@�����ٝxVMÁ�G%(�)'�_C/�P���kں���c½Z0)��P�>r��R�t���$��{^�- R5�ք,�������������Vi O*OQ��&���|����N��
ڈ���H���%�\t�������!8 0
rU|'@���1aU��RN������:,X�����]|��3A��z����G��+�P1����^�|��\'���w*
��<ch��UR�):N�V��9�H?�e�RL�M�;�I߱���W�_w�Ы�([��AY�M�{��R�-`T�a#��B'��.\ƚs6���\���k!b%Q�n�������~;�;��D�H{T߷�J������=�r�9/�	yWU�K��z�������K�^G\�nb_�e�x=�ץ��~GE�t@Lm�yu"#�R4D�J����M����Uf)8� $��<K%j�7E#&ps2���_�zL(tnEY��b�{�����-]"�3Ӱ d{ť$��R�si�A�7y/�p獰f���cq�l�Iw������h�
����M�{9�f��g��t�&��K�'!����`����O���軞�w�ݞK0�&i��~# U�>݉ZN�e�.V���㩏A�USI0{���&���@-�����g
ʖ�����t5%L�`N���T�{J�E���RO��C񙇔y��gb:Zޟ��	,%��)�V N�տ_wقY�I�I���Zlj�s�*�����]C����ƿ�}��24!u�F�á��k$x�{b)
��R�Ê����Urlb��`�����g�0!���T�T�p��C�SW!�7
�����Q���z��ϛyly��.5Cަ����]�'����\^v�my�S���=Z,-�7���3:O�6���zp��8\��o�N"�1aD�$��W���-!dSS�ks��3c��e�bS��V��X���Q�s;5̦��Oߧ1��y,9�S��|� ���{ȁq���N�)����d�Z�5����04 
4���9�7�����ᠴϝ��᝘�2��T��.6��BM�%��Ɖf�@;�A[Ox��@	�#��)uj�9Q+WOG3=ݏM�P=�K�,��9<`�YQ���F��ʲ̝2�wdvD �5Bi�-�y����F �	�bL��8?�Jޠ~��U��Xz6V��{��v �qŵr� �����g�)b�<�L��2c�b�1Y~��SM�L�H=�A�m��~�H^+�)M`k:�t8o�`^��k��M��o4��J�RK��T~��Nݨ��ӗ3��lT"z�0�k�̎���N�T�wd�6�ī������
��N�� �
���W*�W]11��i���AS�8�+�z��|C#��Z��:�~4e;��I�`"��v@s��Rc��M��=R������CV�Ͱh�߄c�&ڛ��i)T��5+Pt�A!��!\��2�HE��,'��dQ����:��N���rk�y��T�-۩��{�'z9z�yW�s�b�HM�->/ƪ�lҼ����
���H�h�4>����T巊�ߏ�_����=)�`�;�˵p�iן�
�S���/K4I=u��:34"-P�������+t�?:.>��@&mq����7�ɨ)���;�~��� ��-h ����B��5������7**�����Z4���t��		��$]�/g9�rj� ���
�׼�� Z���8[>G�R+�ޔp͙�75�q�74��B�F�w(I<?*]�i8��B[�`��)!K�}�k�����g�7dҏ�-�X����q�W<�3��=��!�v��a-�r��HW9���M Sg�^�1�:�p/�8ᆶ1.��V����%ț�x�
��|�A��%l��/b��Q��K�V?��ݖ����/!B(ʂ&:4%ǻô���l�L��*nA�@l�AkZ�XL���P�H�e�5))QN\��|�1l(cp��r�e��{���G����}��-|���	�����)���Ȍ����ԛ�N�O�f�ٜ"jCo�(�ß썒�]5t��>���Q�Wy]��'�(M"���q��V�f;n�f���}��nJ���D4��uI�#;|�Y>�-Q��������+�3WY#���jn���\��F�!H���͙Y��g��٨��Bgq�OOfˇ"�����$����VoB+�5�*��d��_901��iq\+Y��w�:�/�h�bdO׃��oe��p�X��dQ���K�W���(Z�0 �O}�	�_�ɴ2P�.��a�<q �{N�#���9{� �-W@]��#��%o@���*�9�wpQ�LF���g.�u�. N����,^���Y}L��vހ�h�������@ ����u~U��<&�0�5��+�D����j���]�ܽ���Uͯ�GYkD�������/!BCM3��+��� j`�z!8��v�5��F��̈́���b��-�>o#	ڈ!P���	�� �� JNh�k��Gz�F3�L3;�W�IR��E�v��Z�\�Lla�C�Lo
�0=����)�G��ד�pHDg37��������(dy}�7�0v`��� �ls�Ch{�cb�q�4��|�B�:�:��2&c���-o�@7�G�Rj�0nw|Y��+����~c B�A_sq���~>1V��M�l���e � ��w�\��?�'#��Ve�bL�}=���Z8d�;�Y{��+��@]ڤ���fd���U��_���pF��^	�>T�2i��|���#�YJ�@�"x�x�q�(����լϐٌO �S�������p�93ɍ�)aT�%ٮ��_$1{�:��͆�V+g��=<z5��Kh��I��2�`'lR�_�� 4�q��R����.3���g!��`~�珱��zRgzv�*8��݋����{fC�p��!�-A��^��x�n����'�ԧϛ���J����3��t�4^z��9N'~�-���a�L�^:]*���ӧO�\�s�      �      x������ � �      �      x�340�42�240�P& *F��� 7�      �   �   x�uֱmA@��W�u��p�7�Iy"� ��oީ�]����3��y>�$�a)���,ò*�� h4�A��A� i�4H$�I��A� i�484848484848484848484(�E��AѠhP4(..........�M��AӠi�4h4�M����`h04�C����`i�4X,�K����`i�4��D���������y�?9�ܪ      �      x������ � �      �      x������ � �      �      x��]]s�敾��+x���/�}�ڎ��e+�ROfv���%D �A9�?ڤ�t��۝��6i����&��lՊ,Q�G{�H�(�	�Od��s����=�ϑ�jS�F�����'���A�Z�cضr���-���"<�(Ku%/BV�u����������O8%.R��Oq
^>P�5mkP��ߙQR��������0�S��Lw;�'խ��x6���)Y��u ����h~ែ%K�;�Of7�w������|`wէE��T���5���8�ӋMdZ d���߁j��#^q�}����m��e���� �rpK�oG_�>N1��� ��aߧ��w���i�ܗ����Ak=�{�wsu�}O�O����ܛ�vԶg:�O�N)K��g��P��:�>��C���3��@�9��U��&�}�|����k��l)��ao�~���n}�\�a<��M+d���rMv'8<���`X~a��de6�|��]�D��b���3��Mo��v�R~��|����pK�� w� ��\"�'�T݁���;��͒Q�B�5�/`�C���,L��X���_�=��1�K����p���9lg]�떉�5Xj6�遐]�>�{���	;	^>D���B��N�7�F��j��޶����,�� w�����s�����e
BV5�[L@����:���?�Ct�X�9�B6�>���N���� (�{��Pum��Ybj d����h��b��'$����}cC�ӫ�2w���kL���7v+]�k�g�V�����Xkz�)155������}vUO�.w�s���Z.�EQÄ^h��T��G�)�D���� �)ɺ?�u�<���4B�*�F�G�h�)}ʈ鳾�:����p���M�ah��7���V@�Mm��{.��O�r�ف#�3�W��nݻ�*3%�&5���+�K21�#�]x�p7��N�u�rܵM�SŮ�n�
_.@�%�X�z���Y���276�\�����>���>�k�0�	/�v�7qf�gc�;�������ݵT7�EGѐ�L?���L�R� �_��x�R�c8��p���sł[�3�6�6��h����W e��؏#0�x��
'e�]����JD��!�����=����Q�;N�0
KD3l�9��p�)	{B�����82vh���^1��x�@���/!��*��}s&�aV*?��3Y�����=��"yE��{��+x���a��S`(��i���6�=��lrL��Z���q`��+,Arʻj��ڦ��XY��B6���A"�L���9��m/�r�3܌�����#(�t��s^i���mc`�ƈ��.i�`{�0����pAv��K�e�L�M;��H����_P�>]���W�'�=0�U���7I���v,��I��O,�R�*��$Aۯ�����ޠL��2����3hh@�M̓������"D�{L��e
o)�Zq��چ���Q����Y�q�I�RRbj�A�lv��&��+�(�����,�������*=*z	^>��40��%8&�ݫ��� ���Se,��7$��~�_��-y>�:�$��Z����K���g�5��uCyYλ
�ƨ�h���;8�hu\s;��B��Fg��'���|���;��
� f���aA9�c�S��r� w�c����m=���V�G �l3��P++h�s���gC=���B��%�K��1�J��l"M?�����9�l���h�m#'�K8�t�G_�̶p����⬛�m}Wࢤ4HX�ٛ�>a�<��U��8/ӫ���S�jΚs}�b�����QJ!�����J�V�
��p���\{ܳ8Q�%�]��#^�Z�x�aܷcw�G۞���%?�x#�CT+UR�~0z��6�y:Va���4��}TR0̄9�² $w!��UA�l�c�3uc5�<܄��PM��|n�f0+9���F�Y��#���Je�N$Y��Gm7�Y�$?7�5i��j�l�����zn.M����EՅ������	������y���5�e�<�@�JI�nX���F�G% x��\�"�3ُ�]ml�/i�zg��@�����O�l]�K�9`г�E@4��������Q�S1�)�tL�ċg�G+�縏n���>GN����kx����U�<Xt�{Ƨ�>�Nih��V0��v��aq���9W�kE���xA�K؈��/sw=��ٰ۷{c��1J�hֵ�3�7����C?����!��!��a��^3ֳl#�!�^	�^Ӡ�^q����GFn��A�+9}X0{ʜ�p�����a���s,��˺ �Z4��0IR�V��3����$��
B6��b{��7��M����4#W�<�ŉ�:�z����ҩ�䀟d��D[}�Sչi���$C��ކ$0ܕ� Z�a�������J?&��scǈ�\�gE)�M=�f3�aN��YIx��8�����>����b��"5Di�Ԙ��^����T_��ф�=9~�Awe0q��篰��71���i՛�B�����
��pV��p.헟b��_�S<��3^̏��b=g �L1�!�]�A@yķa����+��TBH��D��%��n}C�M��o��i�LH�	�f��?�$���R�2o��|j�b��2^�d��e��#�Q��\Y�5�t����|�l 2#��&��A2�,<���i���ډfC��;ܟd�v8�ĸ-u�&���qM��i:���zsC1,e���%3�5;*��W� d��������nc��0C�9��k�-��E$�Q?�ˇ���T�MNT��MX� j2jI�:������N��I��h�wW�܂���{���λ��8���!	�K�h�uj[Hd��=�����tB�R��s�>[�=�-XNܼ,��������/152�{��?�m�|�t��#���H�����Ǝrqr������� �ZS�<�ʙ[)�+,]M]/��z�\kT+�z�.7f���?	&��h��a���A�sz��u��g�)j�������(W͹����d&w���	�,R7�!Qi|6����m�xL]��2=D^�=�,\Ӱ�_f��@(O�Z���.K��3�~�cտ���Q�_Q��ۈ��Me��%�B��dE^c�,X ���!OOY��l64L+�K�ޝZ�&���d5�=Q�P�	6���WX;��pXpa��GdZ WcE���O����I@��!dU����y�+#�� d��ߜ��V�b�����o:��z�\�*B�%9�L&�B��|E�ސ�
4�=W8�`]�y��a~�1�Ȕ�$�"z�yO(S;��jR�N@��7Ε����-�K���{`�OBz���/NM;����m���4zА��Ff�<!�tn6n��������1C���2Ԃ���7����_�L���A�{!iܜWx����3u���T<�I�ܼ`b�Z���~vb�Z����s�G0ʉ��ť	�ژ]+GE�'�� ��[c��"���;���� ��y���?�{ �u�sdxYv�t_�jZ2���A���gy����͞7cz*��iZ!*��u����qH� 4������m[�|�Ȅ��-�;�{��ܷ:C;���A�zM�`��j�Y��~�$�/B�ڊ����$��% x���Lmha���+%ι��e�F�N���N3�7�,D���|�=�S�B�O�h�B��)���ZԢf�\F��^��Xּ`U��I��!Ku����
����H�,p���j�8���#���/��k��s�Z�2:[�$D�B�6����~�y%��=S��Oq���]/����,(z�=�ˇ�ђ��ԙ��f7x�d9.�
Y�s���/��NC��M� �/�������W��n�����:�7�<�lT�7�E����RT�zB��,|t@�'!�2ҁQ�{��b��,(}�0����{���~�m}�}�Q�@ �  ���0���WH׳�	�Ů�m
|�R��������_��1��x�o��CQiؒ
e�Գ���r�K.��֤�+��D�j0��ڗ`z���U$B�kc^s��{fL��f<�#W���o:�e]�v!A�f=ٞ��C�L+nSr�n�s��`o�$��I��ɿ�ǿ��ާ5����F��Zw���$�R���!�W�|�)	�)��C�#q�Ĵ���J���nm:�L�� �G-�E�@������6m>�jn�<�D�x'H�r2�D�������$�B�JD`�݅b�4���!e����ݳg���26Y��!d�����˷���j9*�"EhP��g�BuʈRZ�8p��85��=���A`��g��Ҵ��۝���J��T��[����җ
!u�\@��=6���.����[Y�w::%ϱ񌚱g��0��6׬���'�{Z����q!����M3K���_S9� ���3
��z�ť���#Fqi�����#�f=e�"�*}z�+6��|�����>��'�◗"�X��A���
"H��.*m@�@�Q��M�?��ZR�Cp�����A�õ��`���(�����x�HmYi�m,ڰWfJ]8��� `S|	��A�{U��3� '$ �Q��l�^�q[�S���W��)�r���d�B���Q.�(B�sǹod��X�Z���w�3�w;�) ��v�q6���[�i��p�w̮r�	M n��P��I^��;?�6n?��f &�.ˠFs�V�#,Ҡ��py$��tA������m���WHi�F�6�Fe	�f3�<��DUצ�(��DQ_p�J�ľ%Z}�����GĲϵlY����l���XD�`�K�J+>��E��8[\ie�.�C`3�RLN��y��b�瓒J�*�zߎvy���v����1��2��`Y�(.�忘�dCN�/jM�Sٶ��ӈJ~t���ji�Y}2�ٽ볨1��w�!d��t���)�8��O}� *��Ak�6T��m�9�	#6v׌��mg�C\� �^C����3�&��r�}�?�i��j�io*.R���6m!�5$�٥��R�,���S��|�*�F�Xi�'���ۖa�`d}Pu����b+6\�5�!q�iod�9���h������I9��
v�S�0��#VySU���UQ<�fb����$��AHY_��♃�w2D;"�D|6����g'N��7�ʻ��Fx����p�l��� Bb��Gl�&�ʧ�!�|��fv�� ���L�3ɉ�Ug��:ِA��	���
!�0�x)����Xn��B�A�5\�x%>���Ǘ���u̇�Hi�{�c��f>�7�k�n.!�r�6��7�����^�ܙ����5��	qa�0���38 3��fp���'���~��g2�q�J�?������      �      x�34��44�242�P��D��qqq V��      �   �  x���Mn1���)|�|E���n�
�ɦ]�@{���ā�Q�p
�0l�����I(@z��o�@91��B-��=���G*��5j�JIL���g`P�}�/{1�&��г����w������_gм���٢w��]����%ș����(�u�|�s[N2�?���Z�'�T��EA]���J��(_E��:WԖcZ�AP�+�l�g�myI� �(h���-%=�:�@m�QP̠}��0����m���Q�#Y�r����e��v@;�S�<��C���J��a{��G��о�.z���i�Q������	QP���hqP��ڱۣ�lt�e���Q�E��h�m���5�~*�J��y�D�QmkP�?{�6J쬿�4P�����h�#�c5�Vz��,@��Q��d#O���Au�qï��Ӧ�B�G9<L"s$�U�K���5h��)Ş6iA.�e���g���t:���      ~      x������ � �      �      x������ � �      �      x�343�4��243�P& *F��� 9#�      �   ?  x��TMo�0=;�B��C۩�S��؀���!�@�l�V�<�n����v7K�����e:�'C/�F<pO���O���
��jM<��,r��bI��9�p�d6W�$�2FV���A
�b�2����L�%�؞�	;eK��x���B��H{�)�i�0m�-R�N(B��?��ju��8k������=�
��%�FX�Z�/��kH$v���j�t8xW�=(�Sw��嚲(ޕ�'L+K�X������%P�s�2����wG���{�7���I�Ed#8�O���e�@#�����RK�H ዲG��G;�.�J�l{[Y��1e�EQJ�U_:���\g7P��s�CT��o��;{F���H,HiGud�y3m����.yp��cp�:�&�q0����H�@�x�AI��Vs��V�]^��	3����pxB5'*w�[޿�N*�.�w��JHׂ~�k�m�g�n�1-�ywQ_գ�k�Ai�)te�o7�?:�;��}M��l�4=�T/P�r�7a[�����&xN0O;�`�z����KD�� >�b���}�<�D�x�[�^���<I�      �   �   x�����@�
�v =���E��a$�"#�7���"2���S�w�9�Ew�؀���/��Nք"�#�)A8ѐHD�H�L���x��9�kɕ^��)�ZWZ�=��Ia��{#��i�P�=͒�Ȉ����.�~�\^�K��N�AD?�:mg      �      x������ � �      �      x��][��6�~��
���@�����v6>'��g��]�<���D"'eg����H�M�b[U)g$d�Ѹ��7��W�+ka��X8� �	!��zc�W7��48\S?}W���tL��������?�o�ĳ�G?�v��I�}|�=ٲ���I���� J��7�����ŷ����GW�Y���W��wYun_���$�&�&"��Z��F��CJ_���.�����g�w�"�mx���i��xn���~�18Vc�����O��p�6�����6>E���C�ֻl�M��no�xK'�e�i�\5^$��mp�z<�+�>�>�^���wj�g_��h�O�.H��J'4����'�������� 9�M�U������nO��ݯ_�?��A�Z�z+��i��c|���Y����?�ǟ�+Z�j�_R�*����{_G�iz��z�|ս��ָ~	��oa�Y�5TZ�{�����ݵ�ȷ����$����O�VrC���.�K�����"J�4�{��M�5�{�c�%lŐ�����Ԓ�b=<��(�{�7�{��h�<>�����w���������Xw�T	�t�9��a�sJ�pJ�i�p�g;��x'���A�;=��Ev8/k��:���+�U���?��_�A����@m6�>	D����ت������c��'��5�كI���)Ǒ��Zç�NecR��`���wr���7ZW�Sg����k�	�躏?��cy�˩(~J㇗1�H�W�͢�RK ��wql�_¦���/e���T'�c�T[Lj���1��幵9N�(0�K`�ɟ�Ȓ��[k�@�YF~����m�(�K*��Gzz�t�v/���@��=��z*|��������B�����޷���3���f8��1��VZ�٧�B	��G��@����Z.�tm��3m����6ςm�F���`�� r�x"]T	��ُ ����.�w�I���k��*�w�{�i�����
�/%���5���� ��[�%y�qK�9��i�G�������O�����-�&����r15���p����������	>.g�&}�1N¿�OzC�S�z�睐����9�'�x�ԑ�3/�@g-���Z{�˿.�����d�6;�\ml��e_ezh���ut���m������r�7����髧#܋��쮰�S?[5��!'$�H������z��|/��7w��N����/�)�ޗ7�\ O���1��we����Cw9�ۧҰB�%	��]�4���a�X� �K�%�0�.ؽ�Fa���%7�$����-H�gU�EK�B	-��~��ە̩�������4�����cY�7����ٕ|>c�o�}�}��3�x�C��D �?�a��ͷ0�@o)v���E��
tyY���>e,�܇���Q��IS��_�;��ZV3T~cbO㎋|�B�ϩ��,\�������-7/���}w���B�I��}T���v|K֌t7����w?���CD�N�q�~U|0�V��e�G�'脹|�zPNlg���3���r��M���?��Q�qwӠT���P�~Y8q�Bu$���'���ywv�����Ί�62��:�DH�ۼ�<�?)U���!N�g�� q�t(�������PP����О]����<�S��k��Ke%���'��0�?��nG��M��N�}~P�@����ö�� ����{�_��t@LR�����������]�+>�/��7q����ܫ!֑؄2 ��DWz�7�s�^z��8l�D�6��f�#��`J))u5���<!J䆔t��|��;]��\S�c��r@U�(s ��?���[׭��]
�Z���y��ٛ>�����ꅻ�.��`�i���j���~����>t
�ί�k��ǟ:�pE�^��4�>(�)
��$l�ğ�Z�����'Ujt�NE��bRr�����^'����ncŸ�+�ےl�B�S7�?幥v]��5�)�!!���8:7K��.! V"�g�mm&BGH]�n�ː���g�Td5YU�j͹�J��?
����{~��v[�W�^��8�)�c�8yi5V��2쀧�8%?:���CU��6�L;�Q�Z	$��˻�_Co�͋����ř<��ˉ�ݮƉ^/�D�il��L�h��Mi��4����l��:MN
�><]���QR��m�
W�T+���j�ն�T��`�V�\���S73y��l�͓=t��mX=5���L�W2�͏�s�?)� �k�[L�ŦK��Y�Z�&rZP�ܐ�w��ư�v<�4ρf+�/����i�v�Me��4�a�&s"ʔ��X!�}8�Ɔ�i��a�C�Q�;m�'�l�d1�Ж�'��?��	��q��[NP���D����v� �5�����|�Ο��({¡��)�2m�A��;��(��w9n2��d����$���c@4i���u&ǈ7,�՛�hSѯo�3X�F4$��se~���.�e�h܅-g�Wo�A'�M�]����c��&�X�s���|��<����7*D'��5��������n��W���v�q���fa���������dP�.M��͊D����߅��n����N�vt�a�f?�W�C���~S��n��m�ӁY��r�R8����jcW�f�K���X�59�p��c=p|�y0�kL�Y_�,���1$>iR�������e�Y��q�#3v����� vi��?u��釸-�����ؤ%���>����XkzQ�N�m�$��r��r��1�i��r�=T���,�C�3��c��$�	T��������[^]g-�	s�P�< �d�󵼺.d�ȉ����u!�?�ٸ��u!�g1�B���(E�eۼ�66Pu3��=W�@k�l'�mӲ�T`E6M�Ž��Bs-�3������t!�V���ѕ��ؾ�u>��d�<P�;�`�i)B���Ѭ$����v���2�!L�c��Aj<#2�n�h�����+x�;��#�d�.��Y�.�R�O+��2���\��K�s�r.}%�Ҋ�'����&��u��R�A)��\� xwA׽�0�����{��=����,�h��w���W�'�Y-�|7~�Z-x<�$����o�7��k���~�2/�P�����W��z�H�բ����-���6�✩Ɖ&m<�$z�x������f�x�����jV;���@/(jX�\h��Z
�<I�q��l�C�M�G?N��=�8�o"?㢾2����͊�]A��bޠ�e�#��i�fE�X[�'��<|H�.(��7n*�r�!A(,��@lP �C�V�����$�� �����3I��͊��X����;.r,��!�\V�f�bu7�ML@��f�#i�/��^�3�[��G�"��!D���=ܤ�<5�)t7u�����$Ym�Jaw�YI�L\���!�]!�HR%I-�Z����k1"��-I@!SHVS��&Φ���#� �t\v�0��U˻��I�8���I^'��	ڙ'�͉&s�OCi�и�f�h�][��T���K��J����:�ʓ�(���] l���H��{�Ȝ*܆��Ճ]'B�\�+V�xh��q�
K�K5�;Լ�8���S4���F���B����`��1pW���j��x=�S��?N�#�Ve`|:4n��CqK���x���R#�o\�y�&� ��P�5��.5��͸�n����zʸ�5��"O��*�����P*������y?�Cf�]��)5�k�k��_{ِ���t�
�r��N���, ����{��LF,���5]�TjxP`N�J���t��1��5��r�T�-��q�Yf��'��8����	�'dN�\OH�w:�hvF\��Tx�R�&kx����y�
�����|�`�v� B$"�}0����:��x��88/)Ɖ��OL�� �&�|x�r��
!�<O���`\N���Ǥ��IXp�Z@�Y���o�; zg9"\ج[#A�V����g��׃����:E�l�҃�z�>[6a=K����5�]�x+�@���Ư�� �  =���d6����<@�Z��@�;Ѵț���vA�%#z�����U�Y������^�� P54S憣	�){�H���,��v�Ƚ�b���~>i� �"Z<M��5��Z��B��e]�	�j|��t����^�!b�Ƨ�rPaа�;����(��l��[v�O�hȦ;�w�Z7P�����^qMK���/�+��yLӤ��1;ЈP���0t<�`�Li<nМA�{Ѥ��=��!�Sj�蝔ۋ�+��X������>�lDJ����r#N o(��nM��b��8�z�ZqGX,`˯�U�i�O�,哭�a"b�X�ae9���cy  ԅ1�7�j��N��Vqj�) c���ƪdhj�X��1����Ú�=�#i�sva��^7�Ga����uy�?:������%�U��@�qA'Cw��e�S��D��n����/�A���Ր��-w�M�Xs���F�C�2�,J
ys$��bJ=ݑ��H%�R/qR�>����S6�KiJ"͂�^SpA�e�!�+�Ep/�;+�u`��4w��x���X�fP�֜1?1l��z��z� ��09�N���]��,ޞ,.cL��X<�*���հr��g��0N{FC�Q��������*��J�O���Ӣ��kB׳�����h5����Ӣ�h6o~=:B���J����1MB�7~�9B���lUq��9�)أd���'t�5����m"�_t�Z��7��灮�9�zB�cE�b0��R���5�eh�\\(����l���!��i.��t�_ܱ��hhV\LƊ;zUqG�[��.[��}v�~�9�.g��캜]���8���E�\�<��K)	mt+'A5�����u�O���;��d�N�D��ւ��!�f��xFi���Y�×4����*$�+K�\���N�V�S�a;�@�CCH��̭���}c�%V�X�mCZ�D�34��	��8�^�9_�DC�R9�3�2P�!�.�ٴ����0 �jG��^��J��>H0��֟�@��}�(�1�e;0dj��t��_1ke�+Bj�� � �e�O���|�V��sH5*a�
�8�U�q�ѲF`�A$�Etz�jc�I��=��N�R���Ap�&�+��
-�@�t�Lo�|~��V2��Kp�'�����,dRX.YU��z�h�Uog��
#Bg,4�`J�G3,(!K�]^.�����bx�~-�|1lU����Z���XZb�hl�3	�r6��4��3�qi������E�B�~��lg�U��0e%
Ψ�7G�	��=��̔f(8��Y��M����e���>bn��5W-�/���au2�(����L
��P��3I�<�2���2ZH·���9��h����b�p���U��=�K	5Jw\z'����X�ʼ&h�AL�!�s�@��d���N��Нn5"�� /������^�|��K�s�r.]Υ��\��Ng�Q&BmˠAJ)�x`o,>c���;{��m��,������?��^���P>$S��(O��^ ٙ���<<�M��J�;wm�C��7Cܑ���s��;0'N�qܑ�N��Yg�WG�Tr��k#�ȼ����S�h]&D`(�^rUv����b*P�<pG��g+C���C=4��8�$�����RW��\�q���-Z7��BX���k��ni��8P�?�W�`�j8�t^9m[��Wyܬ7�=���Gd$�W}�e��5���G%��������3>�|h�O^��9�8:�ϸF������%&J�@\[�þ�T����F�8���]i�|'�㞉�]��IBӪ�7G�6&S���E3�3L�y��q��e���U;5qCLJ9����>����q=y�V2#u>�p�:x*s����$t +��[��1\8�z����ɽ��'���S?$�1i{����sqj�� Cda�	�a��Q@�>숂�1�h�ZH�|?!��i
�e���t����}-;������	�~�%��^P���W�\�^�A�q�Ъ�na�/���W@N������t��ߟ�η��5Z�w�D��U����d��G��d�__�GF#Х_EK����J�@U�;�5RWKHhL�9*����bc������,�*�j��5_%ugG��J�3��3d/���)H�TYrF� �r�"��͂�Eޱ3�˨"��&+̫P%Y��4�wWl�^Uf*)˪9w��iݭ��΃�p̟�P��8Ce����+W�y\�EI��q�<�jR�S�>gmlg�Red��)ܧl�?=�9ý"�&۷.�%`}���
4�z��RRu����j;�H�iA�
4�f�*:�Ᾰ�f^;�d� 9�"�V�ђe�����JmV�0�����"�}께uvR�of2��H�ͬ��.'�S�6���f,k�+�X@j���V����f%���, �Y5�j�J�b{ג1��K#��<K������Q�B�z��c�����/Qw�(��5���6�W��"��wg�B�R��|j��f7Z :燦-�7��Pׂ���j;�G	�%�G�c�m^�]���x0������nL�R��T�.�R�\R��|��K�s�r.]Υ��\R�e;�Gj3�Jmf��xQ:ݚ�kx��nU�*I�b�Sk�e*�����@��L��v���Q[����)�>m 1\�<	�<L���y���p%�sEmm 1\N� ��l 1\��摮��K+u[�'��?�u���p+ƶ��M݀H��J}$��� џ²@�jgIߞ����p��Tm�F��@b��Ot�ꅻ�#��)�\��7�:6v�8���B�I��.�0|uM}<��h��@�tڱ$�k�tc��6�P[kY�B����Q�j����jg7t٥ܳI�������gu�      �      x������ � �      �      x������ � �      �   *   x�3�4���!sS.CKCd�2��c��1E�!81z\\\ �7      �   7   x�=�9  D�����p�@�uP�wӍk�w�d����u4�P���<^5��l      �      x�320�4��22� Q1z\\\ P�      �      x������ � �      �      x������ � �      �      x�343�45�243�P� *F��� 8B�     