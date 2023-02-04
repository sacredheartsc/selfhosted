import ipaddress

def test_ip_in_subnet(ip, cidr):
  return ipaddress.ip_address(ip) in ipaddress.ip_network(cidr)

def test_subnet_contains_ip(cidr, ip):
  return ipaddress.ip_address(ip) in ipaddress.ip_network(cidr)

class TestModule(object):
  test_map = {
    'in_subnet': test_ip_in_subnet,
    'contains_ip': test_subnet_contains_ip,
  }

  def tests(self):
    return self.test_map
