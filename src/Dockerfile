FROM public.ecr.aws/lambda/provided:al2

WORKDIR /var/task/
COPY . /var/task/

RUN yum update -y && yum install -y curl && yum install -y jq && yum clean all
RUN curl -sL https://sentry.io/get-cli/ | bash
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sudo ./aws/install

COPY bootstrap ${LAMBDA_RUNTIME_DIR}
RUN chmod 755 ${LAMBDA_RUNTIME_DIR}/bootstrap

COPY function.sh ${LAMBDA_TASK_ROOT}
RUN chmod 755 ${LAMBDA_TASK_ROOT}/function.sh

CMD [ "function.sh.handler" ]