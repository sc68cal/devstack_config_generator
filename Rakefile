require 'yaml'

settings = YAML::load(File.open('settings.yml'))

all_nodes = settings["controller"] + settings["nodes"] 
user = settings["user"]

task :default => [:generate_configs, :push_localconf,
                  :set_devstack_origin, :checkout_devstack_branch, :restack]

task :config => [:generate_configs, :push_localconf,
                 :set_devstack_origin, :checkout_devstack_branch]

task :clone do
  for node in all_nodes do
    sh "ssh #{user}@#{node['ip']} git clone #{settings['devstack_repo']}"
  end
end

task :push_localconf => [:generate_configs] do 
  for node in all_nodes do
    sh "scp #{node['hostname']}.local.conf #{user}@#{node['ip']}:devstack/local.conf"
  end
end

task :generate_configs do
  controller = settings["controller"].first

  local_conf_template = File.open('local.conf.template').read()

  # Compute Nodes - local.conf
  for node in settings['nodes'] do
    rendered = local_conf_template.gsub("$NODE_IP", node["ip"])
    rendered.gsub!("$CONTROLLER_HOSTNAME", "#{controller['ip']}")
    rendered.gsub!("$PASSWORD", settings['password'])
    output = File.open("#{node["hostname"]}.local.conf", 'w')
    output.write(rendered)
    output.close()
    sh "cat computes.localrc.fragment >> #{node["hostname"]}.local.conf"
  end

  # Control node
  rendered = local_conf_template.gsub("$NODE_IP", controller['ip'])
  rendered.gsub!("$CONTROLLER_HOSTNAME", "#{controller['ip']}")
  rendered.gsub!("$PASSWORD", settings['password'])
  output = File.open("#{controller['hostname']}.local.conf", "w")
  output.write(rendered)
  output.close()

  sh "cat controller.localrc.fragment >> #{controller['hostname']}.local.conf"

end

task :checkout_devstack_branch do
  for node in all_nodes do
    sh "ssh #{user}@#{node['hostname']} 'cd devstack; git fetch; git checkout origin/#{settings["devstack_branch"]}'"
  end
end

task :set_devstack_origin do
  for node in all_nodes do
    sh "ssh #{user}@#{node['hostname']} 'cd devstack; git remote set-url origin #{settings["devstack_repo"]}'"
  end
end

task :restack do 
  for node in all_nodes do
    sh "ssh #{user}@#{node['hostname']} bash devstack/unstack.sh"
    sh "ssh #{user}@#{node['hostname']} screen -d -m bash devstack/stack.sh"
  end
end

task :unstack do
  for node in all_nodes do
    sh "ssh #{user}@#{node['hostname']} bash devstack/unstack.sh"
  end
end

task :restack_computes do
  for node in settings["nodes"]
    sh "ssh #{user}@#{node['hostname']} bash devstack/unstack.sh"
    sh "ssh #{user}@#{node['hostname']} screen -d -m bash devstack/stack.sh"
  end
end

task :reboot do
  for node in settings["nodes"]
    sh "ssh #{user}@#{node['hostname']} sudo shutdown -r now"
  end
end
