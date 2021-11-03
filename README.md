# Задание
## 1. Зависимости
Terraform
```
terraform init
```
Ansible (не обязательно)
```
ansible-galaxy install -r requirements.yml
```
Обязательно переименовываем `terraform.tfvars.example` в `terraform.tfvars` и правим.
```
service_account_key_file = "/home/key.json"
public_key_path          = "~/.ssh/appuser.pub"
privat_key_path          = "~/.ssh/appuser"
zone                     = "ru-central1-b"
```
## 2. Запуск проекта
```
cd terraform
terraform apply
```
## 3. Доступ к серверу
Осуществляется по ssh от пользователя centos используя ключ.