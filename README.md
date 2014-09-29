# Ruby on Rails task: TODO list application


-------------------------------------------------------------------------------
Given tables:
- tasks(id, name, status, project_id)
- projects (id, name)

Queries for:


1. get all statuses, not repeating, alphabetically ordered

select DISTINCT status from tasks order by status

2. get the count of all tasks in each project, order by tasks count descending

select count(*) as count_tasks
from tasks group by project_id
order by count_tasks desc

3. get the count of all tasks in each project, order by project names

select (select count(*) from tasks where project_id=projects.id) as count_tasks,projects.name as project_name
from projects
order by project_name desc

4. get the tasks for all projects having the name beginning with "N" letter

select tasks.id, tasks.name, tasks.status 
from tasks,projects where tasks.project_id=projects.id 
and
projects.name like 'N%'

5. get the list of all projects containing the 'a' letter in the middle of the name, and show the tasks count near each project. Mention that there can exist projects without tasks and tasks with project_id = NULL.

select projects.name, (select count(*) from tasks where tasks.project_id=projects.id)
from projects 
where projects.name like '_%a%_'

6. get the list of tasks with duplicate names. Order alphabetically.

select id, name, status, project_id
from tasks
where name in (select name
from tasks group by name
having (COUNT(name)>1))
order by name 

7. get the list of tasks having several exact matches of both name and status, from the project 'Garage'. Order by matches count.

select count(*) as matches_count,tasks.name,tasks.status
from tasks, projects 
where projects.name='Garage' and project_id = projects.id
group by tasks.name,tasks.status
having (count(*) >1)
order by matches_count

8. get the list of project names having more than 10 tasks in status 'completed'. Order by project_id

select name 
from projects
where id in (select project_id
from tasks, projects 
where status='completed' and project_id = projects.id
group by project_id
having (count(*) >10))
order by id
