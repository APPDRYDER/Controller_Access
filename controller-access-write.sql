#
# Update Controller Access Key and Global Account Name
# Ref: https://docs.appdynamics.com/display/PRO45/Controller+Secure+Credential+Store
#
# Only update customer1 and with id 2
SET @ACCOUNT_NAME        = "customer1";
SET @ACCOUNT_ID          = "2";
#
SELECT @ACCESS_KEY ;
SELECT @GLOBAL_ACCOUNT_NAME ;
# Update account access key
#
UPDATE account
  SET access_key = @ACCESS_KEY, encryption_scheme = NULL
  WHERE id = @ACCOUNT_ID
  AND name COLLATE utf8_unicode_ci = @ACCOUNT_NAME;
#
# Update account access key for agent users
#
UPDATE user
  SET encrypted_password = SHA1( @ACCESS_KEY )
  WHERE id = @ACCOUNT_ID
  AND name = 'singularity-agent';
#
# Update Global Account Name
#
UPDATE account
  SET global_account_name = @GLOBAL_ACCOUNT_NAME
  WHERE id = @ACCOUNT_ID
  AND name COLLATE utf8_unicode_ci = @ACCOUNT_NAME;
#
#
commit;
#
# Validate
#
SELECT name, id, encryption_scheme, access_key, global_account_name
  FROM account
  WHERE id = @ACCOUNT_ID
  AND name COLLATE utf8_unicode_ci = @ACCOUNT_NAME;
#
