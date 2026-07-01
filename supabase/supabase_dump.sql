--
-- PostgreSQL database dump
--

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.9 (Ubuntu 17.9-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: device_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.device_type AS ENUM (
    'door',
    'gate',
    'turnstile',
    'ramp'
);


--
-- Name: system_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.system_role AS ENUM (
    'owner',
    'manager',
    'user'
);


--
-- Name: bulk_create_devices(text, integer, text, uuid, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.bulk_create_devices(name_prefix text, count integer, device_type text, company_id uuid, building_id uuid, pad_length integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  i int;
BEGIN
  FOR i IN 1..count LOOP
    INSERT INTO public.devices (name, type, company_id, created_utc, updated_utc, deleted_utc, is_deleted, building_id) 
    VALUES (
      name_prefix || LPAD(i::text, pad_length, '0'),
      device_type::public.device_type, 
      company_id,
      NOW(),
      NOW(),
      NULL,
      FALSE,
      building_id
    );
  END LOOP;
END;
$$;


--
-- Name: can_unlock_device(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_unlock_device(user_id uuid, device_id uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.accounts a
    JOIN public.account_access_key aak ON a.id = aak.account_id
    JOIN public.device_access_key dak ON aak.access_key_id = dak.access_key_id
    WHERE a.id = user_id
    AND dak.device_id = can_unlock_device.device_id
    AND aak.valid_from_utc <= NOW()
    AND aak.valid_to_utc >= NOW()
    AND a.is_deleted = false
  );
END;
$$;


--
-- Name: check_data_integrity(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_data_integrity(company_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  issues JSON[];
BEGIN
  -- Check for orphaned areas
  SELECT array_agg(
    json_build_object(
      'type', 'orphaned_area',
      'message', 'Area "' || name || '" has invalid company_id',
      'entity_id', id
    )
  ) INTO issues
  FROM public.areas a
  WHERE a.company_id = check_data_integrity.company_id
  AND NOT EXISTS (SELECT 1 FROM public.companies c WHERE c.id = a.company_id);

  -- Check for orphaned buildings
  SELECT array_agg(
    json_build_object(
      'type', 'orphaned_building',
      'message', 'Building "' || name || '" has invalid area_id',
      'entity_id', id
    )
  ) INTO issues
  FROM public.buildings b
  WHERE b.company_id = check_data_integrity.company_id
  AND NOT EXISTS (SELECT 1 FROM public.areas a WHERE a.id = b.area_id);

  -- Check for invalid device-access_key relationships
  SELECT array_agg(
    json_build_object(
      'type', 'invalid_device_access_key',
      'message', 'Device-AccessKey relationship references non-existent device or access key',
      'device_id', dak.device_id,
      'access_key_id', dak.access_key_id
    )
  ) INTO issues
  FROM public.device_access_key dak
  WHERE NOT EXISTS (SELECT 1 FROM public.devices d WHERE d.id = dak.device_id AND d.company_id = check_data_integrity.company_id)
  OR NOT EXISTS (SELECT 1 FROM public.access_keys ak WHERE ak.id = dak.access_key_id AND ak.company_id = check_data_integrity.company_id);

  RETURN json_build_object(
    'has_issues', COALESCE(array_length(issues, 1), 0) > 0,
    'issue_count', COALESCE(array_length(issues, 1), 0),
    'issues', COALESCE(issues, '[]'::JSON[]),
    'checked_at', NOW()
  );
END;
$$;


--
-- Name: delete_user_account(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_user_account(target_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Deleting from auth.users will automatically cascade 
  -- and delete the row in public.accounts (thanks to Step 1)
  DELETE FROM auth.users 
  WHERE id = target_user_id;
END;
$$;


--
-- Name: get_building_hierarchy(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_building_hierarchy(building_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'building', json_build_object(
      'id', b.id,
      'name', b.name,
      'address', b.address,
      'area', json_build_object(
        'id', a.id,
        'name', a.name,
        'location', a.location
      )
    ),
    'devices', (
      SELECT json_agg(
        json_build_object(
          'id', d.id,
          'name', d.name,
          'type', d.type
        )
      )
      FROM public.devices d
      JOIN public.device_access_key dak ON dak.device_id = d.id
      JOIN public.access_keys ak ON ak.id = dak.access_key_id
      WHERE ak.building_id = get_building_hierarchy.building_id
      AND d.is_deleted = false
    )
  ) INTO result
  FROM public.buildings b
  JOIN public.areas a ON a.id = b.area_id
  WHERE b.id = get_building_hierarchy.building_id
  AND b.is_deleted = false;

  RETURN result;
END;
$$;


--
-- Name: get_company_accesses_with_relations(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_company_accesses_with_relations(p_company_id uuid) RETURNS TABLE(key_id uuid, key_name character varying, company_id uuid, building_id uuid, created_utc timestamp with time zone, updated_utc timestamp with time zone, is_deleted boolean, device_ids uuid[])
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ak.id AS key_id,
    ak.name AS key_name,
    ak.company_id,
    ak.building_id,
    ak.created_utc,
    ak.updated_utc,
    ak.is_deleted,
    COALESCE(
      ARRAY_AGG(DISTINCT dak.device_id) FILTER (WHERE dak.device_id IS NOT NULL),
      '{}'
    ) AS device_ids
  FROM public.access_keys ak
  LEFT JOIN public.device_access_key dak ON ak.id = dak.access_key_id
  WHERE ak.company_id = p_company_id
  AND ak.is_deleted = false
  GROUP BY ak.id;
END;
$$;


--
-- Name: get_company_statistics(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_company_statistics(p_company_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  result json;
BEGIN
  SELECT json_build_object(
    'areas_count',       (SELECT COUNT(id) FROM public.areas WHERE company_id = p_company_id AND is_deleted = false),
    'buildings_count',   (SELECT COUNT(id) FROM public.buildings WHERE company_id = p_company_id AND is_deleted = false),
    'devices_count',     (SELECT COUNT(id) FROM public.devices WHERE company_id = p_company_id AND is_deleted = false),
    'access_keys_count', (SELECT COUNT(id) FROM public.access_keys WHERE company_id = p_company_id AND is_deleted = false),
    'accounts_count',    (SELECT COUNT(id) FROM public.accounts WHERE company_id = p_company_id AND is_deleted = false)
  ) INTO result;
  RETURN result;
END;
$$;


--
-- Name: get_user_access_statistics(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_access_statistics(p_account_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_access_key_ids uuid[];
  result json;
BEGIN
  -- 1. Get all active access key IDs for the user
  SELECT ARRAY_AGG(access_key_id) INTO v_access_key_ids
  FROM public.account_access_key
  WHERE account_id = p_account_id;

  -- 2. Calculate stats based on those access keys
  SELECT json_build_object(
    'access_keys_count', COALESCE(array_length(v_access_key_ids, 1), 0),
    'devices_count', (
      SELECT COUNT(DISTINCT dak.device_id)
      FROM public.device_access_key dak
      JOIN public.devices d ON dak.device_id = d.id
      WHERE dak.access_key_id = ANY(v_access_key_ids)
      AND d.is_deleted = false
    ),
    'buildings_count', (
      SELECT COUNT(DISTINCT d.building_id)
      FROM public.device_access_key dak
      JOIN public.devices d ON dak.device_id = d.id
      WHERE dak.access_key_id = ANY(v_access_key_ids)
      AND d.is_deleted = false
    ),
    'areas_count', (
      SELECT COUNT(DISTINCT a.id)
      FROM public.areas a
      JOIN public.buildings b ON a.id = b.area_id
      JOIN public.devices d ON d.building_id = b.id
      JOIN public.device_access_key dak ON dak.device_id = d.id
      WHERE dak.access_key_id = ANY(v_access_key_ids)
      AND d.is_deleted = false
      AND b.is_deleted = false
      AND a.is_deleted = false
    )
  ) INTO result;
  RETURN result;
END;
$$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_company_id uuid;
  v_role_text text; 
begin
  -- 1. Parse Company ID safely
  begin
    v_company_id := (new.raw_user_meta_data->>'company_id')::uuid;
  exception when others then
    v_company_id := null; 
  end;

  -- 2. Extract the Role from metadata
  -- Since our Edge Function sends { role: 'area_manager' }, this will capture it.
  v_role_text := coalesce(new.raw_user_meta_data->>'role', 'user');

  -- 3. Insert into public.accounts
  insert into public.accounts (
    id,
    email,
    company_id,
    role, -- This expects public.system_role type
    created_utc,
    updated_utc,
    deleted_utc,
    is_deleted
  )
  values (
    new.id,
    new.email,
    v_company_id,
    
    -- ✅ CRITICAL: Cast the text to the system_role Enum
    -- If v_role_text is 'area_manager', this casts it to the Enum value.
    v_role_text::public.system_role, 
    
    now(),
    now(),
    '1970-01-01 00:00:00+00', 
    false
  );

  return new;
end;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_utc = NOW();
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_keys (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    company_id uuid,
    building_id uuid,
    created_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    deleted_utc timestamp with time zone DEFAULT '1970-01-01 00:00:00+00'::timestamp with time zone,
    is_deleted boolean DEFAULT false
);


--
-- Name: account_access_key; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_access_key (
    account_id uuid NOT NULL,
    access_key_id uuid NOT NULL,
    granted_by uuid,
    granted_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    valid_from_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    valid_to_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL
);


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    role public.system_role DEFAULT 'user'::public.system_role,
    company_id uuid,
    created_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    deleted_utc timestamp with time zone,
    is_deleted boolean DEFAULT false
);


--
-- Name: areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.areas (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    company_id uuid,
    created_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    deleted_utc timestamp with time zone,
    is_deleted boolean DEFAULT false
);


--
-- Name: buildings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.buildings (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    area_id uuid,
    company_id uuid,
    created_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    deleted_utc timestamp with time zone,
    is_deleted boolean DEFAULT false
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    created_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    deleted_utc timestamp with time zone,
    is_deleted boolean DEFAULT false
);


--
-- Name: device_access_key; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_access_key (
    device_id uuid NOT NULL,
    access_key_id uuid NOT NULL
);


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devices (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    type public.device_type DEFAULT 'door'::public.device_type,
    company_id uuid,
    created_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_utc timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    deleted_utc timestamp with time zone,
    is_deleted boolean DEFAULT false,
    building_id uuid
);


--
-- Name: account_access_key account_access_key_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_access_key
    ADD CONSTRAINT account_access_key_pkey PRIMARY KEY (account_id, access_key_id);


--
-- Name: accounts accounts_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_email_key UNIQUE (email);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: buildings buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_pkey PRIMARY KEY (id);


--
-- Name: device_access_key device_access_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_access_key
    ADD CONSTRAINT device_access_keys_pkey PRIMARY KEY (device_id, access_key_id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: companies owners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT owners_pkey PRIMARY KEY (id);


--
-- Name: access_keys roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_keys
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: idx_accounts_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_accounts_email ON public.accounts USING btree (email);


--
-- Name: idx_accounts_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_accounts_owner_id ON public.accounts USING btree (company_id);


--
-- Name: idx_areas_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_areas_owner_id ON public.areas USING btree (company_id);


--
-- Name: idx_buildings_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_buildings_area_id ON public.buildings USING btree (area_id);


--
-- Name: idx_buildings_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_buildings_owner_id ON public.buildings USING btree (company_id);


--
-- Name: idx_devices_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_devices_owner_id ON public.devices USING btree (company_id);


--
-- Name: idx_roles_building_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_building_id ON public.access_keys USING btree (building_id);


--
-- Name: idx_roles_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_owner_id ON public.access_keys USING btree (company_id);


--
-- Name: access_keys update_access_keys_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_access_keys_updated_at BEFORE UPDATE ON public.access_keys FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: accounts update_accounts_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_accounts_updated_at BEFORE UPDATE ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: areas update_areas_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_areas_updated_at BEFORE UPDATE ON public.areas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: buildings update_buildings_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_buildings_updated_at BEFORE UPDATE ON public.buildings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: companies update_companies_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON public.companies FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: devices update_devices_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_devices_updated_at BEFORE UPDATE ON public.devices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: account_access_key account_role_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_access_key
    ADD CONSTRAINT account_role_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: account_access_key account_role_granted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_access_key
    ADD CONSTRAINT account_role_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES public.accounts(id);


--
-- Name: account_access_key account_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_access_key
    ADD CONSTRAINT account_role_role_id_fkey FOREIGN KEY (access_key_id) REFERENCES public.access_keys(id) ON DELETE CASCADE;


--
-- Name: accounts accounts_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: accounts accounts_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: areas areas_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: buildings buildings_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id) ON DELETE CASCADE;


--
-- Name: buildings buildings_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: device_access_key device_role_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_access_key
    ADD CONSTRAINT device_role_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id) ON DELETE CASCADE;


--
-- Name: device_access_key device_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_access_key
    ADD CONSTRAINT device_role_role_id_fkey FOREIGN KEY (access_key_id) REFERENCES public.access_keys(id) ON DELETE CASCADE;


--
-- Name: devices devices_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.buildings(id) ON DELETE CASCADE;


--
-- Name: devices devices_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: access_keys roles_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_keys
    ADD CONSTRAINT roles_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.buildings(id) ON DELETE CASCADE;


--
-- Name: access_keys roles_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_keys
    ADD CONSTRAINT roles_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: access_keys Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.access_keys TO authenticated USING (true) WITH CHECK (true);


--
-- Name: account_access_key Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.account_access_key TO authenticated USING (true) WITH CHECK (true);


--
-- Name: accounts Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.accounts TO authenticated USING (true) WITH CHECK (true);


--
-- Name: areas Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.areas TO authenticated USING (true) WITH CHECK (true);


--
-- Name: buildings Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.buildings TO authenticated USING (true) WITH CHECK (true);


--
-- Name: companies Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.companies TO authenticated USING (true) WITH CHECK (true);


--
-- Name: device_access_key Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.device_access_key TO authenticated USING (true) WITH CHECK (true);


--
-- Name: devices Enable full access for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable full access for authenticated users" ON public.devices TO authenticated USING (true) WITH CHECK (true);


--
-- Name: access_keys; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.access_keys ENABLE ROW LEVEL SECURITY;

--
-- Name: account_access_key; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.account_access_key ENABLE ROW LEVEL SECURITY;

--
-- Name: accounts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;

--
-- Name: areas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.areas ENABLE ROW LEVEL SECURITY;

--
-- Name: buildings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.buildings ENABLE ROW LEVEL SECURITY;

--
-- Name: companies; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

--
-- Name: device_access_key; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.device_access_key ENABLE ROW LEVEL SECURITY;

--
-- Name: devices; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.devices ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--