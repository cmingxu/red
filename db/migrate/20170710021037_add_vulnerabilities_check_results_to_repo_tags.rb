class AddVulnerabilitiesCheckResultsToRepoTags < ActiveRecord::Migration[5.0]
  def change
    add_column :repo_tags, :vulnerabilities_check_results, :text, :limit => 4294967295
  end
end
