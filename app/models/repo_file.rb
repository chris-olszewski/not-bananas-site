class RepoFile < ActiveRecord::Base
  belongs_to :repository

  before_create :create_jsfs

  def refresh!
    response = HTTParty.get(build_url)
    jsfs_update = HTTParty.put(jsfs_update_url, { body: response[:body] })
    update_attributes({ version: jsfs_update[:headers]['x-version'] })
  end

  private
  def build_url
    @github_url = "https://raw.githubusercontent.com/#{repository.gh_name}/#{filename}?token=#{repository.user.token}"
  end

  def jsfs_update_url
    "#{url}?access_key=#{access_key}"
  end

  def create_jsfs
    response = HTTParty.get(build_url)
    jsfs_url = "#{ENV['JSFS_URL']}/#{repository.id}/#{filename}"
    jsfs_create = HTTParty.post(jsfs_url, { body: response[:body] })
    self.url = jsfs_url
  end
end
