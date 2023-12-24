# Veil Architecture

The Veil Nebula is a cloud of heated and ionized red and blue gas to appear purple

Veil consists of the front end architecture for a static web app hosted in S3, terraform AWS infrastructure-as-code (IAC), an API gateway backend, and Docker build pipeline

### Table of Contents

1. [Front end](#front-end-webapp)
2. [Terraform](#terraform)
   1. [Authenticate with the CLI](#assume-role-and-set-environment-variables)
   2. [Run terraform](#run-terraform)
   3. [Useful AWS CLI Commands](#useful-aws-cli-commands)

## Front End Webapp

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 17.0.8.

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The application will automatically reload if you change any of the source files.

#### Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

#### Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory.

#### Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

#### Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via a platform of your choice. To use this command, you need to first add a package that implements end-to-end testing capabilities.

#### Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI Overview and Command Reference](https://angular.io/cli) page.

## Terraform

#### Assume role and set environment variables

In order to execute terraform, the user/machine must assume a role with the AWS CLI. In order to assume a role, you must be authenticated with AWS CLI:

run  

    aws configure

Enter your access key and secret access key. You can run `aws sts get-caller-identity` to see that it worked

#### Assume Role and Map Env Vars

Replace {rolearn} with the role arn - it will look like: arn:aws:iam::999999999999:role/OrgAccountAccessRole

##### Mac

If you don't have jq installed already:

    brew install jq
    
Then assume with:

    eval $(aws sts assume-role --role-arn {rolearn} --role-session-name trfrm | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId)\nexport AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\nexport AWS_SESSION_TOKEN=\(.SessionToken)"')

##### Windows

    $credentials = aws sts assume-role --role-arn {rolearn} --role-session-name trfrm | ConvertFrom-Json

    [Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", $credentials.Credentials.AccessKeyId, [System.EnvironmentVariableTarget]::Process)
    [Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", $credentials.Credentials.SecretAccessKey, [System.EnvironmentVariableTarget]::Process)
    [Environment]::SetEnvironmentVariable("AWS_SESSION_TOKEN", $credentials.Credentials.SessionToken, [System.EnvironmentVariableTarget]::Process)`

This will map the role access keys and token to your environment variables. Now run `aws sts get-caller-identity` again to see that you are authenticated as the role. 

*Note*: in your CLI config, you are still configured in as your user. With the keys and tokens set, the CLI will use the session token to authenticate as the role. Once the role token expires, you will get authentication errors until the token is removed. You can [unset the environment variables](#remove-role-session) to interact with the CLI as your user and run the [assume role](#assume-role-and-map-env-vars) command to re-assume the role if needed

##### run terraform

*From the /tf directory,* view the change details: 

    terraform plan
    
To submit changs:

    terraform apply

##### tear it all down 

    terraform destroy

#### useful aws cli commands

##### view user/role session info: 

    aws sts get-caller-identity

##### remove role session:  

    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
