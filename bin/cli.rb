#!/usr/bin/env ruby
require_relative '../lib/k8test/cli'

Dry::CLI.new(K8sTest::CLI::Commands).call
