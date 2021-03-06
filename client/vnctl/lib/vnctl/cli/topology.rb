# -*- coding: utf-8 -*-

module Vnctl::Cli
  class Topology < Base
    namespace :topologies
    api_suffix "topologies"

    add_modify_shared_options {
      option :mode, :type => :string, :desc => "The mode for this topology."
    }

    define_standard_crud_commands

    define_relation :datapaths do |relation|
      relation.option :interface_uuid, :type => :string, :required => true,
        :desc => "the host interface to use as underlay."
    end

    define_relation :underlays do |relation|
    end

    define_relation :networks do |relation|
    end

    define_relation :segments do |relation|
    end

    define_relation :route_links do |relation|
    end

  end
end
