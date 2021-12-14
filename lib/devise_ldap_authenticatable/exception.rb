module DeviseLdapAuthenticatable

  class LdapException < Exception; end

  class LdapAdminCredentialsException < LdapException; end
  class LdapConnectionException < LdapException; end

end
