class ProjectsController < ApplicationController
  def new
    if !signed_in?
      redirect_to(root_url)
    else
      @project= current_user.projects.new
    end
  end
  
  def index
    @task=Task.new
    @projects = current_user.projects.order(:id)
  end
  
  def create
    name = "Project #{current_user.projects.count+1}"
	@project_new = current_user.projects.build(name: name)
    if @project_new.save
      @projects = current_user.projects.order(:id)
      respond_to do |format|
        format.html 
        format.js {render action: 'script.js.erb'}
      end
      #flash[:success] = "Project created!"
      #redirect_to todolists_path
      #render @projects
    else
      flash[:error] = @project.errors.full_messages
      redirect_to todolists_path
    end
  end
  
  def destroy
    @project=current_user.projects.find_by(id: params[:id])
	@project.destroy 
	
	@projects = current_user.projects.order(:id)
	respond_to do |format|
       format.html {redirect_to todolists_path}
       format.js  {render action: 'script.js.erb'}
	end
  end
  
  def update
    @project=current_user.projects.find_by(id: params[:id])
	if @project.update_attributes(name: params[:project][:name])
      @projects = current_user.projects.order(:id)
	  respond_to do |format|
         format.html {redirect_to todolists_path}
         format.js  {render action: 'script.js.erb'}
      end		 
    end 
	
  end
  
  private
    def correct_user
      @project = current_user.projects.find_by(id: params[:id])
      redirect_to root_url if @project.nil?
    end
    
    def project_params
      params.require(:project).permit(:name)
    end
    

end
