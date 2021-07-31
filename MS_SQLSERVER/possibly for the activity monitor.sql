
select object_id as id, 
    null as id2,
    case
        when [is_filetable] = 1 then 'UF'
        else [type]
    end as [type],
    schema_name(schema_id) as name1,
    name as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.tables
where 
    is_ms_shipped != 1

union

select object_id as id, 
    null as id2,
    case
        when [type] != 'D ' then [type]
        when parent_object_id != 0 then 'D '
        else 'LD' 
    end as [type],
    schema_name(schema_id) as name1,
    name as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.objects
where 
    type != 'S'
    and type != 'U'
    and type != 'ST'
    and is_ms_shipped != 1

union

select principal_id as id, 
    null as id2,
    type, 
    name as name1, 
    null as name2, 
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.database_principals

union

select assembly_id as id, 
    null as id2,
    'CLR' as type, 
    name as name1, 
    null as name2, 
    null as name3,
    principal_id as a1,
    null as v1,
    modify_date as mod
from sys.assemblies
where
    is_user_defined =1

union

select schema_id as id, 
    null as id2,
    'SCH' as type, 
    name as name1, 
    null as name2, 
    null as name3,
    principal_id as a1,
    null as v1,
    null as mod
from sys.schemas

union

select user_type_id as id, 
    null as id2,
    case
        when is_assembly_type = 1 then 'UDT'
        when is_table_type = 1 then 'TT'
        else 'UDDT'
    end as [type],
    schema_name(schema_id) as name1,
    name as name2,
    null as name3,
    null as a1,
    binary_checksum(system_type_id, schema_id, max_length, precision, scale, is_nullable, is_assembly_type, default_object_id, rule_object_id) as v1,
    null as mod
from sys.types
where
    is_user_defined = 1

union

select 
    idx.object_id as id,
    idx.index_id as id2,
    case
        when idx.type = 3 then 
                case 
                    when ( [xi].[xml_index_type] = 0 OR [xi].[xml_index_type] = 1 ) then 'XIX'
                    else 'SXI'
                end           
        when idx.type = 4 then 'SIX'
        when idx.type = 6 then 'CIX'
        else 'IDX' 
    end as [type],
    schema_name(tab.schema_id) as name,
    tab.name as name2,
    idx.name as name3,
    null as a1,
    binary_checksum(idx.is_unique, idx.data_space_id, idx.ignore_dup_key, idx.is_primary_key, 
        idx.is_unique_constraint, idx.fill_factor, idx.is_padded, idx.is_disabled, idx.allow_row_locks, idx.allow_page_locks) as v1,
    null as mod
from sys.indexes idx 
    inner join sys.tables tab on idx.object_id = tab.object_id
    left join [sys].[xml_indexes] xi on idx.object_id = xi.object_id and  idx.index_id = xi.index_id
where 
    idx.is_primary_key = 0
    and idx.name is not null
    and idx.is_unique_constraint = 0
    and idx.is_hypothetical = 0

union

select stat.object_id as id,
    stat.stats_id as id2,
    'STAT' as [type],
    schema_name(tab.schema_id) as name,
    tab.name as name2,
    stat.name as name3,
    null as a1,
    no_recompute as v1,
    null as mod
from sys.stats stat
    inner join sys.tables tab on stat.object_id = tab.object_id
where 
    stat.user_created = 1

union

select xml_collection_id as id,
    null as id2,
    'XSC' as type,
    schema_name(schema_id),
    name as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod 
from sys.xml_schema_collections
where xml_collection_id > 1

union

select 
    object_id id,
    null id2,
    'DDT' as type,
    name,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod 
from sys.triggers
where
    parent_class = 0

union

select
    database_specification_id id,
    null as id2,
    'DAS' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.database_audit_specifications

union

select 
    certificate_id id,
    null as id2,
    'CERT' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    binary_checksum(pvt_key_encryption_type, thumbprint) as v1,
    null as mod
from sys.certificates

union

select
    asymmetric_key_id id,
    null as id2,
    'ASMK' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    null as v1,
    null as mod
from sys.asymmetric_keys

union

select
    symmetric_key_id id,
    null as id2,
    case
        when name = N'##MS_DatabaseMasterKey##' then 'MK'
        else 'SYMK'
    end as type,
    case
        when name = N'##MS_DatabaseMasterKey##' then null
        else name
    end as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    null as v1,
    modify_date as mod
from sys.symmetric_keys
where
    name = N'##MS_DatabaseMasterKey##'
    or name not like N'##%'

union

select
    fulltext_catalog_id id,
    null as id2,
    'FTC' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    binary_checksum(is_default, is_accent_sensitivity_on) as v1,
    null as mod
from sys.fulltext_catalogs

