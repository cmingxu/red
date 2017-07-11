class VulnerabilitiesCheckWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 2
  sidekiq_retries_exhausted do |msg, e|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(*args)
    repo_tag_id = args.first
    RepoTag.find(repo_tag_id).start_vulnerabilities_check
  end
end
