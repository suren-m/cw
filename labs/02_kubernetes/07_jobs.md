# Jobs

### Steps

1. Create CronJob called sleepycron that runs pod busy box with ```sleep 5``` command every minute

    ```bash    
        kubectl create cronjob sleepycron --image=busybox --schedule "*/1 * * * *" -- sleep 5
    ```

2. List all the CronJob, Jobs and Pods

    ```bash
       kubectl get cj,job,pod
       # observe every minute job and pods will be created
    ```

3. Clean up your resources

    ```bash
        kubectl delete all --all
    ```