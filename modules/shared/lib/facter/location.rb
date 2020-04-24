Facter.add('location') do
  setcode do
      l = Facter.value(:networking)['fqdn']
      location = l[/.*\.releng\.(.+)\.mozilla\..*/, 1]
      case location
      when /mdc1|mdc2/
          location
      else
          'unknown'
      end
  end
end
