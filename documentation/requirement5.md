# Continuous Deployment (CD)

## Deployment Automation

To achieve continuous deployment, we added four new phases to our pipeline:

### build_backend_image

This phase builds the Docker image and uploads it to the Docker registry every time the pipeline runs.

```yml
build_backend_image:
  stage: docker-build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - echo "$CI_JOB_TOKEN" | docker login -u gitlab-ci-token --password-stdin "$CI_REGISTRY"
  script:
    - docker build -t "$DOCKER_IMAGE_BACKEND:latest" ./backend
    - docker push "$DOCKER_IMAGE_BACKEND:latest"
```

We used the `docker:latest` image because Docker is pre-installed in it. We also used two GitLab variables for logging into the Docker registry:

- `$CI_JOB_TOKEN`: to authenticate in GitLab’s Docker registry.
- `$CI_REGISTRY`: to specify the GitLab registry address (`host:port`).

Finally, we built the backend Dockerfile, tagged it with `latest`, and pushed it to the registry.

### backend-deploy

#### Automate Deployment to EC2 via SSH

Initially, for backend deployment, we used the recommended SSH login method as explained in assignment issues #10, #11, and merge request !11.

#### Automate Deployment via Terraform

However, after completing requirement 6, we realized that using the traditional SSH login with a key was not suitable anymore. This was because we now had a load balancer and autoscaling configured. This meant we no longer had a single EC2 instance or fixed IP address that could be stored as a GitLab variable.

While there were other solutions, we could not use them because we lacked AIM permissions in our educational AWS lab. Therefore, the only feasible method left for us was using Terraform directly in the pipeline. We configured our autoscaler with `instance_refresh`:

```tf
instance_refresh {
  strategy = "Rolling"
  preferences {
    instance_warmup         = 30
    min_healthy_percentage  = 50
  }
  triggers = ["launch_template"]
}
```

Explanation:

- `strategy = "Rolling"`: AWS replaces EC2 instances gradually, in small groups, reducing downtime.
- `instance_warmup = 30`: AWS waits 30 seconds after marking a new instance as healthy to ensure it is ready.
- `min_healthy_percentage = 50`: AWS ensures that at least 50% of the instances stay running during the update, keeping the service available.
- `triggers = ["launch_template"]`: AWS automatically triggers instance updates whenever we change the launch template, which includes changes to the Docker image version in our `user_data`.

##### Pipeline

For the backend deployment, we used the `zenika/terraform-aws-cli` image, which already includes Terraform and AWS CLI.

We created new variables in GitLab CI/CD for AWS credentials and configured Terraform to use them:

```yml
script:
    - mkdir -p ~/.aws
    - |
      cat <<EOF > ~/.aws/credentials
      [default]
      aws_access_key_id = $AWS_ACCESS_KEY_ID
      aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
      aws_session_token = $AWS_SESSION_TOKEN
      EOF
```

We faced an issue initially because the Terraform state file was deleted after each pipeline run. After researching, we found GitLab offers a solution to store Terraform's state remotely. We included the following command:

```yml
    - |
      export TF_STATE_NAME=default
      terraform init \
      -backend-config="address=https://gitlab.com/api/v4/projects/68303238/terraform/state/$TF_STATE_NAME" \
      -backend-config="lock_address=https://gitlab.com/api/v4/projects/68303238/terraform/state/$TF_STATE_NAME/lock" \
      -backend-config="unlock_address=https://gitlab.com/api/v4/projects/68303238/terraform/state/$TF_STATE_NAME/lock" \
      -backend-config="username=tavger" \
      -backend-config="password=$GITLAB_ACCESS_TOKEN" \
      -backend-config="lock_method=POST" \
      -backend-config="unlock_method=DELETE" \
      -backend-config="retry_wait_min=5"
```

We also added a new CI/CD variable called `GITLAB_ACCESS_TOKEN` to allow GitLab to store Terraform's state file.

After setting this up, we used `terraform plan` and `terraform apply` to deploy the backend.

To fully automate our pipeline, Terraform outputs the ALB DNS, which we save as an artifact to be used in the next frontend-deploy stage:

```yml
  artifacts:
    paths:
      - infra/gitlab_env.sh
    expire_in: 15 minutes
```

## Static Website Hosting

### Using AWS S3 Bucket

Initially, for our project, we aimed to deploy our static frontend using an S3 bucket. We chose this approach because it aligned well with our overall AWS-based architecture, promising high availability and easy integration with other AWS services we were using. Additionally, hosting on S3 would have allowed us greater control over custom domains and SSL configurations for our frontend.

However, while trying to automate the deployment via our CI/CD pipeline, we encountered permission issues. Our educational AWS account didn't have the necessary privileges to create an IAM user with the required permissions to access S3 and generate the proper access keys. Due to these constraints, we switched to GitLab Pages, which is natively integrated into our CI/CD process and doesn't require additional AWS credentials.

### Using GitLab Pages

We updated the `frontend-build` step to accept and use `infra/gitlab_env.sh` as environment variables. This ensures it always uses the correct ALB DNS, especially useful as our educational AWS lab infrastructure might change each run:

```yml
before_script:
    - cd frontend && npm install
    - source ../infra/gitlab_env.sh
script:
    - echo "VITE_API_URL=http://${ALB_DNS_NAME}" > .env
```

This step was straightforward: the built frontend files (`frontend/dist`) are moved to the `public` directory:

```yml
pages:
  stage: pages
  script:
    - mv frontend/dist public
  only:
    - main
```

GitLab Pages automatically deploys when the pipeline includes a `pages` stage.