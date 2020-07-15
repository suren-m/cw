# Jobs

## Setup

* Create a directory called `jobs` within `cw_labs\kubernetes` directory and `cd` into it. Set your terminal to the `...../kubernetes/jobs` directory. (similar to how we did this in previous labs. If in doubt, take a look at 00_setup.md)

---

## Exercise - 1 Batch Job

1. Create a batch job from below yaml with both `parallelism and completions` set to 1. Name the yaml file `job.yaml` or something similar.

> Open a separate terminal or a pane and run `kubectl get pod -w` so you can observe the pods coming up when you create a job.

When copying the manifest yaml across, make sure the `indentation` is intact. Or else, you will see unexpected errors when doing the apply.

```yaml
apiVersion: batch/v1 # Notice the api here that is different from one for deployment.
kind: Job
metadata:
 name: sleepyjob
spec:
 parallelism: 1
 completions: 1
 template:
  spec:
   containers:
   - name: busybox
     image: busybox
     command: ["sleep"]
     args: ["10"] # sleep for 10 seconds and then exit
   restartPolicy: OnFailure
```

2. Try changing completions to `4` and try `applying` again. Observe the error stating that the field `completion` is immutable.

3. Now change the name of the job to `sleepyjob2` as well as change the numbers for `completion` and `parallelism`. See below

```yaml
apiVersion: batch/v1
kind: Job
metadata:
 name: sleepyjob2 # Name change
spec:
 parallelism: 2 # Increase parallel pods that will be launched at a time
 completions: 4 # Total number of completions
 template:
  spec:
   containers:
   - name: busybox
     image: busybox
     command: ["sleep"]
     args: ["10"]
   restartPolicy: OnFailure
```

After applying (kubectl apply -f job-filename.yaml), observe the `watcher` pane and see how the pods come up and run to completion. (Time column will give you an idea as well)

---

## Exercise - 2 Cron Jobs

1. Create CronJob called sleepycron that runs pod busy box with ```sleep 5``` command every minute. Feel free to choose between `imperative` or `declarative` approach for this.

    ```bash    
        kubectl create cronjob sleepycron --image=busybox --schedule "*/1 * * * *" -- sleep 5        
    ```
    **Or** go ahead create a manifest file for below yaml as we've done before and do an apply using `kubectl apply -f <manifest-filename>.yaml`

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
 name: sleepycronjob
spec:
 schedule: "*/1 * * * *"
 jobTemplate:
  spec:
   parallelism: 1
   completions: 1
   template:
    spec:
     containers:
     - name: busybox
       image: busybox
       command: ["sleep"]
       args: ["5"]
     restartPolicy: OnFailure
```
 
2. Give it a minute and list all the CronJob, Jobs and Pods (the pods created by job associated with cronjob should have prefix `sleepcron-` in this case)

    ```bash
      kubectl get cj,job,pod       
    ```
3. Observe that at every minute, a new job and its pod will be created. In this case, the pod will just sleep for 5 seconds and then will go into completed state.

   ```bash   
   kubectl get cj,job

   # Example output after a few minutes of letting the cron job run
   NAME                       SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
   cronjob.batch/sleepycron   */1 * * * *   False     0        24s             11m

   NAME                              COMPLETIONS   DURATION   AGE
   job.batch/sleepycron-1594837140   1/1           8s         2m17s
   job.batch/sleepycron-1594837200   1/1           9s         77s
   job.batch/sleepycron-1594837260   1/1           8s         17s
   ```

4. Delete the cronjob, so it doesn't keep firing

   ```bash
   kubectl delete cronjob.batch/sleepycron 
   ```
---
