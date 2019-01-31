module JSONAPI
  class Processor
    define_jsonapi_resources_callbacks :custom_actions_instance, :custom_actions_collection

    # Processing custom actions results for single model
    # It will handle action result if returns one single model
    #
    # @return [ResourceSetOperationResult]
    def custom_actions_instance
      resource = resource_klass.resource_for(params[:result], context)

      include_directives = params[:include_directives]
      fields = params[:fields]
      serializer = params[:serializer]

      find_options = {
        context: context,
        fields: fields,
        filters: { resource_klass._primary_key => resource.id }
      }

      resource_set = find_resource_set(resource_klass,
                                       include_directives,
                                       serializer,
                                       find_options)

      JSONAPI::ResourceSetOperationResult.new(:ok, resource_set, result_options)
    rescue
      JSONAPI::OperationResult.new(:accepted, result_options)
    end

    # Processing custom actions results for many models
    # It will handle action result if returns array or ActiveRecord::Relation
    #
    # @return [ResourceSetOperationResult]
    def custom_actions_collection
      resources = resource_klass.resources_for(params[:results], context)

      include_directives = params[:include_directives]
      fields = params[:fields]
      serializer = params[:serializer]

      find_options = {
        context: context,
        fields: fields,
        filters: { resource_klass._primary_key => resources.map(&:id) }
      }

      resource_set = find_resource_set(resource_klass,
                                       include_directives,
                                       serializer,
                                       find_options)

      JSONAPI::ResourceSetOperationResult.new(:ok, resource_set, result_options)
    rescue
      JSONAPI::OperationResult.new(:accepted, result_options)
    end
  end
end
