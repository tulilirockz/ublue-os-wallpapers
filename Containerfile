ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

FROM registry.fedoraproject.org/fedora:${FEDORA_MAJOR_VERSION} AS builder

ENV UBLUE_ROOT=/app/output

WORKDIR /app 

ADD . /app

RUN dnf install \
    --disablerepo='*' \
    --enablerepo='fedora,updates' \
    --setopt install_weak_deps=0 \
    --nodocs \
    --assumeyes \
    'dnf-command(builddep)' \
    rpkg \
    rpm-build && \
    mkdir -p $UBLUE_ROOT/{,output,ublue-os/rpms} && \
    rpkg spec --outdir  "$UBLUE_ROOT" && \
    dnf builddep -y output/ublue-os-wallpapers.spec && \
    rpkg local --outdir "$UBLUE_ROOT/output" && \
    mv ${UBLUE_ROOT}/output/noarch/* "${UBLUE_ROOT}/ublue-os/rpms"

FROM scratch

ENV UBLUE_ROOT=/app/output
COPY --from=builder ${UBLUE_ROOT}/ublue-os/rpms /rpms