union

select
    ft.object_id id,
    ft.unique_index_id as id2,
    'FTI' as type,
    schema_name(o.schema_id) as name1,
    o.name as name2,
    null as name3,
    null as a1,
    binary_checksum(is_enabled, change_tracking_state) as v1,
    null as mod
from sys.fulltext_indexes ft
inner join sys.objects o on ft.object_id = o.object_id

union

select
    stoplist_id id,
    null as id2,
    'FTSL' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    null as v1,
    modify_date as mod
from sys.fulltext_stoplists

union

select
    data_space_id id,
    null as id2,
    [type] as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    is_default as v1,
    null as mod
from sys.data_spaces

union

select
    function_id id,
    null as id2,
    'PF' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.partition_functions

union

select
    file_id id,
    null as id2,
    'FILE' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    binary_checksum(type, data_space_id, physical_name, state, growth, is_read_only, is_sparse, is_percent_growth) as v1,
    null as mod
from sys.database_files


union

select
    message_type_id id,
    null as id2,
    'MT' as [type],
    name collate database_default as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    binary_checksum(validation, xml_collection_id) as v1,
    null as mod
from sys.service_message_types

union

select
    service_contract_id id,
    null as id2,
    'SC' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    null as v1,
    null as mod
from sys.service_contracts

union

select
    service_id id,
    null as id2,
    'SERVICE' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    binary_checksum(service_queue_id) as v1,
    null as mod
from sys.services

union

select
    route_id id,
    null as id2,
    'ROUTE' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    binary_checksum(remote_service_name, broker_instance, lifetime, address, mirror_address) as v1,
    null as mod
from sys.routes

union

select
    remote_service_binding_id id,
    null as id2,
    'RSB' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    binary_checksum(service_contract_id, remote_principal_id, is_anonymous_on) as v1,
    null as mod
from sys.remote_service_bindings

union

select 
    object_id id,
    null as id2,
    'DEN' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.event_notifications

union

select
    priority_id id,
    null as id2,
    'SBP' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    binary_checksum(service_contract_id, local_service_id, remote_service_name, priority) as v1,
    null as mod
from sys.conversation_priorities

union

select
    property_list_id id,
    null as id2,
    'SPL' as type,
    name as name1,
    null as name2,
    null as name3,
    principal_id as a1,
    null as v1,
    modify_date as mod
from sys.registered_search_property_lists


union

select
    principal_id id,
    null as id2,
    case
        when type = N'R' then 'SUR'
        else 'LOG'
    end as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.server_principals
where is_fixed_role = 0

union

select
    audit_id id,
    null as id2,
    'SAD' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.server_audits

union

select
    credential_id id,
    null as id2,
    'CRD' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.credentials


union

select
    msg.message_id id,
    msg.language_id as id2,
    'SEM' as type,
    cast(msg.message_id as sysname) as name1,
    lang.alias collate database_default as name2,
    null as name3,
    null as a1,
    binary_checksum(msg.severity, msg.is_event_logged, msg.text) as v1,
    null as mod
from sys.messages msg inner join sys.syslanguages lang on (msg.language_id = lang.lcid)
where
    msg.message_id > 50000

union

select 
    base.endpoint_id id,
    null as id2,
    'SEP' as type,
    base.name as name1,
    null as name2,
    null as name3,
    base.principal_id as a1,
    binary_checksum(*) as v1,
    null as mod
from sys.endpoints base  
    left outer join sys.http_endpoints http on (base.endpoint_id = http.endpoint_id)
    left outer join sys.service_broker_endpoints sb on (base.endpoint_id = sb.endpoint_id)
    left outer join sys.soap_endpoints soap on (base.endpoint_id = soap.endpoint_id)
    left outer join sys.tcp_endpoints tcp on (base.endpoint_id = tcp.endpoint_id)
    left outer join sys.database_mirroring_endpoints mirror on (base.endpoint_id = mirror.endpoint_id)

union

select 
    server_id id,
    null as id2,
    'SLS' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.servers

union

select 
    logins.server_id id,
    logins.local_principal_id as id2,
    'SLL' as type,
    srvs.name as name1,
    lp.name as name2,
    null as name3,
    null as a1,
    null as v1,
    logins.modify_date as mod
from sys.linked_logins logins 
    inner join sys.servers srvs on (logins.server_id = srvs.server_id)
    left join sys.server_principals lp on (logins.local_principal_id = lp.principal_id)

union

select 
    object_id id,
    null as id2,
    'SST' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.server_triggers
where
    is_ms_shipped = 0

union

select 
    server_specification_id id,
    null as id2,
    'SAS' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    modify_date as mod
from sys.server_audit_specifications

union

select 
    event_session_id id,
    null as id2,
    'SES' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    null as v1,
    null as mod
