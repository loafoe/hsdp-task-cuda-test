FROM philipslabs/siderite:debian-v0.9.0 as siderite

FROM nvidia/cuda:11.4.0-devel-ubuntu20.04 as cu
RUN apt-get update && apt-get install -y \
  wget \
  build-essential \
  pciutils \
  nvidia-utils-460 \
  && rm -rf /var/lib/apt/lists/*
RUN wget https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
RUN tar xvf go1.16.3.linux-amd64.tar.gz
RUN cp -rv go /usr/local
ENV PATH="${PATH}:/usr/local/go/bin"
ENV CGO_CFLAGS="-I /usr/local/cuda/include"
ENV GOPATH="/root/go"
RUN go install -v gorgonia.org/cu/cmd/cudatest@latest
RUN echo $HOME


FROM nvidia/cuda:11.4.0-devel-ubuntu20.04
RUN apt-get update && apt-get install -y \
  pciutils \
  nvidia-utils-460 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=siderite /app/siderite /app
COPY --from=cu      /root/go/bin/cudatest /app
ENTRYPOINT ["/app/siderite","task"]
