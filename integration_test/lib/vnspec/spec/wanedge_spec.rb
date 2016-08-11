# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'wanedge', :vms_enable_vm => [:vm1, :vm7], :vms_enable_ifup => [:vm1, :vm7] do
  describe 'remote vm1 in vnet1' do
    it 'reaches to the gateway' do
      to_gw = double()
      allow(to_gw).to receive(:ipv4_address).and_return(config[:physical_network_gw_ip])

      expect(vm1).to be_able_to_ping(to_gw, 10)
    end

    it 'reaches to the internet' do
      to_gw = double()
      allow(to_gw).to receive(:ipv4_address).and_return(config[:pseudo_global_ip])

      expect(vm1).to be_able_to_ping(to_gw, 10)
    end
  end

  describe 'local vm7 in vnet1' do
    it 'reaches to the gateway' do
      to_gw = double()
      allow(to_gw).to receive(:ipv4_address).and_return(config[:physical_network_gw_ip])

      expect(vm7).to be_able_to_ping(to_gw, 10)
    end

    it 'reaches to the internet' do
      to_gw = double()
      allow(to_gw).to receive(:ipv4_address).and_return(config[:pseudo_global_ip])

      expect(vm7).to be_able_to_ping(to_gw, 10)
    end
  end

  describe 'vm1 and vm7 in nw-global' do
    context "vm1 on node1" do
      it "reachable to vm7 on wanedge node" do
        expect(vm1).to be_reachable_to(vm7)
      end
    end
  end

end
