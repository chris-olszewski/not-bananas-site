class ProjectsController < ApplicationController
  before_action :load_project, only: [:show, :update]

  def index
  end

  def show
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
end
