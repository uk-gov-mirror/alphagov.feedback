Rails.application.routes.draw do
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/contact", format: false, to: "contact#index"

  namespace :contact do
    get "govuk", to: "govuk#new", format: false
    post "govuk", to: "govuk#create", format: false

    get "govuk/anonymous-feedback/thankyou", to: "govuk#anonymous_feedback_thankyou", format: false, as: "anonymous_feedback_thankyou"
    get "govuk/thankyou", to: "govuk#named_contact_thankyou", format: false, as: "named_contact_thankyou"

    namespace :govuk do
      # This list of POST-able routes should be kept in sync with the rate-limited URLS in
      # govuk-puppet: https://github.com/alphagov/govuk-puppet/blob/master/modules/router/templates/router_include.conf.erb#L56-L61
      post "problem_reports", to: "problem_reports#create", format: false
      post "service-feedback", to: "service_feedback#create", format: false
      post "assisted-digital-survey-feedback", to: "assisted_digital_feedback#create", format: false
      post "email-survey-signup", to: "email_survey_signup#create", format: false
      post "email-survey-signup.js", to: "email_survey_signup#create", defaults: { format: :js }
      post "content_improvement", to: "content_improvement#create", defaults: { format: :js }
      resources "page_improvements", only: [:create], format: false
    end
  end

  root to: redirect("/contact")
end
