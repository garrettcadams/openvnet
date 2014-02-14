# -*- coding: utf-8 -*-

module Vnet::Openflow::Ports

  module Host
    include Vnet::Openflow::FlowHelpers

    def port_type
      :host
    end

    def flow_options
      @flow_options ||= {:cookie => @cookie}
    end

    def install
      set_remote_md = flow_options.merge(md_create(:remote => nil))

      reflection_md = md_create(:reflection => nil)
      reflection_mac2mac_md = md_create({ :reflection => nil,
                                          :mac2mac => nil
                                        })

      flows = []

      if @dp_info.datapath.datapath_info.node_id =~ /^edge/
        flows << flow_create(:default,
                             table: TABLE_CLASSIFIER,
                             goto_table: TABLE_EDGE_SRC,
                             priority: 2,
                             match: {
                               :in_port => self.port_number
                             },
                             write_remote: true)
      end

      if @interface_id && @dp_info.datapath.datapath_info.node_id !~ /^edge/
        flows << flow_create(:default,
                             table: TABLE_CLASSIFIER,
                             goto_table: TABLE_INTERFACE_INGRESS_CLASSIFIER,
                             priority: 2,

                             match: {
                               :in_port => self.port_number
                             },

                             write_interface: @interface_id,
                             write_remote: true)

        flows << flow_create(:default,
                             table: TABLE_OUT_PORT_INTERFACE_EGRESS,
                             priority: 2,
                             match: {
                               :in_port => self.port_number
                             },
                             match_interface: @interface_id,
                             match_reflection: true,
                             actions: {
                               :output => OFPP_IN_PORT
                             })
        flows << flow_create(:default,
                             table: TABLE_OUT_PORT_INTERFACE_EGRESS,
                             priority: 1,
                             match_interface: @interface_id,
                             actions: {
                               :output => self.port_number
                             })
      end

      @dp_info.add_flows(flows)
      @dp_info.dc_segment_manager.async.update(event: :insert_port_number,
                                               port_number: self.port_number)
    end

    def uninstall
      @dp_info.dc_segment_manager.async.update(event: :remove_port_number,
                                               port_number: self.port_number)
    end

  end

end
