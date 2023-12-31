region = "us-west-2"
backend_ecr_repo_url = "123456789012.dkr.ecr.us-west-2.amazonaws.com/prod-backend-repo"
backend_task_execution_role_arn = "arn:aws:iam::123456789012:role/prod-backend-task-execution-role"
backend_cpu = 4096
backend_memory = 8192
private_subnet_ids = ["subnet-aaaaaa", "subnet-bbbbbb"]
backend_alb_sg_id = "sg-yyyyyy"
frontend_bucket_name = "prod-frontend-bucket"
file_storage_bucket_name = "prod-file-storage-bucket"
db_username = "db_user"
db_password = "db_password"
db_backup_retention_period = 35
kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/qrst-uvwx-yzab-cdef"
ssl_certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/qrst-uvwx-yzab-cdef"
acm_certificate_arn = "arn:aws:acm:us-west-2:123456789012:certificate/qrst-uvwx-yzab-cdef"
