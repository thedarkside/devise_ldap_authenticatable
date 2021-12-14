module Devise
  module LDAP
    module LDAPRaiseExtension
      refine ::Net::LDAP do
        #TODO: enforce timeout via Timeout::timeout?
        def search(*args)
          handle_exceptions(:search) do
            super
          end
        end
        def bind(*args)
          handle_exceptions(:bind) do
            super
          end
        end
        def modify(*args)
          handle_exceptions(:modify) do
            super
          end
        end

        private
        def handle_exceptions(op)
          result = yield
          if is_error? get_operation_result.code
            raise DeviseLdapAuthenticatable::LdapException.new(get_operation_result)
          end
          result
        rescue Errno::ECONNREFUSED => e
          raise DeviseLdapAuthenticatable::LdapConnectionException.new(e)
        rescue => e #at least Net::LDAP::Error
          raise DeviseLdapAuthenticatable::LdapException.new(e)
        end

        def is_error?(code)
          not (::Net::LDAP::ResultCodesNonError + ::Net::LDAP::ResultCodesSearchSuccess + [::Net::LDAP::ResultCodeInvalidCredentials]).include?(code)
        end
      end
    end
  end
end
