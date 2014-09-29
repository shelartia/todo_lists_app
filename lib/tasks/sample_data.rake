namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                         email: "testsrep@gmail.com",
                         password: "foobar",
                         password_confirmation: "foobar",
                         admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    10.times do 
      users.each do |user|
        name = "Project#{user.projects.count+1}"
        user.projects.create!(name: name)
        user.projects.each do |project|
          task_name = "Task #{project.tasks.count+1}"
		  if project.tasks.count>0
		    task_priority=project.tasks.maximum(:priority)+1 
		  else
		    task_priority=0
		  end
          project.tasks.create!(name: task_name, priority: task_priority)
        end
      end
    end
  end
end