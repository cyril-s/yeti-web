# frozen_string_literal: true

module ClickhouseDictionary
  class Gateway < Base
    model_class ::Gateway

    attributes :id,
               :name,
               :external_id,
               :enabled,
               :gateway_group_id,
               :allow_origination,
               :allow_termination,
               :origination_capacity,
               :termination_capacity
  end
end
