# Experimental Semgrep config
# `Support for Jsonnet rules is experimental and currently meant for internal use only. The syntax may change or be removed at any point.`
# Figured out from https://github.com/returntocorp/semgrep/blob/519cce55b30225c33540f201cfda71a869e8137e/semgrep.jsonnet
# Language documentation: https://jsonnet.org/

# https://github.com/github/securitylab-code-analysis/blob/f7d9f34705d7785b68b89e05ce40d40540375b06/qlpacks/ql-seclab/Patches.ql#L109
local excluded_directories = [
    '*/*__tests__*/*',
    '*/test*/*',
    '*/benchmark/*',
    '*/benchmarks/*',
    '*/spec/*',
    '*/*.spec.ts',
    '*/doc/*',
    '*/docs/*',
    '*/documentation/*'
];

############################ List of rules to run ############################

# Rules can be found at https://semgrep.dev/explore
# Creating custom rules: https://semgrep.dev/docs/writing-rules/overview/

# Rules can be added as many times as needed (for tracking purposes), but
# they will only be run once.

# To add a new rule, add its id to the list below. Make sure the rule is
# present in any of the `packs` below.

local packs = [
  (import 'p/default'),
  (import 'p/javascript'),
  # (import 'rules/custom.yml'),

  # rules not present in a pack
  (import 'r/javascript.sequelize.security.audit.sequelize-raw-query.sequelize-raw-query'),
  (import 'r/csharp.dotnet.security.audit.ldap-injection.ldap-injection'),
];

local rules = [

  # https://github.com/github/securitylab-code-analysis/issues/56
  'ruby.rails.security.audit.mail-to.mail-to',
  'ruby.rails.security.audit.number-to-currency.number-to-currency',
  'ruby.rails.security.audit.xss.avoid-link-to.avoid-link-to',
  'ruby.rails.security.audit.xss.avoid-render-inline.avoid-render-inline',
  'ruby.rails.security.audit.xss.avoid-render-text.avoid-render-text',
  'ruby.rails.security.audit.xss.manual-template-creation.manual-template-creation',

  # https://github.com/github/securitylab-code-analysis/issues/57
  'ruby.lang.security.dangerous-exec.dangerous-exec',
  'ruby.lang.security.dangerous-open.dangerous-open',
  'ruby.lang.security.dangerous-open3-pipeline.dangerous-open3-pipeline',
  'ruby.lang.security.dangerous-subshell.dangerous-subshell',

  # https://github.com/github/securitylab-code-analysis/issues/58
  'csharp.lang.security.injections.os-command.os-command-injection',

  # https://github.com/github/securitylab-code-analysis/issues/76
  'javascript.express.security.injection.tainted-sql-string.tainted-sql-string',
  'javascript.lang.security.audit.sqli.node-mssql-sqli.node-mssql-sqli',
  'javascript.lang.security.audit.sqli.node-mysql-sqli.node-mysql-sqli',
  'javascript.lang.security.audit.sqli.node-postgres-sqli.node-postgres-sqli',
  'javascript.sequelize.security.audit.sequelize-injection-express.express-sequelize-injection',
  'javascript.sequelize.security.audit.sequelize-raw-query.sequelize-raw-query',

  # https://github.com/github/securitylab-code-analysis/issues/91
  'csharp.lang.security.sqli.csharp-sqli.csharp-sqli',

  # https://github.com/github/securitylab-code-analysis/issues/109
  'yaml.github-actions.security.allowed-unsecure-commands.allowed-unsecure-commands',
  'yaml.github-actions.security.pull-request-target-code-checkout.pull-request-target-code-checkout',
  'yaml.github-actions.security.run-shell-injection.run-shell-injection',

  # https://github.com/github/securitylab-code-analysis/issues/124
  'csharp.dotnet.security.audit.ldap-injection.ldap-injection',
  
  # https://github.com/github/securitylab-code-analysis/issues/193
  'typescript.react.security.audit.react-unsanitized-method.react-unsanitized-method',
  'typescript.react.security.audit.react-unsanitized-property.react-unsanitized-property',

];
##############################################################################

# The following is a hack to dynamically exclude directories and apply the allowlist
# Should not be necessary to change when adding new rules or exclussions
{
  rules: [
    rule + { paths : { exclude : excluded_directories } }
    for pack in packs
    for rule in pack.rules
    if std.member(rules, rule.id)
  ]
}
