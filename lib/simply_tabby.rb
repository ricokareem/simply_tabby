require 'socket'

class SimplyTabby
  cattr_accessor :settings, :data

  class << self
    def release_file
      settings[:release_file] rescue File.join(Rails.root, 'VERSION')
    end

    def release_metadata
      File.exist?(release_file) ? YAML.load(File.read(release_file)) : {}
    rescue
      {}
    end

    def data
      @hostname ||= Socket.gethostname.downcase

      @@data ||= {
        :environment => Rails.env,
        :hostname => (@hostname.match(/^([a-z])[a-z]+(\d+)\.([a-z]+)/)[1..3].join rescue @hostname)
      }.merge(release_metadata)
    end

    def do_tell(options={})
      data
      buf = Array.new
      buf << '<!-- SimplyTabby' unless options[:no_comment]
      buf << data.map {|k,v| "#{k}: #{v}"}.sort.join("\n")
      buf << '-->' unless options[:no_comment]

      buf.join("\n")
    end
  end
end

