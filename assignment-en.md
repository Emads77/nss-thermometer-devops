# Exam Assignment DevOps — NSS Thermometer
_April 2025_

The National Student Survey is a large-scale national satisfaction survey in which students give their opinion about their HBO program and educational institution. You have probably filled in this survey as well.

HBO-IT uses several systems to promote the NSS. One of these systems is the NSS Stretch Goal Thermometer. The application that is visible on several screens within Saxion, that displays the current amount of votes and the reached stretch goals.

In this examination assignment it is your task to get this application properly up and running in the cloud. Everything should be automated in such a way, that a simple push to gitlab would redeploy the application to the cloud in a scalable manner.

### Conditional Requirements

- It is mandatory to submit all *practice assignments* and have them signed off by your teacher before this final assignment can be submitted. Of course, you can already start working on this exam assignment in the meantime.

- For each requirement (see below), you explain how you solved the problem and why you solved it this way. You describe this in your own words in a way that is understandable to the teacher who is assessing your work. You can write it down in a Markdown file in your repository or in comments in the source code (in the latter case, you refer in the Markdown file to the locations of these comments).

- Make sure you use a repository in the Saxion Gitlab organization, created via [https://repo.hboictlab.nl](https://repo.hboictlab.nl/)

- Upload a zipped export of your Gitlab project to Brightspace (Settings → General → Advanced → Export Project).\
  **Also mention the URL of your repository in the comments field on Brightspace.**

### Exam Rules

- The deadline for submitting the assignment is Sunday, April 6, 23:59 (end of week 3.8).

- The assignment is done in groups of two students who have registered with their teacher. Groups are formed in week 6, with group members both having to have submitted an equal number of practice assignments to be allowed to work together (maximum 1 week difference).

- Your grade is determined based on the assessment that takes place after you have submitted your assignment. So make sure you understand all the parts you have made, theoretical questions will also be asked about your solution.

- You only get points for parts of your work that you can explain during the assessment. For example: if your code works, but you can't explain what it does or why it works that way, then that part of the assignment does not count towards your final grade.

- It is **not** allowed to get help from someone outside your test group, except from your teacher. It is also **not** allowed to provide help to someone else.

- You may use online posts, articles, tutorials, books, videos. However, you must add references [[1]](https://libguides.murdoch.edu.au/IEEE) for all sources and code snippets that you use in your text/code.

## Process Requirements

During the execution of the assignment, you must follow a proper software development process, as covered in week 1. This includes things like keeping track of tasks using Gitlab Issues, using Git to collaborate on the code, and using branches and merge requests to be able to do code reviews. This should all be clearly visible from your Gitlab repository.

## Functional Requirements

### 1. Add data to the backend

In the repository, you will find a folder containing a backend application. This is a Laravel application provided by us that returns data in JSON format. Please read the `README.md` in the backend folder for more information about how to get the project up and running. If you run the application and go to http://localhost:8000/api/goals, you will see a list of goals that are currently present in the database. Initially, the database is empty.

To add goals to the backend, you need to do a POST request in the correct format (see the `seed-application` folder). You can use `curl` for this. Make sure you set the content type to `application/json` in your Curl command. In addition, the REST endpoint must be configurable through an environment variable in the script. Make sure that we can pass the data file as a parameter to the script, so that we can easily load a different data file.

Write the Bash script `add_data.sh`, which should read the data file `data.md` and then add each goal to the backend (also known as 'seeding'). Provide sufficient error handling.

### 2. Containerization of the applications

We want to have the whole application (backend, frontend, database and seed script) containerized with Docker and Docker Compose. There must be separate backend and frontend containers.

Provide a convenient way to build, run, and stop the containers by writing a script. Make sure that temporary files created by running the application outside Docker do not end up in the image.

Extend the compose file so that the data is stored in a PostgreSQL database. The `README.md` of the backend explains which variables are needed to connect the backend to the database.

You are allowed to use an nginx server for running the frontend application.

Don't forget to create a docker image for seeding the application. This seeding can only be done when the backend and database is running, so you might need to look into health checking mechanisms to fix the booting order of the docker composition.

Usefull things to look into are:
- Environment variables and .env files
- Dockerignore, so that only the necessary files are copied into the containers
- Health check mechanisms for databases and webserver
- Multi-stage builds with docker

### 3. Continuous Integration

Implement a development pipeline with continuous integration for the app. The CI/CD must consist of at least two phases. One for testing and building the backend and one for building the frontend. The frontend build artefact should be available in gitlab as download.

### 4. Create an infrastructure to run the application

Create a suitable infrastructure for the application in AWS using Terraform. The infrastructure does not (yet) need to be high availability. If this is not possible with Terraform, you may manually create the infrastructure (of course, you will lose points for this). Your Terraform configuration must be placed in the supplied `infra` folder.

The application does not need to be deployed with terraform to your created infrastructure. This will be done in the next step with Continious Deployment.

### 5. Automate the deployment of applications (continious deployment)

Automate the deployment of the backend so that, when we commit to the main branch, the Gitlab CI:

- builds the necessary Docker images for the backend

- uploads the image(s) to the [private container registry](https://docs.gitlab.com/ee/user/packages/container_registry/index.html) of your Gitlab repository

- connects to the EC2 instance using SSH, pulls in the Docker image(s) and runs them

- uploads the built frontend web files as a static website.

To achieve this, you need to copy the contents of your AWS private SSH key (which you use to connect to the instance) to an environment variable in Gitlab CI (Settings → CI/CD → Variables, click on "Expand"). In your `.gitlab-ci.yml` file, you can then use this variable to connect to the EC2 instance via SSH.

When using SSH, the client checks if the server is a known server. For our automated deployment, this is not very convenient (because someone then has to type 'yes'). If you want to disable this check, you can use the option `-o StrictHostKeyChecking=no` with SSH.

Additional ideas:
- You could add manual steps in your pipeline for creating the infrastructure or tearing the infrastructure down.

### 7. Create a backend with high availability

Extend your Terraform configuration with a high availability backend. Don't forget to also make the database highly available (i.e., redundant). If this is not possible, you may also work with a single database instance, although you will of course get fewer points for this.

Make sure the instances are not directly accessible from outside your network. Don't forget to adjust the frontend to connect to your new infrastructure. To validate whether your infrastructure is set up correctly, check if your frontend shows the goals.