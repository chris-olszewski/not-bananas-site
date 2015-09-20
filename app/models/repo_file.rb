require 'rest-client'

class RepoFile < ActiveRecord::Base
  belongs_to :repository

  def refresh!
    client = Octokit::Client.new(access_token: repository.user.token)
    content = Base64.decode64(client.contents(repository.gh_name, path: filename).content)
    if access_key
      jsfs_update = RestClient.put(jsfs_update_url, { :body => content, :content_type => 'text/plain' })
      #update_attributes(version: jsfs_update[:headers]['x-version'])
    else
      create_jsfs content
      update_attributes(version: 0)
    end
  end

  private
  def jsfs_update_url
    "#{url}?access_key=#{access_key}"
  end

  def create_jsfs content
    jsfs_url = "#{ENV['JSFS_URL']}/#{repository.id}/#{filename}"
    jsfs_create = RestClient.post(jsfs_url, { :body => content, :content_type => 'application/plain' })
    update_attributes(url: jsfs_url, access_key: JSON.parse(jsfs_create.body)['access_key'])
  end
end
