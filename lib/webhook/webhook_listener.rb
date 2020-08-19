require 'net/http'

module Webhook
  class WebhookListener < Redmine::Hook::Listener

    def skip_webhooks(context)
      request = context[:request]
      if request.headers['X-Skip-Webhooks']
        return true
      end
      return false
    end

    def controller_issues_edit_after_save(context = {})
      return if skip_webhooks(context)
      journal = context[:journal]
      controller = context[:controller]
      issue = context[:issue]
      project = issue.project
      return unless project.module_enabled?('webhook')
      post(journal_to_json(issue, journal, controller))
    end

    def controller_issues_new_after_save(context = {})
      return if skip_webhooks(context)
      controller = context[:controller]
      issue = context[:issue]
      project = issue.project
      return unless project.module_enabled?('webhook')
      post(newissue_to_json(issue, controller))
    end

    def controller_custom_fields_new_after_save(context = {})
      return if skip_webhooks(context)
      controller = context[:controller]
      custom_field = context[:custom_field]
      post(newcustomfield_to_json(custom_field, controller), 'cf_')
    end

    def controller_custom_fields_edit_after_save(context = {})
      return if skip_webhooks(context)
      controller = context[:controller]
      custom_field = context[:custom_field]
      post(editcustomfield_to_json(custom_field, controller), 'cf_')
    end

    private
    def newissue_to_json(issue, controller)
      {
        :payload => {
          :action => 'created',
          :issue => Webhook::IssueWrapper.new(issue).to_hash,
          :journal => nil,
          :url => controller.issue_url(issue)
        }
      }.to_json
    end

    private
    def journal_to_json(issue, journal, controller)
      {
        :payload => {
          :action => 'updated',
          :issue => Webhook::IssueWrapper.new(issue).to_hash,
          :journal => Webhook::JournalWrapper.new(journal).to_hash,
          :url => controller.issue_url(issue)
        }
      }.to_json
    end

    private
    def newcustomfield_to_json(custom_field, controller)
      {
        :payload => {
          :action => 'created',
          :field => Webhook::CustomFieldWrapper.new(custom_field).to_hash
        }
      }.to_json
    end

    private
    def editcustomfield_to_json(custom_field, controller)
      {
        :payload => {
          :action => 'updated',
          :field => Webhook::CustomFieldWrapper.new(custom_field).to_hash
        }
      }.to_json
    end

    def post(request_body, prefix = nil)
      Thread.start do
          begin
              url = prefix.nil? ? Setting.plugin_webhook['url'] : Setting.plugin_webhook[prefix + 'url']
              if url.nil? || url == ''
                  raise 'Url is not defined for webhook plugin'
              end
              url = URI(url)
	      headers = {
                  'Content-Type' => 'application/json',
                  'X-Redmine-Event' => 'Edit Issue',
              }
              req = Net::HTTP::Post.new(url, headers)
	      req.body = request_body
	      Net::HTTP.start(url.hostname, url.port) do |http|
                  http.request(req)
              end
          rescue => e
            Rails.logger.error e
          end
	end
    end
  end
end
