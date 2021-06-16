#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=${cluster_name}"
} >> /etc/ecs/ecs.config
{
  echo "ECS_ENABLE_TASK_IAM_ROLE=${enable_task_role}"
} >> /etc/ecs/ecs.config

sudo restart ecs

echo "Done"