# == Schema Information
#
# Table name: repo_tags
#
#  id            :integer          not null, primary key
#  name          :string
#  repository_id :integer
#  namespace_id  :integer
#  blob_size     :integer
#  owner_name    :string
#  digest        :string
#  url           :string
#  source        :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RepoTag < ApplicationRecord
  belongs_to :repository
  belongs_to :namespace

  belongs_to :user

  serialize :vulnerabilities_check_results, Hash

  def start_vulnerabilities_check
  end

  def request_vulnerabilities_check
    @client = Portus::RegistryClient.new(URI($base_services[:registry]).hostname, true, "admin@admin.com", "admin") 

    Clair::Base.token_path = $base_services[:demo] +"/registry/token"
    Clair::Base.password= "admin"
    Clair::Base.username= "admin@admin.com"

    @manifest = @client.manifest(self.repository.name, self.name)

    @manifest[2]["layers"].each_with_index do |layer, index|
      puts Clair::Layer.post self.repository.name, layer['digest'], @manifest[2]["layers"][index+1].try(:fetch, "digest")
    end
  end

  def collect_vulnerabilities_check_result
    @client = Portus::RegistryClient.new(URI($base_services[:registry]).hostname, true, "admin@admin.com", "admin") 

    Clair::Base.token_path = $base_services[:demo] +"/registry/token"
    Clair::Base.password= "admin"
    Clair::Base.username= "admin@admin.com"

    @manifest = @client.manifest(self.repository.name, self.name)

    @manifest[2]["layers"].each_with_index do |layer, index|
      res = Clair::Layer.get self.repository.name, layer['digest']
      self.vulnerabilities_check_results[layer['digest']] = res
    end

    self.save
  end

  def strip_vulnerabilities
    vulnerabilities = []
    self.vulnerabilities_check_results.values.each do |check_results|
      next unless check_results['Layer']['Features']
      check_results['Layer']['Features'].each do |feature|
        if vulns = feature["Vulnerabilities"]
          vulns.each do |v|
            v.merge!({"FeatureName": feature['Name'], 'VersionFormat': feature['VersionFormat'], 'Version': feature['Version'], 'AddedBy': feature['AddedBy'], 'FixedBy': feature['FixedBy']})
            vulnerabilities << OpenStruct.new(v)
          end
        end
      end
    end

    vulnerabilities
  end
end

