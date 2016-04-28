gem 'benchmark-ips', '>= 2.0'
require 'benchmark/ips'

data = [*0..100_000_000]

Benchmark.ips do |x|
  x.report('any')    { data.any? }
  x.report('empty') { data.empty? }
  x.compare!
end