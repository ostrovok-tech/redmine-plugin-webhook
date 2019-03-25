require 'net/http'

module Webhook
    class Hooks < Redmine::Hook::Listener
        # def :controller_issues_new_after_save(context = {})
        #     # TODO
        # end
        def controller_issues_edit_after_save(context = {})
            issue = context[:issue]
            project = Project.find(issue[:project_id])
            return unless project.module_enabled?('webhook')
            url = Setting.plugin_webhook['url']
            if url.nil? || url == ''
                url = 'http://localhost:8000'
            end
            url = URI(url)
            headers = {
                'Content-Type' => 'application/json',
                'X-Redmine-Event' => 'Edit Issue',
            }
            req = Net::HTTP::Post.new(url, headers)
            journal = context[:journal]
            custom_fields = []
            for cf in issue.visible_custom_field_values do
                custom_fields.push({
                    :custom_field_id => cf.custom_field.id,
                    :custom_field_name => cf.custom_field.name,
                    :value => cf.value,
                    :value_was => cf.value_was,
                })
            end
            req.body = {
                :issue => context[:issue],
                :journal => context[:journal],
                :journal_details => context[:journal].visible_details,
                :custom_fields => custom_fields
            }.to_json
            begin
                Net::HTTP.start(url.hostname, url.port) do |http|
                    http.request(req)
                end
            rescue
                # TODO: add some code
            end
        end
    end
end