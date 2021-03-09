Facter.add(:pod_cidr) do
  setcode do
    index = Facter.value(:hostname).scan(/\d+/)
    "10.200.#{index.first}.0/24"
  end
end
