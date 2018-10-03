database sysadmin;
grant dba to root;

execute function admin ('modify chunk extendable', 1);

execute function admin('STORAGEPOOL ADD', '/opt/hcl/data/spaces', 
                      0,0,'64MB',1); 
