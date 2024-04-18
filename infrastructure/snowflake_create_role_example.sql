-- Create a role below account admin, but that has privs to set up infrastructure
CREATE OR REPLACE ROLE infra_admin 
COMMENT = 'Role to manage infrastructure from Terraform';

-- grant privs to build infra 
-- essentially, you create a new role like accountadmin, but don't use account admin so as
-- not to risk leaking the credentials. AccountAdmin stays as the master account that cannot
-- be altered by another role 
GRANT ALL ON ACCOUNT TO ROLE infra_admin ; 

-- create a service account user for managing the infra via the infra_admin role
CREATE OR REPLACE USER sf_infra_srv_user
    PASSWORD = '' -- I've left this blank, but ensure you fill it with a strong password!
    MUST_CHANGE_PASSWORD = FALSE -- No need to force a password change on first login 
    COMMENT = 'Service Acct user for Dev team to perform infrastructure mgmt of snowflake resources' 
;

-- grant the infra role to that user 
GRANT ROLE infra_admin TO USER sf_infra_srv_user ; 

ALTER USER sf_infra_srv_user
    SET DEFAULT_ROLE = infra_admin,    -- Set a default role for the user
        DEFAULT_WAREHOUSE = compute_wh ;  -- Set a default warehouse if necessary

-- end 