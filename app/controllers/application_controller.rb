class ApplicationController < ActionController::API
  include Authenticable

  rescue_from 'AccessGranted::AccessDenied', with: :forbidden_resource
end
