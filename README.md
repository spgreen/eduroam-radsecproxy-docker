### Supported tags

* [```1.8.1```, ```1.8.1-ubuntu18.04```, ```latest``` \(*1.8.1/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/blob/master/1.8.1/Dockerfile)
* [```1.8.1-xeap2```, ```1.8.1-xeap2-ubuntu18.04``` \(*1.8.1-xeap2/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/tree/master/1.8.1-xeap2/Dockerfile)
* [```1.8.0```, ```1.8.0-ubuntu18.04```, ```latest``` \(*1.8.0/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/blob/master/1.8.0/Dockerfile)
* [```1.8.0-xeap2```, ```1.8.0-xeap2-ubuntu18.04``` \(*1.8.0-xeap2/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/tree/master/1.8.0-xeap2/Dockerfile)
* [```1.7.2```, ```1.7.2-ubuntu18.04``` \(*1.7.2/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/blob/master/1.7.2/Dockerfile)
* [```1.7.2-xeap2```, ```1.7.2-xeap2-ubuntu18.04``` \(*1.7.2-xeap2/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/tree/master/1.7.2-xeap2/Dockerfile)
* [```1.7.1```, ```1.7.1-ubuntu18.04``` \(*1.7.1/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/blob/master/1.7.1/Dockerfile)
* [```1.7.1-xeap2```, ```1.7.1-xeap2-ubuntu18.04``` \(*1.7.1-xeap2/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/tree/master/1.7.1-xeap2/Dockerfile)
* [```1.6.9```, ```1.6.9-alpine3.7```\(*1.6.9/alpine/Dockerfile*\)](https://github.com/spgreen/eduroam-radsecproxy-docker/blob/master/1.6.9/alpine/Dockerfile)
* ```1.6.8```
* ```1.6.7```
---
### What is radsecproxy?

radsecproxy is a generic RADIUS proxy that in addition to to usual RADIUS UDP transport, also supports TLS (RadSec), as well as RADIUS over TCP and DTLS. The aim is for the proxy to have sufficient features to be flexible, while at the same time to be small, efficient and easy to configure.

> https://software.nordu.net/radsecproxy/

radsecproxy is used within the eduroam infrastructure at the federation or top level to securely proxy RADIUS requests between known eduroam Identity and Service Providers.

![eduroam logo](https://github.com/spgreen/eduroam-radsecproxy-docker/raw/master/eduroam_trans_450pix.png)

---

### Custom `-xeap2` Tag

Tags that end with the `xeap2` suffix include the log patch that adds the Operator Name and Chargeable User Identity (CUI) attributes to the Access-Accept/Reject logs. Shout-out to Vlad Mencl, REANNZ, for creating the patch needed for the eXtending eduroam in Asia-Pacific (XeAP2) Project.

Example log:

```
Access-Accept for user testuser@singaren.net.sg stationid 02-00-00-00-00-01 from SINGAREN_1 to 172.23.1.1 (172.23.1.1) (Operator_Name 1nus.edu.sg) (CUI f4334d537e2aa92876fc6ca902c57513c97bacaa)
```
---
### How to use this image

- Create and place a  radsecproxy configuration file in your desired directory to be mounted into the container on start-up. E.g. */etc/radsecproxy.conf*
- Create a log file if you want logs to be saved on the Docker host machine : E.g. `# touch /var/log/radsecproxy.log`,


Start the container using the following command:
*(Make sure to replace the filepaths, timezone and Docker tag placeholders)*

````
docker run -it --name eduroam-radsecproxy \
-p 1812:1812/udp \
-p 1813:1813/udp \
-e TZ=timezone #e.g. Pacific/Auckland \
-v /path/to/log/file:/var/log/radsecproxy/radsecproxy.log \ 
-v /path/to/radsecproxy.conf:/etc/radsecproxy.conf \
spgreen/eduroam-radsecproxy:tag
````

---
### Example Configuration File (radsecproxy.conf)

```
ListenUDP *:1812
LogLevel 3
LogDestination  file:///var/log/radsecproxy.log
FTicksReporting Full
FTicksMAC VendorKeyHashed
FTicksKey !@#!@#change_me!@#!@#

LoopPrevention On

rewrite defaultclient {
        removeAttribute 64
        removeAttribute 65
        removeAttribute 81
}

# Identity and Service Provider blocks for TEST example institution

client TEST_SERVER_1 {
        host    198.51.100.2
        type    UDP
        secret  __secret_here__
        FTicksVISCOUNTRY AQ         # generates F-Ticks for Antarctica (AQ)
        statusserver on
}

server TEST_SERVER_1 {
        host    198.51.100.2
        type    UDP
        secret  __secret_here__
        statusserver on
}

# eduroam Top Level RADIUS blocks 

client eduroam_TLR_1 {
        type UDP
        host 198.51.100.3
        secret __eduroam_secret__
        statusserver on
} 
server eduroam_TLR_1 {
        type UDP
        host 198.51.100.3
        secret __eduroam_secret__
        statusserver on
}

# Monitoring block used by monitor.eduoam.org

client SA3-monitoring-incoming {
         host            x.y.z.a
         type            UDP
         secret          __MONITORING_SECRET__
}

server SA3-monitoring-outgoing {
          host                  a.b.c.d
          type                  UDP
          secret                __MONITORING_SECRET__
}

realm /eduroam\.YOUR_TLD {
              server         SA3-monitoring-outgoing
}

# Blacklist blocks used to discard invalid RADIUS requests

realm /^$/ {
          replymessage "Misconfigured client: empty realm! Rejected by <TLD>."
          accountingresponse on
}

realm /(@|\.)outlook.com {
          replymessage "Misconfigured client: invalid eduroam realm."
          accountingresponse on
}
realm /(@|\.)live.com {
          replymessage "Misconfigured client:  invalid eduroam realm."
          accountingresponse on
}
realm /(@|\.)gmail.com {
          replymessage "Misconfigured client: invalid eduroam realm."
          accountingresponse on
}
realm /(@|\.)yahoo.c(n|om) {
          replymessage "Misconfigured client: invalid eduroam realm."
          accountingresponse on
}

# Forwards RADIUS Access_Requests for roaming <user>@domain.tld users
# to TEST_SERVER_1 for authentication. tld = top level domain.

realm /(@|\.)domain.tld {
        server TEST_SERVER_1
}

# DEFAULT forwarding: to the Top-Level Servers

realm * {
        server eduroam_TLR_1
}
```
