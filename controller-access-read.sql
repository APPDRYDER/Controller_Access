#
# Read Controller Access Key and Global Account Name
# Ref: Ref: https://docs.appdynamics.com/display/PRO45/Controller+Secure+Credential+Store
#
SET @ACCOUNT_NAME        = "customer1";
SET @ACCOUNT_ID          = "2";
#
SELECT name, id, encryption_scheme, access_key, global_account_name
  FROM account
  WHERE id = @ACCOUNT_ID
  AND name COLLATE utf8_unicode_ci = @ACCOUNT_NAME;
#
#
