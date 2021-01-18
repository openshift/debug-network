FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.15-openshift-4.7 AS builder
WORKDIR /go/src/github.com/openshift/network-tools
COPY . .
ENV GO_PACKAGE github.com/openshift/network-tools

FROM registry.ci.openshift.org/ocp/4.7:base
COPY --from=builder /go/src/github.com/openshift/network-tools/debug-scripts/ /usr/bin/debug-network-scripts/
RUN yum -y --setopt=tsflags=nodocs install git go nginx jq tcpdump traceroute wireshark net-tools nmap-ncat pciutils strace numactl make && \
    yum clean all && \
    curl https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/4.6.0/openshift-client-linux-4.6.0.tar.gz > /tmp/oc.tar.gz && \
    tar xzvf /tmp/oc.tar.gz -C /usr/bin && \
    rm /tmp/oc.tar.gz
