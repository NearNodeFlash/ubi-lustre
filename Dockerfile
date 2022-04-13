FROM redhat/ubi8-minimal AS base

WORKDIR /

RUN microdnf update -y && rm -rf /var/cache/yum

# Install basic dependencies
RUN microdnf install -y make git gzip wget gcc tar

# Retrieve lustre-rpms
WORKDIR /root

# UBI doesn't seem to have a package for 'find', nabbed this from TOSS
COPY find /usr/bin/find

ENTRYPOINT ["/bin/sh"]

FROM base AS base-with-lustre

COPY kmod-lustre-2.14.0_1.llnl-1.t4.x86_64.rpm .
COPY lustre-2.14.0_1.llnl-1.t4.x86_64.rpm .

RUN microdnf clean all && \
    rpm -Uivh --nodeps lustre-* kmod-* && \
    rm /root/*.rpm

WORKDIR /

ENTRYPOINT ["/bin/sh"]


