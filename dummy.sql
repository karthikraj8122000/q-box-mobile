--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: qbox_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO qbox_admin;

--
-- Name: masters; Type: SCHEMA; Schema: -; Owner: qbox_admin
--

CREATE SCHEMA masters;


ALTER SCHEMA masters OWNER TO qbox_admin;

--
-- Name: partner_order; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA partner_order;


ALTER SCHEMA partner_order OWNER TO postgres;

--
-- Name: create_app_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_name text:= (in_data->>'appMenuName')::text;
i_parent_menu_sno smallint:= (in_data->>'parentMenuSno')::smallint;
i_href text:= (in_data->>'href')::text;
i_title text:= (in_data->>'title')::text;
i_status boolean:= (in_data->>'status')::boolean;

  i_app_menu_sno  smallint  := 0;
  
begin

INSERT INTO auth.app_menu(
	  app_menu_name,parent_menu_sno,href,title,status)
	VALUES (i_app_menu_name,i_parent_menu_sno,i_href,i_title,i_status) returning app_menu_sno into i_app_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'appMenuSno',app_menu_sno,'appMenuName',app_menu_name,'parentMenuSno',parent_menu_sno,'href',href,'title',title,'status',status
 ))))
 FROM auth.app_menu
 where    app_menu_sno = i_app_menu_sno;
end;
$$;


ALTER FUNCTION auth.create_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_permission_name text:= (in_data->>'appPermissionName')::text;
i_created_at timestamp without time zone:= (in_data->>'createdAt')::timestamp without time zone;

  i_app_permission_sno  bigint  := 0;
  
begin

INSERT INTO auth.app_permission(
	  app_permission_name,created_at)
	VALUES (i_app_permission_name,i_created_at) returning app_permission_sno into i_app_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'appPermissionSno',app_permission_sno,'appPermissionName',app_permission_name,'createdAt',created_at
 ))))
 FROM auth.app_permission
 where    app_permission_sno = i_app_permission_sno;
end;
$$;


ALTER FUNCTION auth.create_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_role_name text:= (in_data->>'appRoleName')::text;
i_status boolean:= (in_data->>'status')::boolean;

  i_app_role_sno  smallint  := 0;
  
begin

INSERT INTO auth.app_role(
	  app_role_name,status)
	VALUES (i_app_role_name,i_status) returning app_role_sno into i_app_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appRoleSno',app_role_sno,'appRoleName',app_role_name,'status',status
 ))))
 FROM auth.app_role
 where    app_role_sno = i_app_role_sno;
end;
$$;


ALTER FUNCTION auth.create_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_user(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_user_id text:= (in_data->>'userId')::text;
i_password text:= (in_data->>'password')::text;
i_status boolean:= (in_data->>'status')::boolean;

  i_app_user_sno  bigint  := 0;
  
begin

INSERT INTO auth.app_user(
	  user_id,password,status)
	VALUES (i_user_id,i_password,i_status) returning app_user_sno into i_app_user_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserSno',app_user_sno,'userId',user_id,'password',password,'status',status
 ))))
 FROM auth.app_user
 where    app_user_sno = i_app_user_sno;
end;
$$;


ALTER FUNCTION auth.create_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_user_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;

  i_app_user_role_sno  bigint  := 0;
  
begin

INSERT INTO auth.app_user_role(
	  app_user_sno,app_role_sno)
	VALUES (i_app_user_sno,i_app_role_sno) returning app_user_role_sno into i_app_user_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserRoleSno',app_user_role_sno,'appUserSno',app_user_sno,'appRoleSno',app_role_sno
 ))))
 FROM auth.app_user_role
 where    app_user_role_sno = i_app_user_role_sno;
end;
$$;


ALTER FUNCTION auth.create_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: create_codes_dtl(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_cd_value text:= (in_data->>'cdValue')::text;
i_seqno integer:= (in_data->>'seqno')::integer;
i_filter_1 text:= (in_data->>'filter1')::text;
i_filter_2 text:= (in_data->>'filter2')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_codes_dtl_sno  smallint  := 0;
  
begin

INSERT INTO auth.codes_dtl(
	  codes_hdr_sno,cd_value,seqno,filter_1,filter_2,active_flag)
	VALUES (i_codes_hdr_sno,i_cd_value,i_seqno,i_filter_1,i_filter_2,i_active_flag) returning codes_dtl_sno into i_codes_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'codesDtlSno',codes_dtl_sno,'codesHdrSno',codes_hdr_sno,'cdValue',cd_value,'seqno',seqno,'filter1',filter_1,'filter2',filter_2,'activeFlag',active_flag
 ))))
 FROM auth.codes_dtl
 where    codes_dtl_sno = i_codes_dtl_sno;
end;
$$;


ALTER FUNCTION auth.create_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: create_codes_hdr(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_code_type text:= (in_data->>'codeType')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_codes_hdr_sno  smallint  := 0;
  
begin

INSERT INTO auth.codes_hdr(
	  code_type,active_flag)
	VALUES (i_code_type,i_active_flag) returning codes_hdr_sno into i_codes_hdr_sno;

 return (select(json_build_object('data',json_build_object(
 'codesHdrSno',codes_hdr_sno,'codeType',code_type,'activeFlag',active_flag
 ))))
 FROM auth.codes_hdr
 where    codes_hdr_sno = i_codes_hdr_sno;
end;
$$;


ALTER FUNCTION auth.create_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: create_menu_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_permission_sno smallint:= (in_data->>'appPermissionSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  i_menu_permission_sno  smallint  := 0;
  
begin

INSERT INTO auth.menu_permission(
	  app_menu_sno,app_permission_sno,status)
	VALUES (i_app_menu_sno,i_app_permission_sno,i_status) returning menu_permission_sno into i_menu_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'menuPermissionSno',menu_permission_sno,'appMenuSno',app_menu_sno,'appPermissionSno',app_permission_sno,'status',status
 ))))
 FROM auth.menu_permission
 where    menu_permission_sno = i_menu_permission_sno;
end;
$$;


ALTER FUNCTION auth.create_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: create_otp(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_sms_otp character varying:= (in_data->>'smsOtp')::character varying;
i_service_otp text:= (in_data->>'serviceOtp')::text;
i_push_otp text:= (in_data->>'pushOtp')::text;
i_device_id text:= (in_data->>'deviceId')::text;
i_otp_expire_time_cd smallint:= (in_data->>'otpExpireTimeCd')::smallint;
i_otp_expire_time timestamp without time zone:= (in_data->>'otpExpireTime')::timestamp without time zone;
i_otp_status boolean:= (in_data->>'otpStatus')::boolean;

  i_otp_sno  bigint  := 0;
  
begin

INSERT INTO auth.otp(
	  app_user_sno,sms_otp,service_otp,push_otp,device_id,otp_expire_time_cd,otp_expire_time,otp_status)
	VALUES (i_app_user_sno,i_sms_otp,i_service_otp,i_push_otp,i_device_id,i_otp_expire_time_cd,i_otp_expire_time,i_otp_status) returning otp_sno into i_otp_sno;

 return (select(json_build_object('data',json_build_object(
 'otpSno',otp_sno,'appUserSno',app_user_sno,'smsOtp',sms_otp,'serviceOtp',service_otp,'pushOtp',push_otp,'deviceId',device_id,'otpExpireTimeCd',otp_expire_time_cd,'otpExpireTime',otp_expire_time,'otpStatus',otp_status
 ))))
 FROM auth.otp
 where    otp_sno = i_otp_sno;
end;
$$;


ALTER FUNCTION auth.create_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: create_role_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  i_role_menu_sno  smallint  := 0;
  
begin

INSERT INTO auth.role_menu(
	  app_menu_sno,app_role_sno,status)
	VALUES (i_app_menu_sno,i_app_role_sno,i_status) returning role_menu_sno into i_role_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'roleMenuSno',role_menu_sno,'appMenuSno',app_menu_sno,'appRoleSno',app_role_sno,'status',status
 ))))
 FROM auth.role_menu
 where    role_menu_sno = i_role_menu_sno;
end;
$$;


ALTER FUNCTION auth.create_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: create_role_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_permission_sno integer:= (in_data->>'appPermissionSno')::integer;

  i_role_permission_sno  bigint  := 0;
  
begin

INSERT INTO auth.role_permission(
	  app_role_sno,app_permission_sno)
	VALUES (i_app_role_sno,i_app_permission_sno) returning role_permission_sno into i_role_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'rolePermissionSno',role_permission_sno,'appRoleSno',app_role_sno,'appPermissionSno',app_permission_sno
 ))))
 FROM auth.role_permission
 where    role_permission_sno = i_role_permission_sno;
end;
$$;


ALTER FUNCTION auth.create_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: create_signin_info(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.create_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_push_token text:= (in_data->>'pushToken')::text;
i_device_type_cd smallint:= (in_data->>'deviceTypeCd')::smallint;
i_device_id text:= (in_data->>'deviceId')::text;
i_login_on timestamp without time zone:= (in_data->>'loginOn')::timestamp without time zone;
i_logout_on timestamp without time zone:= (in_data->>'logoutOn')::timestamp without time zone;

  i_signin_info_sno  bigint  := 0;
  
begin

INSERT INTO auth.signin_info(
	  app_user_sno,push_token,device_type_cd,device_id,login_on,logout_on)
	VALUES (i_app_user_sno,i_push_token,i_device_type_cd,i_device_id,i_login_on,i_logout_on) returning signin_info_sno into i_signin_info_sno;

 return (select(json_build_object('data',json_build_object(
 'signinInfoSno',signin_info_sno,'appUserSno',app_user_sno,'pushToken',push_token,'deviceTypeCd',device_type_cd,'deviceId',device_id,'loginOn',login_on,'logoutOn',logout_on
 ))))
 FROM auth.signin_info
 where    signin_info_sno = i_signin_info_sno;
end;
$$;


ALTER FUNCTION auth.create_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_name text;
i_parent_menu_sno smallint;
i_href text;
i_title text;
i_status boolean;

  i_app_menu_sno smallint  := (in_data->>'appMenuSno')::smallint;
  
begin
  Select app_menu_name into i_app_menu_name from auth.app_menu where app_menu_sno = i_app_menu_sno;
Select parent_menu_sno into i_parent_menu_sno from auth.app_menu where app_menu_sno = i_app_menu_sno;
Select href into i_href from auth.app_menu where app_menu_sno = i_app_menu_sno;
Select title into i_title from auth.app_menu where app_menu_sno = i_app_menu_sno;
Select status into i_status from auth.app_menu where app_menu_sno = i_app_menu_sno;

DELETE from auth.app_menu where app_menu_sno = i_app_menu_sno;

return (select(json_build_object('data',json_build_object(
 'appMenuSno',i_app_menu_sno,'appMenuName',i_app_menu_name,'parentMenuSno',i_parent_menu_sno,'href',i_href,'title',i_title,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION auth.delete_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_permission_name text;
i_created_at timestamp without time zone;

  i_app_permission_sno bigint  := (in_data->>'appPermissionSno')::bigint;
  
begin
  Select app_permission_name into i_app_permission_name from auth.app_permission where app_permission_sno = i_app_permission_sno;
Select created_at into i_created_at from auth.app_permission where app_permission_sno = i_app_permission_sno;

DELETE from auth.app_permission where app_permission_sno = i_app_permission_sno;

return (select(json_build_object('data',json_build_object(
 'appPermissionSno',i_app_permission_sno,'appPermissionName',i_app_permission_name,'createdAt',i_created_at
 ))));
end;
$$;


ALTER FUNCTION auth.delete_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_role_name text;
i_status boolean;

  i_app_role_sno smallint  := (in_data->>'appRoleSno')::smallint;
  
begin
  Select app_role_name into i_app_role_name from auth.app_role where app_role_sno = i_app_role_sno;
Select status into i_status from auth.app_role where app_role_sno = i_app_role_sno;

DELETE from auth.app_role where app_role_sno = i_app_role_sno;

return (select(json_build_object('data',json_build_object(
 'appRoleSno',i_app_role_sno,'appRoleName',i_app_role_name,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION auth.delete_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_user(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_user_id text;
i_password text;
i_status boolean;

  i_app_user_sno bigint  := (in_data->>'appUserSno')::bigint;
  
begin
  Select user_id into i_user_id from auth.app_user where app_user_sno = i_app_user_sno;
Select password into i_password from auth.app_user where app_user_sno = i_app_user_sno;
Select status into i_status from auth.app_user where app_user_sno = i_app_user_sno;

DELETE from auth.app_user where app_user_sno = i_app_user_sno;

return (select(json_build_object('data',json_build_object(
 'appUserSno',i_app_user_sno,'userId',i_user_id,'password',i_password,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION auth.delete_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_user_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint;
i_app_role_sno smallint;

  i_app_user_role_sno bigint  := (in_data->>'appUserRoleSno')::bigint;
  
begin
  Select app_user_sno into i_app_user_sno from auth.app_user_role where app_user_role_sno = i_app_user_role_sno;
Select app_role_sno into i_app_role_sno from auth.app_user_role where app_user_role_sno = i_app_user_role_sno;

DELETE from auth.app_user_role where app_user_role_sno = i_app_user_role_sno;

return (select(json_build_object('data',json_build_object(
 'appUserRoleSno',i_app_user_role_sno,'appUserSno',i_app_user_sno,'appRoleSno',i_app_role_sno
 ))));
end;
$$;


ALTER FUNCTION auth.delete_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_codes_dtl(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_codes_hdr_sno smallint;
i_cd_value text;
i_seqno integer;
i_filter_1 text;
i_filter_2 text;
i_active_flag boolean;

  i_codes_dtl_sno smallint  := (in_data->>'codesDtlSno')::smallint;
  
begin
  Select codes_hdr_sno into i_codes_hdr_sno from auth.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select cd_value into i_cd_value from auth.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select seqno into i_seqno from auth.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select filter_1 into i_filter_1 from auth.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select filter_2 into i_filter_2 from auth.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select active_flag into i_active_flag from auth.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;

DELETE from auth.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;

return (select(json_build_object('data',json_build_object(
 'codesDtlSno',i_codes_dtl_sno,'codesHdrSno',i_codes_hdr_sno,'cdValue',i_cd_value,'seqno',i_seqno,'filter1',i_filter_1,'filter2',i_filter_2,'activeFlag',i_active_flag
 ))));
end;
$$;


ALTER FUNCTION auth.delete_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_codes_hdr(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_code_type text;
i_active_flag boolean;

  i_codes_hdr_sno smallint  := (in_data->>'codesHdrSno')::smallint;
  
begin
  Select code_type into i_code_type from auth.codes_hdr where codes_hdr_sno = i_codes_hdr_sno;
Select active_flag into i_active_flag from auth.codes_hdr where codes_hdr_sno = i_codes_hdr_sno;

DELETE from auth.codes_hdr where codes_hdr_sno = i_codes_hdr_sno;

return (select(json_build_object('data',json_build_object(
 'codesHdrSno',i_codes_hdr_sno,'codeType',i_code_type,'activeFlag',i_active_flag
 ))));
end;
$$;


ALTER FUNCTION auth.delete_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_menu_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_sno smallint;
i_app_permission_sno smallint;
i_status boolean;

  i_menu_permission_sno smallint  := (in_data->>'menuPermissionSno')::smallint;
  
begin
  Select app_menu_sno into i_app_menu_sno from auth.menu_permission where menu_permission_sno = i_menu_permission_sno;
Select app_permission_sno into i_app_permission_sno from auth.menu_permission where menu_permission_sno = i_menu_permission_sno;
Select status into i_status from auth.menu_permission where menu_permission_sno = i_menu_permission_sno;

DELETE from auth.menu_permission where menu_permission_sno = i_menu_permission_sno;

return (select(json_build_object('data',json_build_object(
 'menuPermissionSno',i_menu_permission_sno,'appMenuSno',i_app_menu_sno,'appPermissionSno',i_app_permission_sno,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION auth.delete_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_otp(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint;
i_sms_otp character varying;
i_service_otp text;
i_push_otp text;
i_device_id text;
i_otp_expire_time_cd smallint;
i_otp_expire_time timestamp without time zone;
i_otp_status boolean;

  i_otp_sno bigint  := (in_data->>'otpSno')::bigint;
  
begin
  Select app_user_sno into i_app_user_sno from auth.otp where otp_sno = i_otp_sno;
Select sms_otp into i_sms_otp from auth.otp where otp_sno = i_otp_sno;
Select service_otp into i_service_otp from auth.otp where otp_sno = i_otp_sno;
Select push_otp into i_push_otp from auth.otp where otp_sno = i_otp_sno;
Select device_id into i_device_id from auth.otp where otp_sno = i_otp_sno;
Select otp_expire_time_cd into i_otp_expire_time_cd from auth.otp where otp_sno = i_otp_sno;
Select otp_expire_time into i_otp_expire_time from auth.otp where otp_sno = i_otp_sno;
Select otp_status into i_otp_status from auth.otp where otp_sno = i_otp_sno;

DELETE from auth.otp where otp_sno = i_otp_sno;

return (select(json_build_object('data',json_build_object(
 'otpSno',i_otp_sno,'appUserSno',i_app_user_sno,'smsOtp',i_sms_otp,'serviceOtp',i_service_otp,'pushOtp',i_push_otp,'deviceId',i_device_id,'otpExpireTimeCd',i_otp_expire_time_cd,'otpExpireTime',i_otp_expire_time,'otpStatus',i_otp_status
 ))));
end;
$$;


ALTER FUNCTION auth.delete_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_role_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_sno smallint;
i_app_role_sno smallint;
i_status boolean;

  i_role_menu_sno smallint  := (in_data->>'roleMenuSno')::smallint;
  
begin
  Select app_menu_sno into i_app_menu_sno from auth.role_menu where role_menu_sno = i_role_menu_sno;
Select app_role_sno into i_app_role_sno from auth.role_menu where role_menu_sno = i_role_menu_sno;
Select status into i_status from auth.role_menu where role_menu_sno = i_role_menu_sno;

DELETE from auth.role_menu where role_menu_sno = i_role_menu_sno;

return (select(json_build_object('data',json_build_object(
 'roleMenuSno',i_role_menu_sno,'appMenuSno',i_app_menu_sno,'appRoleSno',i_app_role_sno,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION auth.delete_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_role_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_role_sno smallint;
i_app_permission_sno integer;

  i_role_permission_sno bigint  := (in_data->>'rolePermissionSno')::bigint;
  
begin
  Select app_role_sno into i_app_role_sno from auth.role_permission where role_permission_sno = i_role_permission_sno;
Select app_permission_sno into i_app_permission_sno from auth.role_permission where role_permission_sno = i_role_permission_sno;

DELETE from auth.role_permission where role_permission_sno = i_role_permission_sno;

return (select(json_build_object('data',json_build_object(
 'rolePermissionSno',i_role_permission_sno,'appRoleSno',i_app_role_sno,'appPermissionSno',i_app_permission_sno
 ))));
end;
$$;


ALTER FUNCTION auth.delete_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_signin_info(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.delete_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint;
i_push_token text;
i_device_type_cd smallint;
i_device_id text;
i_login_on timestamp without time zone;
i_logout_on timestamp without time zone;

  i_signin_info_sno bigint  := (in_data->>'signinInfoSno')::bigint;
  
begin
  Select app_user_sno into i_app_user_sno from auth.signin_info where signin_info_sno = i_signin_info_sno;
Select push_token into i_push_token from auth.signin_info where signin_info_sno = i_signin_info_sno;
Select device_type_cd into i_device_type_cd from auth.signin_info where signin_info_sno = i_signin_info_sno;
Select device_id into i_device_id from auth.signin_info where signin_info_sno = i_signin_info_sno;
Select login_on into i_login_on from auth.signin_info where signin_info_sno = i_signin_info_sno;
Select logout_on into i_logout_on from auth.signin_info where signin_info_sno = i_signin_info_sno;

DELETE from auth.signin_info where signin_info_sno = i_signin_info_sno;

return (select(json_build_object('data',json_build_object(
 'signinInfoSno',i_signin_info_sno,'appUserSno',i_app_user_sno,'pushToken',i_push_token,'deviceTypeCd',i_device_type_cd,'deviceId',i_device_id,'loginOn',i_login_on,'logoutOn',i_logout_on
 ))));
end;
$$;


ALTER FUNCTION auth.delete_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_menu_name text:= (in_data->>'appMenuName')::text;
i_parent_menu_sno smallint:= (in_data->>'parentMenuSno')::smallint;
i_href text:= (in_data->>'href')::text;
i_title text:= (in_data->>'title')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

UPDATE auth.app_menu SET app_menu_name= i_app_menu_name ,parent_menu_sno= i_parent_menu_sno ,href= i_href ,title= i_title ,status= i_status where app_menu_sno = i_app_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'appMenuSno',app_menu_sno,'appMenuName',app_menu_name,'parentMenuSno',parent_menu_sno,'href',href,'title',title,'status',status
 ))))
 FROM auth.app_menu
 where    app_menu_sno = i_app_menu_sno;
end;
$$;


ALTER FUNCTION auth.edit_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_permission_sno bigint:= (in_data->>'appPermissionSno')::bigint;
i_app_permission_name text:= (in_data->>'appPermissionName')::text;
i_created_at timestamp without time zone:= (in_data->>'createdAt')::timestamp without time zone;

  
begin

UPDATE auth.app_permission SET app_permission_name= i_app_permission_name ,created_at= i_created_at where app_permission_sno = i_app_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'appPermissionSno',app_permission_sno,'appPermissionName',app_permission_name,'createdAt',created_at
 ))))
 FROM auth.app_permission
 where    app_permission_sno = i_app_permission_sno;
end;
$$;


ALTER FUNCTION auth.edit_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_role_name text:= (in_data->>'appRoleName')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

UPDATE auth.app_role SET app_role_name= i_app_role_name ,status= i_status where app_role_sno = i_app_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appRoleSno',app_role_sno,'appRoleName',app_role_name,'status',status
 ))))
 FROM auth.app_role
 where    app_role_sno = i_app_role_sno;
end;
$$;


ALTER FUNCTION auth.edit_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_user(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_user_id text:= (in_data->>'userId')::text;
i_password text:= (in_data->>'password')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

UPDATE auth.app_user SET user_id= i_user_id ,password= i_password ,status= i_status where app_user_sno = i_app_user_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserSno',app_user_sno,'userId',user_id,'password',password,'status',status
 ))))
 FROM auth.app_user
 where    app_user_sno = i_app_user_sno;
end;
$$;


ALTER FUNCTION auth.edit_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_user_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_role_sno bigint:= (in_data->>'appUserRoleSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;

  
begin

UPDATE auth.app_user_role SET app_user_sno= i_app_user_sno ,app_role_sno= i_app_role_sno where app_user_role_sno = i_app_user_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserRoleSno',app_user_role_sno,'appUserSno',app_user_sno,'appRoleSno',app_role_sno
 ))))
 FROM auth.app_user_role
 where    app_user_role_sno = i_app_user_role_sno;
end;
$$;


ALTER FUNCTION auth.edit_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_codes_dtl(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_codes_dtl_sno smallint:= (in_data->>'codesDtlSno')::smallint;
i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_cd_value text:= (in_data->>'cdValue')::text;
i_seqno integer:= (in_data->>'seqno')::integer;
i_filter_1 text:= (in_data->>'filter1')::text;
i_filter_2 text:= (in_data->>'filter2')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE auth.codes_dtl SET codes_hdr_sno= i_codes_hdr_sno ,cd_value= i_cd_value ,seqno= i_seqno ,filter_1= i_filter_1 ,filter_2= i_filter_2 ,active_flag= i_active_flag where codes_dtl_sno = i_codes_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'codesDtlSno',codes_dtl_sno,'codesHdrSno',codes_hdr_sno,'cdValue',cd_value,'seqno',seqno,'filter1',filter_1,'filter2',filter_2,'activeFlag',active_flag
 ))))
 FROM auth.codes_dtl
 where    codes_dtl_sno = i_codes_dtl_sno;
end;
$$;


ALTER FUNCTION auth.edit_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_codes_hdr(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_code_type text:= (in_data->>'codeType')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE auth.codes_hdr SET code_type= i_code_type ,active_flag= i_active_flag where codes_hdr_sno = i_codes_hdr_sno;

 return (select(json_build_object('data',json_build_object(
 'codesHdrSno',codes_hdr_sno,'codeType',code_type,'activeFlag',active_flag
 ))))
 FROM auth.codes_hdr
 where    codes_hdr_sno = i_codes_hdr_sno;
end;
$$;


ALTER FUNCTION auth.edit_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_menu_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_menu_permission_sno smallint:= (in_data->>'menuPermissionSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_permission_sno smallint:= (in_data->>'appPermissionSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

UPDATE auth.menu_permission SET app_menu_sno= i_app_menu_sno ,app_permission_sno= i_app_permission_sno ,status= i_status where menu_permission_sno = i_menu_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'menuPermissionSno',menu_permission_sno,'appMenuSno',app_menu_sno,'appPermissionSno',app_permission_sno,'status',status
 ))))
 FROM auth.menu_permission
 where    menu_permission_sno = i_menu_permission_sno;
end;
$$;


ALTER FUNCTION auth.edit_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_otp(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_otp_sno bigint:= (in_data->>'otpSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_sms_otp character varying:= (in_data->>'smsOtp')::character varying;
i_service_otp text:= (in_data->>'serviceOtp')::text;
i_push_otp text:= (in_data->>'pushOtp')::text;
i_device_id text:= (in_data->>'deviceId')::text;
i_otp_expire_time_cd smallint:= (in_data->>'otpExpireTimeCd')::smallint;
i_otp_expire_time timestamp without time zone:= (in_data->>'otpExpireTime')::timestamp without time zone;
i_otp_status boolean:= (in_data->>'otpStatus')::boolean;

  
begin

UPDATE auth.otp SET app_user_sno= i_app_user_sno ,sms_otp= i_sms_otp ,service_otp= i_service_otp ,push_otp= i_push_otp ,device_id= i_device_id ,otp_expire_time_cd= i_otp_expire_time_cd ,otp_expire_time= i_otp_expire_time ,otp_status= i_otp_status where otp_sno = i_otp_sno;

 return (select(json_build_object('data',json_build_object(
 'otpSno',otp_sno,'appUserSno',app_user_sno,'smsOtp',sms_otp,'serviceOtp',service_otp,'pushOtp',push_otp,'deviceId',device_id,'otpExpireTimeCd',otp_expire_time_cd,'otpExpireTime',otp_expire_time,'otpStatus',otp_status
 ))))
 FROM auth.otp
 where    otp_sno = i_otp_sno;
end;
$$;


ALTER FUNCTION auth.edit_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_role_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_role_menu_sno smallint:= (in_data->>'roleMenuSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

UPDATE auth.role_menu SET app_menu_sno= i_app_menu_sno ,app_role_sno= i_app_role_sno ,status= i_status where role_menu_sno = i_role_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'roleMenuSno',role_menu_sno,'appMenuSno',app_menu_sno,'appRoleSno',app_role_sno,'status',status
 ))))
 FROM auth.role_menu
 where    role_menu_sno = i_role_menu_sno;
end;
$$;


ALTER FUNCTION auth.edit_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_role_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_role_permission_sno bigint:= (in_data->>'rolePermissionSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_permission_sno integer:= (in_data->>'appPermissionSno')::integer;

  
begin

UPDATE auth.role_permission SET app_role_sno= i_app_role_sno ,app_permission_sno= i_app_permission_sno where role_permission_sno = i_role_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'rolePermissionSno',role_permission_sno,'appRoleSno',app_role_sno,'appPermissionSno',app_permission_sno
 ))))
 FROM auth.role_permission
 where    role_permission_sno = i_role_permission_sno;
end;
$$;


ALTER FUNCTION auth.edit_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_signin_info(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.edit_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_signin_info_sno bigint:= (in_data->>'signinInfoSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_push_token text:= (in_data->>'pushToken')::text;
i_device_type_cd smallint:= (in_data->>'deviceTypeCd')::smallint;
i_device_id text:= (in_data->>'deviceId')::text;
i_login_on timestamp without time zone:= (in_data->>'loginOn')::timestamp without time zone;
i_logout_on timestamp without time zone:= (in_data->>'logoutOn')::timestamp without time zone;

  
begin

UPDATE auth.signin_info SET app_user_sno= i_app_user_sno ,push_token= i_push_token ,device_type_cd= i_device_type_cd ,device_id= i_device_id ,login_on= i_login_on ,logout_on= i_logout_on where signin_info_sno = i_signin_info_sno;

 return (select(json_build_object('data',json_build_object(
 'signinInfoSno',signin_info_sno,'appUserSno',app_user_sno,'pushToken',push_token,'deviceTypeCd',device_type_cd,'deviceId',device_id,'loginOn',login_on,'logoutOn',logout_on
 ))))
 FROM auth.signin_info
 where    signin_info_sno = i_signin_info_sno;
end;
$$;


ALTER FUNCTION auth.edit_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_menu_name text:= (in_data->>'appMenuName')::text;
i_parent_menu_sno smallint:= (in_data->>'parentMenuSno')::smallint;
i_href text:= (in_data->>'href')::text;
i_title text:= (in_data->>'title')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'appMenuSno',app_menu_sno,'appMenuName',app_menu_name,'parentMenuSno',parent_menu_sno,'href',href,'title',title,'status',status
 )))
 FROM auth.app_menu
 where    
  case when i_app_menu_sno isnull then 1=1 else app_menu_sno = i_app_menu_sno end and 
  case when i_app_menu_name isnull then 1=1 else app_menu_name = i_app_menu_name end and 
  case when i_parent_menu_sno isnull then 1=1 else parent_menu_sno = i_parent_menu_sno end and 
  case when i_href isnull then 1=1 else href = i_href end and 
  case when i_title isnull then 1=1 else title = i_title end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_permission_sno bigint:= (in_data->>'appPermissionSno')::bigint;
i_app_permission_name text:= (in_data->>'appPermissionName')::text;
i_created_at timestamp without time zone:= (in_data->>'createdAt')::timestamp without time zone;

  
begin

 return (select json_agg(json_build_object(
 'appPermissionSno',app_permission_sno,'appPermissionName',app_permission_name,'createdAt',created_at
 )))
 FROM auth.app_permission
 where    
  case when i_app_permission_sno isnull then 1=1 else app_permission_sno = i_app_permission_sno end and 
  case when i_app_permission_name isnull then 1=1 else app_permission_name = i_app_permission_name end and 
  case when i_created_at isnull then 1=1 else created_at = i_created_at end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_role_name text:= (in_data->>'appRoleName')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'appRoleSno',app_role_sno,'appRoleName',app_role_name,'status',status
 )))
 FROM auth.app_role
 where    
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
  case when i_app_role_name isnull then 1=1 else app_role_name = i_app_role_name end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_user(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_user_id text:= (in_data->>'userId')::text;
i_password text:= (in_data->>'password')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'appUserSno',app_user_sno,'userId',user_id,'password',password,'status',status
 )))
 FROM auth.app_user
 where    
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_user_id isnull then 1=1 else user_id = i_user_id end and 
  case when i_password isnull then 1=1 else password = i_password end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_user_role(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_role_sno bigint:= (in_data->>'appUserRoleSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;

  
begin

 return (select json_agg(json_build_object(
 'appUserRoleSno',app_user_role_sno,'appUserSno',app_user_sno,'appRoleSno',app_role_sno
 )))
 FROM auth.app_user_role
 where    
  case when i_app_user_role_sno isnull then 1=1 else app_user_role_sno = i_app_user_role_sno end and 
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: search_codes_dtl(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_codes_dtl_sno smallint:= (in_data->>'codesDtlSno')::smallint;
i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_cd_value text:= (in_data->>'cdValue')::text;
i_seqno integer:= (in_data->>'seqno')::integer;
i_filter_1 text:= (in_data->>'filter1')::text;
i_filter_2 text:= (in_data->>'filter2')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'codesDtlSno',codes_dtl_sno,'codesHdrSno',codes_hdr_sno,'cdValue',cd_value,'seqno',seqno,'filter1',filter_1,'filter2',filter_2,'activeFlag',active_flag
 )))
 FROM auth.codes_dtl
 where    
  case when i_codes_dtl_sno isnull then 1=1 else codes_dtl_sno = i_codes_dtl_sno end and 
  case when i_codes_hdr_sno isnull then 1=1 else codes_hdr_sno = i_codes_hdr_sno end and 
  case when i_cd_value isnull then 1=1 else cd_value = i_cd_value end and 
  case when i_seqno isnull then 1=1 else seqno = i_seqno end and 
  case when i_filter_1 isnull then 1=1 else filter_1 = i_filter_1 end and 
  case when i_filter_2 isnull then 1=1 else filter_2 = i_filter_2 end and 
  case when i_active_flag isnull then 1=1 else active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: search_codes_hdr(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_code_type text:= (in_data->>'codeType')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'codesHdrSno',codes_hdr_sno,'codeType',code_type,'activeFlag',active_flag
 )))
 FROM auth.codes_hdr
 where    
  case when i_codes_hdr_sno isnull then 1=1 else codes_hdr_sno = i_codes_hdr_sno end and 
  case when i_code_type isnull then 1=1 else code_type = i_code_type end and 
  case when i_active_flag isnull then 1=1 else active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: search_menu_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_menu_permission_sno smallint:= (in_data->>'menuPermissionSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_permission_sno smallint:= (in_data->>'appPermissionSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'menuPermissionSno',menu_permission_sno,'appMenuSno',app_menu_sno,'appPermissionSno',app_permission_sno,'status',status
 )))
 FROM auth.menu_permission
 where    
  case when i_menu_permission_sno isnull then 1=1 else menu_permission_sno = i_menu_permission_sno end and 
  case when i_app_menu_sno isnull then 1=1 else app_menu_sno = i_app_menu_sno end and 
  case when i_app_permission_sno isnull then 1=1 else app_permission_sno = i_app_permission_sno end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: search_otp(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_otp_sno bigint:= (in_data->>'otpSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_sms_otp character varying:= (in_data->>'smsOtp')::character varying;
i_service_otp text:= (in_data->>'serviceOtp')::text;
i_push_otp text:= (in_data->>'pushOtp')::text;
i_device_id text:= (in_data->>'deviceId')::text;
i_otp_expire_time_cd smallint:= (in_data->>'otpExpireTimeCd')::smallint;
i_otp_expire_time timestamp without time zone:= (in_data->>'otpExpireTime')::timestamp without time zone;
i_otp_status boolean:= (in_data->>'otpStatus')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'otpSno',otp_sno,'appUserSno',app_user_sno,'smsOtp',sms_otp,'serviceOtp',service_otp,'pushOtp',push_otp,'deviceId',device_id,'otpExpireTimeCd',otp_expire_time_cd,'otpExpireTime',otp_expire_time,'otpStatus',otp_status
 )))
 FROM auth.otp
 where    
  case when i_otp_sno isnull then 1=1 else otp_sno = i_otp_sno end and 
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_sms_otp isnull then 1=1 else sms_otp = i_sms_otp end and 
  case when i_service_otp isnull then 1=1 else service_otp = i_service_otp end and 
  case when i_push_otp isnull then 1=1 else push_otp = i_push_otp end and 
  case when i_device_id isnull then 1=1 else device_id = i_device_id end and 
  case when i_otp_expire_time_cd isnull then 1=1 else otp_expire_time_cd = i_otp_expire_time_cd end and 
  case when i_otp_expire_time isnull then 1=1 else otp_expire_time = i_otp_expire_time end and 
  case when i_otp_status isnull then 1=1 else otp_status = i_otp_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: search_role_menu(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_role_menu_sno smallint:= (in_data->>'roleMenuSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'roleMenuSno',role_menu_sno,'appMenuSno',app_menu_sno,'appRoleSno',app_role_sno,'status',status
 )))
 FROM auth.role_menu
 where    
  case when i_role_menu_sno isnull then 1=1 else role_menu_sno = i_role_menu_sno end and 
  case when i_app_menu_sno isnull then 1=1 else app_menu_sno = i_app_menu_sno end and 
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: search_role_permission(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_role_permission_sno bigint:= (in_data->>'rolePermissionSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_permission_sno integer:= (in_data->>'appPermissionSno')::integer;

  
begin

 return (select json_agg(json_build_object(
 'rolePermissionSno',role_permission_sno,'appRoleSno',app_role_sno,'appPermissionSno',app_permission_sno
 )))
 FROM auth.role_permission
 where    
  case when i_role_permission_sno isnull then 1=1 else role_permission_sno = i_role_permission_sno end and 
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
  case when i_app_permission_sno isnull then 1=1 else app_permission_sno = i_app_permission_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: search_signin_info(json); Type: FUNCTION; Schema: auth; Owner: qbox_admin
--

CREATE FUNCTION auth.search_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_signin_info_sno bigint:= (in_data->>'signinInfoSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_push_token text:= (in_data->>'pushToken')::text;
i_device_type_cd smallint:= (in_data->>'deviceTypeCd')::smallint;
i_device_id text:= (in_data->>'deviceId')::text;
i_login_on timestamp without time zone:= (in_data->>'loginOn')::timestamp without time zone;
i_logout_on timestamp without time zone:= (in_data->>'logoutOn')::timestamp without time zone;

  
begin

 return (select json_agg(json_build_object(
 'signinInfoSno',signin_info_sno,'appUserSno',app_user_sno,'pushToken',push_token,'deviceTypeCd',device_type_cd,'deviceId',device_id,'loginOn',login_on,'logoutOn',logout_on
 )))
 FROM auth.signin_info
 where    
  case when i_signin_info_sno isnull then 1=1 else signin_info_sno = i_signin_info_sno end and 
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_push_token isnull then 1=1 else push_token = i_push_token end and 
  case when i_device_type_cd isnull then 1=1 else device_type_cd = i_device_type_cd end and 
  case when i_device_id isnull then 1=1 else device_id = i_device_id end and 
  case when i_login_on isnull then 1=1 else login_on = i_login_on end and 
  case when i_logout_on isnull then 1=1 else logout_on = i_logout_on end and 
 1=1; 
end;
$$;


ALTER FUNCTION auth.search_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: accept_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.accept_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
	_result json;
 begin
 
	if i_sku_inventory_sno is not null
	THEN

	UPDATE masters.sku_inventory SET wf_stage_cd = 10 where sku_inventory_sno = i_sku_inventory_sno;
	
	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description) SELECT 
	i_sku_inventory_sno,9,CURRENT_TIMESTAMP,1, unique_code from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
	
	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description) SELECT 
	i_sku_inventory_sno,10,CURRENT_TIMESTAMP,1, unique_code from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
	
	END IF;
	
	 RETURN (SELECT json_agg(json_build_object(
                'skuInventorySno', sku_inventory_sno,
                'purchaseOrderDtlSno', purchase_order_dtl_sno,
                'uniqueCode', unique_code,
                'salesOrderDtlSno', sales_order_dtl_sno,
                'wfStageCd', wf_stage_cd
            ))
            FROM (
                SELECT 
                    sku_inventory_sno,
                    purchase_order_dtl_sno,
                    unique_code,
                    sales_order_dtl_sno,
                    wf_stage_cd
                FROM 
                    masters.sku_inventory
                WHERE 
                    purchase_order_dtl_sno IN (
                        SELECT purchase_order_dtl_sno 
                        FROM masters.sku_inventory 
                        WHERE sku_inventory_sno = i_sku_inventory_sno
                    )
                ORDER BY sku_inventory_sno  -- Ordering within the subquery
            ) AS subquery
        );

end;
$$;


ALTER FUNCTION masters.accept_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: clean_up(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.clean_up(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	_result json;
 begin

DELETE FROM masters.box_cell_food;
DELETE FROM masters.box_cell_food_hist;
DELETE FROM masters.sku_trace_wf;
DELETE FROM masters.sku_inventory;
DELETE FROM masters.purchase_order_dtl;
DELETE FROM masters.purchase_order;
DELETE FROM masters.sales_order_dtl;
DELETE FROM masters.sales_order;

	
	 RETURN (SELECT json_build_object(
                'cleanUp',  'Success'
            ));
end;
$$;


ALTER FUNCTION masters.clean_up(in_data json) OWNER TO qbox_admin;

--
-- Name: create_address(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_address(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
i_line1 text:= (in_data->>'line1')::text;
i_line2 text:= (in_data->>'line2')::text;
i_area_sno integer:= (in_data->>'areaSno')::integer;
i_city_sno integer:= (in_data->>'citySno')::integer;
i_geo_loc_code text:= (in_data->>'geoLocCode')::text;
i_description text:=(in_data->>'description')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_address_sno  bigint  := 0;
  
begin

INSERT INTO masters.address(
	  line1,line2,area_sno,city_sno,geo_loc_code,description,active_flag)
	VALUES (i_line1,i_line2,i_area_sno,i_city_sno,i_geo_loc_code,i_description,i_active_flag) returning address_sno into i_address_sno;

 return (select(json_build_object('data',json_build_object(
 'addressSno',address_sno,'line1',line1,'line2',line2,'areaSno',area_sno,'citySno',city_sno,'geoLocCode',geo_loc_code,'description',description,'activeFlag',active_flag
 ))))
 FROM masters.address
 where    address_sno = i_address_sno;
end;
$$;


ALTER FUNCTION masters.create_address(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_name text:= (in_data->>'appMenuName')::text;
i_parent_menu_sno smallint:= (in_data->>'parentMenuSno')::smallint;
i_href text:= (in_data->>'href')::text;
i_title text:= (in_data->>'title')::text;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_app_menu_sno  smallint  := 0;
  
begin

INSERT INTO masters.app_menu(
	  app_menu_name,parent_menu_sno,href,title,status,active_flag)
	VALUES (i_app_menu_name,i_parent_menu_sno,i_href,i_title,i_status,i_active_flag) returning app_menu_sno into i_app_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'appMenuSno',app_menu_sno,'appMenuName',app_menu_name,'parentMenuSno',parent_menu_sno,'href',href,'title',title,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.app_menu
 where    app_menu_sno = i_app_menu_sno;
end;
$$;


ALTER FUNCTION masters.create_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_permission_name text:= (in_data->>'appPermissionName')::text;
i_created_at timestamp without time zone:= (in_data->>'createdAt')::timestamp without time zone;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_app_permission_sno  bigint  := 0;
  
begin

INSERT INTO masters.app_permission(
	  app_permission_name,created_at,active_flag)
	VALUES (i_app_permission_name,i_created_at,i_active_flag) returning app_permission_sno into i_app_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'appPermissionSno',app_permission_sno,'appPermissionName',app_permission_name,'createdAt',created_at,'activeFalg',active_flag
 ))))
 FROM masters.app_permission
 where    app_permission_sno = i_app_permission_sno;
end;
$$;


ALTER FUNCTION masters.create_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_role_name text:= (in_data->>'appRoleName')::text;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_app_role_sno  smallint  := 0;
  
begin

INSERT INTO masters.app_role(
	  app_role_name,status,active_flag)
	VALUES (i_app_role_name,i_status,i_active_flag) returning app_role_sno into i_app_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appRoleSno',app_role_sno,'appRoleName',app_role_name,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.app_role
 where    app_role_sno = i_app_role_sno;
end;
$$;


ALTER FUNCTION masters.create_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_user(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_user_id text:= (in_data->>'userId')::text;
i_password text:= (in_data->>'password')::text;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_app_user_sno  bigint  := 0;
  
begin

INSERT INTO masters.app_user(
	  user_id,password,status,active_flag)
	VALUES (i_user_id,i_password,i_status,i_active_flag) returning app_user_sno into i_app_user_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserSno',app_user_sno,'userId',user_id,'password',password,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.app_user
 where    app_user_sno = i_app_user_sno;
end;
$$;


ALTER FUNCTION masters.create_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: create_app_user_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_app_user_role_sno  bigint  := 0;
  
begin

INSERT INTO masters.app_user_role(
	  app_user_sno,app_role_sno,active_flag)
	VALUES (i_app_user_sno,i_app_role_sno,i_active_flag) returning app_user_role_sno into i_app_user_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserRoleSno',app_user_role_sno,'appUserSno',app_user_sno,'appRoleSno',app_role_sno,'activeFlag',active_flag
 ))))
 FROM masters.app_user_role
 where    app_user_role_sno = i_app_user_role_sno;
end;
$$;


ALTER FUNCTION masters.create_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: create_area(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_area(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_city_sno integer:= (in_data->>'citySno')::integer;
i_name text:= (in_data->>'name')::text;
i_pincode text:= (in_data->>'pincode')::text;

  i_area_sno  bigint  := 0;
  
begin

INSERT INTO masters.area(
	  country_sno,state_sno,city_sno,name,pincode)
	VALUES (i_country_sno,i_state_sno,i_city_sno,i_name,i_pincode) returning area_sno into i_area_sno;

 return (select(json_build_object('data',json_build_object(
 'areaSno',area_sno,'countrySno',country_sno,'stateSno',state_sno,'citySno',city_sno,'name',name,'pincode',pincode
 ))))
 FROM masters.area
 where    area_sno = i_area_sno;
end;
$$;


ALTER FUNCTION masters.create_area(in_data json) OWNER TO qbox_admin;

--
-- Name: create_box_cell(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_box_cell(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
i_row_no smallint:= (in_data->>'rowNo')::smallint;
i_column_no smallint:= (in_data->>'columnNo')::smallint;
i_box_cell_status_cd smallint:= (in_data->>'boxCellStatusCd')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_box_cell_sno  bigint  := 0;
  
begin

INSERT INTO masters.box_cell(
	  qbox_entity_sno,entity_infra_sno,row_no,column_no,box_cell_status_cd,active_flag)
	VALUES (i_qbox_entity_sno,i_entity_infra_sno,i_row_no,i_column_no,i_box_cell_status_cd,i_active_flag) returning box_cell_sno into i_box_cell_sno;

 return (select(json_build_object('data',json_build_object(
 'boxCellSno',box_cell_sno,'qboxEntitySno',qbox_entity_sno,'entityInfraSno',entity_infra_sno,'rowNo',row_no,'columnNo',column_no,'boxCellStatusCd',box_cell_status_cd,
 'activeFlag',active_flag
 ))))
 FROM masters.box_cell
 where    box_cell_sno = i_box_cell_sno;
end;
$$;


ALTER FUNCTION masters.create_box_cell(in_data json) OWNER TO qbox_admin;

--
-- Name: create_box_cell_food(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_box_cell_food(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_box_cell_sno smallint:= (in_data->>'boxCellSno')::smallint;
i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_entry_time timestamp without time zone:= (in_data->>'entryTime')::timestamp without time zone;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_box_cell_food_sno  bigint  := 0;
  
begin

INSERT INTO masters.box_cell_food(
	  box_cell_sno,sku_inventory_sno,entry_time,qbox_entity_sno,active_flag)
	VALUES (i_box_cell_sno,i_sku_inventory_sno,i_entry_time,i_qbox_entity_sno,i_active_flag) returning box_cell_food_sno into i_box_cell_food_sno;

 return (select(json_build_object('data',json_build_object(
 'boxCellFoodSno',box_cell_food_sno,'boxCellSno',box_cell_sno,'skuInventorySno',sku_inventory_sno,'entryTime',entry_time,'qboxEntitySno',qbox_entity_sno,
 'activeFlag',active_flag
 ))))
 FROM masters.box_cell_food
 where    box_cell_food_sno = i_box_cell_food_sno;
end;
$$;


ALTER FUNCTION masters.create_box_cell_food(in_data json) OWNER TO qbox_admin;

--
-- Name: create_box_cell_food_hist(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_box_cell_food_hist(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
    i_box_cell_food_sno bigint := (in_data->>'boxCellFoodSno')::bigint;
    i_box_cell_sno smallint := (in_data->>'boxCellSno')::smallint;
    i_sku_inventory_sno bigint := (in_data->>'skuInventorySno')::bigint;
    i_entry_time timestamp without time zone := (in_data->>'entryTime')::timestamp without time zone;
    i_qbox_entity_sno bigint := (in_data->>'qboxEntitySno')::bigint;
    i_active_flag boolean := (in_data->>'activeFlag')::boolean;

    i_box_cell_food_hist_sno bigint := 0;
BEGIN
    INSERT INTO masters.box_cell_food_hist(
        box_cell_food_sno, box_cell_sno, sku_inventory_sno, entry_time, qbox_entity_sno, active_flag)
    VALUES (i_box_cell_food_sno, i_box_cell_sno, i_sku_inventory_sno, i_entry_time, i_qbox_entity_sno, i_active_flag)
    RETURNING box_cell_food_hist_sno INTO i_box_cell_food_hist_sno;

    RETURN (
        SELECT json_build_object(
            'data', json_build_object(
                'boxCellFoodHistSno', i_box_cell_food_hist_sno,
                'boxCellFoodSno', i_box_cell_food_sno,
                'boxCellSno', i_box_cell_sno,
                'skuInventorySno', i_sku_inventory_sno,
                'entryTime', i_entry_time,
                'qboxEntitySno', i_qbox_entity_sno,
                'activeFlag', i_active_flag
            )
        )
    );
END;
$$;


ALTER FUNCTION masters.create_box_cell_food_hist(in_data json) OWNER TO qbox_admin;

--
-- Name: create_city(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_city(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_name text:= (in_data->>'name')::text;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_city_sno  bigint  := 0;
  
begin

INSERT INTO masters.city(
	  country_sno,state_sno,name,active_flag)
	VALUES (i_country_sno,i_state_sno,i_name,i_active_flag) returning city_sno into i_city_sno;

 return (select(json_build_object('data',json_build_object(
 'citySno',city_sno,'countrySno',country_sno,'stateSno',state_sno,'name',name,'activeFlag',active_flag
 ))))
 FROM masters.city
 where    city_sno = i_city_sno;
end;
$$;


ALTER FUNCTION masters.create_city(in_data json) OWNER TO qbox_admin;

--
-- Name: create_codes_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_cd_value text:= (in_data->>'cdValue')::text;
i_seqno integer:= (in_data->>'seqno')::integer;
i_filter_1 text:= (in_data->>'filter1')::text;
i_filter_2 text:= (in_data->>'filter2')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_codes_dtl_sno  smallint  := 0;
  
begin

INSERT INTO masters.codes_dtl(
	  codes_hdr_sno,description,seqno,filter_1,filter_2,active_flag)
	VALUES (i_codes_hdr_sno,i_cd_value,i_seqno,i_filter_1,i_filter_2,i_active_flag) returning codes_dtl_sno into i_codes_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'codesDtlSno',codes_dtl_sno,'codesHdrSno',codes_hdr_sno,'cdValue',description,'seqno',seqno,'filter1',filter_1,'filter2',filter_2,'activeFlag',active_flag
 ))))
 FROM masters.codes_dtl
 where    codes_dtl_sno = i_codes_dtl_sno;
end;
$$;


ALTER FUNCTION masters.create_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: create_codes_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_code_type text:= (in_data->>'codeType')::text;
  i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  i_codes_hdr_sno  smallint  := 0;
  
begin

INSERT INTO masters.codes_hdr(
	  description,active_flag)
	VALUES (i_code_type,i_active_flag) returning codes_hdr_sno into i_codes_hdr_sno;

 return (select(json_build_object('data',json_build_object(
 'codesHdrSno',codes_hdr_sno,'codeType',description,'activeFlag',active_flag
 ))))
 FROM masters.codes_hdr
 where    codes_hdr_sno = i_codes_hdr_sno;
end;
$$;


ALTER FUNCTION masters.create_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: create_country(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_country(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_name text:= (in_data->>'name')::text;
i_iso2 character varying:= (in_data->>'iso2')::character varying;
i_phone_code character varying:= (in_data->>'phoneCode')::character varying;
i_numeric_code character varying:= (in_data->>'numericCode')::character varying;
i_currency_code character varying:= (in_data->>'currencyCode')::character varying;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_country_sno  smallint  := 0;
  
begin

INSERT INTO masters.country(
	  name,iso2,phone_code,numeric_code,currency_code,active_flag)
	VALUES (i_name,i_iso2,i_phone_code,i_numeric_code,i_currency_code,i_active_flag) returning country_sno into i_country_sno;

 return (select(json_build_object('data',json_build_object(
 'countrySno',country_sno,'name',name,'iso2',iso2,'phoneCode',phone_code,'numericCode',numeric_code,'currencyCode',currency_code,'activeFlag',active_flag
 ))))
 FROM masters.country
 where    country_sno = i_country_sno;
end;
$$;


ALTER FUNCTION masters.create_country(in_data json) OWNER TO qbox_admin;

--
-- Name: create_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_partner_code character varying:= (in_data->>'partnerCode')::character varying;
i_partner_name text:= (in_data->>'partnerName')::text;
i_partner_status_cd smallint:= (in_data->>'partnerStatusCd')::smallint;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_delivery_partner_sno  smallint  := 0;
  
begin

INSERT INTO masters.delivery_partner(
	  partner_code,name,partner_status_cd,active_flag)
	VALUES (i_partner_code,i_partner_name,i_partner_status_cd,i_active_flag) returning delivery_partner_sno into i_delivery_partner_sno;

 return (select(json_build_object('data',json_build_object(
 'deliveryPartnerSno',delivery_partner_sno,'partnerCode',partner_code,'partnerName',name,'partnerStatusCd',partner_status_cd,'activeFlag',active_flag
 ))))
 FROM masters.delivery_partner
 where    delivery_partner_sno = i_delivery_partner_sno;
end;
$$;


ALTER FUNCTION masters.create_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: create_entity_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_entity_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_infra_sno bigint:= (in_data->>'infraSno')::bigint;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_entity_infra_sno  bigint  := 0;
  
begin

INSERT INTO masters.entity_infra(
	  qbox_entity_sno,infra_sno,active_flag)
	VALUES (i_qbox_entity_sno,i_infra_sno,i_active_flag) returning entity_infra_sno into i_entity_infra_sno;

 return (select(json_build_object('data',json_build_object(
 'entityInfraSno',entity_infra_sno,'qboxEntitySno',qbox_entity_sno,'infraSno',infra_sno,'activeFlag',active_flag
 ))))
 FROM masters.entity_infra
 where    entity_infra_sno = i_entity_infra_sno;
end;
$$;


ALTER FUNCTION masters.create_entity_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: create_entity_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_entity_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
i_infra_property_sno smallint:= (in_data->>'infraPropertySno')::smallint;
i_value text:= (in_data->>'value')::text;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_entity_infra_property_sno  bigint  := 0;
  
begin

INSERT INTO masters.entity_infra_property(
	  entity_infra_sno,infra_property_sno,value,active_flag)
	VALUES (i_entity_infra_sno,i_infra_property_sno,i_value,i_active_flag) returning entity_infra_property_sno into i_entity_infra_property_sno;

 return (select(json_build_object('data',json_build_object(
 'entityInfraPropertySno',entity_infra_property_sno,'entityInfraSno',entity_infra_sno,'infraPropertySno',infra_property_sno,'value',value,'activeFlag',active_flag
 ))))
 FROM masters.entity_infra_property
 where    entity_infra_property_sno = i_entity_infra_property_sno;
end;
$$;


ALTER FUNCTION masters.create_entity_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: create_etl_table_column(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_etl_table_column(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_order_etl_hdr_sno SMALLINT := (in_data->>'orderEtlHdrSno')::smallint;
    i_source_column VARCHAR(255) := (in_data->>'sourceColumn')::varchar;
    i_staging_column VARCHAR(255) := (in_data->>'stagingColumn')::varchar;
    i_data_type VARCHAR(50) := (in_data->>'dataType')::varchar;
    i_is_required BOOLEAN := (in_data->>'isRequired')::boolean;
    i_description TEXT := (in_data->>'description')::text;
    i_etl_table_column_sno SMALLINT;
BEGIN
    INSERT INTO partner_order.etl_table_column(
        order_etl_hdr_sno, source_column, staging_column, data_type, is_required, description, created_at, updated_at)
    VALUES (
        i_order_etl_hdr_sno, i_source_column, i_staging_column, i_data_type, 
        COALESCE(i_is_required, TRUE), i_description, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    ) RETURNING etl_table_column_sno INTO i_etl_table_column_sno;

    RETURN (
        SELECT json_build_object('data', json_build_object(
            'etlTableColumnSno', etl_table_column_sno, 'orderEtlHdrSno', order_etl_hdr_sno,
            'sourceColumn', source_column, 'stagingColumn', staging_column,
            'dataType', data_type, 'isRequired', is_required, 
            'description', description, 'createdAt', created_at, 'updatedAt', updated_at
        ))
        FROM partner_order.etl_table_column WHERE etl_table_column_sno = i_etl_table_column_sno
    );
END;
$$;


ALTER FUNCTION masters.create_etl_table_column(in_data json) OWNER TO qbox_admin;

--
-- Name: create_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_restaurant_brand_cd text:= (in_data->>'restaurantBrandCd')::text;
i_food_name text:= (in_data->>'foodName')::text;
i_sku_code text:= (in_data->>'skuCode')::text;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_food_sku_sno  bigint  := 0;
  
begin

INSERT INTO masters.food_sku(
	  restaurant_brand_cd,name,sku_code,active_flag)
	VALUES (i_restaurant_brand_cd,i_food_name,i_sku_code,i_active_flag) returning food_sku_sno into i_food_sku_sno;

 return (select(json_build_object('data',json_build_object(
 'foodSkuSno',food_sku_sno,'restaurantBrandCd',restaurant_brand_cd,'foodName',name,'skuCode',sku_code,'activeFlag',active_flag
 ))))
 FROM masters.food_sku
 where    food_sku_sno = i_food_sku_sno;
end;
$$;


ALTER FUNCTION masters.create_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: create_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 

  i_infra_name text:= (in_data->>'infraName')::text;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;
 
  i_infra_sno  smallint  := 0;
begin
 
INSERT INTO masters.infra(
	  name,active_flag)
	VALUES (i_infra_name,i_active_flag) returning infra_sno into i_infra_sno;
 
return (select(json_build_object('data',json_build_object(
'infraSno',infra_sno,'infraName',name,'activeFlag',active_flag
))))
FROM masters.infra
where    infra_sno = i_infra_sno;
end;
$$;


ALTER FUNCTION masters.create_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: create_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 

  i_infra_sno smallint:= (in_data->>'infraSno')::smallint;
i_property_name text:= (in_data->>'propertyName')::text;
i_data_type_cd smallint:= (in_data->>'dataTypeCd')::smallint;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;
 
  i_infra_property_sno  smallint  := 0;
begin
 
INSERT INTO masters.infra_property(
	  infra_sno,name,data_type_cd,active_flag)
	VALUES (i_infra_sno,i_property_name,i_data_type_cd,i_active_flag) returning infra_property_sno into i_infra_property_sno;
 
return (select(json_build_object('data',json_build_object(
'infraPropertySno',infra_property_sno,'infraSno',infra_sno,'propertyName',name,'dataTypeCd',data_type_cd,'activeFlag',active_flag
))))
FROM masters.infra_property
where    infra_property_sno = i_infra_property_sno;
end;
$$;


ALTER FUNCTION masters.create_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: create_menu_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_permission_sno smallint:= (in_data->>'appPermissionSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;
 i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_menu_permission_sno  smallint  := 0;
  
begin

INSERT INTO masters.menu_permission(
	  app_menu_sno,app_permission_sno,status,active_flag)
	VALUES (i_app_menu_sno,i_app_permission_sno,i_status,i_active_flag) returning menu_permission_sno into i_menu_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'menuPermissionSno',menu_permission_sno,'appMenuSno',app_menu_sno,'appPermissionSno',app_permission_sno,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.menu_permission
 where    menu_permission_sno = i_menu_permission_sno;
end;
$$;


ALTER FUNCTION masters.create_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: create_order_etl_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_order_etl_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_delivery_partner_sno SMALLINT := (in_data->>'deliveryPartnerSno')::smallint;
    i_partner_code VARCHAR := (in_data->>'partnerCode')::varchar;
    i_staging_table_name VARCHAR := (in_data->>'stagingTableName')::varchar;
    i_is_active BOOLEAN := (in_data->>'isActive')::boolean;
    i_file_name_prefix VARCHAR(7) := (in_data->>'fileNamePrefix')::varchar(7);
    i_order_etl_hdr_sno SMALLINT;
BEGIN
    INSERT INTO partner_order.order_etl_hdr(
        delivery_partner_sno, partner_code, staging_table_name, 
        is_active, file_name_prefix)
    VALUES (
        i_delivery_partner_sno, i_partner_code, i_staging_table_name, 
        COALESCE(i_is_active, TRUE), i_file_name_prefix
    )
    RETURNING order_etl_hdr_sno INTO i_order_etl_hdr_sno;

    RETURN (
        SELECT json_build_object('data', json_build_object(
            'orderEtlHdrSno', order_etl_hdr_sno, 'deliveryPartnerSno', delivery_partner_sno,
            'partnerCode', partner_code, 'stagingTableName', staging_table_name,
            'isActive', is_active, 'fileNamePrefix', file_name_prefix
        ))
        FROM partner_order.order_etl_hdr WHERE order_etl_hdr_sno = i_order_etl_hdr_sno
    );
END;
$$;


ALTER FUNCTION masters.create_order_etl_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: create_otp(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_sms_otp character varying:= (in_data->>'smsOtp')::character varying;
i_service_otp text:= (in_data->>'serviceOtp')::text;
i_push_otp text:= (in_data->>'pushOtp')::text;
i_device_id text:= (in_data->>'deviceId')::text;
i_otp_expire_time_cd smallint:= (in_data->>'otpExpireTimeCd')::smallint;
i_otp_expire_time timestamp without time zone:= (in_data->>'otpExpireTime')::timestamp without time zone;
i_otp_status boolean:= (in_data->>'otpStatus')::boolean;
 i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_otp_sno  bigint  := 0;
  
begin

INSERT INTO masters.otp(
	  app_user_sno,sms_otp,service_otp,push_otp,device_id,otp_expire_time_cd,otp_expire_time,otp_status,active_flag)
	VALUES (i_app_user_sno,i_sms_otp,i_service_otp,i_push_otp,i_device_id,i_otp_expire_time_cd,i_otp_expire_time,i_otp_status,i_active_flag) returning otp_sno into i_otp_sno;

 return (select(json_build_object('data',json_build_object(
 'otpSno',otp_sno,'appUserSno',app_user_sno,'smsOtp',sms_otp,'serviceOtp',service_otp,'pushOtp',push_otp,'deviceId',device_id,'otpExpireTimeCd',otp_expire_time_cd,'otpExpireTime',otp_expire_time,'otpStatus',otp_status,
 'activeFlag',active_flag
 ))))
 FROM masters.otp
 where    otp_sno = i_otp_sno;
end;
$$;


ALTER FUNCTION masters.create_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: create_partner_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_partner_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_food_sku_sno smallint:= (in_data->>'foodSkuSno')::smallint;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
 i_active_flag boolean := (in_data->>'activeFlag')::boolean;

i_partner_food_sku_sno  smallint  := 0;
  
begin

INSERT INTO masters.partner_food_sku(
	  delivery_partner_sno,food_sku_sno,partner_food_code,active_flag)
	VALUES (i_delivery_partner_sno,i_food_sku_sno,i_partner_food_code,i_active_flag) returning partner_food_sku_sno into i_partner_food_sku_sno;

 return (select(json_build_object('data',json_build_object(
 'partnerFoodSkuSno',partner_food_sku_sno,'deliveryPartnerSno',delivery_partner_sno,'foodSkuSno',food_sku_sno,'partnerFoodCode',partner_food_code,
 'activeFlag',active_flag
 ))))
 FROM masters.partner_food_sku
 where partner_food_sku_sno = i_partner_food_sku_sno;
end;
$$;


ALTER FUNCTION masters.create_partner_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: create_purchase_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_purchase_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;
i_ordered_time timestamp without time zone:= (in_data->>'orderedTime')::timestamp without time zone;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_purchase_order_id text:= (in_data->>'partnerPurchaseOrderId')::text;
 i_active_flag boolean := (in_data->>'activeFlag')::boolean;

i_purchase_order_sno  bigint  := 0;
	i_purchase_order_dtl_sno  bigint  := 0;
    order_detail_record json;
	order_details_result json;
i_sku_inventory_sno bigint :=0;
	
begin

INSERT INTO masters.purchase_order(
	  qbox_entity_sno,restaurant_sno,delivery_partner_sno,order_status_cd,ordered_time,ordered_by,partner_purchase_order_id,active_flag)
	VALUES (i_qbox_entity_sno,i_restaurant_sno,i_delivery_partner_sno,i_order_status_cd,i_ordered_time,i_ordered_by,i_partner_purchase_order_id,i_active_flag) returning purchase_order_sno into i_purchase_order_sno;

if i_purchase_order_sno is not null

	then

-- Loop through each order detail in the JSON array
    FOR order_detail_record IN SELECT json_array_elements(in_data->'purchaseOrderDtl') 
    LOOP
        -- Insert the order detail into the purchase_order_dtl table
        INSERT INTO masters.purchase_order_dtl (purchase_order_sno, food_sku_sno, order_quantity, sku_price, partner_food_code)
        VALUES (
           	i_purchase_order_sno::bigint,
            (order_detail_record->>'foodSkuSno')::bigint,
            (order_detail_record->>'orderQuantity')::smallint,
            (order_detail_record->>'skuPrice')::numeric,
            order_detail_record->>'partnerFoodCode'
        )RETURNING purchase_order_dtl_sno INTO i_purchase_order_dtl_sno;

		FOR i IN 1..(order_detail_record->>'orderQuantity')::integer
        LOOP
            INSERT INTO masters.sku_inventory (purchase_order_dtl_sno, unique_code)
            VALUES (i_purchase_order_dtl_sno, 
                    CONCAT(order_detail_record->>'partnerFoodCode', '-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', i))
			RETURNING sku_inventory_sno INTO i_sku_inventory_sno;

if i_sku_inventory_sno is not null
	then
		INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by)
			VALUES (i_sku_inventory_sno, 6, CURRENT_TIMESTAMP, 1);

       	end if;

        END LOOP;

    END LOOP;

	end if;

 -- return (select(json_build_object('data',json_build_object(
 -- 'purchaseOrderSno',purchase_order_sno,'qboxEntitySno',qbox_entity_sno,'restaurantSno',restaurant_sno,'deliveryPartnerSno',delivery_partner_sno,'orderStatusCd',order_status_cd,'orderedTime',ordered_time,'orderedBy',ordered_by,'partnerPurchaseOrderId',partner_purchase_order_id
 -- ))))
 -- FROM masters.purchase_order
 -- where    purchase_order_sno = i_purchase_order_sno;

order_details_result := json_build_object(
        'purchaseOrder', json_build_object(
            'purchaseOrderSno', i_purchase_order_sno,
            'qboxEntitySno', (in_data->>'qboxEntitySno')::bigint,
            'restaurantSno', (in_data->>'restaurantSno')::bigint,
            'deliveryPartnerSno', (in_data->>'deliveryPartnerSno')::smallint,
            'orderStatusCd', (in_data->>'orderStatusCd')::smallint,
            'orderedBy', (in_data->>'orderedBy')::bigint,
            'partnerPurchaseOrderId', in_data->>'partnerPurchaseOrderId',
            'orderedTime', CURRENT_TIMESTAMP
        ),
        'purchaseOrderDtls', json_agg(order_detail_with_inventory)
    )
    FROM (
        -- Subquery to fetch order details and corresponding sku_inventory records
        SELECT
            json_build_object(
                'purchaseOrderDtlSno', pod.purchase_order_dtl_sno,
                'foodSkuSno', pod.food_sku_sno,
                'orderQuantity', pod.order_quantity,
                'skuPrice', pod.sku_price,
                'partnerFoodCode', pod.partner_food_code,
                'skuInventory', json_agg(json_build_object(
                                    'skuInventorySno', si.sku_inventory_sno,
                                    'uniqueCode', si.unique_code
                                ))
            ) AS order_detail_with_inventory
        FROM
            masters.purchase_order_dtl pod
        LEFT JOIN
            masters.sku_inventory si ON pod.purchase_order_dtl_sno = si.purchase_order_dtl_sno
        WHERE
            pod.purchase_order_sno = i_purchase_order_sno
        GROUP BY
            pod.purchase_order_dtl_sno
    ) AS result;

    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN order_details_result;

	
end;
$$;


ALTER FUNCTION masters.create_purchase_order(in_data json) OWNER TO qbox_admin;

--
-- Name: create_purchase_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_purchase_order_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_purchase_order_sno bigint:= (in_data->>'purchaseOrderSno')::bigint;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_order_quantity smallint:= (in_data->>'orderQuantity')::smallint;
i_sku_price numeric:= (in_data->>'skuPrice')::numeric;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
 i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_purchase_order_dtl_sno  bigint  := 0;
  
begin

INSERT INTO masters.purchase_order_dtl(
	  purchase_order_sno,food_sku_sno,order_quantity,sku_price,partner_food_code,active_flag)
	VALUES (i_purchase_order_sno,i_food_sku_sno,i_order_quantity,i_sku_price,i_partner_food_code,i_active_flag) returning purchase_order_dtl_sno into i_purchase_order_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'purchaseOrderDtlSno',purchase_order_dtl_sno,'purchaseOrderSno',purchase_order_sno,'foodSkuSno',food_sku_sno,'orderQuantity',order_quantity,'skuPrice',sku_price,'partnerFoodCode',partner_food_code,
 'activeFlag',active_flag
 ))))
 FROM masters.purchase_order_dtl
 where    purchase_order_dtl_sno = i_purchase_order_dtl_sno;
end;
$$;


ALTER FUNCTION masters.create_purchase_order_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: create_qbox_entity(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_qbox_entity(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Variables for the qbox entity data
    i_qbox_entity_name text := (in_data->>'qboxEntityName')::text;
    i_address_sno bigint;
    i_area_sno bigint := (in_data->>'areaSno')::bigint;
    i_qbox_entity_status_cd smallint := (in_data->>'qboxEntityStatusCd')::smallint;
    i_qbox_entity_code text := (in_data->>'entityCode')::text;
    i_qbox_active_flag boolean := (in_data->>'activeFlag')::boolean;
    i_created_on timestamp without time zone := (in_data->>'createdOn')::timestamp without time zone;

    -- Variables for address details
    i_address_details json := in_data->'addressDetails';  -- Extract the address details from the input JSON

    -- Variables for address insert
    i_line1 text := (i_address_details->>'line1')::text;
    i_line2 text := (i_address_details->>'line2')::text;
    i_address_area_sno integer := (i_address_details->>'areaSno')::integer;
    i_city_sno integer := (i_address_details->>'citySno')::integer;
    i_geo_loc_code text := (i_address_details->>'geoLocCode')::text;
    i_description text := (i_address_details->>'description')::text;
    i_address_active_flag boolean := (i_address_details->>'activeFlag')::boolean;

    -- Variables for the qbox entity
    i_qbox_entity_sno bigint := 0;
BEGIN
    -- If address_sno is an empty string or null, set it to NULL (bigint)
    IF (in_data->>'addressSno') = '' OR (in_data->>'addressSno') IS NULL THEN
        i_address_sno := NULL;
    ELSE
        i_address_sno := (in_data->>'addressSno')::bigint;
    END IF;

    -- Insert address and get the address_sno if it's not already provided
    IF i_address_sno IS NULL THEN
        -- Insert address and get the address_sno
        i_address_sno := (
            SELECT NULLIF((masters.create_address(i_address_details::json))->'data'->>'addressSno', '')::bigint
        );
    END IF;

    -- Debugging output
    raise notice 'Inserted Address Sno: %', i_address_sno;

    -- Insert the qbox_entity
    INSERT INTO masters.qbox_entity(
        name,
        address_sno,
        area_sno,
        qbox_entity_status_cd,
        created_on,
        entity_code,
        active_flag
    )
    VALUES (
        i_qbox_entity_name,
        i_address_sno,
        i_area_sno,
        i_qbox_entity_status_cd,
        i_created_on,
        i_qbox_entity_code,
        i_qbox_active_flag
    )
    RETURNING qbox_entity_sno INTO i_qbox_entity_sno;

    -- Return the newly created qbox_entity
    RETURN (SELECT json_build_object('data', json_build_object(
        'qboxEntitySno', qbox_entity_sno,
        'qboxEntityName', name,
        'addressSno', address_sno,
        'areaSno', area_sno,
        'qboxEntityStatusCd', qbox_entity_status_cd,
        'createdOn', created_on,
        'entityCode', entity_code,
        'activeFlag', active_flag
    ))
    FROM masters.qbox_entity
    WHERE qbox_entity_sno = i_qbox_entity_sno);
END;
$$;


ALTER FUNCTION masters.create_qbox_entity(in_data json) OWNER TO qbox_admin;

--
-- Name: create_qbox_entity_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_qbox_entity_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_delivery_type_cd smallint:= (in_data->>'deliveryTypeCd')::smallint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
 i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_qbox_entity_delivery_partner_sno  bigint  := 0;
  
begin

INSERT INTO masters.qbox_entity_delivery_partner(
	  delivery_type_cd,qbox_entity_sno,delivery_partner_sno,active_flag)
	VALUES (i_delivery_type_cd,i_qbox_entity_sno,i_delivery_partner_sno,i_active_flag) returning qbox_entity_delivery_partner_sno into i_qbox_entity_delivery_partner_sno;

 return (select(json_build_object('data',json_build_object(
 'qboxEntityDeliveryPartnerSno',qbox_entity_delivery_partner_sno,'deliveryTypeCd',delivery_type_cd,'qboxEntitySno',qbox_entity_sno,'deliveryPartnerSno',delivery_partner_sno,
 'activeFlag',active_flag
 ))))
 FROM masters.qbox_entity_delivery_partner
 where    qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno;
end;
$$;


ALTER FUNCTION masters.create_qbox_entity_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: create_restaurant(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_restaurant(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_restaurant_brand_cd text:= (in_data->>'restaurantBrandCd')::text;
i_restaurant_name text:= (in_data->>'restaurantName')::text;
i_address_sno bigint:= (in_data->>'addressSno')::bigint;
i_area_sno bigint:= (in_data->>'areaSno')::bigint;
i_restaurant_status_cd smallint:= (in_data->>'restaurantStatusCd')::smallint;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_restaurant_sno  bigint  := 0;
  
begin

INSERT INTO masters.restaurant(
	  restaurant_brand_cd,name,address_sno,area_sno,restaurant_status_cd,active_flag)
	VALUES (i_restaurant_brand_cd,i_restaurant_name,i_address_sno,i_area_sno,i_restaurant_status_cd,i_active_flag) returning restaurant_sno into i_restaurant_sno;

 return (select(json_build_object('data',json_build_object(
 'restaurantSno',restaurant_sno,'restaurantBrandCd',restaurant_brand_cd,'restaurantName',name,'addressSno',address_sno,'areaSno',area_sno,'restaurantStatusCd',restaurant_status_cd,
 'activeFlag',active_flag
 ))))
 FROM masters.restaurant
 where    restaurant_sno = i_restaurant_sno;
end;
$$;


ALTER FUNCTION masters.create_restaurant(in_data json) OWNER TO qbox_admin;

--
-- Name: create_restaurant_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_restaurant_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_restaurant_food_sku_sno  bigint  := 0;
  
begin

INSERT INTO masters.restaurant_food_sku(
	  restaurant_sno,food_sku_sno,status,active_flag)
	VALUES (i_restaurant_sno,i_food_sku_sno,i_status,i_active_flag) returning restaurant_food_sku_sno into i_restaurant_food_sku_sno;

 return (select(json_build_object('data',json_build_object(
 'restaurantFoodSkuSno',restaurant_food_sku_sno,'restaurantSno',restaurant_sno,'foodSkuSno',food_sku_sno,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.restaurant_food_sku
 where    restaurant_food_sku_sno = i_restaurant_food_sku_sno;
end;
$$;


ALTER FUNCTION masters.create_restaurant_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: create_role_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_role_menu_sno  smallint  := 0;
  
begin

INSERT INTO masters.role_menu(
	  app_menu_sno,app_role_sno,status,active_flag)
	VALUES (i_app_menu_sno,i_app_role_sno,i_status,i_active_flag) returning role_menu_sno into i_role_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'roleMenuSno',role_menu_sno,'appMenuSno',app_menu_sno,'appRoleSno',app_role_sno,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.role_menu
 where    role_menu_sno = i_role_menu_sno;
end;
$$;


ALTER FUNCTION masters.create_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: create_role_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_permission_sno integer:= (in_data->>'appPermissionSno')::integer;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_role_permission_sno  bigint  := 0;
  
begin

INSERT INTO masters.role_permission(
	  app_role_sno,app_permission_sno,active_flag)
	VALUES (i_app_role_sno,i_app_permission_sno,i_active_flag) returning role_permission_sno into i_role_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'rolePermissionSno',role_permission_sno,'appRoleSno',app_role_sno,'appPermissionSno',app_permission_sno,'activeFlag',active_flag
 ))))
 FROM masters.role_permission
 where    role_permission_sno = i_role_permission_sno;
end;
$$;


ALTER FUNCTION masters.create_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: create_sales_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_sales_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_partner_sales_order_id text:= (in_data->>'partnerSalesOrderId')::text;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_delivery_partner_sno bigint:= (in_data->>'deliveryPartnerSno')::bigint;
i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;
i_ordered_time timestamp without time zone:= (in_data->>'orderedTime')::timestamp without time zone;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_customer_ref text:= (in_data->>'partnerCustomerRef')::text;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_sales_order_sno  bigint  := 0;
  
begin

INSERT INTO masters.sales_order(
	  partner_sales_order_id,qbox_entity_sno,delivery_partner_sno,order_status_cd,ordered_time,ordered_by,partner_customer_ref,active_flag)
	VALUES (i_partner_sales_order_id,i_qbox_entity_sno,i_delivery_partner_sno,i_order_status_cd,i_ordered_time,i_ordered_by,i_partner_customer_ref,i_active_flag) returning sales_order_sno into i_sales_order_sno;

 return (select(json_build_object('data',json_build_object(
 'salesOrderSno',sales_order_sno,'partnerSalesOrderId',partner_sales_order_id,'qboxEntitySno',qbox_entity_sno,'deliveryPartnerSno',delivery_partner_sno,'orderStatusCd',order_status_cd,'orderedTime',ordered_time,'orderedBy',ordered_by,'partnerCustomerRef',partner_customer_ref,
 'activeFlag',active_flag
 ))))
 FROM masters.sales_order
 where    sales_order_sno = i_sales_order_sno;
end;
$$;


ALTER FUNCTION masters.create_sales_order(in_data json) OWNER TO qbox_admin;

--
-- Name: create_sales_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_sales_order_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_sales_order_sno bigint:= (in_data->>'salesOrderSno')::bigint;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_order_quantity integer:= (in_data->>'orderQuantity')::integer;
i_sku_price numeric:= (in_data->>'skuPrice')::numeric;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_sales_order_dtl_sno  bigint  := 0;
  
begin

INSERT INTO masters.sales_order_dtl(
	  sales_order_sno,partner_food_code,food_sku_sno,order_quantity,sku_price,active_flag)
	VALUES (i_sales_order_sno,i_partner_food_code,i_food_sku_sno,i_order_quantity,i_sku_price,i_active_flag) returning sales_order_dtl_sno into i_sales_order_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'salesOrderDtlSno',sales_order_dtl_sno,'salesOrderSno',sales_order_sno,'partnerFoodCode',partner_food_code,'foodSkuSno',food_sku_sno,'orderQuantity',order_quantity,'skuPrice',sku_price,
 'activeFlag',active_flag
 ))))
 FROM masters.sales_order_dtl
 where    sales_order_dtl_sno = i_sales_order_dtl_sno;
end;
$$;


ALTER FUNCTION masters.create_sales_order_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: create_signin_info(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_push_token text:= (in_data->>'pushToken')::text;
i_device_type_cd smallint:= (in_data->>'deviceTypeCd')::smallint;
i_device_id text:= (in_data->>'deviceId')::text;
i_login_on timestamp without time zone:= (in_data->>'loginOn')::timestamp without time zone;
i_logout_on timestamp without time zone:= (in_data->>'logoutOn')::timestamp without time zone;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_signin_info_sno  bigint  := 0;
  
begin

INSERT INTO masters.signin_info(
	  app_user_sno,push_token,device_type_cd,device_id,login_on,logout_on,active_flag)
	VALUES (i_app_user_sno,i_push_token,i_device_type_cd,i_device_id,i_login_on,i_logout_on,i_active_flag) returning signin_info_sno into i_signin_info_sno;

 return (select(json_build_object('data',json_build_object(
 'signinInfoSno',signin_info_sno,'appUserSno',app_user_sno,'pushToken',push_token,'deviceTypeCd',device_type_cd,'deviceId',device_id,'loginOn',login_on,'logoutOn',logout_on,
 'activeFlag',active_flag
 ))))
 FROM masters.signin_info
 where    signin_info_sno = i_signin_info_sno;
end;
$$;


ALTER FUNCTION masters.create_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: create_sku_inventory(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_sku_inventory(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_purchase_order_dtl_sno bigint:= (in_data->>'purchaseOrderDtlSno')::bigint;
i_unique_code text:= (in_data->>'uniqueCode')::text;
i_sales_order_dtl_sno bigint:= (in_data->>'salesOrderDtlSno')::bigint;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_sku_inventory_sno  bigint  := 0;
  
begin

INSERT INTO masters.sku_inventory(
	  purchase_order_dtl_sno,unique_code,sales_order_dtl_sno,active_flag)
	VALUES (i_purchase_order_dtl_sno,i_unique_code,i_sales_order_dtl_sno,i_active_flag) returning sku_inventory_sno into i_sku_inventory_sno;

 return (select(json_build_object('data',json_build_object(
 'skuInventorySno',sku_inventory_sno,'purchaseOrderDtlSno',purchase_order_dtl_sno,'uniqueCode',unique_code,'salesOrderDtlSno',sales_order_dtl_sno,
 'activeFlag',active_flag
 ))))
 FROM masters.sku_inventory
 where    sku_inventory_sno = i_sku_inventory_sno;
end;
$$;


ALTER FUNCTION masters.create_sku_inventory(in_data json) OWNER TO qbox_admin;

--
-- Name: create_sku_trace_wf(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_sku_trace_wf(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_wf_stage_cd smallint:= (in_data->>'wfStageCd')::smallint;
i_action_time timestamp without time zone:= (in_data->>'actionTime')::timestamp without time zone;
i_action_by bigint:= (in_data->>'actionBy')::bigint;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_sku_trace_wf_sno  bigint  := 0;
  
begin

INSERT INTO masters.sku_trace_wf(
	  sku_inventory_sno,wf_stage_cd,action_time,action_by,active_flag)
	VALUES (i_sku_inventory_sno,i_wf_stage_cd,i_action_time,i_action_by,i_active_flag) returning sku_trace_wf_sno into i_sku_trace_wf_sno;

 return (select(json_build_object('data',json_build_object(
 'skuTraceWfSno',sku_trace_wf_sno,'skuInventorySno',sku_inventory_sno,'wfStageCd',wf_stage_cd,'actionTime',action_time,'actionBy',action_by,
 'activeFlag',active_flag
 ))))
 FROM masters.sku_trace_wf
 where    sku_trace_wf_sno = i_sku_trace_wf_sno;
end;
$$;


ALTER FUNCTION masters.create_sku_trace_wf(in_data json) OWNER TO qbox_admin;

--
-- Name: create_state(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.create_state(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_code character varying:= (in_data->>'stateCode')::character varying;
i_name text:= (in_data->>'name')::text;
i_active_flag boolean := (in_data->>'activeFlag')::boolean;

  i_state_sno  smallint  := 0;
  
begin

INSERT INTO masters.state(
	  country_sno,state_code,name,active_flag)
	VALUES (i_country_sno,i_state_code,i_name,i_active_flag) returning state_sno into i_state_sno;

 return (select(json_build_object('data',json_build_object(
 'stateSno',state_sno,'countrySno',country_sno,'stateCode',state_code,'name',name,'activeFlag',active_flag
 ))))
 FROM masters.state
 where    state_sno = i_state_sno;
end;
$$;


ALTER FUNCTION masters.create_state(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_address(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_address(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_line1 text;
i_line2 text;
i_area_sno integer;
i_city_sno integer;
i_geo_loc_code text;

  i_address_sno bigint  := (in_data->>'addressSno')::bigint;
  
begin
  Select line1 into i_line1 from masters.address where address_sno = i_address_sno;
Select line2 into i_line2 from masters.address where address_sno = i_address_sno;
Select area_sno into i_area_sno from masters.address where address_sno = i_address_sno;
Select city_sno into i_city_sno from masters.address where address_sno = i_address_sno;
Select geo_loc_code into i_geo_loc_code from masters.address where address_sno = i_address_sno;

DELETE from masters.address where address_sno = i_address_sno;

return (select(json_build_object('data',json_build_object(
 'addressSno',i_address_sno,'line1',i_line1,'line2',i_line2,'areaSno',i_area_sno,'citySno',i_city_sno,'geoLocCode',i_geo_loc_code
 ))));
end;
$$;


ALTER FUNCTION masters.delete_address(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_name text;
i_parent_menu_sno smallint;
i_href text;
i_title text;
i_status boolean;

  i_app_menu_sno smallint  := (in_data->>'appMenuSno')::smallint;
  
begin
  Select app_menu_name into i_app_menu_name from masters.app_menu where app_menu_sno = i_app_menu_sno;
Select parent_menu_sno into i_parent_menu_sno from masters.app_menu where app_menu_sno = i_app_menu_sno;
Select href into i_href from masters.app_menu where app_menu_sno = i_app_menu_sno;
Select title into i_title from masters.app_menu where app_menu_sno = i_app_menu_sno;
Select status into i_status from masters.app_menu where app_menu_sno = i_app_menu_sno;

DELETE from masters.app_menu where app_menu_sno = i_app_menu_sno;

return (select(json_build_object('data',json_build_object(
 'appMenuSno',i_app_menu_sno,'appMenuName',i_app_menu_name,'parentMenuSno',i_parent_menu_sno,'href',i_href,'title',i_title,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION masters.delete_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_permission_name text;
i_created_at timestamp without time zone;

  i_app_permission_sno bigint  := (in_data->>'appPermissionSno')::bigint;
  
begin
  Select app_permission_name into i_app_permission_name from masters.app_permission where app_permission_sno = i_app_permission_sno;
Select created_at into i_created_at from masters.app_permission where app_permission_sno = i_app_permission_sno;

DELETE from masters.app_permission where app_permission_sno = i_app_permission_sno;

return (select(json_build_object('data',json_build_object(
 'appPermissionSno',i_app_permission_sno,'appPermissionName',i_app_permission_name,'createdAt',i_created_at
 ))));
end;
$$;


ALTER FUNCTION masters.delete_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_role_name text;
i_status boolean;

  i_app_role_sno smallint  := (in_data->>'appRoleSno')::smallint;
  
begin
  Select app_role_name into i_app_role_name from masters.app_role where app_role_sno = i_app_role_sno;
Select status into i_status from masters.app_role where app_role_sno = i_app_role_sno;

DELETE from masters.app_role where app_role_sno = i_app_role_sno;

return (select(json_build_object('data',json_build_object(
 'appRoleSno',i_app_role_sno,'appRoleName',i_app_role_name,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION masters.delete_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_user(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_user_id text;
i_password text;
i_status boolean;

  i_app_user_sno bigint  := (in_data->>'appUserSno')::bigint;
  
begin
  Select user_id into i_user_id from masters.app_user where app_user_sno = i_app_user_sno;
Select password into i_password from masters.app_user where app_user_sno = i_app_user_sno;
Select status into i_status from masters.app_user where app_user_sno = i_app_user_sno;

DELETE from masters.app_user where app_user_sno = i_app_user_sno;

return (select(json_build_object('data',json_build_object(
 'appUserSno',i_app_user_sno,'userId',i_user_id,'password',i_password,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION masters.delete_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_app_user_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint;
i_app_role_sno smallint;

  i_app_user_role_sno bigint  := (in_data->>'appUserRoleSno')::bigint;
  
begin
  Select app_user_sno into i_app_user_sno from masters.app_user_role where app_user_role_sno = i_app_user_role_sno;
Select app_role_sno into i_app_role_sno from masters.app_user_role where app_user_role_sno = i_app_user_role_sno;

DELETE from masters.app_user_role where app_user_role_sno = i_app_user_role_sno;

return (select(json_build_object('data',json_build_object(
 'appUserRoleSno',i_app_user_role_sno,'appUserSno',i_app_user_sno,'appRoleSno',i_app_role_sno
 ))));
end;
$$;


ALTER FUNCTION masters.delete_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_area(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_area(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
i_country_sno smallint;
i_state_sno smallint;
i_city_sno integer;
i_name text;
i_pincode text;

  i_area_sno bigint  := (in_data->>'areaSno')::bigint;
	
  
begin
	raise notice '%d',i_area_sno;
Select country_sno into i_country_sno from masters.area where area_sno = i_area_sno;
Select state_sno into i_state_sno from masters.area where area_sno = i_area_sno;
Select city_sno into i_city_sno from masters.area where area_sno = i_area_sno;
Select name into i_name from masters.area where area_sno = i_area_sno;
Select pincode into i_pincode from masters.area where area_sno = i_area_sno;

DELETE from masters.area where area_sno = i_area_sno;

return (select(json_build_object('data',json_build_object(
 'areaSno',i_area_sno,'countrySno',i_country_sno,'stateSno',i_state_sno,'citySno',i_city_sno,'name',i_name,'pincode',i_pincode
 ))));
end;
$$;


ALTER FUNCTION masters.delete_area(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_box_cell(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_box_cell(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_qbox_entity_sno bigint;
i_entity_infra_sno bigint;
i_row_no smallint;
i_column_no smallint;
i_box_cell_status_cd smallint;

  i_box_cell_sno bigint  := (in_data->>'boxCellSno')::bigint;
  
begin
  Select qbox_entity_sno into i_qbox_entity_sno from masters.box_cell where box_cell_sno = i_box_cell_sno;
Select entity_infra_sno into i_entity_infra_sno from masters.box_cell where box_cell_sno = i_box_cell_sno;
Select row_no into i_row_no from masters.box_cell where box_cell_sno = i_box_cell_sno;
Select column_no into i_column_no from masters.box_cell where box_cell_sno = i_box_cell_sno;
Select box_cell_status_cd into i_box_cell_status_cd from masters.box_cell where box_cell_sno = i_box_cell_sno;

DELETE from masters.box_cell where box_cell_sno = i_box_cell_sno;

return (select(json_build_object('data',json_build_object(
 'boxCellSno',i_box_cell_sno,'qboxEntitySno',i_qbox_entity_sno,'entityInfraSno',i_entity_infra_sno,'rowNo',i_row_no,'columnNo',i_column_no,'boxCellStatusCd',i_box_cell_status_cd
 ))));
end;
$$;


ALTER FUNCTION masters.delete_box_cell(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_box_cell_food(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_box_cell_food(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_box_cell_sno smallint;
i_sku_inventory_sno bigint;
i_entry_time timestamp without time zone;
i_qbox_entity_sno bigint;

  i_box_cell_food_sno bigint  := (in_data->>'boxCellFoodSno')::bigint;
  
begin
  Select box_cell_sno into i_box_cell_sno from masters.box_cell_food where box_cell_food_sno = i_box_cell_food_sno;
Select sku_inventory_sno into i_sku_inventory_sno from masters.box_cell_food where box_cell_food_sno = i_box_cell_food_sno;
Select entry_time into i_entry_time from masters.box_cell_food where box_cell_food_sno = i_box_cell_food_sno;
Select qbox_entity_sno into i_qbox_entity_sno from masters.box_cell_food where box_cell_food_sno = i_box_cell_food_sno;

DELETE from masters.box_cell_food where box_cell_food_sno = i_box_cell_food_sno;

return (select(json_build_object('data',json_build_object(
 'boxCellFoodSno',i_box_cell_food_sno,'boxCellSno',i_box_cell_sno,'skuInventorySno',i_sku_inventory_sno,'entryTime',i_entry_time,'qboxEntitySno',i_qbox_entity_sno
 ))));
end;
$$;


ALTER FUNCTION masters.delete_box_cell_food(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_box_cell_food_hist(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_box_cell_food_hist(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_box_cell_food_sno bigint;
i_box_cell_sno smallint;
i_sku_inventory_sno bigint;
i_entry_time timestamp without time zone;
i_qbox_entity_sno bigint;

  i_box_cell_food_hist_sno bigint  := (in_data->>'boxCellFoodHistSno')::bigint;
  
begin
  Select box_cell_food_sno into i_box_cell_food_sno from masters.box_cell_food_hist where box_cell_food_hist_sno = i_box_cell_food_hist_sno;
Select box_cell_sno into i_box_cell_sno from masters.box_cell_food_hist where box_cell_food_hist_sno = i_box_cell_food_hist_sno;
Select sku_inventory_sno into i_sku_inventory_sno from masters.box_cell_food_hist where box_cell_food_hist_sno = i_box_cell_food_hist_sno;
Select entry_time into i_entry_time from masters.box_cell_food_hist where box_cell_food_hist_sno = i_box_cell_food_hist_sno;
Select qbox_entity_sno into i_qbox_entity_sno from masters.box_cell_food_hist where box_cell_food_hist_sno = i_box_cell_food_hist_sno;

DELETE from masters.box_cell_food_hist where box_cell_food_hist_sno = i_box_cell_food_hist_sno;

return (select(json_build_object('data',json_build_object(
 'boxCellFoodHistSno',i_box_cell_food_hist_sno,'boxCellFoodSno',i_box_cell_food_sno,'boxCellSno',i_box_cell_sno,'skuInventorySno',i_sku_inventory_sno,'entryTime',i_entry_time,'qboxEntitySno',i_qbox_entity_sno
 ))));
end;
$$;


ALTER FUNCTION masters.delete_box_cell_food_hist(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_city(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_city(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_country_sno smallint;
i_state_sno smallint;
i_name text;

  i_city_sno bigint  := (in_data->>'citySno')::bigint;
  
begin
  Select country_sno into i_country_sno from masters.city where city_sno = i_city_sno;
Select state_sno into i_state_sno from masters.city where city_sno = i_city_sno;
Select name into i_name from masters.city where city_sno = i_city_sno;

DELETE from masters.city where city_sno = i_city_sno;

return (select(json_build_object('data',json_build_object(
 'citySno',i_city_sno,'countrySno',i_country_sno,'stateSno',i_state_sno,'name',i_name
 ))));
end;
$$;


ALTER FUNCTION masters.delete_city(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_codes_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_codes_hdr_sno smallint;
i_cd_value text;
i_seqno integer;
i_filter_1 text;
i_filter_2 text;
i_active_flag boolean;

  i_codes_dtl_sno smallint  := (in_data->>'codesDtlSno')::smallint;
  
begin
  Select codes_hdr_sno into i_codes_hdr_sno from masters.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select cd_value into i_cd_value from masters.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select seqno into i_seqno from masters.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select filter_1 into i_filter_1 from masters.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select filter_2 into i_filter_2 from masters.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;
Select active_flag into i_active_flag from masters.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;

DELETE from masters.codes_dtl where codes_dtl_sno = i_codes_dtl_sno;

return (select(json_build_object('data',json_build_object(
 'codesDtlSno',i_codes_dtl_sno,'codesHdrSno',i_codes_hdr_sno,'cdValue',i_cd_value,'seqno',i_seqno,'filter1',i_filter_1,'filter2',i_filter_2,'activeFlag',i_active_flag
 ))));
end;
$$;


ALTER FUNCTION masters.delete_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_codes_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_code_type text;
i_active_flag boolean;

  i_codes_hdr_sno smallint  := (in_data->>'codesHdrSno')::smallint;
  
begin
  Select description into i_code_type from masters.codes_hdr where codes_hdr_sno = i_codes_hdr_sno;
Select active_flag into i_active_flag from masters.codes_hdr where codes_hdr_sno = i_codes_hdr_sno;

DELETE from masters.codes_hdr where codes_hdr_sno = i_codes_hdr_sno;

return (select(json_build_object('data',json_build_object(
 'codesHdrSno',i_codes_hdr_sno,'codeType',i_code_type,'activeFlag',i_active_flag
 ))));
end;
$$;


ALTER FUNCTION masters.delete_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_country(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_country(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_name text;
i_iso2 character varying;
i_phone_code character varying;
i_numeric_code character varying;
i_currency_code character varying;

  i_country_sno smallint  := (in_data->>'countrySno')::smallint;
  
begin
  Select name into i_name from masters.country where country_sno = i_country_sno;
Select iso2 into i_iso2 from masters.country where country_sno = i_country_sno;
Select phone_code into i_phone_code from masters.country where country_sno = i_country_sno;
Select numeric_code into i_numeric_code from masters.country where country_sno = i_country_sno;
Select currency_code into i_currency_code from masters.country where country_sno = i_country_sno;

DELETE from masters.country where country_sno = i_country_sno;

return (select(json_build_object('data',json_build_object(
 'countrySno',i_country_sno,'name',i_name,'iso2',i_iso2,'phoneCode',i_phone_code,'numericCode',i_numeric_code,'currencyCode',i_currency_code
 ))));
end;
$$;


ALTER FUNCTION masters.delete_country(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_partner_code character varying;
i_partner_name text;
i_partner_status_cd smallint;

  i_delivery_partner_sno smallint  := (in_data->>'deliveryPartnerSno')::smallint;
  
begin
  Select partner_code into i_partner_code from masters.delivery_partner where delivery_partner_sno = i_delivery_partner_sno;
Select name into i_partner_name from masters.delivery_partner where delivery_partner_sno = i_delivery_partner_sno;
Select partner_status_cd into i_partner_status_cd from masters.delivery_partner where delivery_partner_sno = i_delivery_partner_sno;

DELETE from masters.delivery_partner where delivery_partner_sno = i_delivery_partner_sno;

return (select(json_build_object('data',json_build_object(
 'deliveryPartnerSno',i_delivery_partner_sno,'partnerCode',i_partner_code,'partnerName',i_partner_name,'partnerStatusCd',i_partner_status_cd
 ))));
end;
$$;


ALTER FUNCTION masters.delete_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_entity_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_entity_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_qbox_entity_sno bigint;
i_infra_sno bigint;

  i_entity_infra_sno bigint  := (in_data->>'entityInfraSno')::bigint;
  
begin
  Select qbox_entity_sno into i_qbox_entity_sno from masters.entity_infra where entity_infra_sno = i_entity_infra_sno;
Select infra_sno into i_infra_sno from masters.entity_infra where entity_infra_sno = i_entity_infra_sno;

DELETE from masters.entity_infra where entity_infra_sno = i_entity_infra_sno;

return (select(json_build_object('data',json_build_object(
 'entityInfraSno',i_entity_infra_sno,'qboxEntitySno',i_qbox_entity_sno,'infraSno',i_infra_sno
 ))));
end;
$$;


ALTER FUNCTION masters.delete_entity_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_entity_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_entity_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_entity_infra_sno bigint;
i_infra_property_sno smallint;
i_value text;

  i_entity_infra_property_sno bigint  := (in_data->>'entityInfraPropertySno')::bigint;
  
begin
  Select entity_infra_sno into i_entity_infra_sno from masters.entity_infra_property where entity_infra_property_sno = i_entity_infra_property_sno;
Select infra_property_sno into i_infra_property_sno from masters.entity_infra_property where entity_infra_property_sno = i_entity_infra_property_sno;
Select value into i_value from masters.entity_infra_property where entity_infra_property_sno = i_entity_infra_property_sno;

DELETE from masters.entity_infra_property where entity_infra_property_sno = i_entity_infra_property_sno;

return (select(json_build_object('data',json_build_object(
 'entityInfraPropertySno',i_entity_infra_property_sno,'entityInfraSno',i_entity_infra_sno,'infraPropertySno',i_infra_property_sno,'value',i_value
 ))));
end;
$$;


ALTER FUNCTION masters.delete_entity_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_etl_table_column(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_etl_table_column(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_etl_table_column_sno SMALLINT := (in_data->>'etlTableColumnSno')::smallint;
BEGIN
    DELETE FROM partner_order.etl_table_column
    WHERE etl_table_column_sno = i_etl_table_column_sno;

    RETURN json_build_object('status', 'success', 'message', 'Record deleted successfully');
END;
$$;


ALTER FUNCTION masters.delete_etl_table_column(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$

declare 

  i_restaurant_brand_cd character varying;

i_food_name text;

i_sku_code text;
 
  i_food_sku_sno bigint  := (in_data->>'foodSkuSno')::bigint;

begin

  Select restaurant_brand_cd into i_restaurant_brand_cd from masters.food_sku where food_sku_sno = i_food_sku_sno;

Select name into i_food_name from masters.food_sku where food_sku_sno = i_food_sku_sno;

Select sku_code into i_sku_code from masters.food_sku where food_sku_sno = i_food_sku_sno;
 
DELETE from masters.food_sku where food_sku_sno = i_food_sku_sno;
 
return (select(json_build_object('data',json_build_object(

'foodSkuSno',i_food_sku_sno,'restaurantBrandCd',i_restaurant_brand_cd,'foodName',i_food_name,'skuCode',i_sku_code

))));

end;

$$;


ALTER FUNCTION masters.delete_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  i_infra_name text;
 
  i_infra_sno smallint  := (in_data->>'infraSno')::smallint;
begin
  Select name into i_infra_name from masters.infra where infra_sno = i_infra_sno;
 
DELETE from masters.infra where infra_sno = i_infra_sno;
 
return (select(json_build_object('data',json_build_object(
'infraSno',i_infra_sno,'infraName',i_infra_name
))));
end;
$$;


ALTER FUNCTION masters.delete_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$

declare 

  i_infra_sno smallint;

i_property_name text;

i_data_type_cd smallint;
 
  i_infra_property_sno smallint  := (in_data->>'infraPropertySno')::smallint;

begin

  Select infra_sno into i_infra_sno from masters.infra_property where infra_property_sno = i_infra_property_sno;

Select name into i_property_name from masters.infra_property where infra_property_sno = i_infra_property_sno;

Select data_type_cd into i_data_type_cd from masters.infra_property where infra_property_sno = i_infra_property_sno;
 
DELETE from masters.infra_property where infra_property_sno = i_infra_property_sno;
 
return (select(json_build_object('data',json_build_object(

'infraPropertySno',i_infra_property_sno,'infraSno',i_infra_sno,'propertyName',i_property_name,'dataTypeCd',i_data_type_cd

))));

end;

$$;


ALTER FUNCTION masters.delete_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_menu_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_sno smallint;
i_app_permission_sno smallint;
i_status boolean;

  i_menu_permission_sno smallint  := (in_data->>'menuPermissionSno')::smallint;
  
begin
  Select app_menu_sno into i_app_menu_sno from masters.menu_permission where menu_permission_sno = i_menu_permission_sno;
Select app_permission_sno into i_app_permission_sno from masters.menu_permission where menu_permission_sno = i_menu_permission_sno;
Select status into i_status from masters.menu_permission where menu_permission_sno = i_menu_permission_sno;

DELETE from masters.menu_permission where menu_permission_sno = i_menu_permission_sno;

return (select(json_build_object('data',json_build_object(
 'menuPermissionSno',i_menu_permission_sno,'appMenuSno',i_app_menu_sno,'appPermissionSno',i_app_permission_sno,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION masters.delete_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_order_etl_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_order_etl_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_order_etl_hdr_sno SMALLINT := (in_data->>'orderEtlHdrSno')::smallint;
BEGIN
    DELETE FROM partner_order.order_etl_hdr
    WHERE order_etl_hdr_sno = i_order_etl_hdr_sno;

    RETURN json_build_object('status', 'success', 'message', 'Record deleted successfully');
END;
$$;


ALTER FUNCTION masters.delete_order_etl_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_otp(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint;
i_sms_otp character varying;
i_service_otp text;
i_push_otp text;
i_device_id text;
i_otp_expire_time_cd smallint;
i_otp_expire_time timestamp without time zone;
i_otp_status boolean;

  i_otp_sno bigint  := (in_data->>'otpSno')::bigint;
  
begin
  Select app_user_sno into i_app_user_sno from masters.otp where otp_sno = i_otp_sno;
Select sms_otp into i_sms_otp from masters.otp where otp_sno = i_otp_sno;
Select service_otp into i_service_otp from masters.otp where otp_sno = i_otp_sno;
Select push_otp into i_push_otp from masters.otp where otp_sno = i_otp_sno;
Select device_id into i_device_id from masters.otp where otp_sno = i_otp_sno;
Select otp_expire_time_cd into i_otp_expire_time_cd from masters.otp where otp_sno = i_otp_sno;
Select otp_expire_time into i_otp_expire_time from masters.otp where otp_sno = i_otp_sno;
Select otp_status into i_otp_status from masters.otp where otp_sno = i_otp_sno;

DELETE from masters.otp where otp_sno = i_otp_sno;

return (select(json_build_object('data',json_build_object(
 'otpSno',i_otp_sno,'appUserSno',i_app_user_sno,'smsOtp',i_sms_otp,'serviceOtp',i_service_otp,'pushOtp',i_push_otp,'deviceId',i_device_id,'otpExpireTimeCd',i_otp_expire_time_cd,'otpExpireTime',i_otp_expire_time,'otpStatus',i_otp_status
 ))));
end;
$$;


ALTER FUNCTION masters.delete_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_partner_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_partner_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_delivery_partner_sno smallint;
i_food_sku_sno smallint;
i_partner_food_code text;

  i_partner_food_sku_sno smallint  := (in_data->>'partnerFoodSkuSno')::smallint;
  
begin
  Select delivery_partner_sno into i_delivery_partner_sno from masters.partner_food_sku where partner_food_sku_sno = i_partner_food_sku_sno;
Select food_sku_sno into i_food_sku_sno from masters.partner_food_sku where partner_food_sku_sno = i_partner_food_sku_sno;
Select partner_food_code into i_partner_food_code from masters.partner_food_sku where partner_food_sku_sno = i_partner_food_sku_sno;

DELETE from masters.partner_food_sku where partner_food_sku_sno = i_partner_food_sku_sno;

return (select(json_build_object('data',json_build_object(
 'partnerFoodSkuSno',i_partner_food_sku_sno,'deliveryPartnerSno',i_delivery_partner_sno,'foodSkuSno',i_food_sku_sno,'partnerFoodCode',i_partner_food_code
 ))));
end;
$$;


ALTER FUNCTION masters.delete_partner_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_purchase_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_purchase_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_qbox_entity_sno bigint;
i_restaurant_sno bigint;
i_delivery_partner_sno smallint;
i_order_status_cd smallint;
i_ordered_time timestamp without time zone;
i_ordered_by bigint;
i_partner_purchase_order_id text;

  i_purchase_order_sno bigint  := (in_data->>'purchaseOrderSno')::bigint;
  
begin
  Select qbox_entity_sno into i_qbox_entity_sno from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;
Select restaurant_sno into i_restaurant_sno from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;
Select delivery_partner_sno into i_delivery_partner_sno from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;
Select order_status_cd into i_order_status_cd from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;
Select ordered_time into i_ordered_time from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;
Select ordered_by into i_ordered_by from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;
Select partner_purchase_order_id into i_partner_purchase_order_id from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;

DELETE from masters.purchase_order where purchase_order_sno = i_purchase_order_sno;

return (select(json_build_object('data',json_build_object(
 'purchaseOrderSno',i_purchase_order_sno,'qboxEntitySno',i_qbox_entity_sno,'restaurantSno',i_restaurant_sno,'deliveryPartnerSno',i_delivery_partner_sno,'orderStatusCd',i_order_status_cd,'orderedTime',i_ordered_time,'orderedBy',i_ordered_by,'partnerPurchaseOrderId',i_partner_purchase_order_id
 ))));
end;
$$;


ALTER FUNCTION masters.delete_purchase_order(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_purchase_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_purchase_order_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_purchase_order_sno bigint;
i_food_sku_sno bigint;
i_order_quantity smallint;
i_sku_price numeric;
i_partner_food_code text;

  i_purchase_order_dtl_sno bigint  := (in_data->>'purchaseOrderDtlSno')::bigint;
  
begin
  Select purchase_order_sno into i_purchase_order_sno from masters.purchase_order_dtl where purchase_order_dtl_sno = i_purchase_order_dtl_sno;
Select food_sku_sno into i_food_sku_sno from masters.purchase_order_dtl where purchase_order_dtl_sno = i_purchase_order_dtl_sno;
Select order_quantity into i_order_quantity from masters.purchase_order_dtl where purchase_order_dtl_sno = i_purchase_order_dtl_sno;
Select sku_price into i_sku_price from masters.purchase_order_dtl where purchase_order_dtl_sno = i_purchase_order_dtl_sno;
Select partner_food_code into i_partner_food_code from masters.purchase_order_dtl where purchase_order_dtl_sno = i_purchase_order_dtl_sno;

DELETE from masters.purchase_order_dtl where purchase_order_dtl_sno = i_purchase_order_dtl_sno;

return (select(json_build_object('data',json_build_object(
 'purchaseOrderDtlSno',i_purchase_order_dtl_sno,'purchaseOrderSno',i_purchase_order_sno,'foodSkuSno',i_food_sku_sno,'orderQuantity',i_order_quantity,'skuPrice',i_sku_price,'partnerFoodCode',i_partner_food_code
 ))));
end;
$$;


ALTER FUNCTION masters.delete_purchase_order_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_qbox_entity(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_qbox_entity(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_qbox_entity_name text;
i_address_sno bigint;
i_area_sno bigint;
i_qbox_entity_status_cd smallint;
i_created_on timestamp without time zone;

  i_qbox_entity_sno bigint  := (in_data->>'qboxEntitySno')::bigint;
  
begin
  Select qbox_entity_name into i_qbox_entity_name from masters.qbox_entity where qbox_entity_sno = i_qbox_entity_sno;
Select address_sno into i_address_sno from masters.qbox_entity where qbox_entity_sno = i_qbox_entity_sno;
Select area_sno into i_area_sno from masters.qbox_entity where qbox_entity_sno = i_qbox_entity_sno;
Select qbox_entity_status_cd into i_qbox_entity_status_cd from masters.qbox_entity where qbox_entity_sno = i_qbox_entity_sno;
Select created_on into i_created_on from masters.qbox_entity where qbox_entity_sno = i_qbox_entity_sno;

DELETE from masters.qbox_entity where qbox_entity_sno = i_qbox_entity_sno;

return (select(json_build_object('data',json_build_object(
 'qboxEntitySno',i_qbox_entity_sno,'qboxEntityName',i_qbox_entity_name,'addressSno',i_address_sno,'areaSno',i_area_sno,'qboxEntityStatusCd',i_qbox_entity_status_cd,'createdOn',i_created_on
 ))));
end;
$$;


ALTER FUNCTION masters.delete_qbox_entity(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_qbox_entity_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_qbox_entity_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_delivery_type_cd smallint;
i_qbox_entity_sno bigint;
i_delivery_partner_sno smallint;

  i_qbox_entity_delivery_partner_sno bigint  := (in_data->>'qboxEntityDeliveryPartnerSno')::bigint;
  
begin
  Select delivery_type_cd into i_delivery_type_cd from masters.qbox_entity_delivery_partner where qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno;
Select qbox_entity_sno into i_qbox_entity_sno from masters.qbox_entity_delivery_partner where qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno;
Select delivery_partner_sno into i_delivery_partner_sno from masters.qbox_entity_delivery_partner where qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno;

DELETE from masters.qbox_entity_delivery_partner where qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno;

return (select(json_build_object('data',json_build_object(
 'qboxEntityDeliveryPartnerSno',i_qbox_entity_delivery_partner_sno,'deliveryTypeCd',i_delivery_type_cd,'qboxEntitySno',i_qbox_entity_sno,'deliveryPartnerSno',i_delivery_partner_sno
 ))));
end;
$$;


ALTER FUNCTION masters.delete_qbox_entity_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_restaurant(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_restaurant(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_restaurant_brand_cd integer;
i_restaurant_name text;
i_address_sno bigint;
i_area_sno bigint;
i_restaurant_status_cd smallint;

  i_restaurant_sno bigint  := (in_data->>'restaurantSno')::bigint;
  
begin
  Select restaurant_brand_cd into i_restaurant_brand_cd from masters.restaurant where restaurant_sno = i_restaurant_sno;
Select name into i_restaurant_name from masters.restaurant where restaurant_sno = i_restaurant_sno;
Select address_sno into i_address_sno from masters.restaurant where restaurant_sno = i_restaurant_sno;
Select area_sno into i_area_sno from masters.restaurant where restaurant_sno = i_restaurant_sno;
Select restaurant_status_cd into i_restaurant_status_cd from masters.restaurant where restaurant_sno = i_restaurant_sno;

DELETE from masters.restaurant where restaurant_sno = i_restaurant_sno;

return (select(json_build_object('data',json_build_object(
 'restaurantSno',i_restaurant_sno,'restaurantBrandCd',i_restaurant_brand_cd,'restaurantName',i_restaurant_name,'addressSno',i_address_sno,'areaSno',i_area_sno,'restaurantStatusCd',i_restaurant_status_cd
 ))));
end;
$$;


ALTER FUNCTION masters.delete_restaurant(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_restaurant_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_restaurant_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_restaurant_sno bigint;
i_food_sku_sno bigint;
i_status boolean;

  i_restaurant_food_sku_sno bigint  := (in_data->>'restaurantFoodSkuSno')::bigint;
  
begin
  Select restaurant_sno into i_restaurant_sno from masters.restaurant_food_sku where restaurant_food_sku_sno = i_restaurant_food_sku_sno;
Select food_sku_sno into i_food_sku_sno from masters.restaurant_food_sku where restaurant_food_sku_sno = i_restaurant_food_sku_sno;
Select status into i_status from masters.restaurant_food_sku where restaurant_food_sku_sno = i_restaurant_food_sku_sno;

DELETE from masters.restaurant_food_sku where restaurant_food_sku_sno = i_restaurant_food_sku_sno;

return (select(json_build_object('data',json_build_object(
 'restaurantFoodSkuSno',i_restaurant_food_sku_sno,'restaurantSno',i_restaurant_sno,'foodSkuSno',i_food_sku_sno,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION masters.delete_restaurant_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_role_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_sno smallint;
i_app_role_sno smallint;
i_status boolean;

  i_role_menu_sno smallint  := (in_data->>'roleMenuSno')::smallint;
  
begin
  Select app_menu_sno into i_app_menu_sno from masters.role_menu where role_menu_sno = i_role_menu_sno;
Select app_role_sno into i_app_role_sno from masters.role_menu where role_menu_sno = i_role_menu_sno;
Select status into i_status from masters.role_menu where role_menu_sno = i_role_menu_sno;

DELETE from masters.role_menu where role_menu_sno = i_role_menu_sno;

return (select(json_build_object('data',json_build_object(
 'roleMenuSno',i_role_menu_sno,'appMenuSno',i_app_menu_sno,'appRoleSno',i_app_role_sno,'status',i_status
 ))));
end;
$$;


ALTER FUNCTION masters.delete_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_role_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_role_sno smallint;
i_app_permission_sno integer;

  i_role_permission_sno bigint  := (in_data->>'rolePermissionSno')::bigint;
  
begin
  Select app_role_sno into i_app_role_sno from masters.role_permission where role_permission_sno = i_role_permission_sno;
Select app_permission_sno into i_app_permission_sno from masters.role_permission where role_permission_sno = i_role_permission_sno;

DELETE from masters.role_permission where role_permission_sno = i_role_permission_sno;

return (select(json_build_object('data',json_build_object(
 'rolePermissionSno',i_role_permission_sno,'appRoleSno',i_app_role_sno,'appPermissionSno',i_app_permission_sno
 ))));
end;
$$;


ALTER FUNCTION masters.delete_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_sales_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_sales_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_partner_sales_order_id text;
i_qbox_entity_sno bigint;
i_delivery_partner_sno bigint;
i_order_status_cd smallint;
i_ordered_time timestamp without time zone;
i_ordered_by bigint;
i_partner_customer_ref text;

  i_sales_order_sno bigint  := (in_data->>'salesOrderSno')::bigint;
  
begin
  Select partner_sales_order_id into i_partner_sales_order_id from masters.sales_order where sales_order_sno = i_sales_order_sno;
Select qbox_entity_sno into i_qbox_entity_sno from masters.sales_order where sales_order_sno = i_sales_order_sno;
Select delivery_partner_sno into i_delivery_partner_sno from masters.sales_order where sales_order_sno = i_sales_order_sno;
Select order_status_cd into i_order_status_cd from masters.sales_order where sales_order_sno = i_sales_order_sno;
Select ordered_time into i_ordered_time from masters.sales_order where sales_order_sno = i_sales_order_sno;
Select ordered_by into i_ordered_by from masters.sales_order where sales_order_sno = i_sales_order_sno;
Select partner_customer_ref into i_partner_customer_ref from masters.sales_order where sales_order_sno = i_sales_order_sno;

DELETE from masters.sales_order where sales_order_sno = i_sales_order_sno;

return (select(json_build_object('data',json_build_object(
 'salesOrderSno',i_sales_order_sno,'partnerSalesOrderId',i_partner_sales_order_id,'qboxEntitySno',i_qbox_entity_sno,'deliveryPartnerSno',i_delivery_partner_sno,'orderStatusCd',i_order_status_cd,'orderedTime',i_ordered_time,'orderedBy',i_ordered_by,'partnerCustomerRef',i_partner_customer_ref
 ))));
end;
$$;


ALTER FUNCTION masters.delete_sales_order(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_sales_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_sales_order_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_sales_order_sno bigint;
i_partner_food_code text;
i_food_sku_sno bigint;
i_order_quantity integer;
i_sku_price numeric;

  i_sales_order_dtl_sno bigint  := (in_data->>'salesOrderDtlSno')::bigint;
  
begin
  Select sales_order_sno into i_sales_order_sno from masters.sales_order_dtl where sales_order_dtl_sno = i_sales_order_dtl_sno;
Select partner_food_code into i_partner_food_code from masters.sales_order_dtl where sales_order_dtl_sno = i_sales_order_dtl_sno;
Select food_sku_sno into i_food_sku_sno from masters.sales_order_dtl where sales_order_dtl_sno = i_sales_order_dtl_sno;
Select order_quantity into i_order_quantity from masters.sales_order_dtl where sales_order_dtl_sno = i_sales_order_dtl_sno;
Select sku_price into i_sku_price from masters.sales_order_dtl where sales_order_dtl_sno = i_sales_order_dtl_sno;

DELETE from masters.sales_order_dtl where sales_order_dtl_sno = i_sales_order_dtl_sno;

return (select(json_build_object('data',json_build_object(
 'salesOrderDtlSno',i_sales_order_dtl_sno,'salesOrderSno',i_sales_order_sno,'partnerFoodCode',i_partner_food_code,'foodSkuSno',i_food_sku_sno,'orderQuantity',i_order_quantity,'skuPrice',i_sku_price
 ))));
end;
$$;


ALTER FUNCTION masters.delete_sales_order_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_signin_info(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint;
i_push_token text;
i_device_type_cd smallint;
i_device_id text;
i_login_on timestamp without time zone;
i_logout_on timestamp without time zone;

  i_signin_info_sno bigint  := (in_data->>'signinInfoSno')::bigint;
  
begin
  Select app_user_sno into i_app_user_sno from masters.signin_info where signin_info_sno = i_signin_info_sno;
Select push_token into i_push_token from masters.signin_info where signin_info_sno = i_signin_info_sno;
Select device_type_cd into i_device_type_cd from masters.signin_info where signin_info_sno = i_signin_info_sno;
Select device_id into i_device_id from masters.signin_info where signin_info_sno = i_signin_info_sno;
Select login_on into i_login_on from masters.signin_info where signin_info_sno = i_signin_info_sno;
Select logout_on into i_logout_on from masters.signin_info where signin_info_sno = i_signin_info_sno;

DELETE from masters.signin_info where signin_info_sno = i_signin_info_sno;

return (select(json_build_object('data',json_build_object(
 'signinInfoSno',i_signin_info_sno,'appUserSno',i_app_user_sno,'pushToken',i_push_token,'deviceTypeCd',i_device_type_cd,'deviceId',i_device_id,'loginOn',i_login_on,'logoutOn',i_logout_on
 ))));
end;
$$;


ALTER FUNCTION masters.delete_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_sku_inventory(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_sku_inventory(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_purchase_order_dtl_sno bigint;
i_unique_code text;
i_sales_order_dtl_sno bigint;

  i_sku_inventory_sno bigint  := (in_data->>'skuInventorySno')::bigint;
  
begin
  Select purchase_order_dtl_sno into i_purchase_order_dtl_sno from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
Select unique_code into i_unique_code from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
Select sales_order_dtl_sno into i_sales_order_dtl_sno from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;

DELETE from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;

return (select(json_build_object('data',json_build_object(
 'skuInventorySno',i_sku_inventory_sno,'purchaseOrderDtlSno',i_purchase_order_dtl_sno,'uniqueCode',i_unique_code,'salesOrderDtlSno',i_sales_order_dtl_sno
 ))));
end;
$$;


ALTER FUNCTION masters.delete_sku_inventory(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_sku_trace_wf(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_sku_trace_wf(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_sku_inventory_sno bigint;
i_wf_stage_cd smallint;
i_action_time timestamp without time zone;
i_action_by bigint;

  i_sku_trace_wf_sno bigint  := (in_data->>'skuTraceWfSno')::bigint;
  
begin
  Select sku_inventory_sno into i_sku_inventory_sno from masters.sku_trace_wf where sku_trace_wf_sno = i_sku_trace_wf_sno;
Select wf_stage_cd into i_wf_stage_cd from masters.sku_trace_wf where sku_trace_wf_sno = i_sku_trace_wf_sno;
Select action_time into i_action_time from masters.sku_trace_wf where sku_trace_wf_sno = i_sku_trace_wf_sno;
Select action_by into i_action_by from masters.sku_trace_wf where sku_trace_wf_sno = i_sku_trace_wf_sno;

DELETE from masters.sku_trace_wf where sku_trace_wf_sno = i_sku_trace_wf_sno;

return (select(json_build_object('data',json_build_object(
 'skuTraceWfSno',i_sku_trace_wf_sno,'skuInventorySno',i_sku_inventory_sno,'wfStageCd',i_wf_stage_cd,'actionTime',i_action_time,'actionBy',i_action_by
 ))));
end;
$$;


ALTER FUNCTION masters.delete_sku_trace_wf(in_data json) OWNER TO qbox_admin;

--
-- Name: delete_state(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.delete_state(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_country_sno smallint;
i_state_code character varying;
i_name text;

  i_state_sno smallint  := (in_data->>'stateSno')::smallint;
  
begin
  Select country_sno into i_country_sno from masters.state where state_sno = i_state_sno;
Select state_code into i_state_code from masters.state where state_sno = i_state_sno;
Select name into i_name from masters.state where state_sno = i_state_sno;

DELETE from masters.state where state_sno = i_state_sno;

return (select(json_build_object('data',json_build_object(
 'stateSno',i_state_sno,'countrySno',i_country_sno,'stateCode',i_state_code,'name',i_name
 ))));
end;
$$;


ALTER FUNCTION masters.delete_state(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_address(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_address(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_address_sno bigint:= (in_data->>'addressSno')::bigint;
i_line1 text:= (in_data->>'line1')::text;
i_line2 text:= (in_data->>'line2')::text;
i_area_sno integer:= (in_data->>'areaSno')::integer;
i_city_sno integer:= (in_data->>'citySno')::integer;
i_geo_loc_code text:= (in_data->>'geoLocCode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.address SET line1= i_line1 ,line2= i_line2 ,area_sno= i_area_sno ,city_sno= i_city_sno ,geo_loc_code= i_geo_loc_code,active_flag= i_active_flag where address_sno = i_address_sno;

 return (select(json_build_object('data',json_build_object(
 'addressSno',address_sno,'line1',line1,'line2',line2,'areaSno',area_sno,'citySno',city_sno,'geoLocCode',geo_loc_code,'activeFlag',active_flag
 ))))
 FROM masters.address
 where    address_sno = i_address_sno;
end;
$$;


ALTER FUNCTION masters.edit_address(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_menu_name text:= (in_data->>'appMenuName')::text;
i_parent_menu_sno smallint:= (in_data->>'parentMenuSno')::smallint;
i_href text:= (in_data->>'href')::text;
i_title text:= (in_data->>'title')::text;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;


  
begin

UPDATE masters.app_menu SET app_menu_name= i_app_menu_name ,parent_menu_sno= i_parent_menu_sno ,href= i_href ,title= i_title ,status= i_status,active_flag= i_active_flag where app_menu_sno = i_app_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'appMenuSno',app_menu_sno,'appMenuName',app_menu_name,'parentMenuSno',parent_menu_sno,'href',href,'title',title,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.app_menu
 where    app_menu_sno = i_app_menu_sno;
end;
$$;


ALTER FUNCTION masters.edit_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_permission_sno bigint:= (in_data->>'appPermissionSno')::bigint;
i_app_permission_name text:= (in_data->>'appPermissionName')::text;
i_created_at timestamp without time zone:= (in_data->>'createdAt')::timestamp without time zone;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.app_permission SET app_permission_name= i_app_permission_name ,created_at= i_created_at,active_flag= i_active_flag where app_permission_sno = i_app_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'appPermissionSno',app_permission_sno,'appPermissionName',app_permission_name,'createdAt',created_at,'activeFlag',active_flag
 ))))
 FROM masters.app_permission
 where    app_permission_sno = i_app_permission_sno;
end;
$$;


ALTER FUNCTION masters.edit_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_role_name text:= (in_data->>'appRoleName')::text;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.app_role SET app_role_name= i_app_role_name ,status= i_status,active_flag= i_active_flag where app_role_sno = i_app_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appRoleSno',app_role_sno,'appRoleName',app_role_name,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.app_role
 where    app_role_sno = i_app_role_sno;
end;
$$;


ALTER FUNCTION masters.edit_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_user(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_user_id text:= (in_data->>'userId')::text;
i_password text:= (in_data->>'password')::text;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.app_user SET user_id= i_user_id ,password= i_password ,status= i_status,active_flag= i_active_flag where app_user_sno = i_app_user_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserSno',app_user_sno,'userId',user_id,'password',password,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.app_user
 where    app_user_sno = i_app_user_sno;
end;
$$;


ALTER FUNCTION masters.edit_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_app_user_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_app_user_role_sno bigint:= (in_data->>'appUserRoleSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.app_user_role SET app_user_sno= i_app_user_sno ,app_role_sno= i_app_role_sno,active_flag= i_active_flag where app_user_role_sno = i_app_user_role_sno;

 return (select(json_build_object('data',json_build_object(
 'appUserRoleSno',app_user_role_sno,'appUserSno',app_user_sno,'appRoleSno',app_role_sno,'activeFlag',active_flag
 ))))
 FROM masters.app_user_role
 where    app_user_role_sno = i_app_user_role_sno;
end;
$$;


ALTER FUNCTION masters.edit_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_area(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_area(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 

i_area_sno bigint:= (in_data->>'areaSno')::bigint;
i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_city_sno integer:= (in_data->>'citySno')::integer;
i_name text:= (in_data->>'name')::text;
i_pincode text:= (in_data->>'pincode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;
 
 
  
begin
 
UPDATE masters.area SET country_sno= i_country_sno ,state_sno= i_state_sno ,city_sno= i_city_sno ,name= i_name ,
	pincode= i_pincode, active_flag= i_active_flag  where area_sno = i_area_sno;
 
return (select(json_build_object('data',json_build_object(
'areaSno',area_sno,'countrySno',country_sno,'stateSno',state_sno,'citySno',city_sno,'name',name,'pincode',pincode,
	 'activeFlag',active_flag
))))
FROM masters.area
where    area_sno = i_area_sno;
end;
$$;


ALTER FUNCTION masters.edit_area(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_box_cell(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_box_cell(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_box_cell_sno bigint:= (in_data->>'boxCellSno')::bigint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
i_row_no smallint:= (in_data->>'rowNo')::smallint;
i_column_no smallint:= (in_data->>'columnNo')::smallint;
i_box_cell_status_cd smallint:= (in_data->>'boxCellStatusCd')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.box_cell SET qbox_entity_sno= i_qbox_entity_sno ,entity_infra_sno= i_entity_infra_sno ,row_no= i_row_no ,column_no= i_column_no ,box_cell_status_cd= i_box_cell_status_cd,active_flag= i_active_flag where box_cell_sno = i_box_cell_sno;

 return (select(json_build_object('data',json_build_object(
 'boxCellSno',box_cell_sno,'qboxEntitySno',qbox_entity_sno,'entityInfraSno',entity_infra_sno,'rowNo',row_no,'columnNo',column_no,'boxCellStatusCd',box_cell_status_cd,'activeFlag',active_flag
 ))))
 FROM masters.box_cell
 where    box_cell_sno = i_box_cell_sno;
end;
$$;


ALTER FUNCTION masters.edit_box_cell(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_box_cell_food(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_box_cell_food(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_box_cell_food_sno bigint:= (in_data->>'boxCellFoodSno')::bigint;
i_box_cell_sno smallint:= (in_data->>'boxCellSno')::smallint;
i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_entry_time timestamp without time zone:= (in_data->>'entryTime')::timestamp without time zone;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.box_cell_food SET box_cell_sno= i_box_cell_sno ,sku_inventory_sno= i_sku_inventory_sno ,entry_time= i_entry_time ,qbox_entity_sno= i_qbox_entity_sno,active_flag= i_active_flag where box_cell_food_sno = i_box_cell_food_sno;

 return (select(json_build_object('data',json_build_object(
 'boxCellFoodSno',box_cell_food_sno,'boxCellSno',box_cell_sno,'skuInventorySno',sku_inventory_sno,'entryTime',entry_time,'qboxEntitySno',qbox_entity_sno,'activeFlag',active_flag
 ))))
 FROM masters.box_cell_food
 where    box_cell_food_sno = i_box_cell_food_sno;
end;
$$;


ALTER FUNCTION masters.edit_box_cell_food(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_box_cell_food_hist(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_box_cell_food_hist(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_box_cell_food_hist_sno bigint:= (in_data->>'boxCellFoodHistSno')::bigint;
i_box_cell_food_sno bigint:= (in_data->>'boxCellFoodSno')::bigint;
i_box_cell_sno smallint:= (in_data->>'boxCellSno')::smallint;
i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_entry_time timestamp without time zone:= (in_data->>'entryTime')::timestamp without time zone;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.box_cell_food_hist SET box_cell_food_sno= i_box_cell_food_sno ,box_cell_sno= i_box_cell_sno ,sku_inventory_sno= i_sku_inventory_sno ,entry_time= i_entry_time ,qbox_entity_sno= i_qbox_entity_sno,active_flag= i_active_flag where box_cell_food_hist_sno = i_box_cell_food_hist_sno;

 return (select(json_build_object('data',json_build_object(
 'boxCellFoodHistSno',box_cell_food_hist_sno,'boxCellFoodSno',box_cell_food_sno,'boxCellSno',box_cell_sno,'skuInventorySno',sku_inventory_sno,'entryTime',entry_time,'qboxEntitySno',qbox_entity_sno,'activeFlag',active_flag
 ))))
 FROM masters.box_cell_food_hist
 where    box_cell_food_hist_sno = i_box_cell_food_hist_sno;
end;
$$;


ALTER FUNCTION masters.edit_box_cell_food_hist(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_city(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_city(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_city_sno bigint:= (in_data->>'citySno')::bigint;
i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_name text:= (in_data->>'name')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.city SET country_sno= i_country_sno ,state_sno= i_state_sno ,name= i_name,active_flag= i_active_flag where city_sno = i_city_sno;

 return (select(json_build_object('data',json_build_object(
 'citySno',city_sno,'countrySno',country_sno,'stateSno',state_sno,'name',name,'activeFlag',active_flag
 ))))
 FROM masters.city
 where    city_sno = i_city_sno;
end;
$$;


ALTER FUNCTION masters.edit_city(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_codes_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_codes_dtl_sno smallint:= (in_data->>'codesDtlSno')::smallint;
i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_cd_value text:= (in_data->>'cdValue')::text;
i_seqno integer:= (in_data->>'seqno')::integer;
i_filter_1 text:= (in_data->>'filter1')::text;
i_filter_2 text:= (in_data->>'filter2')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.codes_dtl SET codes_hdr_sno= i_codes_hdr_sno ,description= i_cd_value ,seqno= i_seqno ,filter_1= i_filter_1 ,filter_2= i_filter_2 ,active_flag= i_active_flag where codes_dtl_sno = i_codes_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'codesDtlSno',codes_dtl_sno,'codesHdrSno',codes_hdr_sno,'cdValue',description,'seqno',seqno,'filter1',filter_1,'filter2',filter_2,'activeFlag',active_flag
 ))))
 FROM masters.codes_dtl
 where    codes_dtl_sno = i_codes_dtl_sno;
end;
$$;


ALTER FUNCTION masters.edit_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_codes_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_code_type text:= (in_data->>'codeType')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.codes_hdr SET description= i_code_type ,active_flag= i_active_flag where codes_hdr_sno = i_codes_hdr_sno;

 return (select(json_build_object('data',json_build_object(
 'codesHdrSno',codes_hdr_sno,'codeType',description,'activeFlag',active_flag
 ))))
 FROM masters.codes_hdr
 where    codes_hdr_sno = i_codes_hdr_sno;
end;
$$;


ALTER FUNCTION masters.edit_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_country(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_country(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_name text:= (in_data->>'name')::text;
i_iso2 character varying:= (in_data->>'iso2')::character varying;
i_phone_code character varying:= (in_data->>'phoneCode')::character varying;
i_numeric_code character varying:= (in_data->>'numericCode')::character varying;
i_currency_code character varying:= (in_data->>'currencyCode')::character varying;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.country SET name= i_name ,iso2= i_iso2 ,phone_code= i_phone_code ,numeric_code= i_numeric_code ,currency_code= i_currency_code,active_flag= i_active_flag where country_sno = i_country_sno;

 return (select(json_build_object('data',json_build_object(
 'countrySno',country_sno,'name',name,'iso2',iso2,'phoneCode',phone_code,'numericCode',numeric_code,'currencyCode',currency_code,'activeFlag',active_flag
 ))))
 FROM masters.country
 where    country_sno = i_country_sno;
end;
$$;


ALTER FUNCTION masters.edit_country(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_partner_code character varying:= (in_data->>'partnerCode')::character varying;
i_partner_name text:= (in_data->>'partnerName')::text;
i_partner_status_cd smallint:= (in_data->>'partnerStatusCd')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.delivery_partner SET partner_code= i_partner_code ,name= i_partner_name ,partner_status_cd= i_partner_status_cd,active_flag= i_active_flag where delivery_partner_sno = i_delivery_partner_sno;

 return (select(json_build_object('data',json_build_object(
 'deliveryPartnerSno',delivery_partner_sno,'partnerCode',partner_code,'partnerName',name,'partnerStatusCd',partner_status_cd,'activeFlag',active_flag
 ))))
 FROM masters.delivery_partner
 where    delivery_partner_sno = i_delivery_partner_sno;
end;
$$;


ALTER FUNCTION masters.edit_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_entity_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_entity_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_infra_sno bigint:= (in_data->>'infraSno')::bigint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.entity_infra SET qbox_entity_sno= i_qbox_entity_sno ,infra_sno= i_infra_sno,active_flag= i_active_flag where entity_infra_sno = i_entity_infra_sno;

 return (select(json_build_object('data',json_build_object(
 'entityInfraSno',entity_infra_sno,'qboxEntitySno',qbox_entity_sno,'infraSno',infra_sno,'activeFlag',active_flag
 ))))
 FROM masters.entity_infra
 where    entity_infra_sno = i_entity_infra_sno;
end;
$$;


ALTER FUNCTION masters.edit_entity_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_entity_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_entity_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_entity_infra_property_sno bigint:= (in_data->>'entityInfraPropertySno')::bigint;
i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
i_infra_property_sno smallint:= (in_data->>'infraPropertySno')::smallint;
i_value text:= (in_data->>'value')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.entity_infra_property SET entity_infra_sno= i_entity_infra_sno ,infra_property_sno= i_infra_property_sno ,value= i_value,active_flag= i_active_flag where entity_infra_property_sno = i_entity_infra_property_sno;

 return (select(json_build_object('data',json_build_object(
 'entityInfraPropertySno',entity_infra_property_sno,'entityInfraSno',entity_infra_sno,'infraPropertySno',infra_property_sno,'value',value,'activeFlag',active_flag
 ))))
 FROM masters.entity_infra_property
 where    entity_infra_property_sno = i_entity_infra_property_sno;
end;
$$;


ALTER FUNCTION masters.edit_entity_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_etl_table_column(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_etl_table_column(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_etl_table_column_sno SMALLINT := (in_data->>'etlTableColumnSno')::smallint;
    i_order_etl_hdr_sno SMALLINT := (in_data->>'orderEtlHdrSno')::smallint;
    i_source_column VARCHAR(255) := (in_data->>'sourceColumn')::varchar;
    i_staging_column VARCHAR(255) := (in_data->>'stagingColumn')::varchar;
    i_data_type VARCHAR(50) := (in_data->>'dataType')::varchar;
    i_is_required BOOLEAN := (in_data->>'isRequired')::boolean;
    i_description TEXT := (in_data->>'description')::text;
BEGIN
    UPDATE partner_order.etl_table_column
    SET 
        order_etl_hdr_sno = i_order_etl_hdr_sno,
        source_column = i_source_column,
        staging_column = i_staging_column,
        data_type = i_data_type,
        is_required = COALESCE(i_is_required, TRUE),
        description = i_description,
        updated_at = CURRENT_TIMESTAMP
    WHERE etl_table_column_sno = i_etl_table_column_sno;

    RETURN (
        SELECT json_build_object('data', json_build_object(
            'etlTableColumnSno', etl_table_column_sno, 'orderEtlHdrSno', order_etl_hdr_sno,
            'sourceColumn', source_column, 'stagingColumn', staging_column,
            'dataType', data_type, 'isRequired', is_required, 
            'description', description, 'createdAt', created_at, 'updatedAt', updated_at
        ))
        FROM partner_order.etl_table_column WHERE etl_table_column_sno = i_etl_table_column_sno
    );
END;
$$;


ALTER FUNCTION masters.edit_etl_table_column(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_restaurant_brand_cd text:= (in_data->>'restaurantBrandCd')::text;
i_food_name text:= (in_data->>'foodName')::text;
i_sku_code text:= (in_data->>'skuCode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.food_sku SET restaurant_brand_cd= i_restaurant_brand_cd ,name= i_food_name ,sku_code= i_sku_code,active_flag= i_active_flag where food_sku_sno = i_food_sku_sno;

 return (select(json_build_object('data',json_build_object(
 'foodSkuSno',food_sku_sno,'restaurantBrandCd',restaurant_brand_cd,'foodName',name,'skuCode',sku_code,'activeFlag',active_flag
 ))))
 FROM masters.food_sku
 where    food_sku_sno = i_food_sku_sno;
end;
$$;


ALTER FUNCTION masters.edit_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 

  i_infra_sno smallint:= (in_data->>'infraSno')::smallint;
i_infra_name text:= (in_data->>'infraName')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;
 
  
begin
 
UPDATE masters.infra SET name= i_infra_name,active_flag= i_active_flag where infra_sno = i_infra_sno;
 
return (select(json_build_object('data',json_build_object(
'infraSno',infra_sno,'infraName',name,'activeFlag',active_flag
))))
FROM masters.infra
where    infra_sno = i_infra_sno;
end;
$$;


ALTER FUNCTION masters.edit_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$

declare 


  i_infra_property_sno smallint:= (in_data->>'infraPropertySno')::smallint;

i_infra_sno smallint:= (in_data->>'infraSno')::smallint;

i_property_name text:= (in_data->>'propertyName')::text;

i_data_type_cd smallint:= (in_data->>'dataTypeCd')::smallint;

i_active_flag boolean:= (in_data->>'activeFlag')::boolean;
 
  

begin
 
UPDATE masters.infra_property SET infra_sno= i_infra_sno ,name= i_property_name ,data_type_cd= i_data_type_cd,active_flag= i_active_flag where infra_property_sno = i_infra_property_sno;
 
return (select(json_build_object('data',json_build_object(

'infraPropertySno',infra_property_sno,'infraSno',infra_sno,'propertyName',name,'dataTypeCd',data_type_cd,'activeFlag',active_flag

))))

FROM masters.infra_property

where    infra_property_sno = i_infra_property_sno;

end;

$$;


ALTER FUNCTION masters.edit_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_menu_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_menu_permission_sno smallint:= (in_data->>'menuPermissionSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_permission_sno smallint:= (in_data->>'appPermissionSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.menu_permission SET app_menu_sno= i_app_menu_sno ,app_permission_sno= i_app_permission_sno ,status= i_status,active_flag= i_active_flag where menu_permission_sno = i_menu_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'menuPermissionSno',menu_permission_sno,'appMenuSno',app_menu_sno,'appPermissionSno',app_permission_sno,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.menu_permission
 where    menu_permission_sno = i_menu_permission_sno;
end;
$$;


ALTER FUNCTION masters.edit_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_order_etl_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_order_etl_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_order_etl_hdr_sno SMALLINT := (in_data->>'orderEtlHdrSno')::smallint;
    i_delivery_partner_sno SMALLINT := (in_data->>'deliveryPartnerSno')::smallint;
    i_partner_code VARCHAR := (in_data->>'partnerCode')::varchar;
    i_staging_table_name VARCHAR := (in_data->>'stagingTableName')::varchar;
    i_is_active BOOLEAN := (in_data->>'isActive')::boolean;
    i_file_name_prefix VARCHAR(7) := (in_data->>'fileNamePrefix')::varchar(7);
BEGIN
    UPDATE partner_order.order_etl_hdr
    SET 
        delivery_partner_sno = i_delivery_partner_sno,
        partner_code = i_partner_code,
        staging_table_name = i_staging_table_name,
        is_active = COALESCE(i_is_active, TRUE),
        file_name_prefix = i_file_name_prefix
    WHERE order_etl_hdr_sno = i_order_etl_hdr_sno;

    RETURN (
        SELECT json_build_object('data', json_build_object(
            'orderEtlHdrSno', order_etl_hdr_sno, 'deliveryPartnerSno', delivery_partner_sno,
            'partnerCode', partner_code, 'stagingTableName', staging_table_name,
            'isActive', is_active, 'fileNamePrefix', file_name_prefix
        ))
        FROM partner_order.order_etl_hdr WHERE order_etl_hdr_sno = i_order_etl_hdr_sno
    );
END;
$$;


ALTER FUNCTION masters.edit_order_etl_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_otp(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_otp_sno bigint:= (in_data->>'otpSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_sms_otp character varying:= (in_data->>'smsOtp')::character varying;
i_service_otp text:= (in_data->>'serviceOtp')::text;
i_push_otp text:= (in_data->>'pushOtp')::text;
i_device_id text:= (in_data->>'deviceId')::text;
i_otp_expire_time_cd smallint:= (in_data->>'otpExpireTimeCd')::smallint;
i_otp_expire_time timestamp without time zone:= (in_data->>'otpExpireTime')::timestamp without time zone;
i_otp_status boolean:= (in_data->>'otpStatus')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.otp SET app_user_sno= i_app_user_sno ,sms_otp= i_sms_otp ,service_otp= i_service_otp ,push_otp= i_push_otp ,device_id= i_device_id ,otp_expire_time_cd= i_otp_expire_time_cd ,otp_expire_time= i_otp_expire_time ,otp_status= i_otp_status,active_flag= i_active_flag where otp_sno = i_otp_sno;

 return (select(json_build_object('data',json_build_object(
 'otpSno',otp_sno,'appUserSno',app_user_sno,'smsOtp',sms_otp,'serviceOtp',service_otp,'pushOtp',push_otp,'deviceId',device_id,'otpExpireTimeCd',otp_expire_time_cd,'otpExpireTime',otp_expire_time,'otpStatus',otp_status,'activeFlag',active_flag
 ))))
 FROM masters.otp
 where    otp_sno = i_otp_sno;
end;
$$;


ALTER FUNCTION masters.edit_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_partner_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_partner_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_partner_food_sku_sno smallint:= (in_data->>'partnerFoodSkuSno')::smallint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_food_sku_sno smallint:= (in_data->>'foodSkuSno')::smallint;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.partner_food_sku SET delivery_partner_sno= i_delivery_partner_sno ,food_sku_sno= i_food_sku_sno ,partner_food_code= i_partner_food_code,active_flag= i_active_flag where partner_food_sku_sno = i_partner_food_sku_sno;

 return (select(json_build_object('data',json_build_object(
 'partnerFoodSkuSno',partner_food_sku_sno,'deliveryPartnerSno',delivery_partner_sno,'foodSkuSno',food_sku_sno,'partnerFoodCode',partner_food_code,'activeFlag',active_flag
 ))))
 FROM masters.partner_food_sku
 where    partner_food_sku_sno = i_partner_food_sku_sno;
end;
$$;


ALTER FUNCTION masters.edit_partner_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_purchase_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_purchase_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_purchase_order_sno bigint:= (in_data->>'purchaseOrderSno')::bigint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;
i_ordered_time timestamp without time zone:= (in_data->>'orderedTime')::timestamp without time zone;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_purchase_order_id text:= (in_data->>'partnerPurchaseOrderId')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.purchase_order SET qbox_entity_sno= i_qbox_entity_sno ,restaurant_sno= i_restaurant_sno ,delivery_partner_sno= i_delivery_partner_sno ,order_status_cd= i_order_status_cd ,ordered_time= i_ordered_time ,ordered_by= i_ordered_by ,partner_purchase_order_id= i_partner_purchase_order_id,active_flag= i_active_flag where purchase_order_sno = i_purchase_order_sno;

 return (select(json_build_object('data',json_build_object(
 'purchaseOrderSno',purchase_order_sno,'qboxEntitySno',qbox_entity_sno,'restaurantSno',restaurant_sno,'deliveryPartnerSno',delivery_partner_sno,'orderStatusCd',order_status_cd,'orderedTime',ordered_time,'orderedBy',ordered_by,'partnerPurchaseOrderId',partner_purchase_order_id,'activeFlag',active_flag
 ))))
 FROM masters.purchase_order
 where    purchase_order_sno = i_purchase_order_sno;
end;
$$;


ALTER FUNCTION masters.edit_purchase_order(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_purchase_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_purchase_order_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_purchase_order_dtl_sno bigint:= (in_data->>'purchaseOrderDtlSno')::bigint;
i_purchase_order_sno bigint:= (in_data->>'purchaseOrderSno')::bigint;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_order_quantity smallint:= (in_data->>'orderQuantity')::smallint;
i_sku_price numeric:= (in_data->>'skuPrice')::numeric;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.purchase_order_dtl SET purchase_order_sno= i_purchase_order_sno ,food_sku_sno= i_food_sku_sno ,order_quantity= i_order_quantity ,sku_price= i_sku_price ,partner_food_code= i_partner_food_code,active_flag= i_active_flag where purchase_order_dtl_sno = i_purchase_order_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'purchaseOrderDtlSno',purchase_order_dtl_sno,'purchaseOrderSno',purchase_order_sno,'foodSkuSno',food_sku_sno,'orderQuantity',order_quantity,'skuPrice',sku_price,'partnerFoodCode',partner_food_code,'activeFlag',active_flag
 ))))
 FROM masters.purchase_order_dtl
 where    purchase_order_dtl_sno = i_purchase_order_dtl_sno;
end;
$$;


ALTER FUNCTION masters.edit_purchase_order_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_qbox_entity(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_qbox_entity(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_qbox_entity_name text:= (in_data->>'qboxEntityName')::text;
i_address_sno bigint:= (in_data->>'addressSno')::bigint;
i_area_sno bigint:= (in_data->>'areaSno')::bigint;
i_qbox_entity_status_cd smallint:= (in_data->>'qboxEntityStatusCd')::smallint;
i_created_on timestamp without time zone:= (in_data->>'createdOn')::timestamp without time zone;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.qbox_entity SET qbox_entity_name= i_qbox_entity_name ,address_sno= i_address_sno ,area_sno= i_area_sno ,qbox_entity_status_cd= i_qbox_entity_status_cd ,created_on= i_created_on,active_flag= i_active_flag where qbox_entity_sno = i_qbox_entity_sno;

 return (select(json_build_object('data',json_build_object(
 'qboxEntitySno',qbox_entity_sno,'qboxEntityName',qbox_entity_name,'addressSno',address_sno,'areaSno',area_sno,'qboxEntityStatusCd',qbox_entity_status_cd,'createdOn',created_on,'activeFlag',active_flag
 ))))
 FROM masters.qbox_entity
 where    qbox_entity_sno = i_qbox_entity_sno;
end;
$$;


ALTER FUNCTION masters.edit_qbox_entity(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_qbox_entity_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_qbox_entity_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_qbox_entity_delivery_partner_sno bigint:= (in_data->>'qboxEntityDeliveryPartnerSno')::bigint;
i_delivery_type_cd smallint:= (in_data->>'deliveryTypeCd')::smallint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.qbox_entity_delivery_partner SET delivery_type_cd= i_delivery_type_cd ,qbox_entity_sno= i_qbox_entity_sno ,delivery_partner_sno= i_delivery_partner_sno,active_flag= i_active_flag where qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno;

 return (select(json_build_object('data',json_build_object(
 'qboxEntityDeliveryPartnerSno',qbox_entity_delivery_partner_sno,'deliveryTypeCd',delivery_type_cd,'qboxEntitySno',qbox_entity_sno,'deliveryPartnerSno',delivery_partner_sno,'activeFlag',active_flag
 ))))
 FROM masters.qbox_entity_delivery_partner
 where    qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno;
end;
$$;


ALTER FUNCTION masters.edit_qbox_entity_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_restaurant(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_restaurant(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_restaurant_brand_cd integer:= (in_data->>'restaurantBrandCd')::integer;
i_restaurant_name text:= (in_data->>'restaurantName')::text;
i_address_sno bigint:= (in_data->>'addressSno')::bigint;
i_area_sno bigint:= (in_data->>'areaSno')::bigint;
i_restaurant_status_cd smallint:= (in_data->>'restaurantStatusCd')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.restaurant SET restaurant_brand_cd= i_restaurant_brand_cd ,name= i_restaurant_name ,address_sno= i_address_sno ,area_sno= i_area_sno ,restaurant_status_cd= i_restaurant_status_cd,active_flag= i_active_flag where restaurant_sno = i_restaurant_sno;

 return (select(json_build_object('data',json_build_object(
 'restaurantSno',restaurant_sno,'restaurantBrandCd',restaurant_brand_cd,'restaurantName',name,'addressSno',address_sno,'areaSno',area_sno,'restaurantStatusCd',restaurant_status_cd,'activeFlag',active_flag
 ))))
 FROM masters.restaurant
 where    restaurant_sno = i_restaurant_sno;
end;
$$;


ALTER FUNCTION masters.edit_restaurant(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_restaurant_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_restaurant_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_restaurant_food_sku_sno bigint:= (in_data->>'restaurantFoodSkuSno')::bigint;
i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.restaurant_food_sku SET restaurant_sno= i_restaurant_sno ,food_sku_sno= i_food_sku_sno ,status= i_status,active_flag= i_active_flag where restaurant_food_sku_sno = i_restaurant_food_sku_sno;

 return (select(json_build_object('data',json_build_object(
 'restaurantFoodSkuSno',restaurant_food_sku_sno,'restaurantSno',restaurant_sno,'foodSkuSno',food_sku_sno,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.restaurant_food_sku
 where    restaurant_food_sku_sno = i_restaurant_food_sku_sno;
end;
$$;


ALTER FUNCTION masters.edit_restaurant_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_role_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_role_menu_sno smallint:= (in_data->>'roleMenuSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.role_menu SET app_menu_sno= i_app_menu_sno ,app_role_sno= i_app_role_sno ,status= i_status,active_flag= i_active_flag where role_menu_sno = i_role_menu_sno;

 return (select(json_build_object('data',json_build_object(
 'roleMenuSno',role_menu_sno,'appMenuSno',app_menu_sno,'appRoleSno',app_role_sno,'status',status,'activeFlag',active_flag
 ))))
 FROM masters.role_menu
 where    role_menu_sno = i_role_menu_sno;
end;
$$;


ALTER FUNCTION masters.edit_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_role_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_role_permission_sno bigint:= (in_data->>'rolePermissionSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_permission_sno integer:= (in_data->>'appPermissionSno')::integer;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.role_permission SET app_role_sno= i_app_role_sno ,app_permission_sno= i_app_permission_sno,active_flag= i_active_flag  where role_permission_sno = i_role_permission_sno;

 return (select(json_build_object('data',json_build_object(
 'rolePermissionSno',role_permission_sno,'appRoleSno',app_role_sno,'appPermissionSno',app_permission_sno,'activeFlag',active_flag
 ))))
 FROM masters.role_permission
 where    role_permission_sno = i_role_permission_sno;
end;
$$;


ALTER FUNCTION masters.edit_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_sales_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_sales_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_sales_order_sno bigint:= (in_data->>'salesOrderSno')::bigint;
i_partner_sales_order_id text:= (in_data->>'partnerSalesOrderId')::text;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_delivery_partner_sno bigint:= (in_data->>'deliveryPartnerSno')::bigint;
i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;
i_ordered_time timestamp without time zone:= (in_data->>'orderedTime')::timestamp without time zone;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_customer_ref text:= (in_data->>'partnerCustomerRef')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.sales_order SET partner_sales_order_id= i_partner_sales_order_id ,qbox_entity_sno= i_qbox_entity_sno ,delivery_partner_sno= i_delivery_partner_sno ,order_status_cd= i_order_status_cd ,ordered_time= i_ordered_time ,ordered_by= i_ordered_by ,partner_customer_ref= i_partner_customer_ref,active_flag= i_active_flag where sales_order_sno = i_sales_order_sno;

 return (select(json_build_object('data',json_build_object(
 'salesOrderSno',sales_order_sno,'partnerSalesOrderId',partner_sales_order_id,'qboxEntitySno',qbox_entity_sno,'deliveryPartnerSno',delivery_partner_sno,'orderStatusCd',order_status_cd,'orderedTime',ordered_time,'orderedBy',ordered_by,'partnerCustomerRef',partner_customer_ref,'activeFlag',active_flag
 ))))
 FROM masters.sales_order
 where    sales_order_sno = i_sales_order_sno;
end;
$$;


ALTER FUNCTION masters.edit_sales_order(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_sales_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_sales_order_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_sales_order_dtl_sno bigint:= (in_data->>'salesOrderDtlSno')::bigint;
i_sales_order_sno bigint:= (in_data->>'salesOrderSno')::bigint;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_order_quantity integer:= (in_data->>'orderQuantity')::integer;
i_sku_price numeric:= (in_data->>'skuPrice')::numeric;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.sales_order_dtl SET sales_order_sno= i_sales_order_sno ,partner_food_code= i_partner_food_code ,food_sku_sno= i_food_sku_sno ,order_quantity= i_order_quantity ,sku_price= i_sku_price,active_flag= i_active_flag where sales_order_dtl_sno = i_sales_order_dtl_sno;

 return (select(json_build_object('data',json_build_object(
 'salesOrderDtlSno',sales_order_dtl_sno,'salesOrderSno',sales_order_sno,'partnerFoodCode',partner_food_code,'foodSkuSno',food_sku_sno,'orderQuantity',order_quantity,'skuPrice',sku_price,'activeFlag',active_flag
 ))))
 FROM masters.sales_order_dtl
 where    sales_order_dtl_sno = i_sales_order_dtl_sno;
end;
$$;


ALTER FUNCTION masters.edit_sales_order_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_signin_info(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_signin_info_sno bigint:= (in_data->>'signinInfoSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_push_token text:= (in_data->>'pushToken')::text;
i_device_type_cd smallint:= (in_data->>'deviceTypeCd')::smallint;
i_device_id text:= (in_data->>'deviceId')::text;
i_login_on timestamp without time zone:= (in_data->>'loginOn')::timestamp without time zone;
i_logout_on timestamp without time zone:= (in_data->>'logoutOn')::timestamp without time zone;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.signin_info SET app_user_sno= i_app_user_sno ,push_token= i_push_token ,device_type_cd= i_device_type_cd ,device_id= i_device_id ,login_on= i_login_on ,logout_on= i_logout_on,active_flag= i_active_flag where signin_info_sno = i_signin_info_sno;

 return (select(json_build_object('data',json_build_object(
 'signinInfoSno',signin_info_sno,'appUserSno',app_user_sno,'pushToken',push_token,'deviceTypeCd',device_type_cd,'deviceId',device_id,'loginOn',login_on,'logoutOn',logout_on,'activeFlag',active_flag
 ))))
 FROM masters.signin_info
 where    signin_info_sno = i_signin_info_sno;
end;
$$;


ALTER FUNCTION masters.edit_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_sku_inventory(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_sku_inventory(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_purchase_order_dtl_sno bigint:= (in_data->>'purchaseOrderDtlSno')::bigint;
i_unique_code text:= (in_data->>'uniqueCode')::text;
i_sales_order_dtl_sno bigint:= (in_data->>'salesOrderDtlSno')::bigint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.sku_inventory SET purchase_order_dtl_sno= i_purchase_order_dtl_sno ,unique_code= i_unique_code ,sales_order_dtl_sno= i_sales_order_dtl_sno,active_flag= i_active_flag where sku_inventory_sno = i_sku_inventory_sno;

 return (select(json_build_object('data',json_build_object(
 'skuInventorySno',sku_inventory_sno,'purchaseOrderDtlSno',purchase_order_dtl_sno,'uniqueCode',unique_code,'salesOrderDtlSno',sales_order_dtl_sno,'activeFlag',active_flag
 ))))
 FROM masters.sku_inventory
 where    sku_inventory_sno = i_sku_inventory_sno;
end;
$$;


ALTER FUNCTION masters.edit_sku_inventory(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_sku_trace_wf(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_sku_trace_wf(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_sku_trace_wf_sno bigint:= (in_data->>'skuTraceWfSno')::bigint;
i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_wf_stage_cd smallint:= (in_data->>'wfStageCd')::smallint;
i_action_time timestamp without time zone:= (in_data->>'actionTime')::timestamp without time zone;
i_action_by bigint:= (in_data->>'actionBy')::bigint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.sku_trace_wf SET sku_inventory_sno= i_sku_inventory_sno ,wf_stage_cd= i_wf_stage_cd ,action_time= i_action_time ,action_by= i_action_by,active_flag= i_active_flag where sku_trace_wf_sno = i_sku_trace_wf_sno;

 return (select(json_build_object('data',json_build_object(
 'skuTraceWfSno',sku_trace_wf_sno,'skuInventorySno',sku_inventory_sno,'wfStageCd',wf_stage_cd,'actionTime',action_time,'actionBy',action_by,'activeFlag',active_flag
 ))))
 FROM masters.sku_trace_wf
 where    sku_trace_wf_sno = i_sku_trace_wf_sno;
end;
$$;


ALTER FUNCTION masters.edit_sku_trace_wf(in_data json) OWNER TO qbox_admin;

--
-- Name: edit_state(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.edit_state(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
  
  
  i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_code character varying:= (in_data->>'stateCode')::character varying;
i_name text:= (in_data->>'name')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

UPDATE masters.state SET country_sno= i_country_sno ,state_code= i_state_code ,name= i_name,active_flag= i_active_flag where state_sno = i_state_sno;

 return (select(json_build_object('data',json_build_object(
 'stateSno',state_sno,'countrySno',country_sno,'stateCode',state_code,'name',name,'activeFlag',active_flag
 ))))
 FROM masters.state
 where    state_sno = i_state_sno;
end;
$$;


ALTER FUNCTION masters.edit_state(in_data json) OWNER TO qbox_admin;

--
-- Name: get_box_cell_inventory(jsonb); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_box_cell_inventory(inputdata jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    inventory_result JSONB;
    counts_result JSONB;
BEGIN
    -- Validate inputData contains required fields
    IF NOT (inputData ? 'qboxEntitySno') THEN
        RAISE EXCEPTION 'Input JSONB must contain the "qboxEntitySno" key';
    END IF;
 
    -- Ensure "qboxEntitySno" is an integer
    IF NOT (inputData->>'qboxEntitySno')::INTEGER IS NOT NULL THEN
        RAISE EXCEPTION '"qboxEntitySno" must be a valid integer';
    END IF;
 
    -- -- Execute the query for Box Cell Inventory
    -- SELECT JSONB_AGG(
    --     JSONB_BUILD_OBJECT(
    --         'boxCellSno', bc.box_cell_sno,
    --         'rowNo', bc.row_no,
    --         'columnNo', bc.column_no,
    --         'description', COALESCE(si.description, 'EMPTY')
    --     ) ORDER BY bc.row_no, bc.column_no ASC
    -- ) INTO inventory_result
    -- FROM masters.box_cell_food cbf
    -- RIGHT OUTER JOIN masters.box_cell bc
    -- ON bc.box_cell_sno = cbf.box_cell_sno
    -- LEFT OUTER JOIN masters.sku_inventory si
    -- ON cbf.sku_inventory_sno = si.sku_inventory_sno
    -- WHERE bc.qbox_entity_sno = (inputData->>'qboxEntitySno')::INTEGER;
 
 
SELECT JSONB_BUILD_OBJECT(
	'qboxEntityName' , (Select name from masters.qbox_entity where qbox_entity_sno =  (inputData->>'qboxEntitySno')::INTEGER),
'rowCount',(Select value from masters.entity_infra_property where infra_property_sno = 5 and
entity_infra_sno in (Select entity_infra_sno from masters.entity_infra where
qbox_entity_sno =  (inputData->>'qboxEntitySno')::INTEGER and infra_sno = 2
)),
'columnCount', (Select value from masters.entity_infra_property where infra_property_sno = 6 and
entity_infra_sno in (Select entity_infra_sno from masters.entity_infra where
qbox_entity_sno =  (inputData->>'qboxEntitySno')::INTEGER and infra_sno = 2
))
,
 
 
'qboxes',JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'qboxId', bc.box_cell_sno,
            'rowNo', bc.row_no,
            'columnNo', bc.column_no,
			'foodCode',si.unique_code,
            'foodName', COALESCE(cbf.description, 'EMPTY')
        ) ORDER BY bc.row_no, bc.column_no ASC
    ) ) INTO inventory_result
    FROM masters.box_cell_food cbf
    RIGHT OUTER JOIN masters.box_cell bc
    ON bc.box_cell_sno = cbf.box_cell_sno
    LEFT OUTER JOIN masters.sku_inventory si
    ON cbf.sku_inventory_sno = si.sku_inventory_sno
    WHERE bc.qbox_entity_sno =  (inputData->>'qboxEntitySno')::INTEGER;
 
 
    -- Execute the query for SKU inventory counts (without nesting aggregates)
    WITH counts AS (
        SELECT
            COALESCE(si.description, 'EMPTY') AS description,
            COUNT(si.sku_inventory_sno) AS sku_inventory_sno_count
        FROM masters.box_cell_food cbf
        RIGHT OUTER JOIN masters.box_cell bc
        ON bc.box_cell_sno = cbf.box_cell_sno
        LEFT OUTER JOIN masters.sku_inventory si
        ON cbf.sku_inventory_sno = si.sku_inventory_sno
        WHERE bc.qbox_entity_sno = (inputData->>'qboxEntitySno')::INTEGER
        GROUP BY si.description
    )
    SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
            'description', counts.description,
            'skuInventorySnoCount', counts.sku_inventory_sno_count
        )
    ) INTO counts_result
    FROM counts;
 
    -- Return both results in a JSONB object with appropriate keys
     RETURN JSONB_BUILD_OBJECT(
        'qboxInventory', inventory_result,
        'qboxCounts', counts_result
    );
END;
$$;


ALTER FUNCTION masters.get_box_cell_inventory(inputdata jsonb) OWNER TO qbox_admin;

--
-- Name: get_crossed_stages_info(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_crossed_stages_info(input_json json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_json json;
	
BEGIN
    IF input_json ->> 'sku_inventory_sno' IS NOT NULL THEN
        -- If sku_inventory_sno is provided in input_json
        result_json := (
            SELECT JSON_AGG(json_build_object(
                'sku_inventory_sno', input_json ->> 'sku_inventory_sno',
                'description', description,
                'crossed_stages', (
                    SELECT JSON_AGG(json_build_object(
                        'wf_stage_cd', wf_stage_cd,
                        'description', codes_dtl.description,
                        'action_time', action_time
                    ) ORDER BY action_time)
                    FROM (
                        SELECT DISTINCT ON (wf_stage_cd)
                            wf_stage_cd,
                            action_time
                        FROM masters.sku_trace_wf
                        WHERE sku_inventory_sno = (input_json ->> 'sku_inventory_sno')::bigint
                        ORDER BY wf_stage_cd, action_time DESC
                    ) AS sub
                    JOIN masters.codes_dtl ON sub.wf_stage_cd = codes_dtl.codes_dtl_sno
                )
            ))
            FROM (
                SELECT DISTINCT ON (description)
                    description
                FROM masters.sku_trace_wf
                WHERE sku_inventory_sno = (input_json ->> 'sku_inventory_sno')::bigint
                ORDER BY description
            ) AS sub2
        );
    ELSE
        -- If no sku_inventory_sno is provided in input_json
        result_json := (
            SELECT JSON_AGG(json_build_object(
                'sku_inventory_sno', sku_inventory_sno,
                'description', description,
                'crossed_stages', (
                    SELECT JSON_AGG(json_build_object(
                        'wf_stage_cd', wf_stage_cd,
                        'description', codes_dtl.description,
                        'action_time', action_time
                    ) ORDER BY action_time)
                    FROM (
                        SELECT DISTINCT ON (wf_stage_cd)
                            wf_stage_cd,
                            action_time
                        FROM masters.sku_trace_wf
                        WHERE sku_inventory_sno = sub.sku_inventory_sno
                        ORDER BY wf_stage_cd, action_time DESC
                    ) AS sub_sub
                    JOIN masters.codes_dtl ON sub_sub.wf_stage_cd = codes_dtl.codes_dtl_sno
                )
            ))
            FROM (
                SELECT DISTINCT ON (sku_inventory_sno, description)
                    sku_inventory_sno,
                    description
                FROM masters.sku_trace_wf
                ORDER BY sku_inventory_sno, description
            ) AS sub
        );
    END IF;

    RETURN result_json;
END;
$$;


ALTER FUNCTION masters.get_crossed_stages_info(input_json json) OWNER TO qbox_admin;

--
-- Name: get_entity_and_properties(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_entity_and_properties(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_entity_sno bigint; -- Variable to hold the entitySno from input JSON
    result_json json;    -- Variable to store the final result JSON
BEGIN
    -- Extract entitySno from the input JSON
    i_entity_sno := (in_data->>'entitySno')::bigint;

    -- Retrieve entity_infra and their associated properties
    result_json := (
        SELECT JSON_AGG(
            json_build_object(
                'entitySno', i_entity_sno,                 -- Include entitySno
                'entityInfraSno', ei.entity_infra_sno,     -- Entity Infra Serial Number
                'qboxEntitySno', ei.qbox_entity_sno,       -- Qbox Entity Serial Number
                'infraSno', ei.infra_sno,                  -- Infra Serial Number
                'properties', (
                    SELECT JSON_AGG(
                        json_build_object(
                            'entityInfraPropertySno', eip.entity_infra_property_sno,  -- Infra Property Serial Number
                            'infraPropertySno', eip.infra_property_sno,              -- Property Serial Number
                            'value', eip.value                                       -- Property Value
                        )
                    )
                    FROM masters.entity_infra_property eip
                    WHERE eip.entity_infra_sno = ei.entity_infra_sno -- Filter by Entity Infra Serial Number
                )
            )
        )
        FROM masters.entity_infra ei
        WHERE ei.parent_entity_sno = i_entity_sno -- Replace with the correct column name
    );

    -- Return the final JSON result
    RETURN result_json;
END;
$$;


ALTER FUNCTION masters.get_entity_and_properties(in_data json) OWNER TO qbox_admin;

--
-- Name: get_entity_infra_properties(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_entity_infra_properties(input_json json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
i_qbox_entity_sno bigint; -- Variable to hold the qboxEntitySno from input JSON
    result_json json;         -- Variable to store the final result JSON
BEGIN
    -- Extract qboxEntitySno from the input JSON
    i_qbox_entity_sno := (input_json->>'qboxEntitySno')::bigint;

    -- Retrieve infraSno and their associated properties
    result_json := (
        SELECT JSON_AGG(
            json_build_object(
                'infraSno', ei.infra_sno,                    -- Infra Serial Number
                'properties', (
                    SELECT JSON_AGG(
                        json_build_object(
                            'infraPropertySno', eip.infra_property_sno,  -- Infra Property Serial Number
                            'value', eip.value                           -- Property Value
                        )
                    )
                    FROM masters.entity_infra_property eip
                    WHERE eip.entity_infra_sno = ei.entity_infra_sno     -- Filter by Entity Infra Serial Number
                )
            )
        )
        FROM masters.entity_infra ei
        WHERE ei.qbox_entity_sno = i_qbox_entity_sno -- Filter by qboxEntitySno
    );

    -- Return the final JSON result
    RETURN result_json;
END;
$$;


ALTER FUNCTION masters.get_entity_infra_properties(input_json json) OWNER TO qbox_admin;

--
-- Name: get_enum(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_enum(p_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
begin

return (select json_agg(json_build_object('codesDtlSno',d.codes_dtl_sno,'cdValue',d.description,'filter1',d.filter_1,'filter2',d.filter_2)) from (select * from masters.codes_dtl cdl where  
cdl.codes_hdr_sno = (select hdr.codes_hdr_sno from masters.codes_hdr hdr where hdr.description = p_data->>'codeType') and case when (p_data->>'filter1') is not null then 
		  filter_1 = (p_data->>'filter1')  else true end order by cdl.seqno asc)d);
end;
$$;


ALTER FUNCTION masters.get_enum(p_data json) OWNER TO qbox_admin;

--
-- Name: get_enum_name(integer, text); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_enum_name(p_cd_sno integer, p_cd_type text) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare 
  cd_value text;
begin

   select d.description into cd_value from masters.codes_dtl d 
   inner join masters.codes_hdr h on d.codes_hdr_sno = h.codes_hdr_sno 
   where d.codes_dtl_sno = p_cd_sno and UPPER(h.description) = UPPER(p_cd_type) ;
   
   return cd_value;
end;
$$;


ALTER FUNCTION masters.get_enum_name(p_cd_sno integer, p_cd_type text) OWNER TO qbox_admin;

--
-- Name: get_hotbox_current_status(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_hotbox_current_status(input_json json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_json json;
	
BEGIN
    result_json := (
            SELECT JSON_AGG(json_build_object(
                'skuInventorySno',si.sku_inventory_sno , 'uniqueCode', si.unique_code ,'name',fs.name))
	
from masters.sku_inventory si,
	masters.purchase_order_dtl pod,
	masters.food_sku fs
where  si.wf_stage_cd = 10
	and pod.purchase_order_dtl_sno = si.purchase_order_dtl_sno
    and pod.food_sku_sno = fs.food_sku_sno);

    RETURN result_json;
END;
$$;


ALTER FUNCTION masters.get_hotbox_current_status(input_json json) OWNER TO qbox_admin;

--
-- Name: get_infra_and_properties(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_infra_and_properties(input_json json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
i_qbox_entity_sno bigint; -- Variable to hold the qboxEntitySno from input JSON
    result_json json;         -- Variable to store the final result JSON
BEGIN
    -- Extract qboxEntitySno from the input JSON
    i_qbox_entity_sno := (input_json->>'qboxEntitySno')::bigint;

    -- Retrieve infraSno and their associated properties
    result_json := (
        SELECT JSON_AGG(
            json_build_object(
                'infraSno', ei.infra_sno,                    -- Infra Serial Number
                'properties', (
                    SELECT JSON_AGG(
                        json_build_object(
                            'infraPropertySno', eip.infra_property_sno,  -- Infra Property Serial Number
                            'value', eip.value                           -- Property Value
                        )
                    )
                    FROM masters.entity_infra_property eip
                    WHERE eip.entity_infra_sno = ei.entity_infra_sno     -- Filter by Entity Infra Serial Number
                )
            )
        )
        FROM masters.entity_infra ei
        WHERE ei.qbox_entity_sno = i_qbox_entity_sno -- Filter by qboxEntitySno
    );

    -- Return the final JSON result
    RETURN result_json;
END;
$$;


ALTER FUNCTION masters.get_infra_and_properties(input_json json) OWNER TO qbox_admin;

--
-- Name: get_qbox_current_status(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.get_qbox_current_status(input_json json DEFAULT NULL::json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_json json; -- Result JSON to store the output
    _qbox_entity_sno bigint; -- Variable to store the extracted qbox_entity_sno
BEGIN
    -- Extract qbox_entity_sno from input_json
    _qbox_entity_sno := (input_json ->> 'qboxEntitySno')::bigint;

    -- Query with filter based on qbox_entity_sno
    result_json := (
        SELECT JSON_AGG(json_build_object(
            'boxCellSno', bc.box_cell_sno,          -- Box Cell Serial Number
            'description', bc.description,         -- Description of the box cell
            'foodUniqueCode', si.unique_code       -- Unique code of the food
        ))
        FROM masters.box_cell bc
        LEFT OUTER JOIN masters.box_cell_food bcf
            ON bc.box_cell_sno = bcf.box_cell_sno
        LEFT OUTER JOIN masters.sku_inventory si
            ON bcf.sku_inventory_sno = si.sku_inventory_sno
        WHERE bc.qbox_entity_sno = _qbox_entity_sno -- Apply filter condition
    );

    -- Return the resulting JSON
    RETURN result_json;
END;
$$;


ALTER FUNCTION masters.get_qbox_current_status(input_json json) OWNER TO qbox_admin;

--
-- Name: insert_order_details(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.insert_order_details(json_input json) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    order_detail_record json;
BEGIN
    -- Loop through each order detail in the JSON array
    FOR order_detail_record IN SELECT json_array_elements(json_input->'purchaseOrderDtl') 
    LOOP
        -- Insert the order detail into the purchase_order_dtl table
        INSERT INTO masters.purchase_order_dtl (purchase_order_sno, food_sku_sno, order_quantity, sku_price, partner_food_code)
        VALUES (
            (json_input->>'purchaseOrderSno')::bigint,
            (order_detail_record->>'foodSkuSno')::bigint,
            (order_detail_record->>'orderQuantity')::smallint,
            (order_detail_record->>'skuPrice')::numeric,
            order_detail_record->>'partnerFoodCode'
        );
    END LOOP;
END;
$$;


ALTER FUNCTION masters.insert_order_details(json_input json) OWNER TO qbox_admin;

--
-- Name: internal_inventory_movement(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.internal_inventory_movement(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_unique_code text:= (in_data->>'uniqueCode')::text;
    i_wf_stage_cd smallint :=(in_data->>'wfStageCd')::smallint;
	i_sku_inventory_sno  bigint := 0;
	_result json;
 begin
	Select sku_inventory_sno  into i_sku_inventory_sno
	from masters.sku_inventory where unique_code = i_unique_code;
	Raise notice '%', i_sku_inventory_sno;
	if i_sku_inventory_sno is not null
	THEN

	UPDATE masters.sku_inventory SET wf_stage_cd = i_wf_stage_cd where sku_inventory_sno = i_sku_inventory_sno;
	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description) SELECT 
	i_sku_inventory_sno,i_wf_stage_cd,CURRENT_TIMESTAMP,1, unique_code from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
	
	
	END IF;
	_result := json_build_object(
        'Internal Movement','Completed') ;

    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN _result;	
end;
$$;


ALTER FUNCTION masters.internal_inventory_movement(in_data json) OWNER TO qbox_admin;

--
-- Name: load_sku_in_qbox(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.load_sku_in_qbox(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_unique_code text:= (in_data->>'uniqueCode')::text;
    i_wf_stage_cd smallint :=(in_data->>'wfStageCd')::smallint;
	i_sku_inventory_sno  bigint := 0;
	i_box_cell_sno smallint:=(in_data->>'boxCellSno')::smallint;
	i_qbox_entity_sno smallint:=(in_data->>'qboxEntitySno')::smallint;
	_result json;
	i_description text;
 begin
	Select sku_inventory_sno  into i_sku_inventory_sno
	from masters.sku_inventory where unique_code = i_unique_code;
	Raise notice '%', i_sku_inventory_sno;
	if i_sku_inventory_sno is not null
	THEN

	select description into i_description from masters.box_cell where box_cell_sno = i_box_cell_sno;
	
	INSERT INTO masters.box_cell_food(
	 box_cell_sno, sku_inventory_sno, entry_time, qbox_entity_sno,description)
	VALUES ( i_box_cell_sno, i_sku_inventory_sno, CURRENT_TIMESTAMP, i_qbox_entity_sno,i_description);

	UPDATE masters.sku_inventory SET wf_stage_cd = i_wf_stage_cd where sku_inventory_sno = i_sku_inventory_sno;
	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description) SELECT 
	i_sku_inventory_sno,i_wf_stage_cd,CURRENT_TIMESTAMP,1, unique_code from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
	
	
	END IF;
	_result := json_build_object(
        'skuloading','inside qbox') ;

    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN _result;	
end;
$$;


ALTER FUNCTION masters.load_sku_in_qbox(in_data json) OWNER TO qbox_admin;

--
-- Name: partner_channel_inward_delivery(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.partner_channel_inward_delivery(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_partner_purchase_order_id text:= (in_data->>'partnerPurchaseOrderId')::text;
	i_purchase_order_sno  bigint  := 0;
	i_purchase_order_dtl_sno  bigint  := 0;
    order_detail_record json;
	order_details_result json;
	i_sku_inventory_sno bigint :=0;
	i_order_status_cd smallint :=2;

begin

	Select purchase_order_sno into i_purchase_order_sno from masters.purchase_order where
	partner_purchase_order_id = i_partner_purchase_order_id;

	raise notice 'PURCHASE ORDER SNO %', i_purchase_order_sno;
 
	
	if(i_purchase_order_sno is not null)
	THEN
		update  masters.purchase_order set order_status_cd = i_order_status_cd where purchase_order_sno = i_purchase_order_sno;
		update  masters.purchase_order_dtl set accepted_quantity = order_quantity where purchase_order_sno = i_purchase_order_sno;

		INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description )
			SELECT sku_inventory_sno, 7, CURRENT_TIMESTAMP, 1 , unique_code from 
			masters.sku_inventory where purchase_order_dtl_sno in (Select purchase_order_dtl_sno from masters.purchase_order_dtl
			where purchase_order_sno = i_purchase_order_sno);

	UPDATE masters.sku_inventory set wf_stage_cd = 7 where purchase_order_dtl_sno in (Select purchase_order_dtl_sno from masters.purchase_order_dtl
			where purchase_order_sno = i_purchase_order_sno);
	
		-- INSERT INTO masters.sku_trace_wf(
		-- 	 sku_inventory_sno, wf_stage_cd, action_time, action_by)
		-- 	SELECT sku_inventory_sno, 8, CURRENT_TIMESTAMP, 1 from 
		-- 	masters.sku_inventory where purchase_order_dtl_sno in (Select purchase_order_dtl_sno from masters.purchase_order_dtl
		-- 	where purchase_order_sno = i_purchase_order_sno);
	END IF;

order_details_result := json_build_object(
        'purchaseOrder', json_build_object(
            'orderStatusCd', i_order_status_cd::smallint,
            'partnerPurchaseOrderId', in_data->>'partnerPurchaseOrderId',
            'deliveredTime', CURRENT_TIMESTAMP
        ),
        'purchaseOrderDtls', json_agg(order_detail_with_inventory)
    )
    FROM (
        SELECT
            json_build_object(
                'orderQuantity', pod.order_quantity,
                'partnerFoodCode', pod.partner_food_code
            ) AS order_detail_with_inventory
        FROM
            masters.purchase_order_dtl pod
        WHERE
            pod.purchase_order_sno = i_purchase_order_sno
        GROUP BY
            pod.purchase_order_dtl_sno
    ) AS result;

    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN order_details_result;

	
end;
$$;


ALTER FUNCTION masters.partner_channel_inward_delivery(in_data json) OWNER TO qbox_admin;

--
-- Name: partner_channel_inward_delivery_list(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.partner_channel_inward_delivery_list(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_partner_purchase_order_id text:= (in_data->>'partnerPurchaseOrderId')::text;
	i_purchase_order_sno  bigint  := 0;
	i_purchase_order_dtl_sno  bigint  := 0;
    order_detail_record json;
	order_details_result json;
	i_sku_inventory_sno bigint :=0;
	i_order_status_cd smallint :=2;

begin

	Select purchase_order_sno into i_purchase_order_sno from masters.purchase_order where
	partner_purchase_order_id = i_partner_purchase_order_id;

	raise notice 'PURCHASE ORDER SNO %', i_purchase_order_sno;
 

order_details_result := json_build_object(
        'purchaseOrder', json_build_object(
            'orderStatusCd', i_order_status_cd::smallint,
            'partnerPurchaseOrderId', in_data->>'partnerPurchaseOrderId',
            'deliveredTime', CURRENT_TIMESTAMP
        ),
        'purchaseOrderDtls', json_agg(order_detail_with_inventory)
    )
    FROM (
        SELECT
            json_build_object(
                'orderQuantity', pod.order_quantity,
                'partnerFoodCode', pod.partner_food_code
            ) AS order_detail_with_inventory
        FROM
            masters.purchase_order_dtl pod
        WHERE
            pod.purchase_order_sno = i_purchase_order_sno
        GROUP BY
            pod.purchase_order_dtl_sno
    ) AS result;

    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN order_details_result;

	
end;
$$;


ALTER FUNCTION masters.partner_channel_inward_delivery_list(in_data json) OWNER TO qbox_admin;

--
-- Name: partner_channel_inward_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.partner_channel_inward_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 

i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;
i_ordered_time timestamp without time zone:= (in_data->>'orderedTime')::timestamp without time zone;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_purchase_order_id text:= (in_data->>'partnerPurchaseOrderId')::text;
 
i_purchase_order_sno  bigint  := 0;
	i_purchase_order_dtl_sno  bigint  := 0;
    order_detail_record json;
	order_details_result json;
i_sku_inventory_sno bigint :=0;
 
	i_sku_code varchar;
	i_partner_code varchar;
	i_city_code varchar;
	i_restaurant_brand_code varchar;
 
	
begin
 
	
INSERT INTO masters.purchase_order(
	  qbox_entity_sno,restaurant_sno,delivery_partner_sno,order_status_cd,ordered_time,ordered_by,partner_purchase_order_id)
	VALUES (i_qbox_entity_sno,i_restaurant_sno,i_delivery_partner_sno,i_order_status_cd,i_ordered_time,i_ordered_by,i_partner_purchase_order_id) returning purchase_order_sno into i_purchase_order_sno;
 
if i_purchase_order_sno is not null
then
 
select restaurant_brand_cd into i_restaurant_brand_code from masters.restaurant where  restaurant_sno = i_restaurant_sno;
select city_code into i_city_code from masters.restaurant where  restaurant_sno = i_restaurant_sno;
Select partner_code into i_partner_code from masters.delivery_partner where delivery_partner_sno = i_delivery_partner_sno;
-- Loop through each order detail in the JSON array
    FOR order_detail_record IN SELECT json_array_elements(in_data->'purchaseOrderDtl') 
    LOOP
 
	Select sku_code into i_sku_code from masters.food_sku where food_sku_sno =  (order_detail_record->>'foodSkuSno')::bigint;
        -- Insert the order detail into the purchase_order_dtl table
        INSERT INTO masters.purchase_order_dtl (purchase_order_sno, restaurant_food_sku_sno, order_quantity, sku_price, partner_food_code)
        VALUES (
           	i_purchase_order_sno::bigint,
            (order_detail_record->>'foodSkuSno')::bigint,
            (order_detail_record->>'orderQuantity')::smallint,
            (order_detail_record->>'skuPrice')::numeric,
           i_sku_code
        )RETURNING purchase_order_dtl_sno INTO i_purchase_order_dtl_sno;
 
		FOR i IN 1..(order_detail_record->>'orderQuantity')::integer
        LOOP
 
			
            INSERT INTO masters.sku_inventory (purchase_order_dtl_sno, unique_code,wf_stage_cd)
            VALUES (i_purchase_order_dtl_sno, 
                    CONCAT(i_city_code,'-',i_partner_code,'-',i_restaurant_brand_code, '-',i_sku_code,'-',TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-',i_purchase_order_dtl_sno,'-', i),6)
			RETURNING sku_inventory_sno INTO i_sku_inventory_sno;
 
if i_sku_inventory_sno is not null
	then
		INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,reference)
			VALUES (i_sku_inventory_sno, 6, CURRENT_TIMESTAMP, 1,concat('pod-sno-',i_purchase_order_dtl_sno));
 
       	end if;
 
        END LOOP;
 
    END LOOP;
 
	end if;
 
-- return (select(json_build_object('data',json_build_object(
-- 'purchaseOrderSno',purchase_order_sno,'qboxEntitySno',qbox_entity_sno,'restaurantSno',restaurant_sno,'deliveryPartnerSno',delivery_partner_sno,'orderStatusCd',order_status_cd,'orderedTime',ordered_time,'orderedBy',ordered_by,'partnerPurchaseOrderId',partner_purchase_order_id
-- ))))
-- FROM masters.purchase_order
-- where    purchase_order_sno = i_purchase_order_sno;
 
order_details_result := json_build_object(
        'purchaseOrder', json_build_object(
            'purchaseOrderSno', i_purchase_order_sno,
            'qboxEntitySno', (in_data->>'qboxEntitySno')::bigint,
            'restaurantSno', (in_data->>'restaurantSno')::bigint,
            'deliveryPartnerSno', (in_data->>'deliveryPartnerSno')::smallint,
            'orderStatusCd', (in_data->>'orderStatusCd')::smallint,
            'orderedBy', (in_data->>'orderedBy')::bigint,
            'partnerPurchaseOrderId', in_data->>'partnerPurchaseOrderId',
            'orderedTime', CURRENT_TIMESTAMP
        ),
        'purchaseOrderDtls', json_agg(order_detail_with_inventory)
    )
    FROM (
        -- Subquery to fetch order details and corresponding sku_inventory records
        SELECT
            json_build_object(
                'purchaseOrderDtlSno', pod.purchase_order_dtl_sno,
                'foodSkuSno', pod.restaurant_food_sku_sno,
                'orderQuantity', pod.order_quantity,
                'skuPrice', pod.sku_price,
                'partnerFoodCode', pod.partner_food_code,
                'skuInventory', json_agg(json_build_object(
                                    'skuInventorySno', si.sku_inventory_sno,
                                    'uniqueCode', si.unique_code
                                ))
            ) AS order_detail_with_inventory
        FROM
            masters.purchase_order_dtl pod
        LEFT JOIN
            masters.sku_inventory si ON pod.purchase_order_dtl_sno = si.purchase_order_dtl_sno
        WHERE
            pod.purchase_order_sno = i_purchase_order_sno
        GROUP BY
            pod.purchase_order_dtl_sno
    ) AS result;
 
    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN order_details_result;
 
	
end;
$$;


ALTER FUNCTION masters.partner_channel_inward_order(in_data json) OWNER TO qbox_admin;

--
-- Name: partner_channel_outward_delivery(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.partner_channel_outward_delivery(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_partner_sales_order_id text:= (in_data->>'partnerSalesOrderId')::text;
	i_sales_order_sno  bigint  := 0;
	i_qbox_entity_sno  bigint  := 0;
	i_sales_order_dtl_sno  bigint  := 0;
    order_detail_record json;
	order_details_result json;
	i_sku_inventory_sno bigint :=0;
	quantity_to_be_delivered smallint :=0;
	row_data RECORD;
	count_data RECORD;
begin
	SELECT sales_order_sno,qbox_entity_sno into i_sales_order_sno,i_qbox_entity_sno from masters.sales_order where partner_sales_order_id = i_partner_sales_order_id;
	if i_partner_sales_order_id is not null 
	THEN
	FOR count_data IN Select sales_order_dtl_sno, (order_quantity - delivered_quantity) as quantity_to_be_delivered from masters.sales_order_dtl
	where sales_order_sno in (Select sales_order_sno from masters.sales_order where
	partner_sales_order_id = i_partner_sales_order_id) and  (order_quantity - delivered_quantity) > 0
	LOOP
		FOR row_data IN 
		Select bcf.box_cell_sno, 
			bcf.box_cell_food_sno, 
			si.unique_code,
			si.sku_inventory_sno ,
			sod.sales_order_dtl_sno,
			so.sales_order_sno
			from masters.sku_inventory si,
				 masters.box_cell_food bcf,
				 masters.sales_order_dtl sod,
				 masters.purchase_order_dtl pod,
				 masters.sales_order so,
				 masters.purchase_order po
		where 
			sod.sales_order_dtl_sno = count_data.sales_order_dtl_sno
			and bcf.active = true
			and so.partner_sales_order_id = i_partner_sales_order_id
			and si.wf_stage_cd = 11
			and pod.restaurant_food_sku_sno = sod.restaurant_food_sku_sno 
			and so.qbox_entity_sno = po.qbox_entity_sno
			and so.delivery_partner_sno = po.delivery_partner_sno
			and sod.sales_order_sno =  so.sales_order_sno 
			and pod.purchase_order_sno = po.purchase_order_sno 
			and si.purchase_order_dtl_sno = pod.purchase_order_dtl_sno
			and si.sku_inventory_sno = bcf.sku_inventory_sno 
			order by bcf.entry_time ASC offset 0 limit count_data.quantity_to_be_delivered
			LOOP
			RAISE NOTICE '%',row_data.box_cell_sno;
			RAISE NOTICE '%',row_data.box_cell_food_sno;
			RAISE NOTICE '%',row_data.unique_code;
			RAISE NOTICE '%',row_data.sku_inventory_sno;
			RAISE NOTICE '%',row_data.sales_order_dtl_sno;
			RAISE NOTICE '%',row_data.sales_order_sno;
 
			INSERT INTO masters.sku_trace_wf(
			sku_inventory_sno, wf_stage_cd, action_time, action_by, reference)
			VALUES (row_data.sku_inventory_sno, 13, CURRENT_TIMESTAMP, 1, concat('box-cell-sno-',row_data.box_cell_sno::varchar));
			UPDATE masters.sales_order_dtl set delivered_quantity = (delivered_quantity+1)
			where sales_order_dtl_sno= row_data.sales_order_dtl_sno;
 
			UPDATE masters.sku_inventory set sales_order_dtl_sno = row_data.sales_order_dtl_sno , wf_stage_cd = 13
			where sku_inventory_sno = row_data.sku_inventory_sno;
			INSERT INTO masters.box_cell_food_hist SELECT  box_cell_food_sno, box_cell_sno, sku_inventory_sno, entry_time, qbox_entity_sno ,i_partner_sales_order_id, active_flag, i_partner_sales_order_id
			FROM masters.box_cell_food 
			WHERE box_cell_food_sno = row_data.box_cell_food_sno;
			DELETE FROM masters.box_cell_food 
			WHERE box_cell_food_sno = row_data.box_cell_food_sno;
			END LOOP;
    END LOOP;
END IF;
order_details_result := json_build_object(
        'salesOrder', json_build_object(
            'salesOrderSno', i_sales_order_sno,
            'partnerSalesOrderId', in_data->>'partnerSalesOrderId',
			'qboxEntitySno',i_qbox_entity_sno,
			  'qboxEntityName', (SELECT qe.name FROM masters.qbox_entity qe WHERE qe.qbox_entity_sno = i_qbox_entity_sno),
            'deliveredTime', CURRENT_TIMESTAMP
        ),
        'salesOrderDtls', json_agg(order_detail_with_inventory)
    )
    FROM (
        -- Subquery to fetch order details and corresponding sku_inventory records
SELECT
    json_build_object(
        'foodSkuSno', sod.restaurant_food_sku_sno,
        'orderQuantity', sod.order_quantity,
        'partnerFoodCode', sod.partner_food_code,
        'skuInventory', COALESCE(json_agg(json_build_object(
            'skuInventorySno', si.sku_inventory_sno,
            'uniqueCode', si.unique_code,
            'rowNo', si.row_no,
            'columnNo', si.column_no,
            'boxCellDescription', si.box_cell_description,
            'restaurantFoodDescription', si.restaurant_food_description,
            'skuCode', si.sku_code
        )) FILTER (WHERE si.sku_inventory_sno IS NOT NULL), '[]')
    ) AS order_detail_with_inventory
FROM
    masters.sales_order_dtl sod
LEFT JOIN (
    SELECT 
        si.sku_inventory_sno,
        si.unique_code,
        bc.row_no,
        bc.column_no,
        bc.description AS box_cell_description,
        rfs.description AS restaurant_food_description,
        rfs.sku_code,
        si.restaurant_food_sku_sno  
    FROM 
        masters.sku_inventory si
    JOIN 
        masters.box_cell_food_hist bcfh 
    ON 
        si.sku_inventory_sno = bcfh.sku_inventory_sno
        AND bcfh.partner_sales_order_id = i_partner_sales_order_id
    JOIN 
        masters.box_cell bc 
    ON 
        bc.box_cell_sno = bcfh.box_cell_sno
    JOIN 
        masters.restaurant_food_sku rfs 
    ON 
        si.restaurant_food_sku_sno = rfs.restaurant_food_sku_sno
) si ON sod.restaurant_food_sku_sno = si.restaurant_food_sku_sno 
WHERE
    sod.sales_order_sno = i_sales_order_sno
GROUP BY
    sod.sales_order_dtl_sno,
    sod.restaurant_food_sku_sno,
    sod.order_quantity,
    sod.partner_food_code
    ) AS result;
RETURN order_details_result;
end;
$$;


ALTER FUNCTION masters.partner_channel_outward_delivery(in_data json) OWNER TO qbox_admin;

--
-- Name: partner_channel_outward_delivery_list(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.partner_channel_outward_delivery_list(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_sales_order_id text:= (in_data->>'partnerSalesOrderId')::text;

i_sales_order_sno  bigint  := 0;
	i_sales_order_dtl_sno  bigint  := 0;
    order_detail_record json;
	order_details_result json;
i_sku_inventory_sno bigint :=0;
	
begin

	Select sales_order_sno into i_sales_order_sno from masters.sales_order where partner_sales_order_id = i_partner_sales_order_id;
 
if i_sales_order_sno is not null

	then

	order_details_result := json_build_object(
        'salesOrder', json_build_object(
            'salesOrderSno', i_sales_order_sno,
            'qboxEntitySno', (in_data->>'qboxEntitySno')::bigint,
            'deliveryPartnerSno', (in_data->>'deliveryPartnerSno')::smallint,
            'orderStatusCd', (in_data->>'orderStatusCd')::smallint,
            'orderedBy', (in_data->>'orderedBy')::bigint,
            'partnerSalesOrderId', in_data->>'partnerSalesOrderId',
            'orderedTime', CURRENT_TIMESTAMP
        ),
        'salesOrderDtls', json_agg(order_detail_with_inventory)
    )
    FROM (
        -- Subquery to fetch order details and corresponding sku_inventory records
        SELECT
            json_build_object(
                'salesOrderDtlSno', pod.sales_order_dtl_sno,
                'foodSkuSno', pod.food_sku_sno,
                'orderQuantity', pod.order_quantity,
                'skuPrice', pod.sku_price,
                'partnerFoodCode', pod.partner_food_code 
            ) AS order_detail_with_inventory
        FROM
            masters.sales_order_dtl pod
        LEFT JOIN
            masters.sku_inventory si ON pod.sales_order_dtl_sno = si.sales_order_dtl_sno
        WHERE
            pod.sales_order_sno = i_sales_order_sno
        GROUP BY
            pod.sales_order_dtl_sno
    ) AS result;

end if;
	
    -- Return the JSON object containing the sales order, order details, and corresponding sku_inventory records
    RETURN order_details_result;
	
end;
$$;


ALTER FUNCTION masters.partner_channel_outward_delivery_list(in_data json) OWNER TO qbox_admin;

--
-- Name: partner_channel_outward_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.partner_channel_outward_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$

declare 

i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;

i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;

i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;

i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;

i_partner_sales_order_id text:= (in_data->>'partnerSalesOrderId')::text;
 
i_sales_order_sno  bigint  := 0;

	i_sales_order_dtl_sno  bigint  := 0;

    order_detail_record json;

	order_details_result json;

i_sku_inventory_sno bigint :=0;

begin
 
INSERT INTO masters.sales_order(

	  qbox_entity_sno,delivery_partner_sno,sales_order_status_cd,ordered_time,ordered_by,partner_sales_order_id)

	VALUES (i_qbox_entity_sno,i_delivery_partner_sno,i_order_status_cd,CURRENT_TIMESTAMP,i_ordered_by,i_partner_sales_order_id) returning sales_order_sno into i_sales_order_sno;
 
if i_sales_order_sno is not null
 
	then
 
-- Loop through each order detail in the JSON array

    FOR order_detail_record IN SELECT json_array_elements(in_data->'salesOrderDtl') 

    LOOP

        -- Insert the order detail into the sales_order_dtl table

        INSERT INTO masters.sales_order_dtl (sales_order_sno, restaurant_food_sku_sno, order_quantity, sku_price, partner_food_code)

        VALUES (

           	i_sales_order_sno::bigint,

            (order_detail_record->>'foodSkuSno')::bigint,

            (order_detail_record->>'orderQuantity')::smallint,

            (order_detail_record->>'skuPrice')::numeric,

            order_detail_record->>'partnerFoodCode'

        )RETURNING sales_order_dtl_sno INTO i_sales_order_dtl_sno;
 
    END LOOP;
 
	end if;
 
	order_details_result := json_build_object(

        'salesOrder', json_build_object(

            'salesOrderSno', i_sales_order_sno,

            'qboxEntitySno', (in_data->>'qboxEntitySno')::bigint,

            'deliveryPartnerSno', (in_data->>'deliveryPartnerSno')::smallint,

            'orderStatusCd', (in_data->>'orderStatusCd')::smallint,

            'orderedBy', (in_data->>'orderedBy')::bigint,

            'partnerSalesOrderId', in_data->>'partnerSalesOrderId',

            'orderedTime', CURRENT_TIMESTAMP

        ),

        'salesOrderDtls', json_agg(order_detail_with_inventory)

    )

    FROM (

        -- Subquery to fetch order details and corresponding sku_inventory records

        SELECT

            json_build_object(

                'salesOrderDtlSno', pod.sales_order_dtl_sno,

                'foodSkuSno', pod.restaurant_food_sku_sno,

                'orderQuantity', pod.order_quantity,

                'skuPrice', pod.sku_price,

                'partnerFoodCode', pod.partner_food_code 

            ) AS order_detail_with_inventory

        FROM

            masters.sales_order_dtl pod

        LEFT JOIN

            masters.sku_inventory si ON pod.sales_order_dtl_sno = si.sales_order_dtl_sno

        WHERE

            pod.sales_order_sno = i_sales_order_sno

        GROUP BY

            pod.sales_order_dtl_sno

    ) AS result;
 
    -- Return the JSON object containing the sales order, order details, and corresponding sku_inventory records

    RETURN order_details_result;

end;

$$;


ALTER FUNCTION masters.partner_channel_outward_order(in_data json) OWNER TO qbox_admin;

--
-- Name: reject_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.reject_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
	_result json;
 begin
 
	if i_sku_inventory_sno is not null
	THEN

	UPDATE masters.sku_inventory SET wf_stage_cd = 8 where sku_inventory_sno = i_sku_inventory_sno;
	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description) SELECT 
	i_sku_inventory_sno,8,CURRENT_TIMESTAMP,1, unique_code from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
	
	END IF;
	
	 RETURN (SELECT json_agg(json_build_object(
                'skuInventorySno', sku_inventory_sno,
                'purchaseOrderDtlSno', purchase_order_dtl_sno,
                'uniqueCode', unique_code,
                'salesOrderDtlSno', sales_order_dtl_sno,
                'wfStageCd', wf_stage_cd
            ))
            FROM (
                SELECT 
                    sku_inventory_sno,
                    purchase_order_dtl_sno,
                    unique_code,
                    sales_order_dtl_sno,
                    wf_stage_cd
                FROM 
                    masters.sku_inventory
                WHERE 
                    purchase_order_dtl_sno IN (
                        SELECT purchase_order_dtl_sno 
                        FROM masters.sku_inventory 
                        WHERE sku_inventory_sno = i_sku_inventory_sno
                    )
                ORDER BY sku_inventory_sno  -- Ordering within the subquery
            ) AS subquery
        );

     
end;
$$;


ALTER FUNCTION masters.reject_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: save_entity_infrastructure(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.save_entity_infrastructure(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_qbox_entity_sno bigint := (in_data->>'qboxEntitySno')::bigint;
    i_infra_data jsonb := in_data->'data';
    i_infra_sno bigint;
    i_entity_infra_sno bigint;
    i_infra_property_sno smallint;
    i_value text;
    result jsonb := '[]'::jsonb;
    current_infra jsonb;
    row_count smallint;
    column_count smallint;
    i smallint;
    j smallint;
BEGIN
    -- Loop through each infraSno entry in the data array
    FOR current_infra IN 
        SELECT jsonb_array_elements(i_infra_data)
    LOOP
        i_infra_sno := (current_infra->>'infraSno')::bigint;
        
        -- Insert each infraSno into the entity_infra table and get the entity_infra_sno
        INSERT INTO masters.entity_infra (qbox_entity_sno, infra_sno)
        VALUES (i_qbox_entity_sno, i_infra_sno)
        RETURNING entity_infra_sno INTO i_entity_infra_sno;

        -- Initialize row and column counts
        row_count := 0;
        column_count := 0;

        -- Loop through the properties array for the current infra
        FOR i_infra_property_sno, i_value IN 
            SELECT (property->>'infraPropertySno')::smallint, (property->>'value')::text
            FROM jsonb_array_elements(current_infra->'properties') AS property
        LOOP
            -- Insert each property into the entity_infra_property table
            INSERT INTO masters.entity_infra_property (
                entity_infra_sno, 
                infra_property_sno, 
                value
            )
            VALUES (
                i_entity_infra_sno, 
                i_infra_property_sno, 
                i_value
            );

            -- Store row and column counts based on infraPropertySno
            IF i_infra_property_sno = 5 THEN
                row_count := i_value::smallint;
            ELSIF i_infra_property_sno = 6 THEN
                column_count := i_value::smallint;
            END IF;
        END LOOP;

        -- Insert box cells based on row and column counts
        FOR i IN 1..row_count LOOP
            FOR j IN 1..column_count LOOP
                INSERT INTO masters.box_cell (
                    qbox_entity_sno,
                    entity_infra_sno,
                    row_no,
                    column_no,
                    box_cell_status_cd,
                    description,
                    active_flag
                )
                VALUES (
                    i_qbox_entity_sno,
                    i_entity_infra_sno,
                    i,
                    j,
                    18, -- Default status code as per sample data
                    format('Row-%s- Column-%s', i, j),
                    true
                );
            END LOOP;
        END LOOP;

        -- Build the result JSON object with entity_infra and properties info
        result := result || jsonb_build_object(
            'entityInfraSno', i_entity_infra_sno,
            'qboxEntitySno', i_qbox_entity_sno,
            'infraSno', i_infra_sno,
            'properties', current_infra->'properties'
        );
    END LOOP;

    RETURN result::json;
END;
$$;


ALTER FUNCTION masters.save_entity_infrastructure(in_data json) OWNER TO qbox_admin;

--
-- Name: search_address(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_address(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
i_address_sno bigint:= (in_data->>'addressSno')::bigint;
i_line1 text:= (in_data->>'line1')::text;
i_line2 text:= (in_data->>'line2')::text;
i_area_sno integer:= (in_data->>'areaSno')::integer;
i_city_sno integer:= (in_data->>'citySno')::integer;
i_geo_loc_code text:= (in_data->>'geoLocCode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

begin

 return (select json_agg(json_build_object(
 'addressSno',ad.address_sno,'line1',ad.line1,'line2',ad.line2,'areaSno',ad.area_sno,'citySno',ad.city_sno,'geoLocCode',ad.geo_loc_code, 'areaName',ar.name,
 'cityName',ct.name,'activeFlag', ad.active_flag
 )))
 FROM masters.address ad
 Join masters.area ar on ar.area_sno = ad.area_sno
 Join masters.city ct on ct.city_sno = ad.city_sno
 where    
  case when i_address_sno isnull then 1=1 else ad.address_sno = i_address_sno end and 
  case when i_line1 isnull then 1=1 else ad.line1 = i_line1 end and 
  case when i_line2 isnull then 1=1 else ad.line2 = i_line2 end and 
  case when i_area_sno isnull then 1=1 else ad.area_sno = i_area_sno end and 
  case when i_city_sno isnull then 1=1 else ad.city_sno = i_city_sno end and 
  case when i_geo_loc_code isnull then 1=1 else ad.geo_loc_code = i_geo_loc_code end and 
  case when i_active_flag isnull then 1=1 else ad.active_flag = i_active_flag end and 	
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_address(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_app_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_menu_name text:= (in_data->>'appMenuName')::text;
i_parent_menu_sno smallint:= (in_data->>'parentMenuSno')::smallint;
i_href text:= (in_data->>'href')::text;
i_title text:= (in_data->>'title')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'appMenuSno',app_menu_sno,'appMenuName',app_menu_name,'parentMenuSno',parent_menu_sno,'href',href,'title',title,'status',status
 )))
 FROM masters.app_menu
 where    
  case when i_app_menu_sno isnull then 1=1 else app_menu_sno = i_app_menu_sno end and 
  case when i_app_menu_name isnull then 1=1 else app_menu_name = i_app_menu_name end and 
  case when i_parent_menu_sno isnull then 1=1 else parent_menu_sno = i_parent_menu_sno end and 
  case when i_href isnull then 1=1 else href = i_href end and 
  case when i_title isnull then 1=1 else title = i_title end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_app_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_app_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_permission_sno bigint:= (in_data->>'appPermissionSno')::bigint;
i_app_permission_name text:= (in_data->>'appPermissionName')::text;
i_created_at timestamp without time zone:= (in_data->>'createdAt')::timestamp without time zone;

  
begin

 return (select json_agg(json_build_object(
 'appPermissionSno',app_permission_sno,'appPermissionName',app_permission_name,'createdAt',created_at
 )))
 FROM masters.app_permission
 where    
  case when i_app_permission_sno isnull then 1=1 else app_permission_sno = i_app_permission_sno end and 
  case when i_app_permission_name isnull then 1=1 else app_permission_name = i_app_permission_name end and 
  case when i_created_at isnull then 1=1 else created_at = i_created_at end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_app_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_app_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_role_name text:= (in_data->>'appRoleName')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'appRoleSno',app_role_sno,'appRoleName',app_role_name,'status',status
 )))
 FROM masters.app_role
 where    
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
  case when i_app_role_name isnull then 1=1 else app_role_name = i_app_role_name end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_app_role(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_user(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_app_user(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_user_id text:= (in_data->>'userId')::text;
i_password text:= (in_data->>'password')::text;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'appUserSno',app_user_sno,'userId',user_id,'password',password,'status',status
 )))
 FROM masters.app_user
 where    
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_user_id isnull then 1=1 else user_id = i_user_id end and 
  case when i_password isnull then 1=1 else password = i_password end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_app_user(in_data json) OWNER TO qbox_admin;

--
-- Name: search_app_user_role(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_app_user_role(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_app_user_role_sno bigint:= (in_data->>'appUserRoleSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;

  
begin

 return (select json_agg(json_build_object(
 'appUserRoleSno',app_user_role_sno,'appUserSno',app_user_sno,'appRoleSno',app_role_sno
 )))
 FROM masters.app_user_role
 where    
  case when i_app_user_role_sno isnull then 1=1 else app_user_role_sno = i_app_user_role_sno end and 
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_app_user_role(in_data json) OWNER TO qbox_admin;

--
-- Name: search_area(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_area(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
i_area_sno bigint:= (in_data->>'areaSno')::bigint;
i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_city_sno integer:= (in_data->>'citySno')::integer;
i_name text:= (in_data->>'name')::text;
i_pincode text:= (in_data->>'pincode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

 return (select json_agg(json_build_object(
  'city1name' ,city_1.name , 
  'country1name' ,country_1.name , 
  'state1name' ,state_1.name ,
  'areaSno',area.area_sno,
  'countrySno',area.country_sno,
  'stateSno',area.state_sno,
  'citySno',area.city_sno,
  'name',area.name,
  'pincode',area.pincode,
  'activeFlag', area.active_flag
 )))
  FROM masters.area area JOIN masters.city city_1 ON city_1.city_sno = area.city_sno JOIN masters.country country_1 ON country_1.country_sno = area.country_sno JOIN masters.state state_1 ON state_1.state_sno = area.state_sno
 where    
  case when i_area_sno isnull then 1=1 else area.area_sno = i_area_sno end and 
  case when i_country_sno isnull then 1=1 else area.country_sno = i_country_sno end and 
  case when i_state_sno isnull then 1=1 else area.state_sno = i_state_sno end and 
  case when i_city_sno isnull then 1=1 else area.city_sno = i_city_sno end and 
  case when i_name isnull then 1=1 else area.name = i_name end and 
  case when i_pincode isnull then 1=1 else area.pincode = i_pincode end and 
  case when i_active_flag isnull then 1=1 else area.active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_area(in_data json) OWNER TO qbox_admin;

--
-- Name: search_area1(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_area1(json_input json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_area_sno bigint:= (json_input->>'areaSno')::bigint;
i_country_sno smallint:= (json_input->>'countrySno')::smallint;
i_state_sno smallint:= (json_input->>'stateSno')::smallint;
i_city_sno integer:= (json_input->>'citySno')::integer;
i_name text:= (json_input->>'name')::text;
i_pincode text:= (json_input->>'pincode')::text;

  
begin

 return (select json_agg(json_build_object(
 'areaSno',area.area_sno,'countrySno',area.country_sno,'stateSno',area.state_sno,'citySno',area.city_sno,'name',area.name,'pincode',area.pincode, 'city1name' ,city_1.name , 'country1name' ,country_1.name , 'state1name' ,state_1.name 
 )))
  FROM masters.area area JOIN masters.city city_1 ON city_1.city_sno = area.city_sno JOIN masters.country country_1 ON country_1.country_sno = area.country_sno JOIN masters.state state_1 ON state_1.state_sno = area.state_sno
 where    
  case when i_area_sno isnull then 1=1 else area.area_sno = i_area_sno end and 
  case when i_country_sno isnull then 1=1 else area.country_sno = i_country_sno end and 
  case when i_state_sno isnull then 1=1 else area.state_sno = i_state_sno end and 
  case when i_city_sno isnull then 1=1 else area.city_sno = i_city_sno end and 
  case when i_name isnull then 1=1 else area.name = i_name end and 
  case when i_pincode isnull then 1=1 else area.pincode = i_pincode end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_area1(json_input json) OWNER TO qbox_admin;

--
-- Name: search_box_cell(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_box_cell(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  	i_box_cell_sno bigint:= (in_data->>'boxCellSno')::bigint;
	i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
	i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
	i_row_no smallint:= (in_data->>'rowNo')::smallint;
	i_column_no smallint:= (in_data->>'columnNo')::smallint;
	i_description text:= (in_data->>'description')::text;
	i_box_cell_status_cd smallint:= (in_data->>'boxCellStatusCd')::smallint;

  
begin

 return (select json_agg(json_build_object(
 'boxCellSno',box_cell_sno,'qboxEntitySno',qbox_entity_sno,'entityInfraSno',
	entity_infra_sno,'rowNo',row_no,'columnNo',column_no,
	'boxCellStatusCd',box_cell_status_cd,'description',description
 )))
 FROM masters.box_cell
 where    
  case when i_box_cell_sno isnull then 1=1 else box_cell_sno = i_box_cell_sno end and 
  case when i_qbox_entity_sno isnull then 1=1 else qbox_entity_sno = i_qbox_entity_sno end and 
  case when i_entity_infra_sno isnull then 1=1 else entity_infra_sno = i_entity_infra_sno end and 
  case when i_row_no isnull then 1=1 else row_no = i_row_no end and 
  case when i_column_no isnull then 1=1 else column_no = i_column_no end and 
  case when i_description isnull then 1=1 else description = i_description end and 
  case when i_box_cell_status_cd isnull then 1=1 else box_cell_status_cd = i_box_cell_status_cd end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_box_cell(in_data json) OWNER TO qbox_admin;

--
-- Name: search_box_cell_food(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_box_cell_food(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_box_cell_food_sno bigint:= (in_data->>'boxCellFoodSno')::bigint;
i_box_cell_sno smallint:= (in_data->>'boxCellSno')::smallint;
i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_entry_time timestamp without time zone:= (in_data->>'entryTime')::timestamp without time zone;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;

  
begin

 return (select json_agg(json_build_object(
 'boxCellFoodSno',box_cell_food_sno,'boxCellSno',box_cell_sno,'skuInventorySno',sku_inventory_sno,'entryTime',entry_time,'qboxEntitySno',qbox_entity_sno
 )))
 FROM masters.box_cell_food
 where    
  case when i_box_cell_food_sno isnull then 1=1 else box_cell_food_sno = i_box_cell_food_sno end and 
  case when i_box_cell_sno isnull then 1=1 else box_cell_sno = i_box_cell_sno end and 
  case when i_sku_inventory_sno isnull then 1=1 else sku_inventory_sno = i_sku_inventory_sno end and 
  case when i_entry_time isnull then 1=1 else entry_time = i_entry_time end and 
  case when i_qbox_entity_sno isnull then 1=1 else qbox_entity_sno = i_qbox_entity_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_box_cell_food(in_data json) OWNER TO qbox_admin;

--
-- Name: search_box_cell_food1(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_box_cell_food1(json_input json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_box_cell_food_sno bigint:= (json_input->>'boxCellFoodSno')::bigint;
i_box_cell_sno smallint:= (json_input->>'boxCellSno')::smallint;
i_sku_inventory_sno bigint:= (json_input->>'skuInventorySno')::bigint;
i_entry_time timestamp without time zone:= (json_input->>'entryTime')::timestamp without time zone;
i_qbox_entity_sno bigint:= (json_input->>'qboxEntitySno')::bigint;
i_active boolean:= (json_input->>'active')::boolean;
i_description text:= (json_input->>'description')::text;

  
begin

 return (select json_agg(json_build_object(
 'boxCellFoodSno',boxcellfood.box_cell_food_sno,'boxCellSno',boxcellfood.box_cell_sno,'skuInventorySno',
	boxcellfood.sku_inventory_sno,'entryTime',boxcellfood.entry_time,'qboxEntitySno',boxcellfood.qbox_entity_sno,
	'active',boxcellfood.active,'description',boxcellfood.description, 'boxCell1description' ,
	box_cell_1.description , 'qboxEntity1name' ,qbox_entity_1.name , 'skuInventory1description' ,
	sku_inventory_1.description 
 )))
  FROM masters.box_cell_food boxcellfood 
	LEFT OUTER JOIN masters.box_cell box_cell_1 ON boxcellfood.box_cell_sno =  box_cell_1.box_cell_sno
	LEFT OUTER JOIN masters.qbox_entity qbox_entity_1 ON qbox_entity_1.qbox_entity_sno = boxcellfood.qbox_entity_sno 
	LEFT OUTER JOIN masters.sku_inventory sku_inventory_1 ON sku_inventory_1.sku_inventory_sno = boxcellfood.sku_inventory_sno
 where    
  case when i_box_cell_food_sno isnull then 1=1 else boxcellfood.box_cell_food_sno = i_box_cell_food_sno end and 
  case when i_box_cell_sno isnull then 1=1 else boxcellfood.box_cell_sno = i_box_cell_sno end and 
  case when i_sku_inventory_sno isnull then 1=1 else boxcellfood.sku_inventory_sno = i_sku_inventory_sno end and 
  case when i_entry_time isnull then 1=1 else boxcellfood.entry_time = i_entry_time end and 
  case when i_qbox_entity_sno isnull then 1=1 else boxcellfood.qbox_entity_sno = i_qbox_entity_sno end and 
  case when i_active isnull then 1=1 else boxcellfood.active = i_active end and 
  case when i_description isnull then 1=1 else boxcellfood.description = i_description end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_box_cell_food1(json_input json) OWNER TO qbox_admin;

--
-- Name: search_box_cell_food_hist(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_box_cell_food_hist(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_box_cell_food_hist_sno bigint:= (in_data->>'boxCellFoodHistSno')::bigint;
i_box_cell_food_sno bigint:= (in_data->>'boxCellFoodSno')::bigint;
i_box_cell_sno smallint:= (in_data->>'boxCellSno')::smallint;
i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_entry_time timestamp without time zone:= (in_data->>'entryTime')::timestamp without time zone;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;

  
begin

 return (select json_agg(json_build_object(
 'boxCellFoodHistSno',box_cell_food_hist_sno,'boxCellFoodSno',box_cell_food_sno,'boxCellSno',box_cell_sno,'skuInventorySno',sku_inventory_sno,'entryTime',entry_time,'qboxEntitySno',qbox_entity_sno
 )))
 FROM masters.box_cell_food_hist
 where    
  case when i_box_cell_food_hist_sno isnull then 1=1 else box_cell_food_hist_sno = i_box_cell_food_hist_sno end and 
  case when i_box_cell_food_sno isnull then 1=1 else box_cell_food_sno = i_box_cell_food_sno end and 
  case when i_box_cell_sno isnull then 1=1 else box_cell_sno = i_box_cell_sno end and 
  case when i_sku_inventory_sno isnull then 1=1 else sku_inventory_sno = i_sku_inventory_sno end and 
  case when i_entry_time isnull then 1=1 else entry_time = i_entry_time end and 
  case when i_qbox_entity_sno isnull then 1=1 else qbox_entity_sno = i_qbox_entity_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_box_cell_food_hist(in_data json) OWNER TO qbox_admin;

--
-- Name: search_city(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_city(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_city_sno bigint:= (in_data->>'citySno')::bigint;
i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_name text:= (in_data->>'name')::text;

  
begin

 return (select json_agg(json_build_object(
 'citySno',city_sno,'countrySno',country_sno,'stateSno',state_sno,'name',name
 )))
 FROM masters.city
 where    
  case when i_city_sno isnull then 1=1 else city_sno = i_city_sno end and 
  case when i_country_sno isnull then 1=1 else country_sno = i_country_sno end and 
  case when i_state_sno isnull then 1=1 else state_sno = i_state_sno end and 
  case when i_name isnull then 1=1 else name = i_name end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_city(in_data json) OWNER TO qbox_admin;

--
-- Name: search_codes_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_codes_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
i_codes_dtl_sno smallint:= (in_data->>'codesDtlSno')::smallint;
i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_description text:= (in_data->>'description')::text;
i_seqno integer:= (in_data->>'seqno')::integer;
i_filter_1 text:= (in_data->>'filter1')::text;
i_filter_2 text:= (in_data->>'filter2')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'codesDtlSno',codes_dtl_sno,'codesHdrSno',codes_hdr_sno,'description',description,'seqno',seqno,'filter1',filter_1,'filter2',filter_2,'activeFlag',active_flag
 )))
 FROM masters.codes_dtl
 where    
  case when i_codes_dtl_sno isnull then 1=1 else codes_dtl_sno = i_codes_dtl_sno end and 
  case when i_codes_hdr_sno isnull then 1=1 else codes_hdr_sno = i_codes_hdr_sno end and 
  case when i_description isnull then 1=1 else description = i_description end and 
  case when i_seqno isnull then 1=1 else seqno = i_seqno end and 
  case when i_filter_1 isnull then 1=1 else filter_1 = i_filter_1 end and 
  case when i_filter_2 isnull then 1=1 else filter_2 = i_filter_2 end and 
  case when i_active_flag isnull then 1=1 else active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_codes_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: search_codes_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_codes_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
i_codes_hdr_sno smallint:= (in_data->>'codesHdrSno')::smallint;
i_code_type text:= (in_data->>'codeType')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'codesHdrSno',codes_hdr_sno,'codeType',description,'activeFlag',active_flag
 )))
 FROM masters.codes_hdr
 where    
  case when i_codes_hdr_sno isnull then 1=1 else codes_hdr_sno = i_codes_hdr_sno end and 
  case when i_code_type isnull then 1=1 else description = i_code_type end and 
  case when i_active_flag isnull then 1=1 else active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_codes_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: search_country(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_country(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_name text:= (in_data->>'name')::text;
i_iso2 character varying:= (in_data->>'iso2')::character varying;
i_phone_code character varying:= (in_data->>'phoneCode')::character varying;
i_numeric_code character varying:= (in_data->>'numericCode')::character varying;
i_currency_code character varying:= (in_data->>'currencyCode')::character varying;

  
begin

 return (select json_agg(json_build_object(
 'countrySno',country_sno,'name',name,'iso2',iso2,'phoneCode',phone_code,'numericCode',numeric_code,'currencyCode',currency_code
 )))
 FROM masters.country
 where    
  case when i_country_sno isnull then 1=1 else country_sno = i_country_sno end and 
  case when i_name isnull then 1=1 else name = i_name end and 
  case when i_iso2 isnull then 1=1 else iso2 = i_iso2 end and 
  case when i_phone_code isnull then 1=1 else phone_code = i_phone_code end and 
  case when i_numeric_code isnull then 1=1 else numeric_code = i_numeric_code end and 
  case when i_currency_code isnull then 1=1 else currency_code = i_currency_code end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_country(in_data json) OWNER TO qbox_admin;

--
-- Name: search_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_partner_code character varying:= (in_data->>'partnerCode')::character varying;
i_partner_name text:= (in_data->>'partnerName')::text;
i_partner_status_cd smallint:= (in_data->>'partnerStatusCd')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

begin

 return (select json_agg(json_build_object(
 'deliveryPartnerSno',delivery_partner_sno,'partnerCode',partner_code,'partnerName',name,
 'partnerStatusCd',partner_status_cd, 'activeFlag', active_flag,
  'partnerStatusCdName', (select masters.get_enum_name(partner_status_cd,'partner_status_cd'))
 )))
 FROM masters.delivery_partner
 where    
  case when i_delivery_partner_sno isnull then 1=1 else delivery_partner_sno = i_delivery_partner_sno end and 
  case when i_partner_code isnull then 1=1 else partner_code = i_partner_code end and 
  case when i_partner_name isnull then 1=1 else name = i_partner_name end and 
  case when i_partner_status_cd isnull then 1=1 else partner_status_cd = i_partner_status_cd end and
  case when i_active_flag isnull then 1=1 else active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: search_entity_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_entity_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_infra_sno bigint:= (in_data->>'infraSno')::bigint;

  
begin

 return (select json_agg(json_build_object(
 'entityInfraSno',entity_infra_sno,'qboxEntitySno',qbox_entity_sno,'infraSno',infra_sno
 )))
 FROM masters.entity_infra
 where    
  case when i_entity_infra_sno isnull then 1=1 else entity_infra_sno = i_entity_infra_sno end and 
  case when i_qbox_entity_sno isnull then 1=1 else qbox_entity_sno = i_qbox_entity_sno end and 
  case when i_infra_sno isnull then 1=1 else infra_sno = i_infra_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_entity_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: search_entity_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_entity_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_entity_infra_property_sno bigint:= (in_data->>'entityInfraPropertySno')::bigint;
i_entity_infra_sno bigint:= (in_data->>'entityInfraSno')::bigint;
i_infra_property_sno smallint:= (in_data->>'infraPropertySno')::smallint;
i_value text:= (in_data->>'value')::text;

  
begin

 return (select json_agg(json_build_object(
 'entityInfraPropertySno',entity_infra_property_sno,'entityInfraSno',entity_infra_sno,'infraPropertySno',infra_property_sno,'value',value
 )))
 FROM masters.entity_infra_property
 where    
  case when i_entity_infra_property_sno isnull then 1=1 else entity_infra_property_sno = i_entity_infra_property_sno end and 
  case when i_entity_infra_sno isnull then 1=1 else entity_infra_sno = i_entity_infra_sno end and 
  case when i_infra_property_sno isnull then 1=1 else infra_property_sno = i_infra_property_sno end and 
  case when i_value isnull then 1=1 else value = i_value end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_entity_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: search_etl_job(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_etl_job(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
    i_etl_job_sno integer := (in_data->>'etlJobSno')::integer;
    i_order_etl_hdr_sno integer := (in_data->>'orderEtlHdrSno')::integer;
    i_status text := (in_data->>'status')::text;
BEGIN
    RETURN (
        SELECT json_agg(json_build_object(
            'etlJobSno', etl_job_sno, 'orderEtlHdrSno', order_etl_hdr_sno,
            'fileName', file_name, 'fileLoadTimestamp', file_load_timestamp,
            'etlStartTimestamp', etl_start_timestamp, 'etlEndTimestamp', etl_end_timestamp,
            'status', status, 'errorMessage', error_message, 'recordCount', record_count,
            'processedBy', processed_by
        ))
        FROM partner_order.etl_job
        WHERE 
            (i_etl_job_sno IS NULL OR etl_job_sno = i_etl_job_sno) AND
            (i_order_etl_hdr_sno IS NULL OR order_etl_hdr_sno = i_order_etl_hdr_sno) AND
            (i_status IS NULL OR status = i_status)
    );
END;
$$;


ALTER FUNCTION masters.search_etl_job(in_data json) OWNER TO qbox_admin;

--
-- Name: search_etl_table_column(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_etl_table_column(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_etl_table_column_sno SMALLINT := (in_data->>'etlTableColumnSno')::smallint;
    i_order_etl_hdr_sno SMALLINT := (in_data->>'orderEtlHdrSno')::smallint;
    i_source_column VARCHAR(255) := (in_data->>'sourceColumn')::varchar;
    i_staging_column VARCHAR(255) := (in_data->>'stagingColumn')::varchar;
    i_data_type VARCHAR(50) := (in_data->>'dataType')::varchar;
    i_is_required BOOLEAN := (in_data->>'isRequired')::boolean;
    i_description TEXT := (in_data->>'description')::text;
BEGIN
    RETURN (
        SELECT json_agg(json_build_object(
            'etlTableColumnSno', etl_table_column_sno, 'orderEtlHdrSno', order_etl_hdr_sno,
            'sourceColumn', source_column, 'stagingColumn', staging_column,
            'dataType', data_type, 'isRequired', is_required, 
            'description', description, 'createdAt', created_at, 'updatedAt', updated_at
        ))
        FROM partner_order.etl_table_column
        WHERE 
            (i_etl_table_column_sno IS NULL OR etl_table_column_sno = i_etl_table_column_sno) AND
            (i_order_etl_hdr_sno IS NULL OR order_etl_hdr_sno = i_order_etl_hdr_sno) AND
            (i_source_column IS NULL OR source_column = i_source_column) AND
            (i_staging_column IS NULL OR staging_column = i_staging_column) AND
            (i_data_type IS NULL OR data_type = i_data_type) AND
            (i_is_required IS NULL OR is_required = i_is_required) AND
            (i_description IS NULL OR description = i_description)
    );
END;
$$;


ALTER FUNCTION masters.search_etl_table_column(in_data json) OWNER TO qbox_admin;

--
-- Name: search_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_restaurant_brand_cd text:= (in_data->>'restaurantBrandCd')::text;
i_food_name text:= (in_data->>'foodName')::text;
i_sku_code text:= (in_data->>'skuCode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'foodSkuSno',food_sku_sno,'restaurantBrandCd',restaurant_brand_cd,'foodName',
	name,'skuCode',sku_code, 'activeFlag', active_flag
 )))
 FROM masters.food_sku
 where    
  case when i_food_sku_sno isnull then 1=1 else food_sku_sno = i_food_sku_sno end and 
  case when i_restaurant_brand_cd isnull then 1=1 else restaurant_brand_cd = i_restaurant_brand_cd end and 
  case when i_food_name isnull then 1=1 else name = i_food_name end and 
  case when i_sku_code isnull then 1=1 else sku_code = i_sku_code end and 
  case when i_active_flag isnull then 1=1 else active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: search_infra(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_infra(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_infra_sno smallint:= (in_data->>'infraSno')::smallint;
  i_infra_name text:= (in_data->>'infraName')::text;
  i_active_flag boolean:= (in_data->>'activeFlag')::boolean;
  
begin

 return (select json_agg(json_build_object(
 'infraSno',infra_sno,'infraName',name, 'activeFlag', active_flag
 )))
 FROM masters.infra
 where    
  case when i_infra_sno isnull then 1=1 else infra_sno = i_infra_sno end and 
  case when i_infra_name isnull then 1=1 else name = i_infra_name end and 
  case when i_active_flag isnull then 1=1 else active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_infra(in_data json) OWNER TO qbox_admin;

--
-- Name: search_infra_property(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_infra_property(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_infra_property_sno smallint:= (in_data->>'infraPropertySno')::smallint;
i_infra_sno smallint:= (in_data->>'infraSno')::smallint;
i_property_name text:= (in_data->>'propertyName')::text;
i_data_type_cd smallint:= (in_data->>'dataTypeCd')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;
  
begin

 return (select json_agg(json_build_object(
 'infraPropertySno',ip.infra_property_sno,'infraSno',ip.infra_sno,'propertyName',ip.name,
 'infraName',i.name,'dataTypeCd',ip.data_type_cd, 'activeFlag',ip.active_flag
 )))
 FROM masters.infra_property ip
 join masters.infra i on i.infra_sno = ip.infra_sno
 where    
  case when i_infra_property_sno isnull then 1=1 else ip.infra_property_sno = i_infra_property_sno end and 
  case when i_infra_sno isnull then 1=1 else ip.infra_sno = i_infra_sno end and 
  case when i_property_name isnull then 1=1 else ip.name = i_property_name end and 
  case when i_data_type_cd isnull then 1=1 else ip.data_type_cd = i_data_type_cd end and 
  case when i_active_flag isnull then 1=1 else ip.active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_infra_property(in_data json) OWNER TO qbox_admin;

--
-- Name: search_menu_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_menu_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_menu_permission_sno smallint:= (in_data->>'menuPermissionSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_permission_sno smallint:= (in_data->>'appPermissionSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'menuPermissionSno',menu_permission_sno,'appMenuSno',app_menu_sno,'appPermissionSno',app_permission_sno,'status',status
 )))
 FROM masters.menu_permission
 where    
  case when i_menu_permission_sno isnull then 1=1 else menu_permission_sno = i_menu_permission_sno end and 
  case when i_app_menu_sno isnull then 1=1 else app_menu_sno = i_app_menu_sno end and 
  case when i_app_permission_sno isnull then 1=1 else app_permission_sno = i_app_permission_sno end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_menu_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: search_order_etl_hdr(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_order_etl_hdr(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_order_etl_hdr_sno SMALLINT := (in_data->>'orderEtlHdrSno')::smallint;
    i_delivery_partner_sno SMALLINT := (in_data->>'deliveryPartnerSno')::smallint;
    i_partner_code VARCHAR := (in_data->>'partnerCode')::varchar;
    i_staging_table_name VARCHAR := (in_data->>'stagingTableName')::varchar;
    i_is_active BOOLEAN := (in_data->>'isActive')::boolean;
BEGIN
    RETURN (
        SELECT json_agg(json_build_object(
            'orderEtlHdrSno', order_etl_hdr_sno, 'deliveryPartnerSno', delivery_partner_sno,
            'partnerCode', partner_code, 'stagingTableName', staging_table_name,
            'isActive', is_active, 'fileNamePrefix', file_name_prefix
        ))
        FROM partner_order.order_etl_hdr
        WHERE 
            (i_order_etl_hdr_sno IS NULL OR order_etl_hdr_sno = i_order_etl_hdr_sno) AND
            (i_delivery_partner_sno IS NULL OR delivery_partner_sno = i_delivery_partner_sno) AND
            (i_partner_code IS NULL OR partner_code = i_partner_code) AND
            (i_staging_table_name IS NULL OR staging_table_name = i_staging_table_name) AND
            (i_is_active IS NULL OR is_active = i_is_active)
    );
END;
$$;


ALTER FUNCTION masters.search_order_etl_hdr(in_data json) OWNER TO qbox_admin;

--
-- Name: search_otp(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_otp(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_otp_sno bigint:= (in_data->>'otpSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_sms_otp character varying:= (in_data->>'smsOtp')::character varying;
i_service_otp text:= (in_data->>'serviceOtp')::text;
i_push_otp text:= (in_data->>'pushOtp')::text;
i_device_id text:= (in_data->>'deviceId')::text;
i_otp_expire_time_cd smallint:= (in_data->>'otpExpireTimeCd')::smallint;
i_otp_expire_time timestamp without time zone:= (in_data->>'otpExpireTime')::timestamp without time zone;
i_otp_status boolean:= (in_data->>'otpStatus')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'otpSno',otp_sno,'appUserSno',app_user_sno,'smsOtp',sms_otp,'serviceOtp',service_otp,'pushOtp',push_otp,'deviceId',device_id,'otpExpireTimeCd',otp_expire_time_cd,'otpExpireTime',otp_expire_time,'otpStatus',otp_status
 )))
 FROM masters.otp
 where    
  case when i_otp_sno isnull then 1=1 else otp_sno = i_otp_sno end and 
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_sms_otp isnull then 1=1 else sms_otp = i_sms_otp end and 
  case when i_service_otp isnull then 1=1 else service_otp = i_service_otp end and 
  case when i_push_otp isnull then 1=1 else push_otp = i_push_otp end and 
  case when i_device_id isnull then 1=1 else device_id = i_device_id end and 
  case when i_otp_expire_time_cd isnull then 1=1 else otp_expire_time_cd = i_otp_expire_time_cd end and 
  case when i_otp_expire_time isnull then 1=1 else otp_expire_time = i_otp_expire_time end and 
  case when i_otp_status isnull then 1=1 else otp_status = i_otp_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_otp(in_data json) OWNER TO qbox_admin;

--
-- Name: search_partner_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_partner_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
i_partner_food_sku_sno smallint:= (in_data->>'partnerFoodSkuSno')::smallint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_food_sku_sno smallint:= (in_data->>'foodSkuSno')::smallint;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;
  
begin

 return (select json_agg(json_build_object(
 'partnerFoodSkuSno',pfs.partner_food_sku_sno,'deliveryPartnerSno',pfs.delivery_partner_sno,'foodSkuSno',pfs.food_sku_sno,
 'partnerFoodCode',pfs.partner_food_code, 'partnerName', dp.name, 'foodName', fsk.name, 'activeFlag', pfs.active_flag
 )))
 FROM masters.partner_food_sku pfs
 Join masters.food_sku fsk on fsk.food_sku_sno = pfs.food_sku_sno
 Join masters.delivery_partner dp on dp.delivery_partner_sno = pfs.delivery_partner_sno
 where
  case when i_partner_food_sku_sno isnull then 1=1 else pfs.partner_food_sku_sno = i_partner_food_sku_sno end and 
  case when i_delivery_partner_sno isnull then 1=1 else pfs.delivery_partner_sno = i_delivery_partner_sno end and 
  case when i_food_sku_sno isnull then 1=1 else pfs.food_sku_sno = i_food_sku_sno end and 
  case when i_partner_food_code isnull then 1=1 else pfs.partner_food_code = i_partner_food_code end and
  case when i_active_flag isnull then 1=1 else pfs.active_flag = i_active_flag end and 	
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_partner_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: search_purchase_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_purchase_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_purchase_order_sno bigint:= (in_data->>'purchaseOrderSno')::bigint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;
i_order_status_cd smallint:= (in_data->>'orderStatusCd')::smallint;
i_ordered_time timestamp without time zone:= (in_data->>'orderedTime')::timestamp without time zone;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_purchase_order_id text:= (in_data->>'partnerPurchaseOrderId')::text;
i_meal_time_cd smallint:= (in_data->>'mealTimeCd')::smallint;
i_description text:= (in_data->>'description')::text;

  
begin

 return (select json_agg(json_build_object(
  'deliveryPartner1name' ,delivery_partner_1.name , 'qboxEntity1name' ,qbox_entity_1.name , 'restaurant1name' ,restaurant_1.name ,'purchaseOrderSno',purchaseorder.purchase_order_sno,'qboxEntitySno',purchaseorder.qbox_entity_sno,
  'restaurantSno',purchaseorder.restaurant_sno,'deliveryPartnerSno',purchaseorder.delivery_partner_sno,'orderStatusCd',
  purchaseorder.order_status_cd,'orderedTime',purchaseorder.ordered_time,'orderedBy',purchaseorder.ordered_by,'partnerPurchaseOrderId',
  purchaseorder.partner_purchase_order_id,'mealTimeCd',purchaseorder.meal_time_cd,'description',purchaseorder.description
 )order by purchase_order_sno desc))
  FROM masters.purchase_order purchaseorder JOIN masters.delivery_partner delivery_partner_1 ON delivery_partner_1.delivery_partner_sno = purchaseorder.delivery_partner_sno JOIN masters.qbox_entity qbox_entity_1 ON qbox_entity_1.qbox_entity_sno = purchaseorder.qbox_entity_sno JOIN masters.restaurant restaurant_1 ON restaurant_1.restaurant_sno = purchaseorder.restaurant_sno
 where    
  case when i_purchase_order_sno isnull then 1=1 else purchaseorder.purchase_order_sno = i_purchase_order_sno end and 
  case when i_qbox_entity_sno isnull then 1=1 else purchaseorder.qbox_entity_sno = i_qbox_entity_sno end and 
  case when i_restaurant_sno isnull then 1=1 else purchaseorder.restaurant_sno = i_restaurant_sno end and 
  case when i_delivery_partner_sno isnull then 1=1 else purchaseorder.delivery_partner_sno = i_delivery_partner_sno end and 
  case when i_order_status_cd isnull then 1=1 else purchaseorder.order_status_cd = i_order_status_cd end and 
  case when i_ordered_time isnull then 1=1 else purchaseorder.ordered_time = i_ordered_time end and 
  case when i_ordered_by isnull then 1=1 else purchaseorder.ordered_by = i_ordered_by end and 
  case when i_partner_purchase_order_id isnull then 1=1 else purchaseorder.partner_purchase_order_id = i_partner_purchase_order_id end and 
  case when i_meal_time_cd isnull then 1=1 else purchaseorder.meal_time_cd = i_meal_time_cd end and 
  case when i_description isnull then 1=1 else purchaseorder.description = i_description end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_purchase_order(in_data json) OWNER TO qbox_admin;

--
-- Name: search_purchase_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_purchase_order_dtl(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_purchase_order_dtl_sno bigint:= (in_data->>'purchaseOrderDtlSno')::bigint;
i_purchase_order_sno bigint:= (in_data->>'purchaseOrderSno')::bigint;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_order_quantity smallint:= (in_data->>'orderQuantity')::smallint;
i_sku_price numeric:= (in_data->>'skuPrice')::numeric;
i_partner_food_code text:= (in_data->>'partnerFoodCode')::text;
i_accepted_quantity smallint:= (in_data->>'acceptedQuantity')::smallint;
i_description text:= (in_data->>'description')::text;

  
begin

 return (select json_agg(json_build_object(
  'foodSku1name' ,food_sku_1.name , 'purchaseOrder1description' ,purchase_order_1.description ,'purchaseOrderDtlSno',purchaseorderdtl.purchase_order_dtl_sno,'purchaseOrderSno',purchaseorderdtl.purchase_order_sno,'foodSkuSno',purchaseorderdtl.restaurant_food_sku_sno,'orderQuantity',purchaseorderdtl.order_quantity,'skuPrice',purchaseorderdtl.sku_price,'partnerFoodCode',purchaseorderdtl.partner_food_code,'acceptedQuantity',purchaseorderdtl.accepted_quantity,'description',purchaseorderdtl.description
 )))
  FROM masters.purchase_order_dtl purchaseorderdtl JOIN masters.food_sku food_sku_1 ON food_sku_1.food_sku_sno = purchaseorderdtl.restaurant_food_sku_sno JOIN masters.purchase_order purchase_order_1 ON purchase_order_1.purchase_order_sno = purchaseorderdtl.purchase_order_sno
 where    
  case when i_purchase_order_dtl_sno isnull then 1=1 else purchaseorderdtl.purchase_order_dtl_sno = i_purchase_order_dtl_sno end and 
  case when i_purchase_order_sno isnull then 1=1 else purchaseorderdtl.purchase_order_sno = i_purchase_order_sno end and 
  case when i_food_sku_sno isnull then 1=1 else purchaseorderdtl.restaurant_food_sku_sno = i_food_sku_sno end and 
  case when i_order_quantity isnull then 1=1 else purchaseorderdtl.order_quantity = i_order_quantity end and 
  case when i_sku_price isnull then 1=1 else purchaseorderdtl.sku_price = i_sku_price end and 
  case when i_partner_food_code isnull then 1=1 else purchaseorderdtl.partner_food_code = i_partner_food_code end and 
  case when i_accepted_quantity isnull then 1=1 else purchaseorderdtl.accepted_quantity = i_accepted_quantity end and 
  case when i_description isnull then 1=1 else purchaseorderdtl.description = i_description end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_purchase_order_dtl(in_data json) OWNER TO qbox_admin;

--
-- Name: search_qbox_entity(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_qbox_entity(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_qbox_entity_name text:= (in_data->>'qboxEntityName')::text;
i_address_sno bigint:= (in_data->>'addressSno')::bigint;
i_area_sno bigint:= (in_data->>'areaSno')::bigint;
i_qbox_entity_status_cd smallint:= (in_data->>'qboxEntityStatusCd')::smallint;
i_qbox_entity_code text:= (in_data->>'entityCode')::text;
i_qbox_active_flag boolean:= (in_data->>'activeFlag')::boolean;
i_created_on timestamp without time zone:= (in_data->>'createdOn')::timestamp without time zone;
 
begin
return (
    SELECT json_agg(
        json_build_object(
            'qboxEntitySno', qe.qbox_entity_sno,
            'qboxEntityName', qe.name,
            'addressSno', qe.address_sno,
            'areaSno', qe.area_sno,
            'qboxEntityStatusCd', qe.qbox_entity_status_cd,
            'createdOn', qe.created_on,
            'entityCode', qe.entity_code,
            'activeFlag', qe.active_flag,
            'areaName', ar.name,
            'line1', ad.line1, 
	        'cityName', city_1.name,
			'country1name' ,country_1.name , 
 			'state1name' ,state_1.name ,
            'infraDetails', (
                WITH infra_counts AS (
                    SELECT 
                        i.name as infraName,
                        COUNT(*) as count
                    FROM masters.entity_infra ei
                    JOIN masters.infra i ON i.infra_sno = ei.infra_sno
                    WHERE ei.qbox_entity_sno = qe.qbox_entity_sno
                    GROUP BY i.name, i.infra_sno
                )
                SELECT json_agg(
                    json_build_object(
                        'infraName', infraName,
                        'count', count
                    )
                )
                FROM infra_counts
            )
        )
    )
    FROM masters.qbox_entity qe
    JOIN masters.area ar ON ar.area_sno = qe.area_sno
	JOIN masters.city city_1 ON city_1.city_sno = ar.city_sno 
	JOIN masters.country country_1 ON country_1.country_sno = ar.country_sno 
	JOIN masters.state state_1 ON state_1.state_sno = ar.state_sno
    JOIN masters.address ad ON ad.address_sno = qe.address_sno
    WHERE    
        CASE WHEN i_qbox_entity_sno IS NULL THEN 1=1 ELSE qe.qbox_entity_sno = i_qbox_entity_sno END AND 
        CASE WHEN i_qbox_entity_name IS NULL THEN 1=1 ELSE qe.name = i_qbox_entity_name END AND 
        CASE WHEN i_address_sno IS NULL THEN 1=1 ELSE qe.address_sno = i_address_sno END AND 
        CASE WHEN i_area_sno IS NULL THEN 1=1 ELSE qe.area_sno = i_area_sno END AND 
        CASE WHEN i_qbox_entity_status_cd IS NULL THEN 1=1 ELSE qe.qbox_entity_status_cd = i_qbox_entity_status_cd END AND 
        CASE WHEN i_created_on IS NULL THEN 1=1 ELSE qe.created_on = i_created_on END AND 
        1=1
);
end;
$$;


ALTER FUNCTION masters.search_qbox_entity(in_data json) OWNER TO qbox_admin;

--
-- Name: search_qbox_entity_delivery_partner(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_qbox_entity_delivery_partner(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_qbox_entity_delivery_partner_sno bigint:= (in_data->>'qboxEntityDeliveryPartnerSno')::bigint;
i_delivery_type_cd smallint:= (in_data->>'deliveryTypeCd')::smallint;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_delivery_partner_sno smallint:= (in_data->>'deliveryPartnerSno')::smallint;

  
begin

 return (select json_agg(json_build_object(
 'qboxEntityDeliveryPartnerSno',qbox_entity_delivery_partner_sno,'deliveryTypeCd',delivery_type_cd,'qboxEntitySno',qbox_entity_sno,'deliveryPartnerSno',delivery_partner_sno
 )))
 FROM masters.qbox_entity_delivery_partner
 where    
  case when i_qbox_entity_delivery_partner_sno isnull then 1=1 else qbox_entity_delivery_partner_sno = i_qbox_entity_delivery_partner_sno end and 
  case when i_delivery_type_cd isnull then 1=1 else delivery_type_cd = i_delivery_type_cd end and 
  case when i_qbox_entity_sno isnull then 1=1 else qbox_entity_sno = i_qbox_entity_sno end and 
  case when i_delivery_partner_sno isnull then 1=1 else delivery_partner_sno = i_delivery_partner_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_qbox_entity_delivery_partner(in_data json) OWNER TO qbox_admin;

--
-- Name: search_restaurant(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_restaurant(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	
i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_restaurant_brand_cd text:= (in_data->>'restaurantBrandCd')::text;
i_restaurant_name text:= (in_data->>'restaurantName')::text;
i_address_sno bigint:= (in_data->>'addressSno')::bigint;
i_area_sno bigint:= (in_data->>'areaSno')::bigint;
i_restaurant_status_cd smallint:= (in_data->>'restaurantStatusCd')::smallint;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

begin

 return (select json_agg(json_build_object(
 'restaurantSno',r.restaurant_sno,'restaurantBrandCd',r.restaurant_brand_cd,
 'restaurantName',r.name,'addressSno',r.address_sno,'areaSno',r.area_sno,
 'restaurantStatusCd',r.restaurant_status_cd,
 'areaName',area.name,'addressLine',ad.line1,	
 'activeFlag', r.active_flag,
 'restaurantStatusCdName',(select masters.get_enum_name(r.restaurant_status_cd,'restaurant_status_cd'))
 -- 'restaurantBrandCdName',(select masters.get_enum_name(r.restaurant_brand_cd,'restaurant_brand_cd'))
 )))
 FROM masters.restaurant r
 JOIN masters.area area ON area.area_sno = r.area_sno 
 JOIN masters.address ad ON r.address_sno = ad.address_sno 
 where    
  case when i_restaurant_sno isnull then 1=1 else r.restaurant_sno = i_restaurant_sno end and 
  case when i_restaurant_brand_cd isnull then 1=1 else r.restaurant_brand_cd = i_restaurant_brand_cd end and 
  case when i_restaurant_name isnull then 1=1 else r.name = i_restaurant_name end and 
  case when i_address_sno isnull then 1=1 else r.address_sno = i_address_sno end and 
  case when i_area_sno isnull then 1=1 else r.area_sno = i_area_sno end and 
  case when i_restaurant_status_cd isnull then 1=1 else r.restaurant_status_cd = i_restaurant_status_cd end and 
  case when i_active_flag isnull then 1=1 else r.active_flag = i_active_flag end and 	
 1=1; 

end;
$$;


ALTER FUNCTION masters.search_restaurant(in_data json) OWNER TO qbox_admin;

--
-- Name: search_restaurant_food_sku(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_restaurant_food_sku(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_restaurant_food_sku_sno bigint:= (in_data->>'restaurantFoodSkuSno')::bigint;
i_restaurant_sno bigint:= (in_data->>'restaurantSno')::bigint;
i_food_sku_sno bigint:= (in_data->>'foodSkuSno')::bigint;
i_status boolean:= (in_data->>'status')::boolean;
i_active_flag boolean:= (in_data->>'activeFlag')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'restaurantFoodSkuSno',rfs.restaurant_food_sku_sno,'restaurantSno',rfs.restaurant_sno,'foodSkuSno',rfs.food_sku_sno,
	'status',rfs.status ,'restaurantName', r.name, 'foodName', fsk.name, 
	'description',rfs.description, 'skuCode',rfs.sku_code, 'activeFlag', rfs.active_flag
 )))
 FROM masters.restaurant_food_sku rfs
 Join masters.restaurant r on r.restaurant_sno = rfs.restaurant_sno
 Join masters.food_sku fsk on fsk.food_sku_sno = rfs.food_sku_sno	
 where    
  case when i_restaurant_food_sku_sno isnull then 1=1 else rfs.restaurant_food_sku_sno = i_restaurant_food_sku_sno end and 
  case when i_restaurant_sno isnull then 1=1 else rfs.restaurant_sno = i_restaurant_sno end and 
  case when i_food_sku_sno isnull then 1=1 else rfs.food_sku_sno = i_food_sku_sno end and 
  case when i_status isnull then 1=1 else rfs.status = i_status end and 
  case when i_active_flag isnull then 1=1 else rfs.active_flag = i_active_flag end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_restaurant_food_sku(in_data json) OWNER TO qbox_admin;

--
-- Name: search_role_menu(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_role_menu(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_role_menu_sno smallint:= (in_data->>'roleMenuSno')::smallint;
i_app_menu_sno smallint:= (in_data->>'appMenuSno')::smallint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_status boolean:= (in_data->>'status')::boolean;

  
begin

 return (select json_agg(json_build_object(
 'roleMenuSno',role_menu_sno,'appMenuSno',app_menu_sno,'appRoleSno',app_role_sno,'status',status
 )))
 FROM masters.role_menu
 where    
  case when i_role_menu_sno isnull then 1=1 else role_menu_sno = i_role_menu_sno end and 
  case when i_app_menu_sno isnull then 1=1 else app_menu_sno = i_app_menu_sno end and 
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
  case when i_status isnull then 1=1 else status = i_status end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_role_menu(in_data json) OWNER TO qbox_admin;

--
-- Name: search_role_permission(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_role_permission(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_role_permission_sno bigint:= (in_data->>'rolePermissionSno')::bigint;
i_app_role_sno smallint:= (in_data->>'appRoleSno')::smallint;
i_app_permission_sno integer:= (in_data->>'appPermissionSno')::integer;

  
begin

 return (select json_agg(json_build_object(
 'rolePermissionSno',role_permission_sno,'appRoleSno',app_role_sno,'appPermissionSno',app_permission_sno
 )))
 FROM masters.role_permission
 where    
  case when i_role_permission_sno isnull then 1=1 else role_permission_sno = i_role_permission_sno end and 
  case when i_app_role_sno isnull then 1=1 else app_role_sno = i_app_role_sno end and 
  case when i_app_permission_sno isnull then 1=1 else app_permission_sno = i_app_permission_sno end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_role_permission(in_data json) OWNER TO qbox_admin;

--
-- Name: search_sales_order(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_sales_order(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_sales_order_sno bigint:= (in_data->>'salesOrderSno')::bigint;
i_partner_sales_order_id text:= (in_data->>'partnerSalesOrderId')::text;
i_qbox_entity_sno bigint:= (in_data->>'qboxEntitySno')::bigint;
i_delivery_partner_sno bigint:= (in_data->>'deliveryPartnerSno')::bigint;
i_sales_order_status_cd smallint:= (in_data->>'salesOrderStatusCd')::smallint;
i_ordered_time timestamp without time zone:= (in_data->>'orderedTime')::timestamp without time zone;
i_ordered_by bigint:= (in_data->>'orderedBy')::bigint;
i_partner_customer_ref text:= (in_data->>'partnerCustomerRef')::text;
i_description text:= (in_data->>'description')::text;

  
begin

 return (select json_agg(json_build_object(
  'deliveryPartner1name' ,delivery_partner_1.name , 'qboxEntity1name' ,qbox_entity_1.name ,'salesOrderSno',salesorder.sales_order_sno,'partnerSalesOrderId',salesorder.partner_sales_order_id,'qboxEntitySno',salesorder.qbox_entity_sno,'deliveryPartnerSno',salesorder.delivery_partner_sno,'salesOrderStatusCd',salesorder.sales_order_status_cd,'orderedTime',salesorder.ordered_time,'orderedBy',salesorder.ordered_by,'partnerCustomerRef',salesorder.partner_customer_ref,'description',salesorder.description
 ) order by sales_order_sno desc))
  FROM masters.sales_order salesorder JOIN masters.delivery_partner delivery_partner_1 ON delivery_partner_1.delivery_partner_sno = salesorder.delivery_partner_sno JOIN masters.qbox_entity qbox_entity_1 ON qbox_entity_1.qbox_entity_sno = salesorder.qbox_entity_sno
 where    
  case when i_sales_order_sno isnull then 1=1 else salesorder.sales_order_sno = i_sales_order_sno end and 
  case when i_partner_sales_order_id isnull then 1=1 else salesorder.partner_sales_order_id = i_partner_sales_order_id end and 
  case when i_qbox_entity_sno isnull then 1=1 else salesorder.qbox_entity_sno = i_qbox_entity_sno end and 
  case when i_delivery_partner_sno isnull then 1=1 else salesorder.delivery_partner_sno = i_delivery_partner_sno end and 
  case when i_sales_order_status_cd isnull then 1=1 else salesorder.sales_order_status_cd = i_sales_order_status_cd end and 
  case when i_ordered_time isnull then 1=1 else salesorder.ordered_time = i_ordered_time end and 
  case when i_ordered_by isnull then 1=1 else salesorder.ordered_by = i_ordered_by end and 
  case when i_partner_customer_ref isnull then 1=1 else salesorder.partner_customer_ref = i_partner_customer_ref end and 
  case when i_description isnull then 1=1 else salesorder.description = i_description end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_sales_order(in_data json) OWNER TO qbox_admin;

--
-- Name: search_sales_order_dtl(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_sales_order_dtl(json_input json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_sales_order_dtl_sno bigint:= (json_input->>'salesOrderDtlSno')::bigint;
i_sales_order_sno bigint:= (json_input->>'salesOrderSno')::bigint;
i_partner_food_code text:= (json_input->>'partnerFoodCode')::text;
i_food_sku_sno bigint:= (json_input->>'foodSkuSno')::bigint;
i_order_quantity integer:= (json_input->>'orderQuantity')::integer;
i_sku_price numeric:= (json_input->>'skuPrice')::numeric;
i_delivered_quantity smallint:= (json_input->>'deliveredQuantity')::smallint;
i_description text:= (json_input->>'description')::text;

  
begin

 return (select json_agg(json_build_object(
  'foodSku1name' ,food_sku_1.name , 'salesOrder1description' ,sales_order_1.description ,'salesOrderDtlSno',salesorderdtl.sales_order_dtl_sno,'salesOrderSno',salesorderdtl.sales_order_sno,'partnerFoodCode',salesorderdtl.partner_food_code,'foodSkuSno',salesorderdtl.food_sku_sno,'orderQuantity',salesorderdtl.order_quantity,'skuPrice',salesorderdtl.sku_price,'deliveredQuantity',salesorderdtl.delivered_quantity,'description',salesorderdtl.description
 )))
  FROM masters.sales_order_dtl salesorderdtl JOIN masters.food_sku food_sku_1 ON food_sku_1.food_sku_sno = salesorderdtl.food_sku_sno JOIN masters.sales_order sales_order_1 ON sales_order_1.sales_order_sno = salesorderdtl.sales_order_sno
 where    
  case when i_sales_order_dtl_sno isnull then 1=1 else salesorderdtl.sales_order_dtl_sno = i_sales_order_dtl_sno end and 
  case when i_sales_order_sno isnull then 1=1 else salesorderdtl.sales_order_sno = i_sales_order_sno end and 
  case when i_partner_food_code isnull then 1=1 else salesorderdtl.partner_food_code = i_partner_food_code end and 
  case when i_food_sku_sno isnull then 1=1 else salesorderdtl.food_sku_sno = i_food_sku_sno end and 
  case when i_order_quantity isnull then 1=1 else salesorderdtl.order_quantity = i_order_quantity end and 
  case when i_sku_price isnull then 1=1 else salesorderdtl.sku_price = i_sku_price end and 
  case when i_delivered_quantity isnull then 1=1 else salesorderdtl.delivered_quantity = i_delivered_quantity end and 
  case when i_description isnull then 1=1 else salesorderdtl.description = i_description end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_sales_order_dtl(json_input json) OWNER TO qbox_admin;

--
-- Name: search_signin_info(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_signin_info(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_signin_info_sno bigint:= (in_data->>'signinInfoSno')::bigint;
i_app_user_sno bigint:= (in_data->>'appUserSno')::bigint;
i_push_token text:= (in_data->>'pushToken')::text;
i_device_type_cd smallint:= (in_data->>'deviceTypeCd')::smallint;
i_device_id text:= (in_data->>'deviceId')::text;
i_login_on timestamp without time zone:= (in_data->>'loginOn')::timestamp without time zone;
i_logout_on timestamp without time zone:= (in_data->>'logoutOn')::timestamp without time zone;

  
begin

 return (select json_agg(json_build_object(
 'signinInfoSno',signin_info_sno,'appUserSno',app_user_sno,'pushToken',push_token,'deviceTypeCd',device_type_cd,'deviceId',device_id,'loginOn',login_on,'logoutOn',logout_on
 )))
 FROM masters.signin_info
 where    
  case when i_signin_info_sno isnull then 1=1 else signin_info_sno = i_signin_info_sno end and 
  case when i_app_user_sno isnull then 1=1 else app_user_sno = i_app_user_sno end and 
  case when i_push_token isnull then 1=1 else push_token = i_push_token end and 
  case when i_device_type_cd isnull then 1=1 else device_type_cd = i_device_type_cd end and 
  case when i_device_id isnull then 1=1 else device_id = i_device_id end and 
  case when i_login_on isnull then 1=1 else login_on = i_login_on end and 
  case when i_logout_on isnull then 1=1 else logout_on = i_logout_on end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_signin_info(in_data json) OWNER TO qbox_admin;

--
-- Name: search_sku_inventory(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_sku_inventory(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_purchase_order_dtl_sno bigint:= (in_data->>'purchaseOrderDtlSno')::bigint;
i_unique_code text:= (in_data->>'uniqueCode')::text;
i_sales_order_dtl_sno bigint:= (in_data->>'salesOrderDtlSno')::bigint;

  
begin

 RETURN (SELECT json_agg(json_build_object(
                'skuInventorySno', sku_inventory_sno,
                'purchaseOrderDtlSno', purchase_order_dtl_sno,
                'uniqueCode', unique_code,
                'salesOrderDtlSno', sales_order_dtl_sno,
                'wfStageCd', wf_stage_cd
            ) ORDER BY sku_inventory_sno)  -- Ordering the JSON array by sku_inventory_sno
            FROM masters.sku_inventory
            WHERE
                (i_sku_inventory_sno IS NULL OR sku_inventory_sno = i_sku_inventory_sno)
                AND (i_purchase_order_dtl_sno IS NULL OR purchase_order_dtl_sno = i_purchase_order_dtl_sno)
                AND (i_unique_code IS NULL OR unique_code = i_unique_code)
                AND (i_sales_order_dtl_sno IS NULL OR sales_order_dtl_sno = i_sales_order_dtl_sno)
            );
end;
$$;


ALTER FUNCTION masters.search_sku_inventory(in_data json) OWNER TO qbox_admin;

--
-- Name: search_sku_trace_wf(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_sku_trace_wf(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_sku_trace_wf_sno bigint:= (in_data->>'skuTraceWfSno')::bigint;
i_sku_inventory_sno bigint:= (in_data->>'skuInventorySno')::bigint;
i_wf_stage_cd smallint:= (in_data->>'wfStageCd')::smallint;
i_action_time timestamp without time zone:= (in_data->>'actionTime')::timestamp without time zone;
i_action_by bigint:= (in_data->>'actionBy')::bigint;
i_reference text:= (in_data->>'reference')::text;
i_description text:= (in_data->>'description')::text;

  
begin

 return (select json_agg(json_build_object(
  'appUser1' ,app_user_1.name , 'codesDtl1description' ,codes_dtl_1.description , 'skuInventory1description' ,sku_inventory_1.description ,'skuTraceWfSno',skutracewf.sku_trace_wf_sno,'skuInventorySno',skutracewf.sku_inventory_sno,'wfStageCd',skutracewf.wf_stage_cd,'actionTime',skutracewf.action_time,'actionBy',skutracewf.action_by,'reference',skutracewf.reference,'description',skutracewf.description
 ) order by sku_trace_wf_sno asc))
  FROM masters.sku_trace_wf skutracewf JOIN masters.app_user app_user_1 ON app_user_1.app_user_sno = skutracewf.action_by JOIN masters.codes_dtl codes_dtl_1 ON codes_dtl_1.codes_dtl_sno = skutracewf.wf_stage_cd JOIN masters.sku_inventory sku_inventory_1 ON sku_inventory_1.sku_inventory_sno = skutracewf.sku_inventory_sno
 where    
  case when i_sku_trace_wf_sno isnull then 1=1 else skutracewf.sku_trace_wf_sno = i_sku_trace_wf_sno end and 
  case when i_sku_inventory_sno isnull then 1=1 else skutracewf.sku_inventory_sno = i_sku_inventory_sno end and 
  case when i_wf_stage_cd isnull then 1=1 else skutracewf.wf_stage_cd = i_wf_stage_cd end and 
  case when i_action_time isnull then 1=1 else skutracewf.action_time = i_action_time end and 
  case when i_action_by isnull then 1=1 else skutracewf.action_by = i_action_by end and 
  case when i_reference isnull then 1=1 else skutracewf.reference = i_reference end and 
  case when i_description isnull then 1=1 else skutracewf.description = i_description end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_sku_trace_wf(in_data json) OWNER TO qbox_admin;

--
-- Name: search_state(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.search_state(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
    
  i_state_sno smallint:= (in_data->>'stateSno')::smallint;
i_country_sno smallint:= (in_data->>'countrySno')::smallint;
i_state_code character varying:= (in_data->>'stateCode')::character varying;
i_name text:= (in_data->>'name')::text;

  
begin

 return (select json_agg(json_build_object(
  'country1name' ,country_1.name ,'stateSno',state.state_sno,'countrySno',state.country_sno,'stateCode',state.state_code,'name',state.name
 )))
  FROM masters.state state JOIN masters.country country_1 ON country_1.country_sno = state.country_sno
 where    
  case when i_state_sno isnull then 1=1 else state.state_sno = i_state_sno end and 
  case when i_country_sno isnull then 1=1 else state.country_sno = i_country_sno end and 
  case when i_state_code isnull then 1=1 else state.state_code = i_state_code end and 
  case when i_name isnull then 1=1 else state.name = i_name end and 
 1=1; 
end;
$$;


ALTER FUNCTION masters.search_state(in_data json) OWNER TO qbox_admin;

--
-- Name: unload_sku_from_qbox_to_hotbox(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.unload_sku_from_qbox_to_hotbox(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_unique_code text:= (in_data->>'uniqueCode')::text;
    i_wf_stage_cd smallint :=(in_data->>'wfStageCd')::smallint;
	i_sku_inventory_sno  bigint := 0;
	i_box_cell_food_sno smallint:=0;
	i_qbox_entity_sno smallint:=(in_data->>'qboxEntitySno')::smallint;
	_result json;
 begin
	Select sku_inventory_sno  into i_sku_inventory_sno
	from masters.sku_inventory where unique_code = i_unique_code;
	Raise notice '%', i_sku_inventory_sno;
	if i_sku_inventory_sno is not null
	THEN

	Select sku_inventory_sno into i_sku_inventory_sno from sku_inventory where unique_code = i_unique_code;

	select max(box_cell_food_sno) into i_box_cell_food_sno from masters.box_cell_food where  
	sku_inventory_sno = i_sku_inventory_sno and active = true;
	
	UPDATE masters.box_cell_food set active = false where box_cell_food_sno = i_box_cell_food_sno;

	UPDATE masters.sku_inventory SET wf_stage_cd = i_wf_stage_cd where sku_inventory_sno = i_sku_inventory_sno;
	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by) SELECT 
	i_sku_inventory_sno,i_wf_stage_cd,CURRENT_TIMESTAMP,1, unique_code from masters.sku_inventory where sku_inventory_sno = i_sku_inventory_sno;
	
	END IF;
	_result := json_build_object(
        'skuTarget','Hot Box') ;

    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN _result;	
end;
$$;


ALTER FUNCTION masters.unload_sku_from_qbox_to_hotbox(in_data json) OWNER TO qbox_admin;

--
-- Name: update_entity_infra_properties(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.update_entity_infra_properties(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_entity_infra_sno bigint;
    i_infra_property_sno smallint;
    i_value text;
    i_properties json;
    result json[];
    idx integer := 0;
BEGIN
    -- Loop through each infrastructure in the input data
    FOR i_entity_infra_sno, i_properties IN
        SELECT 
            (infra->>'entityInfraSno')::bigint,
            infra->'properties'
        FROM json_array_elements(in_data->'data') AS infra
    LOOP
        -- Update each property for the current entity_infra
        FOR i_infra_property_sno, i_value IN
            SELECT 
                (prop->>'infraPropertySno')::smallint,
                (prop->>'value')::text
            FROM json_array_elements(i_properties) AS prop
        LOOP
            UPDATE masters.entity_infra_property
            SET value = i_value
            WHERE entity_infra_sno = i_entity_infra_sno
            AND infra_property_sno = i_infra_property_sno;
        END LOOP;

        -- Add updated records to result array
        result[idx] := json_build_object(
            'entityInfraSno', i_entity_infra_sno,
            'properties', i_properties
        );
        idx := idx + 1;
    END LOOP;

    RETURN json_build_object(
        'status', 200,
        'isSuccess', true,
        'data', array_to_json(result)
    );
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'status', 500,
        'isSuccess', false,
        'errorMsg', SQLERRM
    );
END;
$$;


ALTER FUNCTION masters.update_entity_infra_properties(in_data json) OWNER TO qbox_admin;

--
-- Name: update_entity_infrastructure(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.update_entity_infrastructure(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    i_entity_infra_sno bigint;
    i_infra_property_sno smallint;
    i_value text;
    i_properties json;
    result json[];
    idx integer := 0;
BEGIN
    -- Loop through each infrastructure in the input data
    FOR i_entity_infra_sno, i_properties IN
        SELECT 
            (infra->>'entityInfraSno')::bigint,
            infra->'properties'
        FROM json_array_elements(in_data->'data') AS infra
    LOOP
        -- Update each property for the current entity_infra
        FOR i_infra_property_sno, i_value IN
            SELECT 
                (prop->>'infraPropertySno')::smallint,
                (prop->>'value')::text
            FROM json_array_elements(i_properties) AS prop
        LOOP
            UPDATE masters.entity_infra_property
            SET value = i_value
            WHERE entity_infra_sno = i_entity_infra_sno
            AND infra_property_sno = i_infra_property_sno;
        END LOOP;

        -- Add updated records to result array
        result[idx] := json_build_object(
            'entityInfraSno', i_entity_infra_sno,
            'properties', i_properties
        );
        idx := idx + 1;
    END LOOP;

    RETURN json_build_object(
        'status', 200,
        'isSuccess', true,
        'data', array_to_json(result)
    );
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'status', 500,
        'isSuccess', false,
        'errorMsg', SQLERRM
    );
END;
$$;


ALTER FUNCTION masters.update_entity_infrastructure(in_data json) OWNER TO qbox_admin;

--
-- Name: verify_inward_delivery(json); Type: FUNCTION; Schema: masters; Owner: qbox_admin
--

CREATE FUNCTION masters.verify_inward_delivery(in_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare 
	i_partner_purchase_order_id text:= (in_data->>'partnerPurchaseOrderId')::text;
    i_purchase_order_sno  bigint  := 0;
    rejected_detail_record json;
	order_details_result json;
begin
	Select purchase_order_sno  into i_purchase_order_sno
	from masters.purchase_order where partner_purchase_order_id = i_partner_purchase_order_id;
	
	Raise notice '%', i_purchase_order_sno;
	
	if i_purchase_order_sno is not null
	THEN
	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description)
			Select sku_inventory_sno,9,CURRENT_TIMESTAMP,1,unique_code from 
			masters.sku_inventory where purchase_order_dtl_sno in (Select purchase_order_dtl_sno from 
	masters.purchase_order_dtl where purchase_order_sno =i_purchase_order_sno);
	
	UPDATE masters.sku_inventory 
	SET wf_stage_cd = 9 WHERE 
	sku_inventory_sno = (rejected_detail_record->>'skuInventorySno')::bigint;

 	FOR rejected_detail_record IN SELECT json_array_elements(in_data->'rejectedSkus') 
    LOOP
		UPDATE masters.sku_trace_wf set wf_stage_cd = 8 WHERE 
		sku_inventory_sno = (rejected_detail_record->>'skuInventorySno')::bigint
	and wf_stage_cd = 9;

	UPDATE masters.sku_inventory set wf_stage_cd = 8 where sku_inventory_sno = (rejected_detail_record->>'skuInventorySno')::bigint;
	
	END LOOP;
	END IF;

	INSERT INTO masters.sku_trace_wf(
			 sku_inventory_sno, wf_stage_cd, action_time, action_by,description)
			Select sku_inventory_sno,10,CURRENT_TIMESTAMP,1,unique_code from 
			masters.sku_inventory where purchase_order_dtl_sno in (Select purchase_order_dtl_sno from 
	masters.purchase_order_dtl where purchase_order_sno =i_purchase_order_sno) and wf_stage_cd = 9;
	
	order_details_result := json_build_object(
        'verification','completed') ;

    -- Return the JSON object containing the purchase order, order details, and corresponding sku_inventory records
    RETURN order_details_result;	
end;
$$;


ALTER FUNCTION masters.verify_inward_delivery(in_data json) OWNER TO qbox_admin;

--
-- Name: group_and_validate_purchase_orders(integer); Type: FUNCTION; Schema: partner_order; Owner: postgres
--

CREATE FUNCTION partner_order.group_and_validate_purchase_orders(i_etl_job_sno integer) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$

DECLARE

    duplicate_count INTEGER;

    grouped_data JSONB;

BEGIN

    -- Step 1: Perform grouping with nested structure (group by partner_purchase_order_id and partner_food_code)

    SELECT 

        JSONB_AGG(

            JSONB_BUILD_OBJECT(

                'partner_code', partner_code,

                'restaurant_code', restaurant_code,

                'qbox_remote_location', qbox_remote_location,

                'partner_purchase_order_id', partner_purchase_order_id,

                'partner_foods', partner_foods -- Nested foods for each partner_purchase_order_id

            )

        )

    INTO grouped_data

    FROM (

        SELECT 

            partner_code,

            restaurant_code,

            qbox_remote_location,

            partner_purchase_order_id,

            JSONB_AGG(

                JSONB_BUILD_OBJECT(

                    'partner_food_code', partner_food_code,

                    'sku_unique_codes', sku_codes,

					 'order_quantity', array_length(array(SELECT * FROM jsonb_array_elements_text(sku_codes)), 1) -- Corrected: Convert JSONB array to PostgreSQL array and calculate length

                )

            ) AS partner_foods

        FROM (

            SELECT 

                partner_code,

                restaurant_code,

                qbox_remote_location,

                partner_purchase_order_id,

                partner_food_code,

                JSONB_AGG(sku_unique_code) AS sku_codes

            FROM partner_order.swiggy_staging

            WHERE swiggy_staging.etl_job_sno = i_etl_job_sno -- Explicit column reference

            GROUP BY 

                partner_code,

                restaurant_code,

                qbox_remote_location,

                partner_purchase_order_id,

                partner_food_code -- Grouping by partner_food_code inside partner_purchase_order_id

        ) food_group

        GROUP BY 

            partner_code,

            restaurant_code,

            qbox_remote_location,

            partner_purchase_order_id -- Grouping by partner_purchase_order_id first

    ) final_group;
 
    -- Step 2: Validate for duplicate `partner_purchase_order_id` post grouping (without partner_food_code in validation)

    SELECT COUNT(*) INTO duplicate_count

    FROM (

        SELECT partner_purchase_order_id

        FROM (

            SELECT 

                partner_code,

                restaurant_code,

                qbox_remote_location,

                partner_purchase_order_id,

                JSONB_AGG(sku_unique_code) AS sku_codes

            FROM partner_order.swiggy_staging

            WHERE swiggy_staging.etl_job_sno = i_etl_job_sno -- Explicit column reference

            GROUP BY 

                partner_code,

                restaurant_code,

                qbox_remote_location,

                partner_purchase_order_id

        ) grouped

        GROUP BY partner_purchase_order_id

        HAVING COUNT(*) > 1

    ) duplicates;
 
    -- Step 3: Return error if duplicates are found

    IF duplicate_count > 0 THEN

        RETURN JSONB_BUILD_OBJECT(

            'status', 'error',

            'message', 'Same Order Id placed for Different Orders',

            'etl_job_sno', i_etl_job_sno

        );

    END IF;
 
	 

    PERFORM partner_order.process_group_validation_json_v2(JSONB_BUILD_OBJECT(

            'status', 'success',

            'message', 'Grouping and validation successful',

            'etl_job_sno', i_etl_job_sno,

            'data', grouped_data

        ));

    -- Step 4: Return grouped data if no duplicates

    RETURN JSONB_BUILD_OBJECT(

        'status', 'success',

        'message', 'Grouping and validation successful',

        'etl_job_sno', i_etl_job_sno,

        'group_validation', JSONB_BUILD_OBJECT(

            'status', 'success',

            'message', 'Inward Order Creation Successful',

            'etl_job_sno', i_etl_job_sno,

            'data', grouped_data

        )

    );

END;

$$;


ALTER FUNCTION partner_order.group_and_validate_purchase_orders(i_etl_job_sno integer) OWNER TO postgres;

--
-- Name: process_etl_job_v4(jsonb); Type: FUNCTION; Schema: partner_order; Owner: postgres
--

CREATE FUNCTION partner_order.process_etl_job_v4(json_data jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$

DECLARE

    etl_job_id INTEGER;

    row JSONB;

    column_map RECORD;

    staging_table_name VARCHAR(255);

    file_name_prefix VARCHAR(7);

    extracted_filename VARCHAR(255);

    i_order_etl_hdr_sno INTEGER;  -- PL/pgSQL variable

    processed_by VARCHAR(255);

    insert_query TEXT;

    staging_row_id INTEGER;

    column_values TEXT[];

    column_names TEXT[];

    check_filename VARCHAR(255);

    group_and_validate_response JSONB;  -- Variable to hold the response from group_and_validate_purchase_orders

BEGIN

    -- Step 1: Extract `filename` and `processed_by` from JSONB input

    extracted_filename := json_data->>'filename';

    processed_by := json_data->>'processed_by';
 
    IF extracted_filename IS NULL THEN

        RETURN jsonb_build_object('status', 'error', 'message', 'Filename is required in the JSON input');

    END IF;
 
    IF processed_by IS NULL THEN

        RETURN jsonb_build_object('status', 'error', 'message', 'Processed_by is required in the JSON input');

    END IF;
 
    -- Step 2: Check if the file with "_datafile" suffix already exists in the etl_job table

    check_filename := extracted_filename;
 
    IF EXISTS (

        SELECT 1

        FROM partner_order.etl_job

        WHERE file_name = check_filename

          AND status = 'Completed'

    ) THEN

        RETURN jsonb_build_object(

            'status', 'error', 

            'message', format('File "%s" is already being processed or is not completed yet', check_filename)

        );

    END IF;
 
    -- Step 3: Fetch order_etl_hdr_sno, staging_table_name, and file_name_prefix using the filename prefix

    SELECT oe.order_etl_hdr_sno, oe.staging_table_name, oe.file_name_prefix

    INTO i_order_etl_hdr_sno, staging_table_name, file_name_prefix

    FROM partner_order.order_etl_hdr oe

    WHERE extracted_filename LIKE oe.file_name_prefix || '%';
 
    IF i_order_etl_hdr_sno IS NULL THEN

        RETURN jsonb_build_object('status', 'error', 'message', format('No matching order_etl_hdr found for filename: %s', extracted_filename));

    END IF;
 
    -- Step 4: Insert into etl_job and retrieve the generated etl_job_sno

    INSERT INTO partner_order.etl_job (

        order_etl_hdr_sno,

        file_name,

        etl_start_timestamp,

        processed_by,

        status

    )

    VALUES (

        i_order_etl_hdr_sno,

        extracted_filename,

        CURRENT_TIMESTAMP,

        processed_by,

        'In Progress'

    )

    RETURNING etl_job_sno INTO etl_job_id;
 
    -- Step 5: Insert records into the staging table first

    FOR row IN SELECT * FROM jsonb_array_elements(json_data->'records')

    LOOP

        column_names := ARRAY[]::TEXT[];  -- Clear column names array

        column_values := ARRAY[]::TEXT[];  -- Clear column values array
 
        -- Loop through column mappings and prepare the list of columns and values for the insert query

        FOR column_map IN

            SELECT ec.source_column, ec.staging_column, ec.data_type, ec.is_required

            FROM partner_order.etl_table_column ec

            WHERE ec.order_etl_hdr_sno = i_order_etl_hdr_sno

        LOOP

            column_names := array_append(column_names, column_map.staging_column);

            column_values := array_append(column_values, 

                CASE 

                    WHEN COALESCE(row->>column_map.source_column, '') = '' THEN 'NULL' 

                    ELSE quote_literal(row->>column_map.source_column)  -- Ensures string literals are properly quoted

                END

            );

        END LOOP;
 
        -- Build the dynamic insert query

        insert_query := format(

            'INSERT INTO partner_order.%I (%s, etl_job_sno) VALUES (%s, %L) RETURNING swiggy_staging_sno',

            staging_table_name,

            array_to_string(column_names, ', '),

            array_to_string(column_values, ', '),

            etl_job_id

        );
 
        -- Execute the insert query

        EXECUTE insert_query INTO staging_row_id;
 
        -- Step 6: Insert corresponding record in etl_record

        INSERT INTO partner_order.etl_record (

            etl_job_sno,

            staging_table_name,

            row_id,

            processing_status

        )

        VALUES (

            etl_job_id,

            staging_table_name,

            staging_row_id,

            'Pending'

        );

    END LOOP;
 
    -- Step 7: Update etl_job status to Completed after processing all rows

    UPDATE partner_order.etl_job

    SET status = 'Completed',

        etl_end_timestamp = CURRENT_TIMESTAMP,

        record_count = (SELECT COUNT(*) FROM partner_order.swiggy_staging WHERE etl_job_sno = etl_job_id)

    WHERE etl_job_sno = etl_job_id;
 
    -- Step 8: Call group_and_validate_purchase_orders function

    group_and_validate_response := partner_order.group_and_validate_purchase_orders(etl_job_id);
 
    -- Step 9: Return the combined response

    RETURN jsonb_build_object(

        'status', 'success',

        'message', 'ETL job completed successfully',

        'etl_job_sno', etl_job_id,

        'group_validation', group_and_validate_response

    );

END;

$$;


ALTER FUNCTION partner_order.process_etl_job_v4(json_data jsonb) OWNER TO postgres;

--
-- Name: process_group_validation_json_v2(jsonb); Type: FUNCTION; Schema: partner_order; Owner: postgres
--

CREATE FUNCTION partner_order.process_group_validation_json_v2(group_validation jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE

    i_partner_code text;

    partner_foods jsonb;

    purchase_order_id text;

    i_restaurant_code text;

    qbox_remote_location text;

    i_restaurant_sno integer;

    i_qbox_entity_sno integer;

    i_delivery_partner_sno integer;

    i_purchase_order_sno integer;

    i_partner_food_code text;

    order_quantity integer;

    sku_unique_codes jsonb;

    partner_food jsonb;

    i_purchase_order_dtl_sno integer;

    i_sku_inventory_sno integer;

    unique_code text;

BEGIN

    -- Loop through each partner order in the group validation data

    RAISE NOTICE 'HEREEEEEEEEE';
    RAISE NOTICE '%',group_validation;

    FOR i_partner_code, partner_foods, purchase_order_id, i_restaurant_code, qbox_remote_location IN

        SELECT 

            partner_order->>'partner_code',

            partner_order->'partner_foods',

            partner_order->>'partner_purchase_order_id',

            partner_order->>'restaurant_code',

            partner_order->>'qbox_remote_location'

        FROM jsonb_array_elements(group_validation->'data') AS partner_order

    LOOP

        -- Debugging: print out values to ensure the loop is working

        RAISE NOTICE 'Processing Partner: %, Order ID: %, Restaurant Code: %, Qbox Location: %', 

            i_partner_code, purchase_order_id, i_restaurant_code, qbox_remote_location;
 
        -- Get qbox_entity_sno and restaurant_sno

        SELECT qbox_entity_sno INTO i_qbox_entity_sno

        FROM masters.qbox_entity

        WHERE entity_code = qbox_remote_location;
 
        SELECT restaurant_sno INTO i_restaurant_sno

        FROM masters.restaurant

        WHERE restaurant_code = i_restaurant_code;
 
        -- Get delivery_partner_sno

        SELECT delivery_partner_sno INTO i_delivery_partner_sno

        FROM masters.delivery_partner

        WHERE partner_code = i_partner_code;
 
        -- Debugging: check if values are found

        RAISE NOTICE 'Qbox Entity Sno: %, Restaurant Sno: %, Delivery Partner Sno: %', 

            i_qbox_entity_sno, i_restaurant_sno, i_delivery_partner_sno;
 
        -- If any lookup returns NULL, exit the loop

        IF i_qbox_entity_sno IS NULL OR i_restaurant_sno IS NULL OR i_delivery_partner_sno IS NULL THEN

            RAISE NOTICE 'Missing data, skipping partner purchase order';

            CONTINUE;

        END IF;
 
        -- Insert the purchase order

        INSERT INTO masters.purchase_order(

            etl_job_sno,

            qbox_entity_sno, 

            restaurant_sno, 

            delivery_partner_sno, 

            order_status_cd,

            ordered_time,

            ordered_by,

            partner_purchase_order_id, 

            meal_time_cd, 

            description, 

            active_flag)

        VALUES (

            51, 

            i_qbox_entity_sno,

            i_restaurant_sno,

            i_delivery_partner_sno,

            1, 

            CURRENT_TIMESTAMP,

            1,

            purchase_order_id,

            1,

            '', 

            true

        )

        RETURNING purchase_order_sno INTO i_purchase_order_sno;
 
        -- Debugging: Check if purchase_order_sno is generated

        RAISE NOTICE 'Created Purchase Order Sno: %', i_purchase_order_sno;
 
        -- Loop through partner foods to insert purchase order details

        FOR partner_food IN

            SELECT * FROM jsonb_array_elements(partner_foods) AS food

        LOOP

            -- Extract partner_food_code and order_quantity

            i_partner_food_code := partner_food->>'partner_food_code';

            order_quantity := (partner_food->>'order_quantity')::int;

            sku_unique_codes := partner_food->'sku_unique_codes';  -- Get the sku_unique_codes
 
            -- Debugging: check extracted values

            RAISE NOTICE 'Food Code: %, Quantity: %', i_partner_food_code, order_quantity;
 
            -- Insert each partner food entry into purchase_order_dtl

            INSERT INTO masters.purchase_order_dtl(

                purchase_order_sno, 

                restaurant_food_sku_sno, 

                order_quantity, 

                sku_price, 

                partner_food_code, 

                accepted_quantity, 

                description, 

                active_flag, 

                qbox_entity_sno

            )

            VALUES (

                i_purchase_order_sno,

                -- Assuming restaurant_food_sku_sno and partner_food_code lookup is correct

                (SELECT restaurant_food_sku_sno 

                 FROM masters.restaurant_food_sku 

                 WHERE restaurant_sno = i_restaurant_sno 

                 AND food_sku_sno = 

                     (SELECT food_sku_sno 

                      FROM masters.partner_food_sku 

                      WHERE partner_food_code = i_partner_food_code)),

                order_quantity, -- The order quantity directly comes from the JSON

                0.0,  -- Assuming SKU price is 0.0, adjust as needed

                i_partner_food_code,

                0,  -- Assuming accepted quantity is 0, adjust as needed

                '',

                true,

                i_qbox_entity_sno  -- Here, explicitly using the variable

            )

            RETURNING purchase_order_dtl_sno INTO i_purchase_order_dtl_sno;
 
  RAISE NOTICE 'HEREEEEEEEEE22222222222222';

            -- Loop through sku_unique_codes and insert into sku_inventory

            FOR unique_code IN

                SELECT * FROM jsonb_array_elements_text(sku_unique_codes)

            LOOP

			RAISE NOTICE 'HEREEEEEEEEE22223333333333333333333';

                -- Insert into sku_inventory

                INSERT INTO masters.sku_inventory(

                    purchase_order_dtl_sno, 

                    unique_code, 

                    wf_stage_cd, 

                    description, 

                    active_flag, 

                    transaction_date, 

                    restaurant_food_sku_sno, 

                    qbox_entity_sno

                )

                VALUES (

                    i_purchase_order_dtl_sno, 

                    unique_code, 

                    6,  -- wf_stage_cd

                    CONCAT(i_restaurant_code,'-',i_partner_food_code),  -- description

                    true, 

                    now(), 

                    (SELECT restaurant_food_sku_sno 

                     FROM masters.restaurant_food_sku 

                     WHERE restaurant_sno = i_restaurant_sno 

                     AND food_sku_sno = 

                         (SELECT food_sku_sno 

                          FROM masters.partner_food_sku 

                          WHERE partner_food_code = i_partner_food_code)),

                    i_qbox_entity_sno

                ) 

                RETURNING sku_inventory_sno INTO i_sku_inventory_sno;
 
                -- If sku_inventory_sno is not null, insert into sku_trace_wf

                IF i_sku_inventory_sno IS NOT NULL THEN

                    INSERT INTO masters.sku_trace_wf(

                        sku_inventory_sno, 

                        wf_stage_cd, 

                        action_time, 

                        action_by, 

                        reference

                    )

                    VALUES (

                        i_sku_inventory_sno, 

                        6, 

                        CURRENT_TIMESTAMP, 

                        1,  -- action_by

                        concat('pod-sno-', i_purchase_order_dtl_sno)

                    );

                END IF;

            END LOOP;

        END LOOP;

    END LOOP;

END;

$$;


ALTER FUNCTION partner_order.process_group_validation_json_v2(group_validation jsonb) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_permission; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.app_permission (
    app_permission_sno bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.app_permission OWNER TO postgres;

--
-- Name: app_function_app_function_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.app_function_app_function_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.app_function_app_function_sno_seq OWNER TO postgres;

--
-- Name: app_function_app_function_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.app_function_app_function_sno_seq OWNED BY auth.app_permission.app_permission_sno;


--
-- Name: app_menu; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.app_menu (
    app_menu_sno smallint NOT NULL,
    name text NOT NULL,
    parent_menu_sno smallint NOT NULL,
    href text NOT NULL,
    title text NOT NULL,
    status boolean DEFAULT false,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.app_menu OWNER TO postgres;

--
-- Name: app_menu_app_menu_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.app_menu_app_menu_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.app_menu_app_menu_sno_seq OWNER TO postgres;

--
-- Name: app_menu_app_menu_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.app_menu_app_menu_sno_seq OWNED BY auth.app_menu.app_menu_sno;


--
-- Name: app_role; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.app_role (
    app_role_sno smallint NOT NULL,
    name text,
    status boolean DEFAULT false,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.app_role OWNER TO postgres;

--
-- Name: app_role_app_role_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.app_role_app_role_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.app_role_app_role_sno_seq OWNER TO postgres;

--
-- Name: app_role_app_role_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.app_role_app_role_sno_seq OWNED BY auth.app_role.app_role_sno;


--
-- Name: app_user; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.app_user (
    app_user_sno bigint NOT NULL,
    user_id text NOT NULL,
    password text,
    status boolean,
    name text,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.app_user OWNER TO postgres;

--
-- Name: app_user_app_user_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.app_user_app_user_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.app_user_app_user_sno_seq OWNER TO postgres;

--
-- Name: app_user_app_user_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.app_user_app_user_sno_seq OWNED BY auth.app_user.app_user_sno;


--
-- Name: app_user_role; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.app_user_role (
    app_user_role_sno bigint NOT NULL,
    app_user_sno bigint,
    app_role_sno smallint NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.app_user_role OWNER TO postgres;

--
-- Name: app_user_role_app_user_role_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.app_user_role_app_user_role_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.app_user_role_app_user_role_sno_seq OWNER TO postgres;

--
-- Name: app_user_role_app_user_role_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.app_user_role_app_user_role_sno_seq OWNED BY auth.app_user_role.app_user_role_sno;


--
-- Name: codes_dtl; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.codes_dtl (
    codes_dtl_sno smallint NOT NULL,
    codes_hdr_sno smallint NOT NULL,
    description text NOT NULL,
    seqno integer,
    filter_1 text,
    filter_2 text,
    active_flag boolean DEFAULT true NOT NULL
);


ALTER TABLE auth.codes_dtl OWNER TO postgres;

--
-- Name: codes_dtl_codes_dtl_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.codes_dtl_codes_dtl_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.codes_dtl_codes_dtl_sno_seq OWNER TO postgres;

--
-- Name: codes_dtl_codes_dtl_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.codes_dtl_codes_dtl_sno_seq OWNED BY auth.codes_dtl.codes_dtl_sno;


--
-- Name: codes_hdr; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.codes_hdr (
    codes_hdr_sno smallint NOT NULL,
    description text NOT NULL,
    active_flag boolean DEFAULT true NOT NULL
);


ALTER TABLE auth.codes_hdr OWNER TO postgres;

--
-- Name: codes_hdr_codes_hdr_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.codes_hdr_codes_hdr_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.codes_hdr_codes_hdr_sno_seq OWNER TO postgres;

--
-- Name: codes_hdr_codes_hdr_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.codes_hdr_codes_hdr_sno_seq OWNED BY auth.codes_hdr.codes_hdr_sno;


--
-- Name: menu_permission; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.menu_permission (
    menu_permission_sno smallint NOT NULL,
    app_menu_sno smallint NOT NULL,
    app_permission_sno smallint NOT NULL,
    status boolean DEFAULT false,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.menu_permission OWNER TO postgres;

--
-- Name: menu_function_menu_function_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.menu_function_menu_function_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.menu_function_menu_function_sno_seq OWNER TO postgres;

--
-- Name: menu_function_menu_function_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.menu_function_menu_function_sno_seq OWNED BY auth.menu_permission.menu_permission_sno;


--
-- Name: otp; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.otp (
    otp_sno bigint NOT NULL,
    app_user_sno bigint,
    sms_otp character varying(6),
    service_otp text,
    push_otp text,
    device_id text,
    otp_expire_time_cd smallint,
    otp_expire_time timestamp without time zone,
    otp_status boolean,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.otp OWNER TO postgres;

--
-- Name: otp_otp_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.otp_otp_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.otp_otp_sno_seq OWNER TO postgres;

--
-- Name: otp_otp_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.otp_otp_sno_seq OWNED BY auth.otp.otp_sno;


--
-- Name: role_permission; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.role_permission (
    role_permission_sno bigint NOT NULL,
    app_role_sno smallint NOT NULL,
    app_permission_sno integer NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.role_permission OWNER TO postgres;

--
-- Name: role_function_role_function_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.role_function_role_function_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.role_function_role_function_sno_seq OWNER TO postgres;

--
-- Name: role_function_role_function_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.role_function_role_function_sno_seq OWNED BY auth.role_permission.role_permission_sno;


--
-- Name: role_menu; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.role_menu (
    role_menu_sno smallint NOT NULL,
    app_menu_sno smallint NOT NULL,
    app_role_sno smallint NOT NULL,
    status boolean DEFAULT false,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.role_menu OWNER TO postgres;

--
-- Name: role_menu_role_menu_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.role_menu_role_menu_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.role_menu_role_menu_sno_seq OWNER TO postgres;

--
-- Name: role_menu_role_menu_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.role_menu_role_menu_sno_seq OWNED BY auth.role_menu.role_menu_sno;


--
-- Name: signin_info; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.signin_info (
    signin_info_sno bigint NOT NULL,
    app_user_sno bigint,
    push_token text,
    device_type_cd smallint,
    device_id text,
    login_on timestamp without time zone,
    logout_on timestamp without time zone,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE auth.signin_info OWNER TO postgres;

--
-- Name: signin_info_signin_info_sno_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.signin_info_signin_info_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.signin_info_signin_info_sno_seq OWNER TO postgres;

--
-- Name: signin_info_signin_info_sno_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.signin_info_signin_info_sno_seq OWNED BY auth.signin_info.signin_info_sno;


--
-- Name: address; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.address (
    address_sno bigint NOT NULL,
    line1 text NOT NULL,
    line2 text,
    area_sno integer,
    city_sno integer NOT NULL,
    geo_loc_code text NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.address OWNER TO postgres;

--
-- Name: address_address_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.address_address_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.address_address_sno_seq OWNER TO postgres;

--
-- Name: address_address_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.address_address_sno_seq OWNED BY masters.address.address_sno;


--
-- Name: app_permission; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.app_permission (
    app_permission_sno bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.app_permission OWNER TO postgres;

--
-- Name: app_function_app_function_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.app_function_app_function_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.app_function_app_function_sno_seq OWNER TO postgres;

--
-- Name: app_function_app_function_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.app_function_app_function_sno_seq OWNED BY masters.app_permission.app_permission_sno;


--
-- Name: app_menu; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.app_menu (
    app_menu_sno smallint NOT NULL,
    name text NOT NULL,
    parent_menu_sno smallint NOT NULL,
    href text NOT NULL,
    title text NOT NULL,
    status boolean DEFAULT false,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.app_menu OWNER TO postgres;

--
-- Name: app_menu_app_menu_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.app_menu_app_menu_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.app_menu_app_menu_sno_seq OWNER TO postgres;

--
-- Name: app_menu_app_menu_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.app_menu_app_menu_sno_seq OWNED BY masters.app_menu.app_menu_sno;


--
-- Name: app_role; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.app_role (
    app_role_sno smallint NOT NULL,
    name text,
    status boolean DEFAULT false,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.app_role OWNER TO postgres;

--
-- Name: app_role_app_role_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.app_role_app_role_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.app_role_app_role_sno_seq OWNER TO postgres;

--
-- Name: app_role_app_role_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.app_role_app_role_sno_seq OWNED BY masters.app_role.app_role_sno;


--
-- Name: app_user; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.app_user (
    app_user_sno bigint NOT NULL,
    user_id text NOT NULL,
    password text,
    status boolean,
    name text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.app_user OWNER TO postgres;

--
-- Name: app_user_app_user_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.app_user_app_user_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.app_user_app_user_sno_seq OWNER TO postgres;

--
-- Name: app_user_app_user_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.app_user_app_user_sno_seq OWNED BY masters.app_user.app_user_sno;


--
-- Name: app_user_role; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.app_user_role (
    app_user_role_sno bigint NOT NULL,
    app_user_sno bigint,
    app_role_sno smallint NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.app_user_role OWNER TO postgres;

--
-- Name: app_user_role_app_user_role_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.app_user_role_app_user_role_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.app_user_role_app_user_role_sno_seq OWNER TO postgres;

--
-- Name: app_user_role_app_user_role_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.app_user_role_app_user_role_sno_seq OWNED BY masters.app_user_role.app_user_role_sno;


--
-- Name: area; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.area (
    area_sno bigint NOT NULL,
    country_sno smallint NOT NULL,
    state_sno smallint NOT NULL,
    city_sno integer NOT NULL,
    name text NOT NULL,
    pincode text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.area OWNER TO postgres;

--
-- Name: area_area_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.area_area_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.area_area_sno_seq OWNER TO postgres;

--
-- Name: area_area_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.area_area_sno_seq OWNED BY masters.area.area_sno;


--
-- Name: box_cell; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.box_cell (
    box_cell_sno bigint NOT NULL,
    qbox_entity_sno bigint NOT NULL,
    entity_infra_sno bigint NOT NULL,
    row_no smallint NOT NULL,
    column_no smallint NOT NULL,
    box_cell_status_cd smallint NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.box_cell OWNER TO postgres;

--
-- Name: box_cell_box_cell_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.box_cell_box_cell_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.box_cell_box_cell_sno_seq OWNER TO postgres;

--
-- Name: box_cell_box_cell_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.box_cell_box_cell_sno_seq OWNED BY masters.box_cell.box_cell_sno;


--
-- Name: box_cell_food; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.box_cell_food (
    box_cell_food_sno bigint NOT NULL,
    box_cell_sno smallint NOT NULL,
    sku_inventory_sno bigint NOT NULL,
    entry_time timestamp without time zone NOT NULL,
    qbox_entity_sno bigint NOT NULL,
    active boolean DEFAULT true,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.box_cell_food OWNER TO postgres;

--
-- Name: box_cell_food_box_cell_food_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.box_cell_food_box_cell_food_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.box_cell_food_box_cell_food_sno_seq OWNER TO postgres;

--
-- Name: box_cell_food_box_cell_food_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.box_cell_food_box_cell_food_sno_seq OWNED BY masters.box_cell_food.box_cell_food_sno;


--
-- Name: box_cell_food_hist; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.box_cell_food_hist (
    box_cell_food_sno bigint NOT NULL,
    box_cell_sno smallint NOT NULL,
    sku_inventory_sno bigint NOT NULL,
    entry_time timestamp without time zone NOT NULL,
    qbox_entity_sno bigint NOT NULL,
    description text,
    active_flag boolean DEFAULT true,
    partner_sales_order_id text
);


ALTER TABLE masters.box_cell_food_hist OWNER TO postgres;

--
-- Name: city; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.city (
    city_sno bigint NOT NULL,
    country_sno smallint NOT NULL,
    state_sno smallint NOT NULL,
    name text NOT NULL,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.city OWNER TO postgres;

--
-- Name: city_city_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.city_city_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.city_city_sno_seq OWNER TO postgres;

--
-- Name: city_city_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.city_city_sno_seq OWNED BY masters.city.city_sno;


--
-- Name: codes_dtl; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.codes_dtl (
    codes_dtl_sno smallint NOT NULL,
    codes_hdr_sno smallint NOT NULL,
    description text NOT NULL,
    seqno integer,
    filter_1 text,
    filter_2 text,
    active_flag boolean DEFAULT true NOT NULL
);


ALTER TABLE masters.codes_dtl OWNER TO postgres;

--
-- Name: codes_dtl_codes_dtl_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.codes_dtl_codes_dtl_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.codes_dtl_codes_dtl_sno_seq OWNER TO postgres;

--
-- Name: codes_dtl_codes_dtl_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.codes_dtl_codes_dtl_sno_seq OWNED BY masters.codes_dtl.codes_dtl_sno;


--
-- Name: codes_hdr; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.codes_hdr (
    codes_hdr_sno smallint NOT NULL,
    description text NOT NULL,
    active_flag boolean DEFAULT true NOT NULL
);


ALTER TABLE masters.codes_hdr OWNER TO postgres;

--
-- Name: codes_hdr_codes_hdr_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.codes_hdr_codes_hdr_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.codes_hdr_codes_hdr_sno_seq OWNER TO postgres;

--
-- Name: codes_hdr_codes_hdr_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.codes_hdr_codes_hdr_sno_seq OWNED BY masters.codes_hdr.codes_hdr_sno;


--
-- Name: country; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.country (
    country_sno smallint NOT NULL,
    name text NOT NULL,
    iso2 character varying(2) NOT NULL,
    phone_code character varying(4) NOT NULL,
    numeric_code character varying(6),
    currency_code character varying(6),
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.country OWNER TO postgres;

--
-- Name: country_country_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.country_country_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.country_country_sno_seq OWNER TO postgres;

--
-- Name: country_country_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.country_country_sno_seq OWNED BY masters.country.country_sno;


--
-- Name: delivery_partner; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.delivery_partner (
    delivery_partner_sno smallint NOT NULL,
    partner_code character varying(4) NOT NULL,
    name text NOT NULL,
    partner_status_cd smallint NOT NULL,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.delivery_partner OWNER TO postgres;

--
-- Name: delivery_partner_delivery_partner_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.delivery_partner_delivery_partner_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.delivery_partner_delivery_partner_sno_seq OWNER TO postgres;

--
-- Name: delivery_partner_delivery_partner_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.delivery_partner_delivery_partner_sno_seq OWNED BY masters.delivery_partner.delivery_partner_sno;


--
-- Name: entity_infra_entity_infra_sno_seq; Type: SEQUENCE; Schema: masters; Owner: qbox_admin
--

CREATE SEQUENCE masters.entity_infra_entity_infra_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE masters.entity_infra_entity_infra_sno_seq OWNER TO qbox_admin;

--
-- Name: entity_infra; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.entity_infra (
    entity_infra_sno bigint DEFAULT nextval('masters.entity_infra_entity_infra_sno_seq'::regclass) NOT NULL,
    qbox_entity_sno bigint NOT NULL,
    infra_sno bigint NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.entity_infra OWNER TO postgres;

--
-- Name: entity_infra_property_entity_infra_property_sno_seq; Type: SEQUENCE; Schema: masters; Owner: qbox_admin
--

CREATE SEQUENCE masters.entity_infra_property_entity_infra_property_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE masters.entity_infra_property_entity_infra_property_sno_seq OWNER TO qbox_admin;

--
-- Name: entity_infra_property; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.entity_infra_property (
    entity_infra_property_sno bigint DEFAULT nextval('masters.entity_infra_property_entity_infra_property_sno_seq'::regclass) NOT NULL,
    entity_infra_sno bigint NOT NULL,
    infra_property_sno smallint NOT NULL,
    value text NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.entity_infra_property OWNER TO postgres;

--
-- Name: food_sku; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.food_sku (
    food_sku_sno bigint NOT NULL,
    name text NOT NULL,
    sku_code text NOT NULL,
    restaurant_brand_cd character varying(10),
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.food_sku OWNER TO postgres;

--
-- Name: food_sku_food_sku_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.food_sku_food_sku_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.food_sku_food_sku_sno_seq OWNER TO postgres;

--
-- Name: food_sku_food_sku_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.food_sku_food_sku_sno_seq OWNED BY masters.food_sku.food_sku_sno;


--
-- Name: infra; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.infra (
    infra_sno smallint NOT NULL,
    name text NOT NULL,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.infra OWNER TO postgres;

--
-- Name: infra_infra_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.infra_infra_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.infra_infra_sno_seq OWNER TO postgres;

--
-- Name: infra_infra_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.infra_infra_sno_seq OWNED BY masters.infra.infra_sno;


--
-- Name: infra_property_infra_property_sno_seq; Type: SEQUENCE; Schema: masters; Owner: qbox_admin
--

CREATE SEQUENCE masters.infra_property_infra_property_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 32767
    CACHE 1;


ALTER TABLE masters.infra_property_infra_property_sno_seq OWNER TO qbox_admin;

--
-- Name: infra_property; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.infra_property (
    infra_property_sno smallint DEFAULT nextval('masters.infra_property_infra_property_sno_seq'::regclass) NOT NULL,
    infra_sno smallint NOT NULL,
    name text NOT NULL,
    data_type_cd smallint NOT NULL,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.infra_property OWNER TO postgres;

--
-- Name: menu_permission; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.menu_permission (
    menu_permission_sno smallint NOT NULL,
    app_menu_sno smallint NOT NULL,
    app_permission_sno smallint NOT NULL,
    status boolean DEFAULT false,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.menu_permission OWNER TO postgres;

--
-- Name: menu_function_menu_function_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.menu_function_menu_function_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.menu_function_menu_function_sno_seq OWNER TO postgres;

--
-- Name: menu_function_menu_function_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.menu_function_menu_function_sno_seq OWNED BY masters.menu_permission.menu_permission_sno;


--
-- Name: otp; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.otp (
    otp_sno bigint NOT NULL,
    app_user_sno bigint,
    sms_otp character varying(6),
    service_otp text,
    push_otp text,
    device_id text,
    otp_expire_time_cd smallint,
    otp_expire_time timestamp without time zone,
    otp_status boolean,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.otp OWNER TO postgres;

--
-- Name: otp_otp_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.otp_otp_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.otp_otp_sno_seq OWNER TO postgres;

--
-- Name: otp_otp_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.otp_otp_sno_seq OWNED BY masters.otp.otp_sno;


--
-- Name: partner_food_sku; Type: TABLE; Schema: masters; Owner: qbox_admin
--

CREATE TABLE masters.partner_food_sku (
    partner_food_sku_sno smallint NOT NULL,
    delivery_partner_sno smallint NOT NULL,
    food_sku_sno smallint NOT NULL,
    partner_food_code text NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.partner_food_sku OWNER TO qbox_admin;

--
-- Name: partner_food_sku_partner_food_sku_sno_seq; Type: SEQUENCE; Schema: masters; Owner: qbox_admin
--

CREATE SEQUENCE masters.partner_food_sku_partner_food_sku_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.partner_food_sku_partner_food_sku_sno_seq OWNER TO qbox_admin;

--
-- Name: partner_food_sku_partner_food_sku_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: qbox_admin
--

ALTER SEQUENCE masters.partner_food_sku_partner_food_sku_sno_seq OWNED BY masters.partner_food_sku.partner_food_sku_sno;


--
-- Name: purchase_order; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.purchase_order (
    purchase_order_sno bigint NOT NULL,
    qbox_entity_sno bigint NOT NULL,
    restaurant_sno bigint NOT NULL,
    delivery_partner_sno smallint,
    order_status_cd smallint NOT NULL,
    ordered_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ordered_by bigint NOT NULL,
    partner_purchase_order_id text NOT NULL,
    meal_time_cd smallint DEFAULT 1,
    description text,
    active_flag boolean DEFAULT true,
    etl_job_sno integer
);


ALTER TABLE masters.purchase_order OWNER TO postgres;

--
-- Name: purchase_order_dtl_purchase_order_dtl_sno_seq; Type: SEQUENCE; Schema: masters; Owner: qbox_admin
--

CREATE SEQUENCE masters.purchase_order_dtl_purchase_order_dtl_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.purchase_order_dtl_purchase_order_dtl_sno_seq OWNER TO qbox_admin;

--
-- Name: purchase_order_dtl; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.purchase_order_dtl (
    purchase_order_dtl_sno bigint DEFAULT nextval('masters.purchase_order_dtl_purchase_order_dtl_sno_seq'::regclass) NOT NULL,
    purchase_order_sno bigint NOT NULL,
    restaurant_food_sku_sno bigint NOT NULL,
    order_quantity smallint NOT NULL,
    sku_price numeric NOT NULL,
    partner_food_code text,
    accepted_quantity smallint,
    description text,
    active_flag boolean DEFAULT true,
    qbox_entity_sno integer
);


ALTER TABLE masters.purchase_order_dtl OWNER TO postgres;

--
-- Name: purchase_order_purchase_order_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.purchase_order_purchase_order_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.purchase_order_purchase_order_sno_seq OWNER TO postgres;

--
-- Name: purchase_order_purchase_order_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.purchase_order_purchase_order_sno_seq OWNED BY masters.purchase_order.purchase_order_sno;


--
-- Name: qbox_entity; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.qbox_entity (
    qbox_entity_sno bigint NOT NULL,
    name text NOT NULL,
    address_sno bigint,
    area_sno bigint NOT NULL,
    qbox_entity_status_cd smallint NOT NULL,
    created_on timestamp without time zone,
    entity_code character varying(6),
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.qbox_entity OWNER TO postgres;

--
-- Name: qbox_entity_delivery_partner; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.qbox_entity_delivery_partner (
    qbox_entity_delivery_partner_sno bigint NOT NULL,
    delivery_type_cd smallint NOT NULL,
    qbox_entity_sno bigint NOT NULL,
    delivery_partner_sno smallint NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.qbox_entity_delivery_partner OWNER TO postgres;

--
-- Name: qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq OWNER TO postgres;

--
-- Name: qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq OWNED BY masters.qbox_entity_delivery_partner.qbox_entity_delivery_partner_sno;


--
-- Name: qbox_entity_qbox_entity_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.qbox_entity_qbox_entity_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.qbox_entity_qbox_entity_sno_seq OWNER TO postgres;

--
-- Name: qbox_entity_qbox_entity_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.qbox_entity_qbox_entity_sno_seq OWNED BY masters.qbox_entity.qbox_entity_sno;


--
-- Name: restaurant; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.restaurant (
    restaurant_sno bigint NOT NULL,
    name text NOT NULL,
    address_sno bigint,
    area_sno bigint NOT NULL,
    restaurant_status_cd smallint NOT NULL,
    city_code character varying(5),
    restaurant_brand_cd character varying(6),
    active_flag boolean DEFAULT true,
    restaurant_code character varying(15)
);


ALTER TABLE masters.restaurant OWNER TO postgres;

--
-- Name: restaurant_food_sku; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.restaurant_food_sku (
    restaurant_food_sku_sno bigint NOT NULL,
    restaurant_sno bigint NOT NULL,
    food_sku_sno bigint NOT NULL,
    status boolean DEFAULT true,
    description text,
    sku_code text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.restaurant_food_sku OWNER TO postgres;

--
-- Name: restaurant_food_sku_restaurant_food_sku_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.restaurant_food_sku_restaurant_food_sku_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.restaurant_food_sku_restaurant_food_sku_sno_seq OWNER TO postgres;

--
-- Name: restaurant_food_sku_restaurant_food_sku_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.restaurant_food_sku_restaurant_food_sku_sno_seq OWNED BY masters.restaurant_food_sku.restaurant_food_sku_sno;


--
-- Name: restaurant_restaurant_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.restaurant_restaurant_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.restaurant_restaurant_sno_seq OWNER TO postgres;

--
-- Name: restaurant_restaurant_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.restaurant_restaurant_sno_seq OWNED BY masters.restaurant.restaurant_sno;


--
-- Name: role_permission; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.role_permission (
    role_permission_sno bigint NOT NULL,
    app_role_sno smallint NOT NULL,
    app_permission_sno integer NOT NULL,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.role_permission OWNER TO postgres;

--
-- Name: role_function_role_function_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.role_function_role_function_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.role_function_role_function_sno_seq OWNER TO postgres;

--
-- Name: role_function_role_function_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.role_function_role_function_sno_seq OWNED BY masters.role_permission.role_permission_sno;


--
-- Name: role_menu; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.role_menu (
    role_menu_sno smallint NOT NULL,
    app_menu_sno smallint NOT NULL,
    app_role_sno smallint NOT NULL,
    status boolean DEFAULT false,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.role_menu OWNER TO postgres;

--
-- Name: role_menu_role_menu_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.role_menu_role_menu_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.role_menu_role_menu_sno_seq OWNER TO postgres;

--
-- Name: role_menu_role_menu_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.role_menu_role_menu_sno_seq OWNED BY masters.role_menu.role_menu_sno;


--
-- Name: sales_order_sales_order_sno_seq; Type: SEQUENCE; Schema: masters; Owner: qbox_admin
--

CREATE SEQUENCE masters.sales_order_sales_order_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.sales_order_sales_order_sno_seq OWNER TO qbox_admin;

--
-- Name: sales_order; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.sales_order (
    sales_order_sno bigint DEFAULT nextval('masters.sales_order_sales_order_sno_seq'::regclass) NOT NULL,
    partner_sales_order_id text NOT NULL,
    qbox_entity_sno bigint NOT NULL,
    delivery_partner_sno bigint NOT NULL,
    sales_order_status_cd smallint NOT NULL,
    ordered_time timestamp without time zone,
    ordered_by bigint NOT NULL,
    partner_customer_ref text,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.sales_order OWNER TO postgres;

--
-- Name: sales_order_dtl_sales_order_dtl_sno_seq; Type: SEQUENCE; Schema: masters; Owner: qbox_admin
--

CREATE SEQUENCE masters.sales_order_dtl_sales_order_dtl_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.sales_order_dtl_sales_order_dtl_sno_seq OWNER TO qbox_admin;

--
-- Name: sales_order_dtl; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.sales_order_dtl (
    sales_order_dtl_sno bigint DEFAULT nextval('masters.sales_order_dtl_sales_order_dtl_sno_seq'::regclass) NOT NULL,
    sales_order_sno bigint NOT NULL,
    partner_food_code text,
    restaurant_food_sku_sno bigint NOT NULL,
    order_quantity integer NOT NULL,
    sku_price numeric NOT NULL,
    delivered_quantity smallint DEFAULT 0,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.sales_order_dtl OWNER TO postgres;

--
-- Name: signin_info; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.signin_info (
    signin_info_sno bigint NOT NULL,
    app_user_sno bigint,
    push_token text,
    device_type_cd smallint,
    device_id text,
    login_on timestamp without time zone,
    logout_on timestamp without time zone,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.signin_info OWNER TO postgres;

--
-- Name: signin_info_signin_info_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.signin_info_signin_info_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.signin_info_signin_info_sno_seq OWNER TO postgres;

--
-- Name: signin_info_signin_info_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.signin_info_signin_info_sno_seq OWNED BY masters.signin_info.signin_info_sno;


--
-- Name: sku_inventory; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.sku_inventory (
    sku_inventory_sno bigint NOT NULL,
    purchase_order_dtl_sno bigint,
    unique_code text NOT NULL,
    sales_order_dtl_sno bigint,
    wf_stage_cd smallint,
    description text,
    active_flag boolean DEFAULT true,
    transaction_date date,
    restaurant_food_sku_sno bigint,
    qbox_entity_sno integer
);


ALTER TABLE masters.sku_inventory OWNER TO postgres;

--
-- Name: sku_inventory_sku_inventory_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.sku_inventory_sku_inventory_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.sku_inventory_sku_inventory_sno_seq OWNER TO postgres;

--
-- Name: sku_inventory_sku_inventory_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.sku_inventory_sku_inventory_sno_seq OWNED BY masters.sku_inventory.sku_inventory_sno;


--
-- Name: sku_trace_wf; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.sku_trace_wf (
    sku_trace_wf_sno bigint NOT NULL,
    sku_inventory_sno bigint NOT NULL,
    wf_stage_cd smallint,
    action_time timestamp without time zone,
    action_by bigint,
    reference text,
    description text,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.sku_trace_wf OWNER TO postgres;

--
-- Name: sku_trace_wf_sku_trace_wf_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.sku_trace_wf_sku_trace_wf_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.sku_trace_wf_sku_trace_wf_sno_seq OWNER TO postgres;

--
-- Name: sku_trace_wf_sku_trace_wf_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.sku_trace_wf_sku_trace_wf_sno_seq OWNED BY masters.sku_trace_wf.sku_trace_wf_sno;


--
-- Name: state; Type: TABLE; Schema: masters; Owner: postgres
--

CREATE TABLE masters.state (
    state_sno smallint NOT NULL,
    country_sno smallint NOT NULL,
    state_code character varying(6),
    name text NOT NULL,
    active_flag boolean DEFAULT true
);


ALTER TABLE masters.state OWNER TO postgres;

--
-- Name: state_state_sno_seq; Type: SEQUENCE; Schema: masters; Owner: postgres
--

CREATE SEQUENCE masters.state_state_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE masters.state_state_sno_seq OWNER TO postgres;

--
-- Name: state_state_sno_seq; Type: SEQUENCE OWNED BY; Schema: masters; Owner: postgres
--

ALTER SEQUENCE masters.state_state_sno_seq OWNED BY masters.state.state_sno;


--
-- Name: etl_job; Type: TABLE; Schema: partner_order; Owner: postgres
--

CREATE TABLE partner_order.etl_job (
    etl_job_sno integer NOT NULL,
    order_etl_hdr_sno integer NOT NULL,
    file_name character varying(255),
    file_load_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    etl_start_timestamp timestamp without time zone,
    etl_end_timestamp timestamp without time zone,
    status character varying(50) DEFAULT 'Pending'::character varying,
    error_message text,
    record_count integer,
    processed_by character varying(255),
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE partner_order.etl_job OWNER TO postgres;

--
-- Name: etl_job_etl_job_sno_seq; Type: SEQUENCE; Schema: partner_order; Owner: postgres
--

CREATE SEQUENCE partner_order.etl_job_etl_job_sno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE partner_order.etl_job_etl_job_sno_seq OWNER TO postgres;

--
-- Name: etl_job_etl_job_sno_seq; Type: SEQUENCE OWNED BY; Schema: partner_order; Owner: postgres
--

ALTER SEQUENCE partner_order.etl_job_etl_job_sno_seq OWNED BY partner_order.etl_job.etl_job_sno;


--
-- Name: etl_record; Type: TABLE; Schema: partner_order; Owner: postgres
--

CREATE TABLE partner_order.etl_record (
    etl_record_sno integer NOT NULL,
    etl_job_sno integer,
    staging_table_name character varying(255),
    row_id integer,
    processing_status character varying(50) DEFAULT 'Pending'::character varying,
    processing_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    error_message text
);


ALTER TABLE partner_order.etl_record OWNER TO postgres;

--
-- Name: etl_record_etl_record_sno_seq; Type: SEQUENCE; Schema: partner_order; Owner: postgres
--

CREATE SEQUENCE partner_order.etl_record_etl_record_sno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE partner_order.etl_record_etl_record_sno_seq OWNER TO postgres;

--
-- Name: etl_record_etl_record_sno_seq; Type: SEQUENCE OWNED BY; Schema: partner_order; Owner: postgres
--

ALTER SEQUENCE partner_order.etl_record_etl_record_sno_seq OWNED BY partner_order.etl_record.etl_record_sno;


--
-- Name: etl_table_column; Type: TABLE; Schema: partner_order; Owner: postgres
--

CREATE TABLE partner_order.etl_table_column (
    etl_table_column_sno smallint NOT NULL,
    order_etl_hdr_sno smallint NOT NULL,
    source_column character varying(255),
    staging_column character varying(255),
    data_type character varying(50),
    is_required boolean DEFAULT true,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE partner_order.etl_table_column OWNER TO postgres;

--
-- Name: etl_table_column_etl_table_column_sno_seq; Type: SEQUENCE; Schema: partner_order; Owner: postgres
--

CREATE SEQUENCE partner_order.etl_table_column_etl_table_column_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE partner_order.etl_table_column_etl_table_column_sno_seq OWNER TO postgres;

--
-- Name: etl_table_column_etl_table_column_sno_seq; Type: SEQUENCE OWNED BY; Schema: partner_order; Owner: postgres
--

ALTER SEQUENCE partner_order.etl_table_column_etl_table_column_sno_seq OWNED BY partner_order.etl_table_column.etl_table_column_sno;


--
-- Name: order_etl_hdr; Type: TABLE; Schema: partner_order; Owner: postgres
--

CREATE TABLE partner_order.order_etl_hdr (
    order_etl_hdr_sno smallint NOT NULL,
    delivery_partner_sno smallint NOT NULL,
    partner_code character varying NOT NULL,
    staging_table_name character varying,
    is_active boolean,
    file_name_prefix character varying(7)
);


ALTER TABLE partner_order.order_etl_hdr OWNER TO postgres;

--
-- Name: order_etl_hdr_order_etl_hdr_sno_seq; Type: SEQUENCE; Schema: partner_order; Owner: postgres
--

CREATE SEQUENCE partner_order.order_etl_hdr_order_etl_hdr_sno_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE partner_order.order_etl_hdr_order_etl_hdr_sno_seq OWNER TO postgres;

--
-- Name: order_etl_hdr_order_etl_hdr_sno_seq; Type: SEQUENCE OWNED BY; Schema: partner_order; Owner: postgres
--

ALTER SEQUENCE partner_order.order_etl_hdr_order_etl_hdr_sno_seq OWNED BY partner_order.order_etl_hdr.order_etl_hdr_sno;


--
-- Name: swiggy_staging; Type: TABLE; Schema: partner_order; Owner: postgres
--

CREATE TABLE partner_order.swiggy_staging (
    swiggy_staging_sno integer NOT NULL,
    qbox_remote_location character varying,
    restaurant_code character varying,
    partner_code character varying,
    order_status_cd integer,
    order_by integer,
    partner_purchase_order_id character varying,
    sku_unique_code character varying,
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    etl_job_sno integer NOT NULL,
    partner_food_code character varying
);


ALTER TABLE partner_order.swiggy_staging OWNER TO postgres;

--
-- Name: swiggy_staging_swiggy_staging_sno_seq; Type: SEQUENCE; Schema: partner_order; Owner: postgres
--

CREATE SEQUENCE partner_order.swiggy_staging_swiggy_staging_sno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE partner_order.swiggy_staging_swiggy_staging_sno_seq OWNER TO postgres;

--
-- Name: swiggy_staging_swiggy_staging_sno_seq; Type: SEQUENCE OWNED BY; Schema: partner_order; Owner: postgres
--

ALTER SEQUENCE partner_order.swiggy_staging_swiggy_staging_sno_seq OWNED BY partner_order.swiggy_staging.swiggy_staging_sno;


--
-- Name: app_menu app_menu_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_menu ALTER COLUMN app_menu_sno SET DEFAULT nextval('auth.app_menu_app_menu_sno_seq'::regclass);


--
-- Name: app_permission app_permission_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_permission ALTER COLUMN app_permission_sno SET DEFAULT nextval('auth.app_function_app_function_sno_seq'::regclass);


--
-- Name: app_role app_role_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_role ALTER COLUMN app_role_sno SET DEFAULT nextval('auth.app_role_app_role_sno_seq'::regclass);


--
-- Name: app_user app_user_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_user ALTER COLUMN app_user_sno SET DEFAULT nextval('auth.app_user_app_user_sno_seq'::regclass);


--
-- Name: app_user_role app_user_role_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_user_role ALTER COLUMN app_user_role_sno SET DEFAULT nextval('auth.app_user_role_app_user_role_sno_seq'::regclass);


--
-- Name: codes_dtl codes_dtl_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.codes_dtl ALTER COLUMN codes_dtl_sno SET DEFAULT nextval('auth.codes_dtl_codes_dtl_sno_seq'::regclass);


--
-- Name: codes_hdr codes_hdr_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.codes_hdr ALTER COLUMN codes_hdr_sno SET DEFAULT nextval('auth.codes_hdr_codes_hdr_sno_seq'::regclass);


--
-- Name: menu_permission menu_permission_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.menu_permission ALTER COLUMN menu_permission_sno SET DEFAULT nextval('auth.menu_function_menu_function_sno_seq'::regclass);


--
-- Name: otp otp_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.otp ALTER COLUMN otp_sno SET DEFAULT nextval('auth.otp_otp_sno_seq'::regclass);


--
-- Name: role_menu role_menu_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.role_menu ALTER COLUMN role_menu_sno SET DEFAULT nextval('auth.role_menu_role_menu_sno_seq'::regclass);


--
-- Name: role_permission role_permission_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.role_permission ALTER COLUMN role_permission_sno SET DEFAULT nextval('auth.role_function_role_function_sno_seq'::regclass);


--
-- Name: signin_info signin_info_sno; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.signin_info ALTER COLUMN signin_info_sno SET DEFAULT nextval('auth.signin_info_signin_info_sno_seq'::regclass);


--
-- Name: address address_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.address ALTER COLUMN address_sno SET DEFAULT nextval('masters.address_address_sno_seq'::regclass);


--
-- Name: app_menu app_menu_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_menu ALTER COLUMN app_menu_sno SET DEFAULT nextval('masters.app_menu_app_menu_sno_seq'::regclass);


--
-- Name: app_permission app_permission_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_permission ALTER COLUMN app_permission_sno SET DEFAULT nextval('masters.app_function_app_function_sno_seq'::regclass);


--
-- Name: app_role app_role_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_role ALTER COLUMN app_role_sno SET DEFAULT nextval('masters.app_role_app_role_sno_seq'::regclass);


--
-- Name: app_user app_user_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_user ALTER COLUMN app_user_sno SET DEFAULT nextval('masters.app_user_app_user_sno_seq'::regclass);


--
-- Name: app_user_role app_user_role_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_user_role ALTER COLUMN app_user_role_sno SET DEFAULT nextval('masters.app_user_role_app_user_role_sno_seq'::regclass);


--
-- Name: area area_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.area ALTER COLUMN area_sno SET DEFAULT nextval('masters.area_area_sno_seq'::regclass);


--
-- Name: box_cell box_cell_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell ALTER COLUMN box_cell_sno SET DEFAULT nextval('masters.box_cell_box_cell_sno_seq'::regclass);


--
-- Name: box_cell_food box_cell_food_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell_food ALTER COLUMN box_cell_food_sno SET DEFAULT nextval('masters.box_cell_food_box_cell_food_sno_seq'::regclass);


--
-- Name: city city_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.city ALTER COLUMN city_sno SET DEFAULT nextval('masters.city_city_sno_seq'::regclass);


--
-- Name: codes_dtl codes_dtl_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.codes_dtl ALTER COLUMN codes_dtl_sno SET DEFAULT nextval('masters.codes_dtl_codes_dtl_sno_seq'::regclass);


--
-- Name: codes_hdr codes_hdr_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.codes_hdr ALTER COLUMN codes_hdr_sno SET DEFAULT nextval('masters.codes_hdr_codes_hdr_sno_seq'::regclass);


--
-- Name: country country_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.country ALTER COLUMN country_sno SET DEFAULT nextval('masters.country_country_sno_seq'::regclass);


--
-- Name: delivery_partner delivery_partner_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.delivery_partner ALTER COLUMN delivery_partner_sno SET DEFAULT nextval('masters.delivery_partner_delivery_partner_sno_seq'::regclass);


--
-- Name: food_sku food_sku_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.food_sku ALTER COLUMN food_sku_sno SET DEFAULT nextval('masters.food_sku_food_sku_sno_seq'::regclass);


--
-- Name: infra infra_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.infra ALTER COLUMN infra_sno SET DEFAULT nextval('masters.infra_infra_sno_seq'::regclass);


--
-- Name: menu_permission menu_permission_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.menu_permission ALTER COLUMN menu_permission_sno SET DEFAULT nextval('masters.menu_function_menu_function_sno_seq'::regclass);


--
-- Name: otp otp_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.otp ALTER COLUMN otp_sno SET DEFAULT nextval('masters.otp_otp_sno_seq'::regclass);


--
-- Name: partner_food_sku partner_food_sku_sno; Type: DEFAULT; Schema: masters; Owner: qbox_admin
--

ALTER TABLE ONLY masters.partner_food_sku ALTER COLUMN partner_food_sku_sno SET DEFAULT nextval('masters.partner_food_sku_partner_food_sku_sno_seq'::regclass);


--
-- Name: purchase_order purchase_order_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order ALTER COLUMN purchase_order_sno SET DEFAULT nextval('masters.purchase_order_purchase_order_sno_seq'::regclass);


--
-- Name: qbox_entity qbox_entity_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity ALTER COLUMN qbox_entity_sno SET DEFAULT nextval('masters.qbox_entity_qbox_entity_sno_seq'::regclass);


--
-- Name: qbox_entity_delivery_partner qbox_entity_delivery_partner_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity_delivery_partner ALTER COLUMN qbox_entity_delivery_partner_sno SET DEFAULT nextval('masters.qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq'::regclass);


--
-- Name: restaurant restaurant_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant ALTER COLUMN restaurant_sno SET DEFAULT nextval('masters.restaurant_restaurant_sno_seq'::regclass);


--
-- Name: restaurant_food_sku restaurant_food_sku_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant_food_sku ALTER COLUMN restaurant_food_sku_sno SET DEFAULT nextval('masters.restaurant_food_sku_restaurant_food_sku_sno_seq'::regclass);


--
-- Name: role_menu role_menu_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.role_menu ALTER COLUMN role_menu_sno SET DEFAULT nextval('masters.role_menu_role_menu_sno_seq'::regclass);


--
-- Name: role_permission role_permission_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.role_permission ALTER COLUMN role_permission_sno SET DEFAULT nextval('masters.role_function_role_function_sno_seq'::regclass);


--
-- Name: signin_info signin_info_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.signin_info ALTER COLUMN signin_info_sno SET DEFAULT nextval('masters.signin_info_signin_info_sno_seq'::regclass);


--
-- Name: sku_inventory sku_inventory_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_inventory ALTER COLUMN sku_inventory_sno SET DEFAULT nextval('masters.sku_inventory_sku_inventory_sno_seq'::regclass);


--
-- Name: sku_trace_wf sku_trace_wf_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_trace_wf ALTER COLUMN sku_trace_wf_sno SET DEFAULT nextval('masters.sku_trace_wf_sku_trace_wf_sno_seq'::regclass);


--
-- Name: state state_sno; Type: DEFAULT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.state ALTER COLUMN state_sno SET DEFAULT nextval('masters.state_state_sno_seq'::regclass);


--
-- Name: etl_job etl_job_sno; Type: DEFAULT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_job ALTER COLUMN etl_job_sno SET DEFAULT nextval('partner_order.etl_job_etl_job_sno_seq'::regclass);


--
-- Name: etl_record etl_record_sno; Type: DEFAULT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_record ALTER COLUMN etl_record_sno SET DEFAULT nextval('partner_order.etl_record_etl_record_sno_seq'::regclass);


--
-- Name: etl_table_column etl_table_column_sno; Type: DEFAULT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_table_column ALTER COLUMN etl_table_column_sno SET DEFAULT nextval('partner_order.etl_table_column_etl_table_column_sno_seq'::regclass);


--
-- Name: order_etl_hdr order_etl_hdr_sno; Type: DEFAULT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.order_etl_hdr ALTER COLUMN order_etl_hdr_sno SET DEFAULT nextval('partner_order.order_etl_hdr_order_etl_hdr_sno_seq'::regclass);


--
-- Name: swiggy_staging swiggy_staging_sno; Type: DEFAULT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.swiggy_staging ALTER COLUMN swiggy_staging_sno SET DEFAULT nextval('partner_order.swiggy_staging_swiggy_staging_sno_seq'::regclass);


--
-- Data for Name: app_menu; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.app_menu (app_menu_sno, name, parent_menu_sno, href, title, status, active_flag) FROM stdin;



--
-- Data for Name: app_permission; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.app_permission (app_permission_sno, name, created_at, active_flag) FROM stdin;
1	Create Super Admin	2024-04-23 18:49:00.889164	t
2	Edit Super Admin	2024-04-23 18:49:10.643965	t
3	View Super Admin	2024-04-23 18:49:21.863299	t
4	Delete Super Admin	2024-04-23 18:49:36.485987	t



--
-- Data for Name: app_role; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.app_role (app_role_sno, name, status, active_flag) FROM stdin;



--
-- Data for Name: app_user; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.app_user (app_user_sno, user_id, password, status, name, active_flag) FROM stdin;
1	vengat	vengat	t	vengat	t



--
-- Data for Name: app_user_role; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.app_user_role (app_user_role_sno, app_user_sno, app_role_sno, description, active_flag) FROM stdin;



--
-- Data for Name: codes_dtl; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.codes_dtl (codes_dtl_sno, codes_hdr_sno, description, seqno, filter_1, filter_2, active_flag) FROM stdin;



--
-- Data for Name: codes_hdr; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.codes_hdr (codes_hdr_sno, description, active_flag) FROM stdin;



--
-- Data for Name: menu_permission; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.menu_permission (menu_permission_sno, app_menu_sno, app_permission_sno, status, description, active_flag) FROM stdin;



--
-- Data for Name: otp; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.otp (otp_sno, app_user_sno, sms_otp, service_otp, push_otp, device_id, otp_expire_time_cd, otp_expire_time, otp_status, description, active_flag) FROM stdin;



--
-- Data for Name: role_menu; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.role_menu (role_menu_sno, app_menu_sno, app_role_sno, status, description, active_flag) FROM stdin;



--
-- Data for Name: role_permission; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.role_permission (role_permission_sno, app_role_sno, app_permission_sno, description, active_flag) FROM stdin;



--
-- Data for Name: signin_info; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.signin_info (signin_info_sno, app_user_sno, push_token, device_type_cd, device_id, login_on, logout_on, description, active_flag) FROM stdin;



--
-- Data for Name: address; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.address (address_sno, line1, line2, area_sno, city_sno, geo_loc_code, description, active_flag) FROM stdin;
4	Venkateshara PG		2	1	DSGH	\N	t
5	OMR Clinic		1	1	DSGH	\N	t
1	Venkateshara PG		2	1	SDFG	\N	t
8	partner_status_cd	\N	2	1	DSGH	\N	t
9	asd	asdas	10	1	123123		\N
10	OMR	Clinic	10	1	123123		\N
11	asd	asd	17	1	23423		t
13	asd	asd	14	1	23456	qweq	t
14	asda		2	1	234234		t
15	Meenambakam		23	1	12344	20mis delivery from meenambakam	t
16	dsf		9	1	12123		t
17	Shollinganallour		32	1	605019	10mins shollinganallour remote location	t
18	shollinganallour		32	1	605011	20mins shollinganallour deivery	t



--
-- Data for Name: app_menu; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.app_menu (app_menu_sno, name, parent_menu_sno, href, title, status, active_flag) FROM stdin;



--
-- Data for Name: app_permission; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.app_permission (app_permission_sno, name, created_at, active_flag) FROM stdin;
1	Create Super Admin	2024-04-23 18:49:00.889164	t
2	Edit Super Admin	2024-04-23 18:49:10.643965	t
3	View Super Admin	2024-04-23 18:49:21.863299	t
4	Delete Super Admin	2024-04-23 18:49:36.485987	t



--
-- Data for Name: app_role; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.app_role (app_role_sno, name, status, active_flag) FROM stdin;



--
-- Data for Name: app_user; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.app_user (app_user_sno, user_id, password, status, name, active_flag) FROM stdin;
1	vengat	vengat	t	vengat	t



--
-- Data for Name: app_user_role; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.app_user_role (app_user_role_sno, app_user_sno, app_role_sno, description, active_flag) FROM stdin;



--
-- Data for Name: area; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.area (area_sno, country_sno, state_sno, city_sno, name, pincode, active_flag) FROM stdin;
2	2	1	1	Thuraipakkam	600096	t
9	1	2	1	pondy	605011	t
10	1	1	1	Pondicherry	600012	t
14	1	1	1	Ambathur	605019	t
1	1	1	3	Adyar	600012	f
21	1	1	1	Pondicherry	605011	t
20	1	1	1	Madurai	605012	t
32	1	1	1	Shollinganallour	605019	t
33	1	1	3	rajiyapalaiyam	600094	t



--
-- Data for Name: box_cell; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.box_cell (box_cell_sno, qbox_entity_sno, entity_infra_sno, row_no, column_no, box_cell_status_cd, description, active_flag) FROM stdin;
135	20	45	1	1	18	Row-1- Column-1	t
136	20	45	1	2	18	Row-1- Column-2	t
137	20	45	1	3	18	Row-1- Column-3	t
138	20	45	1	4	18	Row-1- Column-4	t
139	20	45	1	5	18	Row-1- Column-5	t
140	20	45	2	1	18	Row-2- Column-1	t
141	20	45	2	2	18	Row-2- Column-2	t
142	20	45	2	3	18	Row-2- Column-3	t
143	20	45	2	4	18	Row-2- Column-4	t
144	20	45	2	5	18	Row-2- Column-5	t
145	20	45	3	1	18	Row-3- Column-1	t
146	20	45	3	2	18	Row-3- Column-2	t
147	20	45	3	3	18	Row-3- Column-3	t
148	20	45	3	4	18	Row-3- Column-4	t
149	20	45	3	5	18	Row-3- Column-5	t
150	20	45	4	1	18	Row-4- Column-1	t
151	20	45	4	2	18	Row-4- Column-2	t
152	20	45	4	3	18	Row-4- Column-3	t
153	20	45	4	4	18	Row-4- Column-4	t
154	20	45	4	5	18	Row-4- Column-5	t
155	20	45	5	1	18	Row-5- Column-1	t
156	20	45	5	2	18	Row-5- Column-2	t
157	20	45	5	3	18	Row-5- Column-3	t
158	20	45	5	4	18	Row-5- Column-4	t
159	20	45	5	5	18	Row-5- Column-5	t
160	21	46	1	1	18	Row-1- Column-1	t



--
-- Data for Name: box_cell_food; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.box_cell_food (box_cell_food_sno, box_cell_sno, sku_inventory_sno, entry_time, qbox_entity_sno, active, description, active_flag) FROM stdin;
56	136	739	2025-01-04 10:41:28.977874	20	t	Row-1- Column-2	t
57	137	740	2025-01-04 10:48:15.249052	20	t	Row-1- Column-3	t



--
-- Data for Name: box_cell_food_hist; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.box_cell_food_hist (box_cell_food_sno, box_cell_sno, sku_inventory_sno, entry_time, qbox_entity_sno, description, active_flag, partner_sales_order_id) FROM stdin;
54	1	498	2024-12-20 16:44:36.650566	3	\N	t	\N
55	135	738	2025-01-04 10:38:36.339973	20	DLBL047	t	DLBL047



--
-- Data for Name: city; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.city (city_sno, country_sno, state_sno, name, active_flag) FROM stdin;
1	1	1	Chennai	t
3	1	1	Madurai	t



--
-- Data for Name: codes_dtl; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.codes_dtl (codes_dtl_sno, codes_hdr_sno, description, seqno, filter_1, filter_2, active_flag) FROM stdin;
4	1	Active	1	\N	\N	t
5	1	Inactive	2	\N	\N	t
6	2	Inward sku ordered	1	\N	\N	t
8	2	Inward sku verified-rejected	3	\N	\N	t
9	2	Inward sku verified-accepted	4	\N	\N	t
11	2	Sku loaded in Q-box	6	\N	\N	t
10	2	Sku loaded in Hot box	5	\N	\N	t
12	2	Sku retured to Hot box	7	\N	\N	t
15	3	Partially Delivered	2	\N	\N	t
16	3	Completely Delivered	3	\N	\N	t
19	4	Filled	2	\N	\N	t
17	4	Not working	1	\N	\N	t
18	4	Empty	3	\N	\N	t
21	1	Sample	10	\N	\N	t
22	11	Active	1	\N	\N	t
23	11	InActive	2	\N	\N	t
24	2	sample	11	\N	\N	t
26	11	Open	34			t
25	2	Close	12	\N	\N	t
27	6	Open	4	ssss	sss	t
30	16	Active	1			t
31	16	InActive	2			t
7	11	Inward sku delivered	2	\N	\N	f
29	11	Close	2			f
20	12	Sku Picked by Delivery Partner	8	sqqssq	qsq	f
13	11	Outward Delivery Picked up	8	\N	\N	f
28	20	Open	1			f
14	3	Ordered	1	\N	\N	t



--
-- Data for Name: codes_hdr; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.codes_hdr (codes_hdr_sno, description, active_flag) FROM stdin;
3	sales_order_status_cd	t
16	qbox_entity_status_cd	t
11	partner_status_cd	t
12	resturant_cd	t



--
-- Data for Name: country; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.country (country_sno, name, iso2, phone_code, numeric_code, currency_code, active_flag) FROM stdin;
1	INDIA	IN	92	12	INR	t
2	USA	US	93	12	USA	t



--
-- Data for Name: delivery_partner; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.delivery_partner (delivery_partner_sno, partner_code, name, partner_status_cd, active_flag) FROM stdin;
14	SWG	Swiggy	22	t
15	ZOM	Zomato	22	t



--
-- Data for Name: entity_infra; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.entity_infra (entity_infra_sno, qbox_entity_sno, infra_sno, description, active_flag) FROM stdin;
44	20	1	\N	t
45	20	2	\N	t
46	21	1	\N	t
47	21	2	\N	t



--
-- Data for Name: entity_infra_property; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.entity_infra_property (entity_infra_property_sno, entity_infra_sno, infra_property_sno, value, description, active_flag) FROM stdin;
34	44	4	100	\N	t
35	45	5	5	\N	t
36	45	6	5	\N	t
37	46	4	100	\N	t
38	46	6	1	\N	t
39	46	7	1	\N	t
40	46	8	100	\N	t
41	46	5	1	\N	t



--
-- Data for Name: food_sku; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.food_sku (food_sku_sno, name, sku_code, restaurant_brand_cd, active_flag) FROM stdin;
3	Chicken Briyani	CHBR	STAR	t
4	White Rice	WRC	A2B	t
2	Sambar Rice	SMRC	A2B	t
1	South Indian Veg Meals	SIVM	A2B	f
6	Curd Rice	CURD	A2B	f



--
-- Data for Name: infra; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.infra (infra_sno, name, active_flag) FROM stdin;
1	Hot Box	t
2	Q-Box	t



--
-- Data for Name: infra_property; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.infra_property (infra_property_sno, infra_sno, name, data_type_cd, active_flag) FROM stdin;
4	1	Capacity	5	t
6	1	column	5	t
7	1	rowdata	5	f
8	1	Capacity	4	f
5	1	rowdata	5	t



--
-- Data for Name: menu_permission; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.menu_permission (menu_permission_sno, app_menu_sno, app_permission_sno, status, description, active_flag) FROM stdin;



--
-- Data for Name: otp; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.otp (otp_sno, app_user_sno, sms_otp, service_otp, push_otp, device_id, otp_expire_time_cd, otp_expire_time, otp_status, description, active_flag) FROM stdin;



--
-- Data for Name: partner_food_sku; Type: TABLE DATA; Schema: masters; Owner: qbox_admin
--

COPY masters.partner_food_sku (partner_food_sku_sno, delivery_partner_sno, food_sku_sno, partner_food_code, description, active_flag) FROM stdin;
8	14	4	SIVM	South indian Veg Meals	t
9	14	3	SMM2299	\N	f
10	14	4	SMM2299	\N	f



--
-- Data for Name: purchase_order; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.purchase_order (purchase_order_sno, qbox_entity_sno, restaurant_sno, delivery_partner_sno, order_status_cd, ordered_time, ordered_by, partner_purchase_order_id, meal_time_cd, description, active_flag, etl_job_sno) FROM stdin;
137	20	3	14	1	2025-01-04 11:49:14.255817	1	SWIGGY_673567	1		t	51
136	20	3	14	2	2025-01-04 13:25:26.030775	1	SWIGGY_67356	1		t	51
138	20	3	14	1	2025-01-05 13:17:44.255737	1	SWIGGY_323456	1		t	51
139	20	3	14	1	2025-01-05 13:29:54.248728	1	SWIGGY_423456	1		t	51



--
-- Data for Name: purchase_order_dtl; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.purchase_order_dtl (purchase_order_dtl_sno, purchase_order_sno, restaurant_food_sku_sno, order_quantity, sku_price, partner_food_code, accepted_quantity, description, active_flag, qbox_entity_sno) FROM stdin;
126	137	1	15	0.0	SIVM	0		t	20
125	136	1	15	0.0	SIVM	15		t	20
127	138	1	15	0.0	SIVM	0		t	20
128	139	1	15	0.0	SIVM	0		t	20



--
-- Data for Name: qbox_entity; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.qbox_entity (qbox_entity_sno, name, address_sno, area_sno, qbox_entity_status_cd, created_on, entity_code, active_flag) FROM stdin;
20	10 mins Shollinganallour	17	32	30	\N	QBXNGM	t
21	20mins sholinganallour	18	32	30	\N	20So	t



--
-- Data for Name: qbox_entity_delivery_partner; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.qbox_entity_delivery_partner (qbox_entity_delivery_partner_sno, delivery_type_cd, qbox_entity_sno, delivery_partner_sno, description, active_flag) FROM stdin;



--
-- Data for Name: restaurant; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.restaurant (restaurant_sno, name, address_sno, area_sno, restaurant_status_cd, city_code, restaurant_brand_cd, active_flag, restaurant_code) FROM stdin;
3	A2B Mount Road	1	1	1	MAA	A2B	t	a2bMntRd
4	Star Briyani Mount Road	1	1	1	MAA	STAR	t	1
5	Salem RR	1	1	1	SRR	SRR	t	2
6	Sangeetha1	1	1	1	MAA	SSSS	t	3
7	A2B Mount Road	1	2	20	MAA	A2BM	t	4
8	Star Briyani Mount Roklk	4	9	20	MAA	STR	f	5



--
-- Data for Name: restaurant_food_sku; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.restaurant_food_sku (restaurant_food_sku_sno, restaurant_sno, food_sku_sno, status, description, sku_code, active_flag) FROM stdin;
3	5	3	t	Star Chicken Briyani	CHBRYNI	\N
2	6	3	t	A2B Sambar Rice	SMBRICE	\N
1	3	4	t	A2B  South Indian Veg Meals	SIVM	f



--
-- Data for Name: role_menu; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.role_menu (role_menu_sno, app_menu_sno, app_role_sno, status, description, active_flag) FROM stdin;



--
-- Data for Name: role_permission; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.role_permission (role_permission_sno, app_role_sno, app_permission_sno, description, active_flag) FROM stdin;



--
-- Data for Name: sales_order; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.sales_order (sales_order_sno, partner_sales_order_id, qbox_entity_sno, delivery_partner_sno, sales_order_status_cd, ordered_time, ordered_by, partner_customer_ref, description, active_flag) FROM stdin;
38	DLBL047	20	14	1	2025-01-04 11:11:05.692076	1	\N	\N	t



--
-- Data for Name: sales_order_dtl; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.sales_order_dtl (sales_order_dtl_sno, sales_order_sno, partner_food_code, restaurant_food_sku_sno, order_quantity, sku_price, delivered_quantity, description, active_flag) FROM stdin;
49	38	\N	1	1	1200	1	\N	t



--
-- Data for Name: signin_info; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.signin_info (signin_info_sno, app_user_sno, push_token, device_type_cd, device_id, login_on, logout_on, description, active_flag) FROM stdin;



--
-- Data for Name: sku_inventory; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.sku_inventory (sku_inventory_sno, purchase_order_dtl_sno, unique_code, sales_order_dtl_sno, wf_stage_cd, description, active_flag, transaction_date, restaurant_food_sku_sno, qbox_entity_sno) FROM stdin;
752	126	MAA-SWG-A2B-SIVM-20240505-95-21	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
753	126	MAA-SWG-A2B-SIVM-20240505-95-22	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
754	126	MAA-SWG-A2B-SIVM-20240505-95-23	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
755	126	MAA-SWG-A2B-SIVM-20240505-95-24	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
756	126	MAA-SWG-A2B-SIVM-20240505-95-25	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
757	126	MAA-SWG-A2B-SIVM-20240505-95-26	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
758	126	MAA-SWG-A2B-SIVM-20240505-95-27	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
759	126	MAA-SWG-A2B-SIVM-20240505-95-28	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
760	126	MAA-SWG-A2B-SIVM-20240505-95-29	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
761	126	MAA-SWG-A2B-SIVM-20240505-95-210	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
762	126	MAA-SWG-A2B-SIVM-20240505-95-211	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
763	126	MAA-SWG-A2B-SIVM-20240505-95-212	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
764	126	MAA-SWG-A2B-SIVM-20240505-95-213	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
765	126	MAA-SWG-A2B-SIVM-20240505-95-214	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
766	126	MAA-SWG-A2B-SIVM-20240505-95-215	\N	6	a2bMntRd-SIVM	t	2025-01-04	1	20
751	125	MAA-SWG-A2B-SIVM-20240505-95-15	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
767	127	MAA-SWG-A2B-SIVM-20240505-95-011	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
768	127	MAA-SWG-A2B-SIVM-20240505-95-021	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
769	127	MAA-SWG-A2B-SIVM-20240505-95-031	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
770	127	MAA-SWG-A2B-SIVM-20240505-95-041	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
771	127	MAA-SWG-A2B-SIVM-20240505-95-051	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
772	127	MAA-SWG-A2B-SIVM-20240505-95-061	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
773	127	MAA-SWG-A2B-SIVM-20240505-95-071	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
774	127	MAA-SWG-A2B-SIVM-20240505-95-081	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
794	128	MAA-SWG-A2B-SIVM-20240505-94-0311	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
795	128	MAA-SWG-A2B-SIVM-20240505-94-0411	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
775	127	MAA-SWG-A2B-SIVM-20240505-95-091	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
776	127	MAA-SWG-A2B-SIVM-20240505-95-0101	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
777	127	MAA-SWG-A2B-SIVM-20240505-95-0111	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
778	127	MAA-SWG-A2B-SIVM-20240505-95-0211	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
779	127	MAA-SWG-A2B-SIVM-20240505-95-0311	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
780	127	MAA-SWG-A2B-SIVM-20240505-95-0411	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
781	127	MAA-SWG-A2B-SIVM-20240505-95-0511	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
782	128	MAA-SWG-A2B-SIVM-20240505-94-011	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
783	128	MAA-SWG-A2B-SIVM-20240505-94-021	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
784	128	MAA-SWG-A2B-SIVM-20240505-94-031	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
785	128	MAA-SWG-A2B-SIVM-20240505-94-041	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
786	128	MAA-SWG-A2B-SIVM-20240505-94-051	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
787	128	MAA-SWG-A2B-SIVM-20240505-94-061	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
788	128	MAA-SWG-A2B-SIVM-20240505-94-071	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
789	128	MAA-SWG-A2B-SIVM-20240505-94-081	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
790	128	MAA-SWG-A2B-SIVM-20240505-94-091	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
791	128	MAA-SWG-A2B-SIVM-20240505-94-0101	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
792	128	MAA-SWG-A2B-SIVM-20240505-94-0111	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
793	128	MAA-SWG-A2B-SIVM-20240505-94-0211	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20
737	125	MAA-SWG-A2B-SIVM-20240505-95-1	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
738	125	MAA-SWG-A2B-SIVM-20240505-95-2	49	10	a2bMntRd-SIVM	t	2025-01-04	1	20
739	125	MAA-SWG-A2B-SIVM-20240505-95-3	\N	8	a2bMntRd-SIVM	t	2025-01-04	1	20
740	125	MAA-SWG-A2B-SIVM-20240505-95-4	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
741	125	MAA-SWG-A2B-SIVM-20240505-95-5	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
742	125	MAA-SWG-A2B-SIVM-20240505-95-6	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
743	125	MAA-SWG-A2B-SIVM-20240505-95-7	\N	8	a2bMntRd-SIVM	t	2025-01-04	1	20
744	125	MAA-SWG-A2B-SIVM-20240505-95-8	\N	8	a2bMntRd-SIVM	t	2025-01-04	1	20
745	125	MAA-SWG-A2B-SIVM-20240505-95-9	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
746	125	MAA-SWG-A2B-SIVM-20240505-95-10	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
747	125	MAA-SWG-A2B-SIVM-20240505-95-11	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
748	125	MAA-SWG-A2B-SIVM-20240505-95-12	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
749	125	MAA-SWG-A2B-SIVM-20240505-95-13	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
750	125	MAA-SWG-A2B-SIVM-20240505-95-14	\N	10	a2bMntRd-SIVM	t	2025-01-04	1	20
796	128	MAA-SWG-A2B-SIVM-20240505-94-0511	\N	6	a2bMntRd-SIVM	t	2025-01-05	1	20



--
-- Data for Name: sku_trace_wf; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.sku_trace_wf (sku_trace_wf_sno, sku_inventory_sno, wf_stage_cd, action_time, action_by, reference, description, active_flag) FROM stdin;
1684	737	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1685	738	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1686	739	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1687	740	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1688	741	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1689	742	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1690	743	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1691	744	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1692	745	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1693	746	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1694	747	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1695	748	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1696	749	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1697	750	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1698	751	6	2025-01-04 13:25:26.030775	1	pod-sno-125	\N	t
1699	738	11	2025-01-04 10:38:36.339973	1	\N	MAA-SWG-A2B-SIVM-20240505-95-2	t
1700	739	11	2025-01-04 10:41:28.977874	1	\N	MAA-SWG-A2B-SIVM-20240505-95-3	t
1701	740	11	2025-01-04 10:48:15.249052	1	\N	MAA-SWG-A2B-SIVM-20240505-95-4	t
1711	738	13	2025-01-04 11:26:09.104068	1	box-cell-sno-135	\N	t
1712	737	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-1	t
1713	741	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-5	t
1714	742	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-6	t
1715	743	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-7	t
1716	744	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-8	t
1717	745	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-9	t
1718	746	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-10	t
1719	747	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-11	t
1720	748	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-12	t
1721	749	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-13	t
1722	750	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-14	t
1723	751	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-15	t
1724	739	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-3	t
1725	740	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-4	t
1726	738	7	2025-01-04 11:34:15.773247	1	\N	MAA-SWG-A2B-SIVM-20240505-95-2	t
1727	737	9	2025-01-04 11:34:28.659687	1	\N	MAA-SWG-A2B-SIVM-20240505-95-1	t
1728	737	10	2025-01-04 11:34:28.659687	1	\N	MAA-SWG-A2B-SIVM-20240505-95-1	t
1729	738	8	2025-01-04 11:34:32.273157	1	\N	MAA-SWG-A2B-SIVM-20240505-95-2	t
1730	741	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-5	t
1731	742	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-6	t
1732	743	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-7	t
1733	744	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-8	t
1734	745	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-9	t
1735	746	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-10	t
1736	747	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-11	t
1737	748	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-12	t
1738	749	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-13	t
1739	750	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-14	t
1740	751	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-15	t
1741	739	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-3	t
1742	740	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-4	t
1743	737	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-1	t
1744	738	7	2025-01-04 11:34:45.116079	1	\N	MAA-SWG-A2B-SIVM-20240505-95-2	t
1745	752	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1746	753	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1747	754	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1748	755	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1749	756	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1750	757	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1751	758	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1752	759	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1753	760	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1754	761	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1755	762	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1756	763	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1757	764	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1758	765	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1759	766	6	2025-01-04 11:49:14.255817	1	pod-sno-126	\N	t
1760	741	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-5	t
1761	742	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-6	t
1762	743	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-7	t
1763	744	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-8	t
1764	745	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-9	t
1765	746	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-10	t
1766	747	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-11	t
1767	748	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-12	t
1768	749	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-13	t
1802	767	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1769	750	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-14	t
1770	751	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-15	t
1771	739	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-3	t
1772	740	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-4	t
1773	737	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-1	t
1774	738	7	2025-01-04 11:54:40.839723	1	\N	MAA-SWG-A2B-SIVM-20240505-95-2	t
1775	737	9	2025-01-04 11:55:47.897068	1	\N	MAA-SWG-A2B-SIVM-20240505-95-1	t
1776	737	10	2025-01-04 11:55:47.897068	1	\N	MAA-SWG-A2B-SIVM-20240505-95-1	t
1777	738	9	2025-01-04 11:55:52.092295	1	\N	MAA-SWG-A2B-SIVM-20240505-95-2	t
1778	738	10	2025-01-04 11:55:52.092295	1	\N	MAA-SWG-A2B-SIVM-20240505-95-2	t
1779	739	8	2025-01-04 11:55:53.262422	1	\N	MAA-SWG-A2B-SIVM-20240505-95-3	t
1780	740	9	2025-01-04 11:56:42.770456	1	\N	MAA-SWG-A2B-SIVM-20240505-95-4	t
1781	740	10	2025-01-04 11:56:42.770456	1	\N	MAA-SWG-A2B-SIVM-20240505-95-4	t
1782	741	9	2025-01-04 11:56:44.356822	1	\N	MAA-SWG-A2B-SIVM-20240505-95-5	t
1783	741	10	2025-01-04 11:56:44.356822	1	\N	MAA-SWG-A2B-SIVM-20240505-95-5	t
1784	742	9	2025-01-04 11:56:45.481573	1	\N	MAA-SWG-A2B-SIVM-20240505-95-6	t
1785	742	10	2025-01-04 11:56:45.481573	1	\N	MAA-SWG-A2B-SIVM-20240505-95-6	t
1786	743	8	2025-01-04 11:56:46.353219	1	\N	MAA-SWG-A2B-SIVM-20240505-95-7	t
1787	744	8	2025-01-04 11:56:47.896432	1	\N	MAA-SWG-A2B-SIVM-20240505-95-8	t
1788	745	9	2025-01-04 11:56:48.830156	1	\N	MAA-SWG-A2B-SIVM-20240505-95-9	t
1789	745	10	2025-01-04 11:56:48.830156	1	\N	MAA-SWG-A2B-SIVM-20240505-95-9	t
1790	746	9	2025-01-04 11:56:51.867175	1	\N	MAA-SWG-A2B-SIVM-20240505-95-10	t
1791	746	10	2025-01-04 11:56:51.867175	1	\N	MAA-SWG-A2B-SIVM-20240505-95-10	t
1792	747	9	2025-01-04 11:56:52.809819	1	\N	MAA-SWG-A2B-SIVM-20240505-95-11	t
1793	747	10	2025-01-04 11:56:52.809819	1	\N	MAA-SWG-A2B-SIVM-20240505-95-11	t
1794	748	9	2025-01-04 11:56:54.842462	1	\N	MAA-SWG-A2B-SIVM-20240505-95-12	t
1795	748	10	2025-01-04 11:56:54.842462	1	\N	MAA-SWG-A2B-SIVM-20240505-95-12	t
1796	749	9	2025-01-04 11:56:55.648582	1	\N	MAA-SWG-A2B-SIVM-20240505-95-13	t
1797	749	10	2025-01-04 11:56:55.648582	1	\N	MAA-SWG-A2B-SIVM-20240505-95-13	t
1798	750	9	2025-01-04 11:56:56.262642	1	\N	MAA-SWG-A2B-SIVM-20240505-95-14	t
1799	750	10	2025-01-04 11:56:56.262642	1	\N	MAA-SWG-A2B-SIVM-20240505-95-14	t
1800	751	9	2025-01-04 11:56:57.669918	1	\N	MAA-SWG-A2B-SIVM-20240505-95-15	t
1801	751	10	2025-01-04 11:56:57.669918	1	\N	MAA-SWG-A2B-SIVM-20240505-95-15	t
1803	768	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1804	769	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1805	770	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1806	771	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1807	772	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1808	773	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1809	774	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1810	775	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1811	776	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1812	777	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1813	778	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1814	779	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1815	780	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1816	781	6	2025-01-05 13:17:44.255737	1	pod-sno-127	\N	t
1817	782	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1818	783	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1819	784	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1820	785	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1821	786	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1822	787	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1823	788	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1824	789	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1825	790	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1826	791	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1827	792	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1828	793	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1829	794	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1830	795	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t
1831	796	6	2025-01-05 13:29:54.248728	1	pod-sno-128	\N	t



--
-- Data for Name: state; Type: TABLE DATA; Schema: masters; Owner: postgres
--

COPY masters.state (state_sno, country_sno, state_code, name, active_flag) FROM stdin;
2	1	KR	Keralaa	t
1	1	TN	Tamil Nadu	t



--
-- Data for Name: etl_job; Type: TABLE DATA; Schema: partner_order; Owner: postgres
--

COPY partner_order.etl_job (etl_job_sno, order_etl_hdr_sno, file_name, file_load_timestamp, etl_start_timestamp, etl_end_timestamp, status, error_message, record_count, processed_by, last_updated) FROM stdin;
93	1	SWIGGYaPartner-Order-28122024-01 1.csv	2025-01-04 13:25:26.030775	2025-01-04 13:25:26.030775	2025-01-04 13:25:26.030775	Completed	\N	15	SWIGGYPartner-Order-28122024-01 1.csv	2025-01-04 13:25:26.030775
94	1	SWIGGYCPartner-Order-28122024-01 1.csv	2025-01-04 11:49:14.255817	2025-01-04 11:49:14.255817	2025-01-04 11:49:14.255817	Completed	\N	15	SWIGGYCPartner-Order-28122024-01 1.csv	2025-01-04 11:49:14.255817
95	1	SWIGGYorder.csv	2025-01-05 13:17:44.255737	2025-01-05 13:17:44.255737	2025-01-05 13:17:44.255737	Completed	\N	15	SWIGGYorder.csv	2025-01-05 13:17:44.255737
96	1	SWIGGYorder1.csv	2025-01-05 13:29:54.248728	2025-01-05 13:29:54.248728	2025-01-05 13:29:54.248728	Completed	\N	15	SWIGGYorder1.csv	2025-01-05 13:29:54.248728



--
-- Data for Name: etl_record; Type: TABLE DATA; Schema: partner_order; Owner: postgres
--

COPY partner_order.etl_record (etl_record_sno, etl_job_sno, staging_table_name, row_id, processing_status, processing_timestamp, error_message) FROM stdin;
384	93	swiggy_staging	385	Pending	2025-01-04 13:25:26.030775	\N
385	93	swiggy_staging	386	Pending	2025-01-04 13:25:26.030775	\N
386	93	swiggy_staging	387	Pending	2025-01-04 13:25:26.030775	\N
387	93	swiggy_staging	388	Pending	2025-01-04 13:25:26.030775	\N
388	93	swiggy_staging	389	Pending	2025-01-04 13:25:26.030775	\N
389	93	swiggy_staging	390	Pending	2025-01-04 13:25:26.030775	\N
390	93	swiggy_staging	391	Pending	2025-01-04 13:25:26.030775	\N
391	93	swiggy_staging	392	Pending	2025-01-04 13:25:26.030775	\N
392	93	swiggy_staging	393	Pending	2025-01-04 13:25:26.030775	\N
393	93	swiggy_staging	394	Pending	2025-01-04 13:25:26.030775	\N
394	93	swiggy_staging	395	Pending	2025-01-04 13:25:26.030775	\N
395	93	swiggy_staging	396	Pending	2025-01-04 13:25:26.030775	\N
396	93	swiggy_staging	397	Pending	2025-01-04 13:25:26.030775	\N
397	93	swiggy_staging	398	Pending	2025-01-04 13:25:26.030775	\N
398	93	swiggy_staging	399	Pending	2025-01-04 13:25:26.030775	\N
399	94	swiggy_staging	400	Pending	2025-01-04 11:49:14.255817	\N
400	94	swiggy_staging	401	Pending	2025-01-04 11:49:14.255817	\N
401	94	swiggy_staging	402	Pending	2025-01-04 11:49:14.255817	\N
402	94	swiggy_staging	403	Pending	2025-01-04 11:49:14.255817	\N
403	94	swiggy_staging	404	Pending	2025-01-04 11:49:14.255817	\N
404	94	swiggy_staging	405	Pending	2025-01-04 11:49:14.255817	\N
405	94	swiggy_staging	406	Pending	2025-01-04 11:49:14.255817	\N
406	94	swiggy_staging	407	Pending	2025-01-04 11:49:14.255817	\N
407	94	swiggy_staging	408	Pending	2025-01-04 11:49:14.255817	\N
408	94	swiggy_staging	409	Pending	2025-01-04 11:49:14.255817	\N
409	94	swiggy_staging	410	Pending	2025-01-04 11:49:14.255817	\N
410	94	swiggy_staging	411	Pending	2025-01-04 11:49:14.255817	\N
411	94	swiggy_staging	412	Pending	2025-01-04 11:49:14.255817	\N
412	94	swiggy_staging	413	Pending	2025-01-04 11:49:14.255817	\N
413	94	swiggy_staging	414	Pending	2025-01-04 11:49:14.255817	\N
414	95	swiggy_staging	415	Pending	2025-01-05 13:17:44.255737	\N
415	95	swiggy_staging	416	Pending	2025-01-05 13:17:44.255737	\N
416	95	swiggy_staging	417	Pending	2025-01-05 13:17:44.255737	\N
417	95	swiggy_staging	418	Pending	2025-01-05 13:17:44.255737	\N
418	95	swiggy_staging	419	Pending	2025-01-05 13:17:44.255737	\N
419	95	swiggy_staging	420	Pending	2025-01-05 13:17:44.255737	\N
420	95	swiggy_staging	421	Pending	2025-01-05 13:17:44.255737	\N
421	95	swiggy_staging	422	Pending	2025-01-05 13:17:44.255737	\N
422	95	swiggy_staging	423	Pending	2025-01-05 13:17:44.255737	\N
423	95	swiggy_staging	424	Pending	2025-01-05 13:17:44.255737	\N
424	95	swiggy_staging	425	Pending	2025-01-05 13:17:44.255737	\N
425	95	swiggy_staging	426	Pending	2025-01-05 13:17:44.255737	\N
426	95	swiggy_staging	427	Pending	2025-01-05 13:17:44.255737	\N
427	95	swiggy_staging	428	Pending	2025-01-05 13:17:44.255737	\N
428	95	swiggy_staging	429	Pending	2025-01-05 13:17:44.255737	\N
429	96	swiggy_staging	430	Pending	2025-01-05 13:29:54.248728	\N
430	96	swiggy_staging	431	Pending	2025-01-05 13:29:54.248728	\N
431	96	swiggy_staging	432	Pending	2025-01-05 13:29:54.248728	\N
432	96	swiggy_staging	433	Pending	2025-01-05 13:29:54.248728	\N
433	96	swiggy_staging	434	Pending	2025-01-05 13:29:54.248728	\N
434	96	swiggy_staging	435	Pending	2025-01-05 13:29:54.248728	\N
435	96	swiggy_staging	436	Pending	2025-01-05 13:29:54.248728	\N
436	96	swiggy_staging	437	Pending	2025-01-05 13:29:54.248728	\N
437	96	swiggy_staging	438	Pending	2025-01-05 13:29:54.248728	\N
438	96	swiggy_staging	439	Pending	2025-01-05 13:29:54.248728	\N
439	96	swiggy_staging	440	Pending	2025-01-05 13:29:54.248728	\N
440	96	swiggy_staging	441	Pending	2025-01-05 13:29:54.248728	\N
441	96	swiggy_staging	442	Pending	2025-01-05 13:29:54.248728	\N
442	96	swiggy_staging	443	Pending	2025-01-05 13:29:54.248728	\N
443	96	swiggy_staging	444	Pending	2025-01-05 13:29:54.248728	\N



--
-- Data for Name: etl_table_column; Type: TABLE DATA; Schema: partner_order; Owner: postgres
--

COPY partner_order.etl_table_column (etl_table_column_sno, order_etl_hdr_sno, source_column, staging_column, data_type, is_required, description, created_at, updated_at) FROM stdin;
1	1	qboxRemoteLocation	qbox_remote_location	VARCHAR	t	qboxRemoteLocation	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785
7	1	restaurantCode	restaurant_code	VARCHAR	t	restaurantCode	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785
3	1	partnerPurchaseOrderId	partner_purchase_order_id	VARCHAR	t	partnerPurchaseOrderId	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785
4	1	orderedBy	order_by	INTEGER	t	orderedBy	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785
5	1	orderStatusCd	order_status_cd	INTEGER	t	orderStatusCd	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785
6	1	partnerCode	partner_code	VARCHAR	t	partnerCode	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785
2	1	uniqueCode	sku_unique_code	VARCHAR	t	uniqueCode	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785
9	1	partnerFoodCode	partner_food_code	VARCHAR	t	partnerFoodCode	2025-01-02 12:03:25.732785	2025-01-02 12:03:25.732785



--
-- Data for Name: order_etl_hdr; Type: TABLE DATA; Schema: partner_order; Owner: postgres
--

COPY partner_order.order_etl_hdr (order_etl_hdr_sno, delivery_partner_sno, partner_code, staging_table_name, is_active, file_name_prefix) FROM stdin;
1	3	SWG	swiggy_staging	t	SWIGGY



--
-- Data for Name: swiggy_staging; Type: TABLE DATA; Schema: partner_order; Owner: postgres
--

COPY partner_order.swiggy_staging (swiggy_staging_sno, qbox_remote_location, restaurant_code, partner_code, order_status_cd, order_by, partner_purchase_order_id, sku_unique_code, created_time, etl_job_sno, partner_food_code) FROM stdin;
385	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-1	2025-01-04 13:25:26.030775	93	SIVM
386	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-2	2025-01-04 13:25:26.030775	93	SIVM
387	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-3	2025-01-04 13:25:26.030775	93	SIVM
388	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-4	2025-01-04 13:25:26.030775	93	SIVM
389	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-5	2025-01-04 13:25:26.030775	93	SIVM
390	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-6	2025-01-04 13:25:26.030775	93	SIVM
391	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-7	2025-01-04 13:25:26.030775	93	SIVM
392	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-8	2025-01-04 13:25:26.030775	93	SIVM
393	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-9	2025-01-04 13:25:26.030775	93	SIVM
394	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-10	2025-01-04 13:25:26.030775	93	SIVM
395	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-11	2025-01-04 13:25:26.030775	93	SIVM
396	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-12	2025-01-04 13:25:26.030775	93	SIVM
397	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-13	2025-01-04 13:25:26.030775	93	SIVM
398	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-14	2025-01-04 13:25:26.030775	93	SIVM
399	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_67356	MAA-SWG-A2B-SIVM-20240505-95-15	2025-01-04 13:25:26.030775	93	SIVM
400	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-21	2025-01-04 11:49:14.255817	94	SIVM
401	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-22	2025-01-04 11:49:14.255817	94	SIVM
402	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-23	2025-01-04 11:49:14.255817	94	SIVM
403	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-24	2025-01-04 11:49:14.255817	94	SIVM
404	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-25	2025-01-04 11:49:14.255817	94	SIVM
405	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-26	2025-01-04 11:49:14.255817	94	SIVM
406	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-27	2025-01-04 11:49:14.255817	94	SIVM
407	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-28	2025-01-04 11:49:14.255817	94	SIVM
408	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-29	2025-01-04 11:49:14.255817	94	SIVM
409	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-210	2025-01-04 11:49:14.255817	94	SIVM
410	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-211	2025-01-04 11:49:14.255817	94	SIVM
411	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-212	2025-01-04 11:49:14.255817	94	SIVM
412	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-213	2025-01-04 11:49:14.255817	94	SIVM
413	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-214	2025-01-04 11:49:14.255817	94	SIVM
414	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_673567	MAA-SWG-A2B-SIVM-20240505-95-215	2025-01-04 11:49:14.255817	94	SIVM
415	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-011	2025-01-05 13:17:44.255737	95	SIVM
416	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-021	2025-01-05 13:17:44.255737	95	SIVM
417	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-031	2025-01-05 13:17:44.255737	95	SIVM
418	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-041	2025-01-05 13:17:44.255737	95	SIVM
419	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-051	2025-01-05 13:17:44.255737	95	SIVM
420	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-061	2025-01-05 13:17:44.255737	95	SIVM
421	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-071	2025-01-05 13:17:44.255737	95	SIVM
422	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-081	2025-01-05 13:17:44.255737	95	SIVM
423	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-091	2025-01-05 13:17:44.255737	95	SIVM
424	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-0101	2025-01-05 13:17:44.255737	95	SIVM
425	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-0111	2025-01-05 13:17:44.255737	95	SIVM
426	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-0211	2025-01-05 13:17:44.255737	95	SIVM
427	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-0311	2025-01-05 13:17:44.255737	95	SIVM
428	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-0411	2025-01-05 13:17:44.255737	95	SIVM
429	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_323456	MAA-SWG-A2B-SIVM-20240505-95-0511	2025-01-05 13:17:44.255737	95	SIVM
430	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-011	2025-01-05 13:29:54.248728	96	SIVM
431	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-021	2025-01-05 13:29:54.248728	96	SIVM
432	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-031	2025-01-05 13:29:54.248728	96	SIVM
433	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-041	2025-01-05 13:29:54.248728	96	SIVM
434	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-051	2025-01-05 13:29:54.248728	96	SIVM
435	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-061	2025-01-05 13:29:54.248728	96	SIVM
436	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-071	2025-01-05 13:29:54.248728	96	SIVM
437	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-081	2025-01-05 13:29:54.248728	96	SIVM
438	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-091	2025-01-05 13:29:54.248728	96	SIVM
439	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-0101	2025-01-05 13:29:54.248728	96	SIVM
440	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-0111	2025-01-05 13:29:54.248728	96	SIVM
441	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-0211	2025-01-05 13:29:54.248728	96	SIVM
442	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-0311	2025-01-05 13:29:54.248728	96	SIVM
443	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-0411	2025-01-05 13:29:54.248728	96	SIVM
444	QBXNGM	a2bMntRd	SWG	1	1	SWIGGY_423456	MAA-SWG-A2B-SIVM-20240505-94-0511	2025-01-05 13:29:54.248728	96	SIVM



--
-- Name: app_function_app_function_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.app_function_app_function_sno_seq', 4, true);


--
-- Name: app_menu_app_menu_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.app_menu_app_menu_sno_seq', 1, false);


--
-- Name: app_role_app_role_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.app_role_app_role_sno_seq', 1, false);


--
-- Name: app_user_app_user_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.app_user_app_user_sno_seq', 1, true);


--
-- Name: app_user_role_app_user_role_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.app_user_role_app_user_role_sno_seq', 1, false);


--
-- Name: codes_dtl_codes_dtl_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.codes_dtl_codes_dtl_sno_seq', 1, false);


--
-- Name: codes_hdr_codes_hdr_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.codes_hdr_codes_hdr_sno_seq', 1, false);


--
-- Name: menu_function_menu_function_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.menu_function_menu_function_sno_seq', 1, false);


--
-- Name: otp_otp_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.otp_otp_sno_seq', 1, false);


--
-- Name: role_function_role_function_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.role_function_role_function_sno_seq', 1, false);


--
-- Name: role_menu_role_menu_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.role_menu_role_menu_sno_seq', 1, false);


--
-- Name: signin_info_signin_info_sno_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.signin_info_signin_info_sno_seq', 1, false);


--
-- Name: address_address_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.address_address_sno_seq', 18, true);


--
-- Name: app_function_app_function_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.app_function_app_function_sno_seq', 4, true);


--
-- Name: app_menu_app_menu_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.app_menu_app_menu_sno_seq', 1, false);


--
-- Name: app_role_app_role_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.app_role_app_role_sno_seq', 1, false);


--
-- Name: app_user_app_user_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.app_user_app_user_sno_seq', 1, true);


--
-- Name: app_user_role_app_user_role_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.app_user_role_app_user_role_sno_seq', 1, false);


--
-- Name: area_area_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.area_area_sno_seq', 33, true);


--
-- Name: box_cell_box_cell_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.box_cell_box_cell_sno_seq', 160, true);


--
-- Name: box_cell_food_box_cell_food_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.box_cell_food_box_cell_food_sno_seq', 61, true);


--
-- Name: city_city_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.city_city_sno_seq', 3, true);


--
-- Name: codes_dtl_codes_dtl_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.codes_dtl_codes_dtl_sno_seq', 31, true);


--
-- Name: codes_hdr_codes_hdr_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.codes_hdr_codes_hdr_sno_seq', 20, true);


--
-- Name: country_country_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.country_country_sno_seq', 7, true);


--
-- Name: delivery_partner_delivery_partner_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.delivery_partner_delivery_partner_sno_seq', 15, true);


--
-- Name: entity_infra_entity_infra_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: qbox_admin
--

SELECT pg_catalog.setval('masters.entity_infra_entity_infra_sno_seq', 47, true);


--
-- Name: entity_infra_property_entity_infra_property_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: qbox_admin
--

SELECT pg_catalog.setval('masters.entity_infra_property_entity_infra_property_sno_seq', 41, true);


--
-- Name: food_sku_food_sku_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.food_sku_food_sku_sno_seq', 6, true);


--
-- Name: infra_infra_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.infra_infra_sno_seq', 2, true);


--
-- Name: infra_property_infra_property_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: qbox_admin
--

SELECT pg_catalog.setval('masters.infra_property_infra_property_sno_seq', 8, true);


--
-- Name: menu_function_menu_function_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.menu_function_menu_function_sno_seq', 1, false);


--
-- Name: otp_otp_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.otp_otp_sno_seq', 1, false);


--
-- Name: partner_food_sku_partner_food_sku_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: qbox_admin
--

SELECT pg_catalog.setval('masters.partner_food_sku_partner_food_sku_sno_seq', 10, true);


--
-- Name: purchase_order_dtl_purchase_order_dtl_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: qbox_admin
--

SELECT pg_catalog.setval('masters.purchase_order_dtl_purchase_order_dtl_sno_seq', 128, true);


--
-- Name: purchase_order_purchase_order_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.purchase_order_purchase_order_sno_seq', 139, true);


--
-- Name: qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.qbox_entity_delivery_partner_qbox_entity_delivery_partner_s_seq', 1, false);


--
-- Name: qbox_entity_qbox_entity_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.qbox_entity_qbox_entity_sno_seq', 21, true);


--
-- Name: restaurant_food_sku_restaurant_food_sku_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.restaurant_food_sku_restaurant_food_sku_sno_seq', 4, true);


--
-- Name: restaurant_restaurant_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.restaurant_restaurant_sno_seq', 8, true);


--
-- Name: role_function_role_function_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.role_function_role_function_sno_seq', 1, false);


--
-- Name: role_menu_role_menu_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.role_menu_role_menu_sno_seq', 1, false);


--
-- Name: sales_order_dtl_sales_order_dtl_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: qbox_admin
--

SELECT pg_catalog.setval('masters.sales_order_dtl_sales_order_dtl_sno_seq', 49, true);


--
-- Name: sales_order_sales_order_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: qbox_admin
--

SELECT pg_catalog.setval('masters.sales_order_sales_order_sno_seq', 38, true);


--
-- Name: signin_info_signin_info_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.signin_info_signin_info_sno_seq', 1, false);


--
-- Name: sku_inventory_sku_inventory_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.sku_inventory_sku_inventory_sno_seq', 796, true);


--
-- Name: sku_trace_wf_sku_trace_wf_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.sku_trace_wf_sku_trace_wf_sno_seq', 1831, true);


--
-- Name: state_state_sno_seq; Type: SEQUENCE SET; Schema: masters; Owner: postgres
--

SELECT pg_catalog.setval('masters.state_state_sno_seq', 2, true);


--
-- Name: etl_job_etl_job_sno_seq; Type: SEQUENCE SET; Schema: partner_order; Owner: postgres
--

SELECT pg_catalog.setval('partner_order.etl_job_etl_job_sno_seq', 96, true);


--
-- Name: etl_record_etl_record_sno_seq; Type: SEQUENCE SET; Schema: partner_order; Owner: postgres
--

SELECT pg_catalog.setval('partner_order.etl_record_etl_record_sno_seq', 443, true);


--
-- Name: etl_table_column_etl_table_column_sno_seq; Type: SEQUENCE SET; Schema: partner_order; Owner: postgres
--

SELECT pg_catalog.setval('partner_order.etl_table_column_etl_table_column_sno_seq', 13, true);


--
-- Name: order_etl_hdr_order_etl_hdr_sno_seq; Type: SEQUENCE SET; Schema: partner_order; Owner: postgres
--

SELECT pg_catalog.setval('partner_order.order_etl_hdr_order_etl_hdr_sno_seq', 1, true);


--
-- Name: swiggy_staging_swiggy_staging_sno_seq; Type: SEQUENCE SET; Schema: partner_order; Owner: postgres
--

SELECT pg_catalog.setval('partner_order.swiggy_staging_swiggy_staging_sno_seq', 444, true);


--
-- Name: app_permission app_function_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_permission
    ADD CONSTRAINT app_function_pkey PRIMARY KEY (app_permission_sno);


--
-- Name: app_menu app_menu_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_menu
    ADD CONSTRAINT app_menu_pkey PRIMARY KEY (app_menu_sno);


--
-- Name: app_role app_role_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_role
    ADD CONSTRAINT app_role_pkey PRIMARY KEY (app_role_sno);


--
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (app_user_sno);


--
-- Name: app_user_role app_user_role_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_user_role
    ADD CONSTRAINT app_user_role_pkey PRIMARY KEY (app_user_role_sno);


--
-- Name: app_user app_user_user_id_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_user
    ADD CONSTRAINT app_user_user_id_key UNIQUE (user_id);


--
-- Name: codes_dtl codes_dtl_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.codes_dtl
    ADD CONSTRAINT codes_dtl_pkey PRIMARY KEY (codes_dtl_sno);


--
-- Name: codes_hdr codes_hdr_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.codes_hdr
    ADD CONSTRAINT codes_hdr_pkey PRIMARY KEY (codes_hdr_sno);


--
-- Name: menu_permission menu_function_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.menu_permission
    ADD CONSTRAINT menu_function_pkey PRIMARY KEY (menu_permission_sno);


--
-- Name: otp otp_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.otp
    ADD CONSTRAINT otp_pkey PRIMARY KEY (otp_sno);


--
-- Name: role_permission role_function_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.role_permission
    ADD CONSTRAINT role_function_pkey PRIMARY KEY (role_permission_sno);


--
-- Name: role_menu role_menu_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.role_menu
    ADD CONSTRAINT role_menu_pkey PRIMARY KEY (role_menu_sno);


--
-- Name: signin_info signin_info_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.signin_info
    ADD CONSTRAINT signin_info_pkey PRIMARY KEY (signin_info_sno);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_sno);


--
-- Name: app_permission app_function_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_permission
    ADD CONSTRAINT app_function_pkey PRIMARY KEY (app_permission_sno);


--
-- Name: app_menu app_menu_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_menu
    ADD CONSTRAINT app_menu_pkey PRIMARY KEY (app_menu_sno);


--
-- Name: app_role app_role_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_role
    ADD CONSTRAINT app_role_pkey PRIMARY KEY (app_role_sno);


--
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (app_user_sno);


--
-- Name: app_user_role app_user_role_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_user_role
    ADD CONSTRAINT app_user_role_pkey PRIMARY KEY (app_user_role_sno);


--
-- Name: app_user app_user_user_id_key; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_user
    ADD CONSTRAINT app_user_user_id_key UNIQUE (user_id);


--
-- Name: area area_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.area
    ADD CONSTRAINT area_pkey PRIMARY KEY (area_sno);


--
-- Name: box_cell_food_hist box_cell_food_hist_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell_food_hist
    ADD CONSTRAINT box_cell_food_hist_pkey PRIMARY KEY (box_cell_food_sno);


--
-- Name: box_cell_food box_cell_food_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell_food
    ADD CONSTRAINT box_cell_food_pkey PRIMARY KEY (box_cell_food_sno);


--
-- Name: box_cell box_cell_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell
    ADD CONSTRAINT box_cell_pkey PRIMARY KEY (box_cell_sno);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_sno);


--
-- Name: codes_dtl codes_dtl_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.codes_dtl
    ADD CONSTRAINT codes_dtl_pkey PRIMARY KEY (codes_dtl_sno);


--
-- Name: codes_hdr codes_hdr_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.codes_hdr
    ADD CONSTRAINT codes_hdr_pkey PRIMARY KEY (codes_hdr_sno);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_sno);


--
-- Name: delivery_partner delivery_partner_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.delivery_partner
    ADD CONSTRAINT delivery_partner_pkey PRIMARY KEY (delivery_partner_sno);


--
-- Name: entity_infra entity_infra_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.entity_infra
    ADD CONSTRAINT entity_infra_pkey PRIMARY KEY (entity_infra_sno);


--
-- Name: entity_infra_property entity_infra_property_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.entity_infra_property
    ADD CONSTRAINT entity_infra_property_pkey PRIMARY KEY (entity_infra_property_sno);


--
-- Name: food_sku food_sku_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.food_sku
    ADD CONSTRAINT food_sku_pkey PRIMARY KEY (food_sku_sno);


--
-- Name: infra infra_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.infra
    ADD CONSTRAINT infra_pkey PRIMARY KEY (infra_sno);


--
-- Name: infra_property infra_property_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.infra_property
    ADD CONSTRAINT infra_property_pkey PRIMARY KEY (infra_property_sno);


--
-- Name: menu_permission menu_function_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.menu_permission
    ADD CONSTRAINT menu_function_pkey PRIMARY KEY (menu_permission_sno);


--
-- Name: otp otp_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.otp
    ADD CONSTRAINT otp_pkey PRIMARY KEY (otp_sno);


--
-- Name: partner_food_sku partner_food_sku_pkey; Type: CONSTRAINT; Schema: masters; Owner: qbox_admin
--

ALTER TABLE ONLY masters.partner_food_sku
    ADD CONSTRAINT partner_food_sku_pkey PRIMARY KEY (partner_food_sku_sno);


--
-- Name: purchase_order partner_purchase_order_id_uk; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order
    ADD CONSTRAINT partner_purchase_order_id_uk UNIQUE (partner_purchase_order_id);


--
-- Name: purchase_order_dtl purchase_order_dtl_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order_dtl
    ADD CONSTRAINT purchase_order_dtl_pkey PRIMARY KEY (purchase_order_dtl_sno);


--
-- Name: purchase_order purchase_order_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order
    ADD CONSTRAINT purchase_order_pkey PRIMARY KEY (purchase_order_sno);


--
-- Name: qbox_entity_delivery_partner qbox_entity_delivery_partner_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity_delivery_partner
    ADD CONSTRAINT qbox_entity_delivery_partner_pkey PRIMARY KEY (qbox_entity_delivery_partner_sno);


--
-- Name: qbox_entity qbox_entity_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity
    ADD CONSTRAINT qbox_entity_pkey PRIMARY KEY (qbox_entity_sno);


--
-- Name: restaurant_food_sku restaurant_food_sku_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant_food_sku
    ADD CONSTRAINT restaurant_food_sku_pkey PRIMARY KEY (restaurant_food_sku_sno);


--
-- Name: restaurant restaurant_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant
    ADD CONSTRAINT restaurant_pkey PRIMARY KEY (restaurant_sno);


--
-- Name: role_permission role_function_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.role_permission
    ADD CONSTRAINT role_function_pkey PRIMARY KEY (role_permission_sno);


--
-- Name: role_menu role_menu_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.role_menu
    ADD CONSTRAINT role_menu_pkey PRIMARY KEY (role_menu_sno);


--
-- Name: sales_order_dtl sales_order_dtl_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sales_order_dtl
    ADD CONSTRAINT sales_order_dtl_pkey PRIMARY KEY (sales_order_dtl_sno);


--
-- Name: sales_order sales_order_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sales_order
    ADD CONSTRAINT sales_order_pkey PRIMARY KEY (sales_order_sno);


--
-- Name: signin_info signin_info_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.signin_info
    ADD CONSTRAINT signin_info_pkey PRIMARY KEY (signin_info_sno);


--
-- Name: sku_inventory sku_inventory_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_inventory
    ADD CONSTRAINT sku_inventory_pkey PRIMARY KEY (sku_inventory_sno);


--
-- Name: sku_trace_wf sku_trace_wf_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_trace_wf
    ADD CONSTRAINT sku_trace_wf_pkey PRIMARY KEY (sku_trace_wf_sno);


--
-- Name: state state_pkey; Type: CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (state_sno);


--
-- Name: etl_job etl_job_tracking_pkey; Type: CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_job
    ADD CONSTRAINT etl_job_tracking_pkey PRIMARY KEY (etl_job_sno);


--
-- Name: etl_table_column etl_table_column_pkey; Type: CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_table_column
    ADD CONSTRAINT etl_table_column_pkey PRIMARY KEY (etl_table_column_sno);


--
-- Name: order_etl_hdr order_etl_hdr_pkey; Type: CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.order_etl_hdr
    ADD CONSTRAINT order_etl_hdr_pkey PRIMARY KEY (order_etl_hdr_sno);


--
-- Name: etl_record row_processing_status_pkey; Type: CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_record
    ADD CONSTRAINT row_processing_status_pkey PRIMARY KEY (etl_record_sno);


--
-- Name: swiggy_staging swiggy_staging_pkey; Type: CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.swiggy_staging
    ADD CONSTRAINT swiggy_staging_pkey PRIMARY KEY (swiggy_staging_sno);


--
-- Name: swiggy_staging swiggy_staging_sku_unique_code_key; Type: CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.swiggy_staging
    ADD CONSTRAINT swiggy_staging_sku_unique_code_key UNIQUE (sku_unique_code);


--
-- Name: app_user_role app_user_role_app_role_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_user_role
    ADD CONSTRAINT app_user_role_app_role_sno_fkey FOREIGN KEY (app_role_sno) REFERENCES auth.app_role(app_role_sno);


--
-- Name: app_user_role app_user_role_app_user_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.app_user_role
    ADD CONSTRAINT app_user_role_app_user_sno_fkey FOREIGN KEY (app_user_sno) REFERENCES auth.app_user(app_user_sno);


--
-- Name: codes_dtl codes_dtl_codes_hdr_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.codes_dtl
    ADD CONSTRAINT codes_dtl_codes_hdr_sno_fkey FOREIGN KEY (codes_hdr_sno) REFERENCES auth.codes_hdr(codes_hdr_sno);


--
-- Name: menu_permission menu_function_app_function_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.menu_permission
    ADD CONSTRAINT menu_function_app_function_sno_fkey FOREIGN KEY (app_permission_sno) REFERENCES auth.app_permission(app_permission_sno);


--
-- Name: menu_permission menu_function_app_menu_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.menu_permission
    ADD CONSTRAINT menu_function_app_menu_sno_fkey FOREIGN KEY (app_menu_sno) REFERENCES auth.app_menu(app_menu_sno);


--
-- Name: otp otp_app_user_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.otp
    ADD CONSTRAINT otp_app_user_sno_fkey FOREIGN KEY (app_user_sno) REFERENCES auth.app_user(app_user_sno);


--
-- Name: otp otp_otp_expire_time_cd_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.otp
    ADD CONSTRAINT otp_otp_expire_time_cd_fkey FOREIGN KEY (otp_expire_time_cd) REFERENCES auth.codes_dtl(codes_dtl_sno);


--
-- Name: role_permission role_function_app_function_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.role_permission
    ADD CONSTRAINT role_function_app_function_sno_fkey FOREIGN KEY (app_permission_sno) REFERENCES auth.app_permission(app_permission_sno);


--
-- Name: role_permission role_function_app_role_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.role_permission
    ADD CONSTRAINT role_function_app_role_sno_fkey FOREIGN KEY (app_role_sno) REFERENCES auth.app_role(app_role_sno);


--
-- Name: role_menu role_menu_app_role_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.role_menu
    ADD CONSTRAINT role_menu_app_role_sno_fkey FOREIGN KEY (app_role_sno) REFERENCES auth.app_role(app_role_sno);


--
-- Name: signin_info signin_info_app_user_sno_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.signin_info
    ADD CONSTRAINT signin_info_app_user_sno_fkey FOREIGN KEY (app_user_sno) REFERENCES auth.app_user(app_user_sno);


--
-- Name: signin_info signin_info_device_type_cd_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.signin_info
    ADD CONSTRAINT signin_info_device_type_cd_fkey FOREIGN KEY (device_type_cd) REFERENCES auth.codes_dtl(codes_dtl_sno);


--
-- Name: app_user_role app_user_role_app_role_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_user_role
    ADD CONSTRAINT app_user_role_app_role_sno_fkey FOREIGN KEY (app_role_sno) REFERENCES masters.app_role(app_role_sno);


--
-- Name: app_user_role app_user_role_app_user_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.app_user_role
    ADD CONSTRAINT app_user_role_app_user_sno_fkey FOREIGN KEY (app_user_sno) REFERENCES masters.app_user(app_user_sno);


--
-- Name: area area_city_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.area
    ADD CONSTRAINT area_city_sno_fkey FOREIGN KEY (city_sno) REFERENCES masters.city(city_sno);


--
-- Name: area area_country_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.area
    ADD CONSTRAINT area_country_sno_fkey FOREIGN KEY (country_sno) REFERENCES masters.country(country_sno);


--
-- Name: area area_state_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.area
    ADD CONSTRAINT area_state_sno_fkey FOREIGN KEY (state_sno) REFERENCES masters.state(state_sno);


--
-- Name: box_cell box_cell_entity_infra_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell
    ADD CONSTRAINT box_cell_entity_infra_sno_fkey FOREIGN KEY (entity_infra_sno) REFERENCES masters.entity_infra(entity_infra_sno);


--
-- Name: box_cell_food box_cell_food_box_cell_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell_food
    ADD CONSTRAINT box_cell_food_box_cell_sno_fkey FOREIGN KEY (box_cell_sno) REFERENCES masters.box_cell(box_cell_sno);


--
-- Name: box_cell_food box_cell_food_qbox_entity_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell_food
    ADD CONSTRAINT box_cell_food_qbox_entity_sno_fkey FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: box_cell_food box_cell_food_sku_inventory_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell_food
    ADD CONSTRAINT box_cell_food_sku_inventory_sno_fkey FOREIGN KEY (sku_inventory_sno) REFERENCES masters.sku_inventory(sku_inventory_sno);


--
-- Name: box_cell box_cell_qbox_entity_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.box_cell
    ADD CONSTRAINT box_cell_qbox_entity_sno_fkey FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: city city_country_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.city
    ADD CONSTRAINT city_country_sno_fkey FOREIGN KEY (country_sno) REFERENCES masters.country(country_sno);


--
-- Name: city city_state_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.city
    ADD CONSTRAINT city_state_sno_fkey FOREIGN KEY (state_sno) REFERENCES masters.state(state_sno);


--
-- Name: delivery_partner delivery_partner_partner_status_cd_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.delivery_partner
    ADD CONSTRAINT delivery_partner_partner_status_cd_fkey FOREIGN KEY (partner_status_cd) REFERENCES masters.codes_dtl(codes_dtl_sno);


--
-- Name: entity_infra entity_infra_infra_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.entity_infra
    ADD CONSTRAINT entity_infra_infra_sno_fkey FOREIGN KEY (infra_sno) REFERENCES masters.infra(infra_sno);


--
-- Name: entity_infra_property entity_infra_property_entity_infra_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.entity_infra_property
    ADD CONSTRAINT entity_infra_property_entity_infra_sno_fkey FOREIGN KEY (entity_infra_sno) REFERENCES masters.entity_infra(entity_infra_sno);


--
-- Name: entity_infra_property entity_infra_property_infra_property_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.entity_infra_property
    ADD CONSTRAINT entity_infra_property_infra_property_sno_fkey FOREIGN KEY (infra_property_sno) REFERENCES masters.infra_property(infra_property_sno);


--
-- Name: entity_infra entity_infra_qbox_entity_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.entity_infra
    ADD CONSTRAINT entity_infra_qbox_entity_sno_fkey FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: sku_inventory fk_qbox_entity; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_inventory
    ADD CONSTRAINT fk_qbox_entity FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: purchase_order_dtl fk_qbox_entity; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order_dtl
    ADD CONSTRAINT fk_qbox_entity FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: sku_inventory fk_restaurant_food_sku; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_inventory
    ADD CONSTRAINT fk_restaurant_food_sku FOREIGN KEY (restaurant_food_sku_sno) REFERENCES masters.restaurant_food_sku(restaurant_food_sku_sno);


--
-- Name: infra_property infra_property_data_type_cd_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.infra_property
    ADD CONSTRAINT infra_property_data_type_cd_fkey FOREIGN KEY (data_type_cd) REFERENCES masters.codes_dtl(codes_dtl_sno);


--
-- Name: infra_property infra_property_infra_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.infra_property
    ADD CONSTRAINT infra_property_infra_sno_fkey FOREIGN KEY (infra_sno) REFERENCES masters.infra(infra_sno);


--
-- Name: menu_permission menu_function_app_function_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.menu_permission
    ADD CONSTRAINT menu_function_app_function_sno_fkey FOREIGN KEY (app_permission_sno) REFERENCES masters.app_permission(app_permission_sno);


--
-- Name: menu_permission menu_function_app_menu_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.menu_permission
    ADD CONSTRAINT menu_function_app_menu_sno_fkey FOREIGN KEY (app_menu_sno) REFERENCES masters.app_menu(app_menu_sno);


--
-- Name: otp otp_app_user_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.otp
    ADD CONSTRAINT otp_app_user_sno_fkey FOREIGN KEY (app_user_sno) REFERENCES masters.app_user(app_user_sno);


--
-- Name: otp otp_otp_expire_time_cd_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.otp
    ADD CONSTRAINT otp_otp_expire_time_cd_fkey FOREIGN KEY (otp_expire_time_cd) REFERENCES masters.codes_dtl(codes_dtl_sno);


--
-- Name: partner_food_sku partner_food_sku_delivery_partner_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: qbox_admin
--

ALTER TABLE ONLY masters.partner_food_sku
    ADD CONSTRAINT partner_food_sku_delivery_partner_sno_fkey FOREIGN KEY (delivery_partner_sno) REFERENCES masters.delivery_partner(delivery_partner_sno);


--
-- Name: partner_food_sku partner_food_sku_food_sku_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: qbox_admin
--

ALTER TABLE ONLY masters.partner_food_sku
    ADD CONSTRAINT partner_food_sku_food_sku_sno_fkey FOREIGN KEY (food_sku_sno) REFERENCES masters.food_sku(food_sku_sno);


--
-- Name: purchase_order purchase_order_delivery_partner_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order
    ADD CONSTRAINT purchase_order_delivery_partner_sno_fkey FOREIGN KEY (delivery_partner_sno) REFERENCES masters.delivery_partner(delivery_partner_sno);


--
-- Name: purchase_order_dtl purchase_order_dtl_purchase_order_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order_dtl
    ADD CONSTRAINT purchase_order_dtl_purchase_order_sno_fkey FOREIGN KEY (purchase_order_sno) REFERENCES masters.purchase_order(purchase_order_sno);


--
-- Name: purchase_order_dtl purchase_order_dtl_restaurant_food_sku_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order_dtl
    ADD CONSTRAINT purchase_order_dtl_restaurant_food_sku_sno_fkey FOREIGN KEY (restaurant_food_sku_sno) REFERENCES masters.restaurant_food_sku(restaurant_food_sku_sno);


--
-- Name: purchase_order purchase_order_qbox_entity_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order
    ADD CONSTRAINT purchase_order_qbox_entity_sno_fkey FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: purchase_order purchase_order_restaurant_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.purchase_order
    ADD CONSTRAINT purchase_order_restaurant_sno_fkey FOREIGN KEY (restaurant_sno) REFERENCES masters.restaurant(restaurant_sno);


--
-- Name: qbox_entity qbox_entity_address_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity
    ADD CONSTRAINT qbox_entity_address_sno_fkey FOREIGN KEY (address_sno) REFERENCES masters.address(address_sno);


--
-- Name: qbox_entity qbox_entity_area_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity
    ADD CONSTRAINT qbox_entity_area_sno_fkey FOREIGN KEY (area_sno) REFERENCES masters.area(area_sno);


--
-- Name: qbox_entity_delivery_partner qbox_entity_delivery_partner_delivery_partner_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity_delivery_partner
    ADD CONSTRAINT qbox_entity_delivery_partner_delivery_partner_sno_fkey FOREIGN KEY (delivery_partner_sno) REFERENCES masters.delivery_partner(delivery_partner_sno);


--
-- Name: qbox_entity_delivery_partner qbox_entity_delivery_partner_delivery_type_cd_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity_delivery_partner
    ADD CONSTRAINT qbox_entity_delivery_partner_delivery_type_cd_fkey FOREIGN KEY (delivery_type_cd) REFERENCES masters.codes_dtl(codes_dtl_sno);


--
-- Name: qbox_entity_delivery_partner qbox_entity_delivery_partner_qbox_entity_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity_delivery_partner
    ADD CONSTRAINT qbox_entity_delivery_partner_qbox_entity_sno_fkey FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: qbox_entity qbox_entity_qbox_entity_status_cd_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.qbox_entity
    ADD CONSTRAINT qbox_entity_qbox_entity_status_cd_fkey FOREIGN KEY (qbox_entity_status_cd) REFERENCES masters.codes_dtl(codes_dtl_sno);


--
-- Name: restaurant restaurant_address_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant
    ADD CONSTRAINT restaurant_address_sno_fkey FOREIGN KEY (address_sno) REFERENCES masters.address(address_sno);


--
-- Name: restaurant restaurant_area_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant
    ADD CONSTRAINT restaurant_area_sno_fkey FOREIGN KEY (area_sno) REFERENCES masters.area(area_sno);


--
-- Name: restaurant_food_sku restaurant_food_sku_food_sku_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant_food_sku
    ADD CONSTRAINT restaurant_food_sku_food_sku_sno_fkey FOREIGN KEY (food_sku_sno) REFERENCES masters.food_sku(food_sku_sno);


--
-- Name: restaurant_food_sku restaurant_food_sku_restaurant_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.restaurant_food_sku
    ADD CONSTRAINT restaurant_food_sku_restaurant_sno_fkey FOREIGN KEY (restaurant_sno) REFERENCES masters.restaurant(restaurant_sno);


--
-- Name: role_permission role_function_app_function_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.role_permission
    ADD CONSTRAINT role_function_app_function_sno_fkey FOREIGN KEY (app_permission_sno) REFERENCES masters.app_permission(app_permission_sno);


--
-- Name: role_permission role_function_app_role_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.role_permission
    ADD CONSTRAINT role_function_app_role_sno_fkey FOREIGN KEY (app_role_sno) REFERENCES masters.app_role(app_role_sno);


--
-- Name: role_menu role_menu_app_role_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.role_menu
    ADD CONSTRAINT role_menu_app_role_sno_fkey FOREIGN KEY (app_role_sno) REFERENCES masters.app_role(app_role_sno);


--
-- Name: sales_order sales_order_delivery_partner_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sales_order
    ADD CONSTRAINT sales_order_delivery_partner_sno_fkey FOREIGN KEY (delivery_partner_sno) REFERENCES masters.delivery_partner(delivery_partner_sno);


--
-- Name: sales_order_dtl sales_order_dtl_restaurant_food_sku_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sales_order_dtl
    ADD CONSTRAINT sales_order_dtl_restaurant_food_sku_sno_fkey FOREIGN KEY (restaurant_food_sku_sno) REFERENCES masters.restaurant_food_sku(restaurant_food_sku_sno);


--
-- Name: sales_order_dtl sales_order_dtl_sales_order_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sales_order_dtl
    ADD CONSTRAINT sales_order_dtl_sales_order_sno_fkey FOREIGN KEY (sales_order_sno) REFERENCES masters.sales_order(sales_order_sno);


--
-- Name: sales_order sales_order_qbox_entity_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sales_order
    ADD CONSTRAINT sales_order_qbox_entity_sno_fkey FOREIGN KEY (qbox_entity_sno) REFERENCES masters.qbox_entity(qbox_entity_sno);


--
-- Name: signin_info signin_info_app_user_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.signin_info
    ADD CONSTRAINT signin_info_app_user_sno_fkey FOREIGN KEY (app_user_sno) REFERENCES masters.app_user(app_user_sno);


--
-- Name: signin_info signin_info_device_type_cd_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.signin_info
    ADD CONSTRAINT signin_info_device_type_cd_fkey FOREIGN KEY (device_type_cd) REFERENCES masters.codes_dtl(codes_dtl_sno);


--
-- Name: sku_inventory sku_inventory_purchase_order_dtl_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_inventory
    ADD CONSTRAINT sku_inventory_purchase_order_dtl_sno_fkey FOREIGN KEY (purchase_order_dtl_sno) REFERENCES masters.purchase_order_dtl(purchase_order_dtl_sno);


--
-- Name: sku_inventory sku_inventory_sales_order_dtl_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_inventory
    ADD CONSTRAINT sku_inventory_sales_order_dtl_sno_fkey FOREIGN KEY (sales_order_dtl_sno) REFERENCES masters.sales_order_dtl(sales_order_dtl_sno);


--
-- Name: sku_trace_wf sku_trace_wf_sku_inventory_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_trace_wf
    ADD CONSTRAINT sku_trace_wf_sku_inventory_sno_fkey FOREIGN KEY (sku_inventory_sno) REFERENCES masters.sku_inventory(sku_inventory_sno);


--
-- Name: sku_trace_wf sku_trace_wf_wf_stage_cd_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.sku_trace_wf
    ADD CONSTRAINT sku_trace_wf_wf_stage_cd_fkey FOREIGN KEY (wf_stage_cd) REFERENCES masters.codes_dtl(codes_dtl_sno) NOT VALID;


--
-- Name: state state_country_sno_fkey; Type: FK CONSTRAINT; Schema: masters; Owner: postgres
--

ALTER TABLE ONLY masters.state
    ADD CONSTRAINT state_country_sno_fkey FOREIGN KEY (country_sno) REFERENCES masters.country(country_sno);


--
-- Name: etl_table_column etl_table_column_order_etl_table_sno_fkey; Type: FK CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_table_column
    ADD CONSTRAINT etl_table_column_order_etl_table_sno_fkey FOREIGN KEY (order_etl_hdr_sno) REFERENCES partner_order.order_etl_hdr(order_etl_hdr_sno);


--
-- Name: order_etl_hdr order_etl_hdr_delivery_partner_sno_fkey; Type: FK CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.order_etl_hdr
    ADD CONSTRAINT order_etl_hdr_delivery_partner_sno_fkey FOREIGN KEY (delivery_partner_sno) REFERENCES masters.delivery_partner(delivery_partner_sno) NOT VALID;


--
-- Name: etl_job order_etl_hdr_sno_id_fkey; Type: FK CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_job
    ADD CONSTRAINT order_etl_hdr_sno_id_fkey FOREIGN KEY (order_etl_hdr_sno) REFERENCES partner_order.order_etl_hdr(order_etl_hdr_sno) ON DELETE CASCADE;


--
-- Name: etl_record row_processing_status_job_id_fkey; Type: FK CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.etl_record
    ADD CONSTRAINT row_processing_status_job_id_fkey FOREIGN KEY (etl_job_sno) REFERENCES partner_order.etl_job(etl_job_sno) ON DELETE CASCADE;


--
-- Name: swiggy_staging swiggy_staging_etl_job_sno_fkey; Type: FK CONSTRAINT; Schema: partner_order; Owner: postgres
--

ALTER TABLE ONLY partner_order.swiggy_staging
    ADD CONSTRAINT swiggy_staging_etl_job_sno_fkey FOREIGN KEY (etl_job_sno) REFERENCES partner_order.etl_job(etl_job_sno) NOT VALID;


--
-- PostgreSQL database dump complete
--
