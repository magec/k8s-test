Facter.add(:pod_cidr) do
  setcode do
    Facter.value('network_info')['workers'][Facter.value('hostname')]['tags']['PODCIDR']
  end
end
