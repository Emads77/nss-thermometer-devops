#### CI Pipeline Phases

#### Overview

The Continuous Integration (CI) pipeline is structured into two main phases: Backend Testing and Building, and Frontend Building and Artifact Storage. The goal of these phases is to streamline and automate the testing, building, and deployment processes efficiently. Due to the educational environment constraints, practical adjustments were made to balance ideal practices with available resources.

##### Backend Testing and Building

For this phase, we selected the `php:8.2-fpm` Docker image, as it already includes the required PHP version, simplifying the setup process.

Initially, our plan was to use a separate database service container during backend testing. However, we faced challenges related to environment variables. To avoid spending excessive time on these issues, we switched to using a `SQLite` database file along with the `php migrate`.

After successfully running backend tests, we export the test report and store it as an artifact with a one-week expiration.

To speed up the building process, we cached these directories:

```yml
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - backend/vendor/
      - /root/.composer/cache
```

- `${CI_COMMIT_REF_SLUG}` ensures the cache key matches the branch name. 
- `backend/vendor/`: directory containing Composer-installed PHP dependencies.
- `/root/.composer/cache`: Composer cache directory for downloaded packages.

[Great explaination which includes our case](https://docs.gitlab.com/ci/caching/)
##### Frontend Building and Artifact Storage

Since the frontend is built using `Node.js`, we chose the minimal `node:18-alpine` Docker image, which includes Node.js pre-installed.

Prior to frontend building, we modified the backend code by removing the hardcoded backend URL and replacing it with an environment variable. Currently, the frontend build depends on backend deployment. Although mixing deployment and integration isn't ideal, the educational AWS lab environment imposes that beacuse on each run it is possible to get a different ALB DNS.

A more ideal solution would involve using a static DNS pointing to the backend. However, we still need to add more automation steps especially to the backend configuration which might make us end up with long and complicated automation pipelines, we accepted our current method.

Frontend pipeline configuration:

```yml
frontend:
  stage: frontend
  image: node:18-alpine
  dependencies:
    - backend-deploy
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - frontend/node_modules/
      - /root/.npm
  before_script:
    - cd frontend && npm install
    - source ../infra/gitlab_env.sh
  script:
    - echo "VITE_API_URL=http://${ALB_DNS_NAME}" > .env
    - npm run build
  artifacts:
    paths:
      - frontend/dist
    expire_in: 1 week
```

- **Caching:** We cache `frontend/node_modules` to accelerate `npm install`. Additionally, caching `/root/.npm` provides a backup of npm packages, serving the same purpose.
- **Artifacts:** The built frontend assets in `frontend/dist` are stored as artifacts for deployment, set to expire after one week.