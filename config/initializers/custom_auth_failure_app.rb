class CustomAuthFailure < Devise::FailureApp
  protected
    def http_auth_body
      { :errors => [i18n_message] }.to_json
    end
end
