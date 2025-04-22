from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.apache.flink.operators.flink_kubernetes import FlinkKubernetesOperator
from airflow.utils.dates import days_ago

TEST_VALID_APPLICATION_YAML = """
apiVersion: flink.apache.org/v1beta1
kind: FlinkDeployment
metadata:
  name: basic-example
  namespace: flink-operator
spec:
  podTemplate:
    spec:
      containers:
          - name: flink-main-container
            image: flink:1.20-java17
            securityContext: 
                runAsNonRoot: true
                runAsGroup: 9999
                runAsUser: 9999
  # image: flink:1.20-java17
  flinkVersion: v1_20
  flinkConfiguration:
    taskmanager.numberOfTaskSlots: "2"
  serviceAccount: flink
  jobManager:
    resource:
      memory: "2048m"
      cpu: 1
  taskManager:
    resource:
      memory: "2048m"
      cpu: 1
  job:
    jarURI: local:///opt/flink/examples/streaming/StateMachineExample.jar
    parallelism: 2
    upgradeMode: stateless

"""


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='hourly_flink_k8s_job',
    default_args=default_args,
    description='Run Flink job on Kubernetes every hour',
    schedule_interval='@hourly',
    start_date=days_ago(1),
    catchup=False,
    tags=['flink', 'kubernetes'],
) as dag:

    run_flink_job = FlinkKubernetesOperator(
        task_id='run_flink_job',
        application_file=TEST_VALID_APPLICATION_YAML,
        # application_file='/opt/airflow/dags/flink_job.yaml',  # Path to your Flink job spec
        namespace='flink-operator',  # Modify this if your job runs in a different namespace
        kubernetes_conn_id='kubernetes_default',  # Update if you're using a custom connection
        # watch=True,  # Set to True if you want Airflow to wait for job completion
    )

    run_flink_job
