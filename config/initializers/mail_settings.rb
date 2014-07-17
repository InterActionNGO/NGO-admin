if Rails.env.production? || Rails.env.staging?
  Iom::Application.configure do
    config.action_mailer.smtp_settings = {
    :address              => "localhost",
    :port                 => 25,
    :domain               => 'ngoaidmap.org',
    :enable_starttls_auto => true   }
  end
end
