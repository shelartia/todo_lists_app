class TasksController < ApplicationController
  def new
  end
  
  def create
    project_id = params[:task][:project_id]
    name = params[:task][:name]
	if current_user.projects.find(project_id).tasks.count>0
	  priority = current_user.projects.find(project_id).tasks.maximum(:priority)+1 
	else
	  priority = 0
	end
    @task_new = current_user.projects.find(project_id).tasks.build(name: name, priority: priority)
    if @task_new.save
      @projects = current_user.projects.order(:id)
      
      respond_to do |format|
        format.html {redirect_to todolists_path}
        format.js {render action: 'script.js.erb'}
      end
    else
      redirect_to todolists_path
    end
  end
  
  def destroy
    @t=Task.find_by(id: params[:id])
	@t.destroy 
	
	@projects = current_user.projects.order(:id)
	respond_to do |format|
       format.html {redirect_to todolists_path}
       format.js {render action: 'script.js.erb'}
	end
  end
  
  def update
    @task=Task.find_by(id: params[:id])
	if !params[:task][:name].nil? and @task.update_attributes(name: params[:task][:name],
	                           deadline: params[:task][:deadline],
							   done: params[:task][:done])
      @projects = current_user.projects.order(:id)
	  respond_to do |format|
         format.html {redirect_to todolists_path}
         format.js {render action: 'script.js.erb'}
      end
	
    end	
	
	if params[:task][:name].nil? and @task.update_attributes(done: params[:task][:done])
      @projects = current_user.projects.order(:id)
	  respond_to do |format|
         format.html {redirect_to todolists_path}
         format.js {render action: 'script.js.erb'}
      end
	
    end	
	
  end
  
  def priority_up
    @task=Task.find_by(id: params[:id])
	@project_cur=current_user.projects.find(@task.project_id)
	if @task.priority != @project_cur.tasks.minimum(:priority)
	  @task_to_change=@project_cur.tasks.find_by(priority: (@task.priority-1))
	  @task_to_change.priority += 1
	  @task_to_change.save
	  @task.priority -= 1
	  @task.save
	  @projects = current_user.projects.order(:id)
	  respond_to do |format|
         format.html {redirect_to todolists_path}
         format.js {render action: 'script.js.erb'}
      end
	end
  end
  
  def priority_down
    @task=Task.find_by(id: params[:id])
	@project_cur=current_user.projects.find(@task.project_id)
	if @task.priority != @project_cur.tasks.maximum(:priority)
	  @task_to_change=@project_cur.tasks.find_by(priority: (@task.priority+1))
	  @task_to_change.priority -= 1
	  @task_to_change.save
	  @task.priority += 1
	  @task.save
	  @projects = current_user.projects.order(:id)
	  respond_to do |format|
         format.html {redirect_to todolists_path}
         format.js {render action: 'script.js.erb'}
      end
	end
  end
  
  private
    def task_params
      params.require(:task).permit(:name)
    end
  
end
