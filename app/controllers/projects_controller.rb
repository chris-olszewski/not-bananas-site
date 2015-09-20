class ProjectsController < ApplicationController
  before_action :load_project, only: [:update]
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
                          url: "#{request.url.split('?').first}/#{repository.id}",
                          content_type: 'json'
                        },
                        {
                          events: ['push'],
                          active: true
                        })
    redirect_to :back
  end

  def update
    if @project
      params[:commits].each do |commit|
        commit[:modified].select { |f| f =~ /views\/*/ }.each do |changed_file|
          RepoFile.where({ repository_id: params[:id], file_name: changed_file }).refresh!
        end
      end
    end
  end

  private
  def load_project
    @project = Repository.find(params[:id])
  end

  def octokit_client
    @client = Octokit::Client.new(:access_token => current_user.token)
  end
end
