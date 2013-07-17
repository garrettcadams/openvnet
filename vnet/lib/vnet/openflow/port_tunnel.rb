# -*- coding: utf-8 -*-

module Vnet::Openflow

  module PortTunnel
    include FlowHelpers

    def flow_options
      @flow_options ||= {:cookie => @cookie}
    end

    def tunnel?
      true
    end

    def install
      flows = []
      flows << Flow.create(TABLE_TUNNEL_PORTS, 30, {
                             :in_port => self.port_number
                           }, {},
                           flow_options.merge(:goto_table => TABLE_TUNNEL_NETWORK_IDS))
      flows << Flow.create(TABLE_VIRTUAL_SRC, 30, {
                             :in_port => self.port_number
                           }, nil,
                           flow_options.merge(:goto_table => TABLE_ROUTER_ENTRY))

      @datapath.add_flows(flows)
    end
  end
end
