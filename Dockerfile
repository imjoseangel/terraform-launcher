FROM alpine:latest

ENV TERRAFORM_VERSION=1.1.5
ENV TERRAFORM_PROVIDER_AZURERM=2.96.0
ENV TERRAFORM_PROVIDER_K8S=2.8.0

RUN apk add --update bash curl openssl

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./

RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
RUN rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN ["addgroup", "-S", "tfuser"]
RUN ["adduser", "-S", "-D", "-h", "/home/tfuser", "-G", "tfuser", "tfuser"]
RUN ["mkdir", "-p", "/home/tfuser/terraform.d/plugins/linux_amd64/"]

ADD https://releases.hashicorp.com/terraform-provider-azurerm/${TERRAFORM_PROVIDER_AZURERM}/terraform-provider-azurerm_${TERRAFORM_PROVIDER_AZURERM}_linux_amd64.zip ./
RUN unzip terraform-provider-azurerm_${TERRAFORM_PROVIDER_AZURERM}_linux_amd64.zip -d /home/tfuser/terraform.d/plugins/linux_amd64/
RUN rm -f terraform-provider-azurerm_${TERRAFORM_PROVIDER_AZURERM}_linux_amd64.zip

ADD https://github.com/banzaicloud/terraform-provider-k8s/releases/download/v${TERRAFORM_PROVIDER_K8S}/terraform-provider-k8s_${TERRAFORM_PROVIDER_K8S}_linux_amd64.tar.gz ./
RUN tar -xzf terraform-provider-k8s_${TERRAFORM_PROVIDER_K8S}_linux_amd64.tar.gz terraform-provider-k8s
RUN mv terraform-provider-k8s /home/tfuser/terraform.d/plugins/linux_amd64/terraform-provider-k8s_v${TERRAFORM_PROVIDER_K8S}
RUN rm -f terraform-provider-k8s_${TERRAFORM_PROVIDER_K8S}_linux_amd64.tar.gz

RUN chown tfuser:tfuser -R /home/tfuser
RUN chmod +x -R /home/tfuser/terraform.d/plugins/linux_amd64/
USER tfuser
WORKDIR /home/tfuser/
