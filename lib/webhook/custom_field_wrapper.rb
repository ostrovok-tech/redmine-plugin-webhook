module Webhook
	class Webhook::CustomFieldWrapper
		def initialize(custom_field)
			@custom_field = custom_field
		end

		def to_hash 
			{
				id: @custom_field.id
				name: @custom_field.name,
				field_format: @custom_field.field_format
			}
		end
	end
end