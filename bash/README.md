# Shell Scripts

## Installation (install.sh)

The install.sh script can be used to automate the fetching, unpacking and
installation of the Stingray software package.

| Variable | Description | Possible Answers | Notes |
| -------- | ----------- | ---------------- | ----- |
| **accept-license** | Whether or not to accept the End-User license agreement.  This value needs to **accept** in order to complete the installation. | **accept** | (Installation will fail for anything else) |
| **zeushome** | The directory that Stingray should be installed to. | Any directory. |  The default value is **/usr/local/zeus**. |
| **zxtm!perform_initial_config** | Whether or not the initial configuration should be performed immediately after the **zinstall** script completes. | **y**,**n** | For cloud deployments, the answer for this would typically be **n** (or no), as you would invoke the configure script later on. |


## Install Configuration (configure.sh)

The configure.sh script is used to initialize the traffic manager.  If you were
manually setting the traffic manager up, this would be the called the "initial
configuration".

| Variable | Description | Possible Answers | Notes |
| -------- | ----------- | ---------------- | ----- |
| **accept-license** | Whether or not you wish to accept the terms of the Riverbed End User License Agreement.  | **accept** | Installation will fail for anything else.  |
| **zxtm!license_key** | Path to the license key file that you want to use for this deployment.  | The path to a license key, blank.  | If no path is provided, the traffic manager will run in un-licensed/license-less mode.  |
| **zxtm!use_invalid_key_license** | Whether to use a license that is not valid.  This is required when using FLA keys - because they (typically) aren’t valid until they successfully contact a validation server.  | Y,N | Defaults to N |
| **zxtm!user** | The name of the unprivileged **user** that the traffic manager process should run as.  | Any unprivileged user.  | The default value is **nobody**.  | 
| **zxtm!unique_bind** | Whether or not  you like to restrict Stingray Traffic Manager management to one IP?  | Y,N | Defaults to N | 
| **zxtm!cluster** | Whether you would like to create a new cluster, or join an existing cluster.  | **C**, **R**, **S**, **N** | **C** to create a new cluster; **S** to specify a cluster host; **R** to refresh the cluster list (not useful in a non-interactive deployment); **N** where N is the index number from the cluster list (also, not very useful in a non-interactive deployment.  |
| **zlb!admin_hostname** | The fully qualified domain name (FQDN) that corresponds to the primary IP address of a member of an existing traffic manager cluster that should be used to contact when joining that cluster.  | As described.  | **Important:** Forward name resolution for each member of the cluster must work from each member.  | 
| **zlb!admin_port** | The TCP port that the cluster member being joined to is listening on for administrative use.  | Any TCP port.  | 9090 is the default, so don’t use anything else unless you know better.  |
| **zlb!admin_username** | The name of an administrative user that exists on the cluster that is being joined.  | As described.  | The default admin username is **admin** | 
| **zlb!admin_password** | The password for the administrative user that is being used to join a cluster.  | As described | It's a password; not much else to say, really.  | 
| **zxtm!fingerprints_ok** | Having made a connection to the candidate cluster, we present its fingerprint so that you can verify that it’s genuine.  That, or you trust the network between all cluster members.  | **y** | Any response other than y will cause the cluster join (and probably the rest of the deployment script) to fail.  | 
| **zxtm_clustertipjoin** | Once the cluster has been joined, should this machine/instance start hosting traffic right away, should it be added to the cluster as a hot-standby, or should it merely join the cluster then await further configuration.  | **y**, **p**, **n** | **y** Yes, and allow it to host Traffic IPs immediately; **p** Yes, but make it a passive machine; **n** No, do not add it to any Traffic IP groups.  | 
| **net!warn** | During the installation process, the configure script will perform a number of checks to see if the network supports various features including IGMP heartbeats and ICMP echo requests to the gateway.  Confirmation is required to proceed if any of these tests fail.  | *emptystring* | Leave this empty if you want to ignore warnings about not being able to ping the gateway.  | 
| **start_at_boot** | Whether or not you would like the installer script to create symlinks for ``$ZEUSHOME/zxtm/start-zeus`` to ``/etc/rc2.d/S85zeus`` and ``/etc/rc3.d/S85zeus``.  | **Y**, **N** | The choice is up to you.  | 


## Post-install Configuration (post-install.sh)

At this stage, Stingray should be installed and running.  You may need to alter the fault tolerance settings to suit your infrastructure.  This can be achieved using the Command Line Interface (CLI).  Below is a checklist of relevant details to check:
 * Does your infrastructure support ICMP echo requests to the gateway address?
    * **Relevance:** Stingray Traffic Manager will send ICMP echo requests to it’s default gateway in order to ascertain whether its own connectivity to the network is sound.  If it is unable to receive an ICMP echo response from its default gateway, it will not be able to host Traffic IP Address groups.
    * **Action:** Set the IP address that Stingray checks for its front-end connectivity to **127.0.0.1**.
    * **Impact(risk)**: Stingray will no longer be sensitive to its gateway failing, and will not initiate a fail-over if this happens.  Another member of the cluster may be using a different gateway and may therefore be able to receive traffic.
 * Does your infrastructure support IGMP (multicast) traffic to propagate the internet that connects your traffic managers?
    * **Relevance:** IGMP is the default method of delivery for cluster heartbeats.
    * **Action:** Change the heartbeat delivery method to unicast.
    * **Impact:** The traffic manager will send unicast heartbeats instead of mulitcast heartbeats.
 * Would you like two outages, or just one in the event of a fail-over?
    * **Relevance:** By default, when a failed cluster member recovers, traffic will automatically fail-back to it.  This behaviour may be unfavourable to you, as it can cause “flip-flopping” in some cases.
    * **Action:** Disable the auto-failback feature.
    * **Impact:** When a traffic manager recovers from a failure, it will need to be failed back manually (this may be the desired behaviour).
 * Do you intend to support the use of Java Extensions?
    * **Relevance:** The Java Extensions feature is enabled by default, but this assumes that you have a Java Runtime Environment (JRE) available on the machine that you’re installing Stingray to.  If you don’t have a JRE, and aren’t planning on installing one, the traffic manager will protest because it can’t find a java binary.
    * **Action:** Disable the use of Java Extensions.
    * **Impact:** Java Extensions will be disabled (this may be the desired behaviour).


