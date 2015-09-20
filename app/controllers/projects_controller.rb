class ProjectsController < ApplicationController
  before_action :octokit_client, only: [:index, :create]

  def index
    @repositories = @client.repositories
  end

  def create
    repository = Repository.create(gh_name: params[:gh_name], enabled: true, user: current_user)
    @client.create_hook(
                        params[:gh_name],
                        'web',
                        {
                          url: "#{request.url.split('?').first}/#{repository.id}/hook",
                          content_type: 'json'
                        },
                        {
                          events: ['push'],
                          active: true
                        })
    redirect_to :back
  end

  def hook
    project = Repository.find(params[:id])
    if project
      params[:commits].each do |commit|
        commit[:modified].select { |f| f =~ /views\/*|README\.md/ }.each do |changed_file|
          file = RepoFile.where({ repository_id: params[:id], filename: changed_file }).try(:first)
          file = RepoFile.create({ repository_id: params[:id], filename: changed_file }) if file.nil?
          file.refresh!
        end
      end
    end
    render nothing: true
  end

  private
  def octokit_client
    @client = Octokit::Client.new(:access_token => current_user.token)
  end
end
