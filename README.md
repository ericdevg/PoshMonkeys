# PoshMonkeys
PowerShell based ChaosMonkey for Azure.

Chaos Monkey is a service which identifies groups of systems and randomly terminates one of the systems in a group. The service operates at a controlled time (does not run on weekends and holidays) and interval (only operates during business hours). In most cases we have designed our applications to continue working when a peer goes offline, but in those special cases we want to make sure there are people around to resolve and learn from any problems.

Failures happen and they inevitably happen when least desired or expected. If your application can't tolerate an instance failure would you rather find out by being paged at 3am or when you're in the office and have had your morning coffee? Even if you are confident that your architecture can tolerate an instance failure, are you sure it will still be able to next week? How about next month? Software is complex and dynamic and that "simple fix" you put in place last week could have undesired consequences. Do your traffic load balancers correctly detect and route requests around instances that go offline? Can you reliably rebuild your instances? Perhaps an engineer "quick patched" an instance last week and forgot to commit the changes to your source repository? There are many failure scenarios that Chaos Monkey helps to detect. 

There are a few assumption made around this tool:

1. Adoption of AvailabilitySet as scaling basic unit.

2. PowerShell v5 + required. (note: PoshMonkey can run against Azure Linux instance, while itself has to be run on windows box)

3. Having a unified user credential for all Azure instances in terms of remote PS.

4. SSL client certificate has to be installed on client machine which will be used to remote PS to Azure instance.



Future consideration:

1. For failure caused by ChaosMonkey, there are a few of them can not be simply automatically recovered through reboot, at this point, it basically requires having recovery service/tool deployed around. ChaoMonkey prabably needs to consider to provide recover action for each failure.

2. Better extensibility of chaos events.

3. GUI for Monkey activity logging.

4. Introduce instance cool down time interval. In general, you don’t want to trigger exact the same failure on same instance twice in a row. Cool down time targets to prevent that happen.

5. Introduce holidays in Monkey Calendar 

6. Customize logging pipe through configuration (imagine the case of serving automation to run)

7. Email notification

8. Support unleashed mode

9. Diagnostic mode