from sys.server_event_sessions
where name != 'telemetry_xevents'

union

select 
    provider_id id,
    null as id2,
    'SCP' as type,
    name as name1,
    null as name2,
    null as name3,
    null as a1,
    binary_checksum(guid, version, dll_path, is_enabled) as v1,
    null as mod
from sys.cryptographic_providers


select 
    cast(32 as tinyint) as class,
    'SES' as type,
    ea.event_session_id as majorid,
    binary_checksum(event_id, ea.name, package, module) as minorid,
    ea.name as name,
    null as id1,
    null as id2
from sys.server_event_session_actions as ea
join sys.server_event_sessions as es on es.event_session_id = ea.event_session_id
where es.name != 'telemetry_xevents'

union

select 
    cast(32 as tinyint) as class,
    'SES' as type,
    se.event_session_id as majorid,
    event_id as minorid,
    se.name as name,
    binary_checksum(predicate) as id1,
    null as id2
from sys.server_event_session_events as se
join sys.server_event_sessions as es on es.event_session_id = se.event_session_id
where es.name != 'telemetry_xevents'

union

select 
    cast(32 as tinyint) as class,
    'SES' as type,
    sf.event_session_id as majorid,
    object_id as minorid,
    sf.name as name,
    binary_checksum(value) as id1,
    null as id2
from sys.server_event_session_fields as sf
join sys.server_event_sessions as es on es.event_session_id = sf.event_session_id
where es.name != 'telemetry_xevents'

union

select 
    cast(32 as tinyint) as class,
    'SES' as type,
    et.event_session_id as majorid,
    event_id as minorid,
    et.name as name,
    null as id1,
    null as id2
from sys.server_event_session_events as et
join sys.server_event_sessions as es on es.event_session_id = et.event_session_id
where es.name != 'telemetry_xevents'


union

select 
    perms.class as class,
    objectpropertyex(perms.major_id, 'BaseType') as type,
    perms.major_id as majorid,
    perms.minor_id as minorid,
    perms.type + perms.state collate database_default as name,
    perms.grantee_principal_id as id1,
    perms.grantor_principal_id as id2
from sys.database_permissions perms
where
    perms.major_id >= 0

union

select 
    props.class as class,
    case 
		when objs.parent_object_id > 0 then objectpropertyex(objs.parent_object_id, 'BaseType') 
		else objectpropertyex(props.major_id, 'BaseType') 
	end as type,
    case
		when objs.parent_object_id > 0 then objs.parent_object_id
		else props.major_id
	end as majorid,
    props.minor_id as minorid,
    props.name as name,
    binary_checksum(props.value) as id1,
    null as id2
from sys.extended_properties props left outer join sys.objects objs on props.major_id = objs.object_id

union

select 
    cast(4 as tinyint) as class,
    'R' as type,
    roles.role_principal_id as majorid,
    roles.member_principal_id as minorid,
    'drm' as name,
    null as id1,
    null as id2
from sys.database_role_members roles 

union

select 
    cast(6 as tinyint) as class,
    'TT' as type,
    tt.user_type_id as majorid,
    cols.column_id as minorid, 
    cols.name as name,
    binary_checksum(cols.user_type_id, cols.max_length, cols.precision, cols.scale, 
        cols.collation_name, cols.is_nullable, cols.is_ansi_padded, cols.is_rowguidcol, cols.is_identity, 
        cols.is_computed, cols.is_xml_document, cols.xml_collection_id, cols.default_object_id, cols.rule_object_id) as id1,
    null as id2
from sys.table_types tt inner join sys.columns cols on (tt.type_table_object_id = cols.object_id)


select 
    cols.object_id as tableid,
    cols.column_id as columnid, 
    binary_checksum(cols.name) as checksum
from sys.tables tabs 
    inner join sys.columns cols  on (tabs.object_id = cols.object_id)
    inner join sys.index_columns idx_cols on (idx_cols.object_id = tabs.object_id and idx_cols.column_id = cols.column_id)
where
    tabs.is_ms_shipped = 0

union

select 
    object_id as tableid,
    column_id as columnid, 
    binary_checksum(type_column_id, language_id) as checksum
from sys.fulltext_index_columns


select 
    object_id as tableid,
    index_id as indexid, 
    path_id as pathid,
    binary_checksum(path, name, path_type, xml_component_id, xquery_max_length, is_node, system_type_id, user_type_id, max_length, precision, scale, collation_name, is_singleton) as checksum
from sys.selective_xml_index_paths 


select 
    object_id as tableid,
    index_id as indexid, 
    uri as uri,
    binary_checksum(is_default_uri, prefix) as checksum
from sys.selective_xml_index_namespaces  


