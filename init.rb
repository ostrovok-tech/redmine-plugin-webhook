require_dependency 'hooks'

Redmine::Plugin.register :webhook do
  name 'Redmine Webhook Plugin'
  author 'Ivan Elfimov'
  description 'A plugin for Redmine which makes callback requests to specified URL when issue changes.'
  version '1.0.0'
  url 'https://github.com/ostrovok-team/redmine-webhook-plugin'
  author_url 'https://github.com/biozz'
  project_module :webhook do
    permission :manage_webhook, :webhook => :webhook
  end
  settings :default => {:empty => true}, :partial => 'settings/webhook/webhook'
end
