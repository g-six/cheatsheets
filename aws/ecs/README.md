# AWS ECS

* Create ecs cluster
  - aws ecs create-cluster --cluster-name <cluster name>
* List ecs cluster
  - aws ecs list-clusters 
* Delete ecs cluster
  - aws ecs delete-cluster --cluster <cluster name>
    - cannot delete a cluster if there are services inside the cluster
* For creating a service we need to generate an cli skeleton
  - aws ecs create-service --generate-cli-skeleton > <filename>.json
  - output
  ```
    {
        "cluster": "",
        "serviceName": "",
        "taskDefinition": "",
        "loadBalancers": [
            {
                "targetGroupArn": "",
                "loadBalancerName": "",
                "containerName": "",
                "containerPort": 0
            }
        ],
        "serviceRegistries": [
            {
                "registryArn": "",
                "port": 0,
                "containerName": "",
                "containerPort": 0
            }
        ],
        "desiredCount": 0,
        "clientToken": "",
        "launchType": "FARGATE",
        "platformVersion": "",
        "role": "",
        "deploymentConfiguration": {
            "maximumPercent": 0,
            "minimumHealthyPercent": 0
        },
        "placementConstraints": [
            {
                "type": "memberOf",
                "expression": ""
            }
        ],
        "placementStrategy": [
            {
                "type": "random",
                "field": ""
            }
        ],
        "networkConfiguration": {
            "awsvpcConfiguration": {
                "subnets": [
                    ""
                ],
                "securityGroups": [
                    ""
                ],
                "assignPublicIp": "ENABLED"
            }
        },
        "healthCheckGracePeriodSeconds": 0,
        "schedulingStrategy": "DAEMON"
    }

  ```
  - Remove data that is not needed in your configuration that is not required for running the service
  - Sample data
  
  ```
    {
        "cluster": "arn:aws:ecs:ap-southeast-2:878673363767:cluster/test-cluster-from-cli",
        "serviceName": "test-service-from-cli",
        "taskDefinition": "test-td-from-cli",
        "desiredCount": 1,
        "launchType": "EC2",
        "networkConfiguration": {
            "awsvpcConfiguration": {
                "subnets": [
                    "subnet-dd3410ba"
                ],
                "securityGroups": [
                    "sg-0d3874b9d2e4db055"
                ],
                "assignPublicIp": "DISABLED"
            }
        }
    }

  ```
  - Creating the service using the json file
    - aws ecs create-service --cli-input-json file://<filename>.json

* List services
  - aws ecs list-services --cluster <cluster arn>

* delete service
  - aws ecs delete-service --cluster <cluster arn> --service <service name> --force
    - cannot delete a service if there are running task delete task first

* Creating task definition
  - Generate a skeleton for the task definition
  - aws ecs register-task-definition --generate-cli-skeleton
  - output
  ```
  {
      "family": "", 
      "taskRoleArn": "", "executionRoleArn": "", 
      "networkMode": "none", 
      "containerDefinitions": [
          {
              "name": "", 
              "image": "", 
              "repositoryCredentials": {
                  "credentialsParameter": ""
              }, 
              "cpu": 0, 
              "memory": 0, 
              "memoryReservation": 0, 
              "links": [
                  ""
              ], 
              "portMappings": [
                  {
                      "containerPort": 0, 
                      "hostPort": 0, 
                      "protocol": "udp"
                  }
              ], 
              "essential": true, 
              "entryPoint": [
                  ""
              ], 
              "command": [
                  ""
              ], 
              "environment": [
                  {
                      "name": "", 
                      "value": ""
                  }
              ], 
              "mountPoints": [
                  {
                      "sourceVolume": "", 
                      "containerPath": "", 
                      "readOnly": true
                  }
              ], 
              "volumesFrom": [
                  {
                      "sourceContainer": "", 
                      "readOnly": true
                  }
              ], 
              "linuxParameters": {
                  "capabilities": {
                      "add": [
                          ""
                      ], 
                      "drop": [
                          ""
                      ]
                  }, 
                  "devices": [
                      {
                          "hostPath": "", 
                          "containerPath": "", 
                          "permissions": [
                              "read"
                          ]
                      }
                  ], 
                  "initProcessEnabled": true, 
                  "sharedMemorySize": 0, 
                  "tmpfs": [
                      {
                          "containerPath": "", 
                          "size": 0, 
                          "mountOptions": [
                              ""
                          ]
                      }
                  ]
              }, 
              "hostname": "", 
              "user": "", 
              "workingDirectory": "", 
              "disableNetworking": true, 
              "privileged": true, 
              "readonlyRootFilesystem": true, 
              "dnsServers": [
                  ""
              ], 
              "dnsSearchDomains": [
                  ""
              ], 
              "extraHosts": [
                  {
                      "hostname": "", 
                      "ipAddress": ""
                  }
              ], 
              "dockerSecurityOptions": [
                  ""
              ], 
              "interactive": true, 
              "pseudoTerminal": true, 
              "dockerLabels": {
                  "KeyName": ""
              }, 
              "ulimits": [
                  {
                      "name": "rttime", 
                      "softLimit": 0, 
                      "hardLimit": 0
                  }
              ], 
              "logConfiguration": {
                  "logDriver": "json-file", 
                  "options": {
                      "KeyName": ""
                  }
              }, 
              "healthCheck": {
                  "command": [
                      ""
                  ], 
                  "interval": 0, 
                  "timeout": 0, 
                  "retries": 0, 
                  "startPeriod": 0
              }, 
              "systemControls": [
                  {
                      "namespace": "", 
                      "value": ""
                  }
              ]
          }
      ], 
      "volumes": [
          {
              "name": "", 
              "host": {
                  "sourcePath": ""
              }, 
              "dockerVolumeConfiguration": {
                  "scope": "shared", 
                  "autoprovision": true, 
                  "driver": "", 
                  "driverOpts": {
                      "KeyName": ""
                  }, 
                  "labels": {
                      "KeyName": ""
                  }
              }
          }
      ], 
      "placementConstraints": [
          {
              "type": "memberOf", 
              "expression": ""
          }
      ], 
      "requiresCompatibilities": [
          "FARGATE"
      ], 
      "cpu": "", 
      "memory": ""
  }

  ```

  - Remove data that is not needed for your configuration and is not required
  - Sample output

  ```
    {
      "family": "test-td-from-cli",
      "taskRoleArn": "",
      "executionRoleArn": "",
      "networkMode": "awsvpc",
      "containerDefinitions": [
          {
              "name": "emman",
              "image": "emman-image",
              "cpu": 250,
              "memory": 300,
              "portMappings": [
                  {
                      "containerPort": 80,
                      "hostPort": 80,
                      "protocol": "udp"
                  }
              ],
              "essential": true,
              "disableNetworking": false,
              "privileged": false,
              "readonlyRootFilesystem": false,
              "interactive": true,
              "pseudoTerminal": true
          }
      ],
      "requiresCompatibilities": [
          "EC2"
      ],
      "cpu": "250",
      "memory": "300"
  }

  ```
  - To create task definition
    - aws ecs register-task-definition --cli-json-input file://<filename>.json
  - To deregister task definition
    - aws ecs deregister-task-definition --task-definition <task definition arn>
