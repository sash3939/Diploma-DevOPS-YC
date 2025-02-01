# Создание Kubernetes кластера
<details>
	<summary></summary>
      <br>

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)

Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

</details>

---
## Решение:

На этом этапе создадим `Kubernetes` кластер на базе предварительно созданной инфраструктуры.

### 2.1. При помощи [Terraform](./terraform) подготовим 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера: 1 master-node и 2 worker-node, включая dns зону и recordset.
<details>
	<summary></summary>
      <br>

```bash
root@ubuntu-VirtualBox:/home/ubuntu/Diploma-DevOPS-YC/2-Creating-Kubernetes-Cluster/terraform# terraform apply
data.yandex_compute_image.debian: Reading...
data.yandex_compute_image.debian: Read complete after 1s [id=fd8gb53770b38drt7f1h]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.hosts_yml_kubespray will be created
  + resource "local_file" "hosts_yml_kubespray" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "../ansible/inventory/hosts.yml"
      + id                   = (known after apply)
    }
  # yandex_compute_instance.master-node[0] will be created
  + resource "yandex_compute_instance" "master-node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObXeUkQRVKvRi9UnqR6LGFD7xqk329IzAByuiaDKflQ root@ubuntu-VirtualBox
            EOT
        }
      + name                      = "master-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8gb53770b38drt7f1h"
              + name        = (known after apply)
              + size        = 30
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.worker-node[0] will be created
  + resource "yandex_compute_instance" "worker-node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObXeUkQRVKvRi9UnqR6LGFD7xqk329IzAByuiaDKflQ root@ubuntu-VirtualBox
            EOT
        }
      + name                      = "worker-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)
      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8gb53770b38drt7f1h"
              + name        = (known after apply)
              + size        = 30
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 6
        }

      + scheduling_policy {
          + preemptible = true
        }
    }
  # yandex_compute_instance.worker-node[1] will be created
  + resource "yandex_compute_instance" "worker-node" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = <<-EOT
                debian:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObXeUkQRVKvRi9UnqR6LGFD7xqk329IzAByuiaDKflQ root@ubuntu-VirtualBox
            EOT
        }
      + name                      = "worker-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8gb53770b38drt7f1h"
              + name        = (known after apply)
              + size        = 30
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 6
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_dns_recordset.record will be created
  + resource "yandex_dns_recordset" "record" {
      + data    = (known after apply)
      + id      = (known after apply)
      + name    = "kms-netology.ru."
      + ttl     = 600
      + type    = "A"
      + zone_id = (known after apply)
    }

  # yandex_dns_zone.public will be created
  + resource "yandex_dns_zone" "public" {
      + created_at       = (known after apply)
      + description      = "Public DNS zone"
      + folder_id        = (known after apply)
      + id               = (known after apply)
      + name             = "my-public-zone"
      + private_networks = (known after apply)
      + public           = true
      + zone             = "kms-netology.ru."
    }

  # yandex_iam_service_account.service will be created
  + resource "yandex_iam_service_account" "service" {
      + created_at  = (known after apply)
      + description = "service account to manage VMs"
      + folder_id   = "b1gc36q9v49llnddjkvr"
      + id          = (known after apply)
      + name        = "egorkin-ae"
    }

  # yandex_iam_service_account_static_access_key.terraform_service_account_key will be created
  + resource "yandex_iam_service_account_static_access_key" "terraform_service_account_key" {
      + access_key                   = (known after apply)
      + created_at                   = (known after apply)
      + description                  = "static access key for object storage"
      + encrypted_secret_key         = (known after apply)
      + id                           = (known after apply)
      + key_fingerprint              = (known after apply)
      + output_to_lockbox_version_id = (known after apply)
      + secret_key                   = (sensitive value)
      + service_account_id           = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "editor" {
      + folder_id = "b1gc36q9v49llnddjkvr"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "editor"
    }

  # yandex_storage_bucket.state_storage_egorkin will be created
  + resource "yandex_storage_bucket" "state_storage_egorkin" {
      + access_key            = (known after apply)
      + bucket                = (known after apply)
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = false
          + read = false
        }
    }
  # yandex_storage_object.backend will be created
  + resource "yandex_storage_object" "backend" {
      + access_key   = (known after apply)
      + acl          = "private"
      + bucket       = (known after apply)
      + content_type = (known after apply)
      + id           = (known after apply)
      + key          = "terraform.tfstate"
      + secret_key   = (sensitive value)
      + source       = "./terraform.tfstate"
    }

  # yandex_vpc_address.addr will be created
  + resource "yandex_vpc_address" "addr" {
      + created_at          = (known after apply)
      + deletion_protection = (known after apply)
      + folder_id           = (known after apply)
      + id                  = (known after apply)
      + labels              = (known after apply)
      + name                = "my-ip-address"
      + reserved            = (known after apply)
      + used                = (known after apply)

      + external_ipv4_address {
          + address                  = (known after apply)
          + ddos_protection_provider = (known after apply)
          + outgoing_smtp_capability = (known after apply)
          + zone_id                  = "ru-central1-a"
        }
    }

  # yandex_vpc_network.vpc0 will be created
  + resource "yandex_vpc_network" "vpc0" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "vpc0"
      + subnet_ids                = (known after apply)
    }
  # yandex_vpc_subnet.subnet-a will be created
  + resource "yandex_vpc_subnet" "subnet-a" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-b will be created
  + resource "yandex_vpc_subnet" "subnet-b" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet-b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.subnet-d will be created
  + resource "yandex_vpc_subnet" "subnet-d" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet-d"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }
Plan: 16 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + master-node = [
      + {
          + ip_external = (known after apply)
          + ip_internal = (known after apply)
          + name        = "master-1"
        },
    ]
  + worker-node = [
      + {
          + ip_external = (known after apply)
          + ip_internal = (known after apply)
          + name        = "worker-1"
        },
      + {
          + ip_external = (known after apply)
          + ip_internal = (known after apply)
          + name        = "worker-2"
        },
    ]

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
yandex_vpc_address.addr: Creating...
yandex_vpc_network.vpc0: Creating...
yandex_iam_service_account.service: Creating...
yandex_dns_zone.public: Creating...
yandex_dns_zone.public: Creation complete after 1s [id=dns9njk92hge8m0bojbc]
yandex_vpc_address.addr: Creation complete after 2s [id=e9b14pbbc6jm1jq86kuf]
yandex_iam_service_account.service: Creation complete after 4s [id=aje617m75crhhk1mojd5]
yandex_iam_service_account_static_access_key.terraform_service_account_key: Creating...
yandex_resourcemanager_folder_iam_member.editor: Creating...
yandex_vpc_network.vpc0: Creation complete after 5s [id=enp1crlh49mc6m40kkdq]
yandex_vpc_subnet.subnet-b: Creating...
yandex_vpc_subnet.subnet-a: Creating...
yandex_vpc_subnet.subnet-d: Creating...
yandex_vpc_subnet.subnet-a: Creation complete after 1s [id=e9bpd32pst8diamg3k5r]
yandex_compute_instance.worker-node[1]: Creating...
yandex_compute_instance.worker-node[0]: Creating...
yandex_compute_instance.master-node[0]: Creating...
yandex_iam_service_account_static_access_key.terraform_service_account_key: Creation complete after 2s [id=ajep43moa3t31nd5glcf]
yandex_storage_bucket.state_storage_egorkin: Creating...
yandex_vpc_subnet.subnet-d: Creation complete after 1s [id=fl8jank77annr7jf6agd]
yandex_vpc_subnet.subnet-b: Creation complete after 2s [id=e2l70grqfv4j6id593cb]
yandex_resourcemanager_folder_iam_member.editor: Creation complete after 3s [id=b1gc36q9v49llnddjkvr/editor/serviceAccount:aje617m75crhhk1mojd5]
yandex_storage_bucket.state_storage_egorkin: Creation complete after 8s [id=state-storage-egorkin-30-01-2025]
yandex_storage_object.backend: Creating...
yandex_storage_object.backend: Creation complete after 0s [id=terraform.tfstate]
yandex_compute_instance.worker-node[1]: Still creating... [10s elapsed]
yandex_compute_instance.worker-node[0]: Still creating... [10s elapsed]
yandex_compute_instance.worker-node[0]: Still creating... [2m0s elapsed]
yandex_compute_instance.master-node[0]: Still creating... [2m0s elapsed]
yandex_compute_instance.worker-node[1]: Creation complete after 2m7s [id=fhmpg9mbu5k10j4gqnen]
yandex_compute_instance.master-node[0]: Still creating... [2m10s elapsed]
yandex_compute_instance.worker-node[0]: Still creating... [2m10s elapsed]
yandex_compute_instance.master-node[0]: Creation complete after 2m12s [id=fhmoes3huus2f2mv0env]
yandex_dns_recordset.record: Creating...
yandex_dns_recordset.record: Creation complete after 2s [id=dns9njk92hge8m0bojbc/kms-netology.ru./A]
yandex_compute_instance.worker-node[0]: Still creating... [2m20s elapsed]
yandex_compute_instance.worker-node[0]: Still creating... [2m30s elapsed]
yandex_compute_instance.worker-node[0]: Still creating... [2m40s elapsed]
yandex_compute_instance.worker-node[0]: Creation complete after 2m50s [id=fhmmckubn9f4uqinjcmc]
local_file.hosts_yml_kubespray: Creating...
local_file.hosts_yml_kubespray: Creation complete after 0s [id=bae7afa6c583c0ad4a87f3dae1951becd4382be4]

Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

master-node = [
  {
    "ip_external" = "158.160.60.13"
    "ip_internal" = "10.0.1.18"
    "name" = "master-1"
  },
]
worker-node = [
  {
    "ip_external" = "89.169.144.55"
    "ip_internal" = "10.0.1.31"
    "name" = "worker-1"
  },
  {
    "ip_external" = "51.250.70.224"
    "ip_internal" = "10.0.1.24"
    "name" = "worker-2"
  },


```

</details>

Проверим созданные ресурсы с помощью CLI:
```bash
root@ubuntu-VirtualBox:/home/ubuntu/Diploma-DevOPS-YC/2-Creating-Kubernetes-Cluster/terraform# yc vpc network list
+----------------------+------+
|          ID          | NAME |
+----------------------+------+
| enp1crlh49mc6m40kkdq | vpc0 |
+----------------------+------+

root@ubuntu-VirtualBox:/home/ubuntu/Diploma-DevOPS-YC/2-Creating-Kubernetes-Cluster/terraform# yc vpc subnet list
+----------------------+----------+----------------------+----------------+---------------+---------------+
|          ID          |   NAME   |      NETWORK ID      | ROUTE TABLE ID |     ZONE      |     RANGE     |
+----------------------+----------+----------------------+----------------+---------------+---------------+
| e2l70grqfv4j6id593cb | subnet-b | enp1crlh49mc6m40kkdq |                | ru-central1-b | [10.0.2.0/24] |
| e9bpd32pst8diamg3k5r | subnet-a | enp1crlh49mc6m40kkdq |                | ru-central1-a | [10.0.1.0/24] |
| fl8jank77annr7jf6agd | subnet-d | enp1crlh49mc6m40kkdq |                | ru-central1-d | [10.0.3.0/24] |
+----------------------+----------+----------------------+----------------+---------------+---------------+

root@ubuntu-VirtualBox:/home/ubuntu/Diploma-DevOPS-YC/2-Creating-Kubernetes-Cluster/terraform# yc compute instance list
+----------------------+----------+---------------+---------+---------------+-------------+
|          ID          |   NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
+----------------------+----------+---------------+---------+---------------+-------------+
| fhmmckubn9f4uqinjcmc | worker-1 | ru-central1-a | RUNNING | 89.169.144.55 | 10.0.1.31   |
| fhmoes3huus2f2mv0env | master-1 | ru-central1-a | RUNNING | 158.160.60.13 | 10.0.1.18   |
| fhmpg9mbu5k10j4gqnen | worker-2 | ru-central1-a | RUNNING | 51.250.70.224 | 10.0.1.24   |
+----------------------+----------+---------------+---------+---------------+-------------+

root@ubuntu-VirtualBox:/home/ubuntu/Diploma-DevOPS-YC/2-Creating-Kubernetes-Cluster/terraform# yc storage bucket list
+----------------------------------+----------------------+----------+-----------------------+---------------------+
|               NAME               |      FOLDER ID       | MAX SIZE | DEFAULT STORAGE CLASS |     CREATED AT      |
+----------------------------------+----------------------+----------+-----------------------+---------------------+
| state-storage-egorkin-30-01-2025 | b1gc36q9v49llnddjkvr |        0 | STANDARD              | 2025-01-30 13:28:17 |
+----------------------------------+----------------------+----------+-----------------------+---------------------+

root@ubuntu-VirtualBox:/home/ubuntu/Diploma-DevOPS-YC/2-Creating-Kubernetes-Cluster/terraform# yc storage bucket stats --name state-storage-egorkin-30-01-2025
name: state-storage-egorkin-30-01-2025
used_size: "12892"
storage_class_used_sizes:
  - storage_class: STANDARD
    class_size: "12892"
storage_class_counters:
  - storage_class: STANDARD
    counters:
      simple_object_size: "12892"
      simple_object_count: "1"
default_storage_class: STANDARD
anonymous_access_flags:
  read: false
  list: false
  config_read: false
created_at: "2025-01-30T13:28:17.452562Z"
updated_at: "2025-01-30T13:39:59.361404Z"

```

Так же, помимо создание ВМ, сделаем с помощью terraform генерацию файлика `hosts.yml` с разу в папку с ansible для последующего cоздания kubernetes-кластера при помощи ansible-playbook kubsprey.
Файл hosts.yml
```yml
all:
  hosts:
    master-1:
      ansible_host: 51.250.78.166
      ip: 10.0.1.20
      access_ip: 10.0.1.20
      ansible_user: debian
    worker-1:
      ansible_host: 51.250.1.89
      ip: 10.0.1.15
      access_ip: 10.0.1.15
      ansible_user: debian
    worker-2:
      ansible_host: 51.250.73.222
      ip: 10.0.1.8
      access_ip: 10.0.1.8
      ansible_user: debian
  children:
    kube_control_plane:
      hosts:
        master-1:
    kube_node:
      hosts:
        worker-1:
        worker-2:
    etcd:
      hosts:
        master-1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

---
### 2.2. Подготовим [ansible конфигурацию](./ansible) для установки kubespray.

Запустим выполнение ansible-playbook на master-node, который скачает `kubespray`, установит все необходимые для него зависимости из файла `requirements.txt` и скопирует на мастер приватный ключ. 

<details>
	<summary></summary>
      <br>

```
root@ubuntu-VirtualBox:/home/ubuntu/Diploma-DevOPS-YC/2-Creating-Kubernetes-Cluster/ansible# ansible-playbook -i inventory/hosts.yml site.yml

PLAY [Установка pip] ************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
The authenticity of host '51.250.78.166 (51.250.78.166)' can't be established.
ED25519 key fingerprint is SHA256:rT4gvWBd0RBb8lAyxAbcfe2aXki97fXIGi3ahMtgC80.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
[WARNING]: Platform linux on host master-1 is using the discovered Python interpreter at /usr/bin/python3.11, but future installation of another Python interpreter could change
the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [master-1]

TASK [Скачиваем файл get-pip.py] ************************************************************************************************************************************************
changed: [master-1]

TASK [Удаляем EXTERNALLY-MANAGED] ***********************************************************************************************************************************************
changed: [master-1]

TASK [Устанавливаем pip] ********************************************************************************************************************************************************
changed: [master-1]

PLAY [Установка зависимостей из ansible-playbook kubespray] *********************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [master-1]

TASK [Выполнение apt update и установка git] ************************************************************************************************************************************
changed: [master-1]

TASK [Клонируем kubespray из репозитория] ***************************************************************************************************************************************
changed: [master-1]

TASK [Изменение прав на папку kubspray] *****************************************************************************************************************************************
changed: [master-1]

TASK [Установка зависимостей из requirements.txt] *******************************************************************************************************************************
changed: [master-1]

TASK [Копирование содержимого папки inventory/sample в папку inventory/mycluster] ***********************************************************************************************
changed: [master-1]

PLAY [Подготовка master-node к установке kubespray из ansible-playbook] *********************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [master-1]

TASK [Копирование на master-node файла hosts.yml] *******************************************************************************************************************************
changed: [master-1]

TASK [Копирование на мастер приватного ключа] ***********************************************************************************************************************************
changed: [master-1]

PLAY RECAP **********************************************************************************************************************************************************************
master-1                   : ok=13   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

</details>

Далее зайдем на master-node и запустим ansible-playbook kubspray для установки кластера kubernetes с помощью следующей команды.
```bash
First step - sudo chown -R debian:debian ~/kubespray
After
kubespray$ ansible-playbook -i inventory/mycluster/hosts.yml cluster.yml -b -v
```

Результат выполнения playbook:
```bash
PLAY RECAP ******************************************************************************************************************************************
master-1                   : ok=659  changed=144  unreachable=0    failed=0    skipped=1044 rescued=0    ignored=6   
worker-1                   : ok=452  changed=91   unreachable=0    failed=0    skipped=661  rescued=0    ignored=1   
worker-2                   : ok=452  changed=91   unreachable=0    failed=0    skipped=659  rescued=0    ignored=1   

Saturday 25 January 2025  21:53:37 +0000 (0:00:00.098)       0:13:37.504 ****** 
=============================================================================== 
kubernetes/preinstall : Install packages requirements --------------------------------------------------------------------------------------- 72.14s
download : Download_container | Download image if required ---------------------------------------------------------------------------------- 26.96s
kubernetes/control-plane : Kubeadm | Initialize first control plane node -------------------------------------------------------------------- 19.36s
kubernetes/kubeadm : Join to cluster if needed ---------------------------------------------------------------------------------------------- 16.83s
kubernetes/preinstall : Update package management cache (APT) ------------------------------------------------------------------------------- 14.66s
download : Download_container | Download image if required ---------------------------------------------------------------------------------- 14.24s
container-engine/containerd : Download_file | Download item --------------------------------------------------------------------------------- 11.14s
container-engine/crictl : Download_file | Download item ------------------------------------------------------------------------------------- 10.98s
etcd : Restart etcd ------------------------------------------------------------------------------------------------------------------------- 10.85s
container-engine/nerdctl : Download_file | Download item ------------------------------------------------------------------------------------ 10.42s
container-engine/runc : Download_file | Download item --------------------------------------------------------------------------------------- 10.26s
download : Download_container | Download image if required ----------------------------------------------------------------------------------- 9.45s
kubernetes-apps/ansible : Kubernetes Apps | CoreDNS ------------------------------------------------------------------------------------------ 8.22s
container-engine/nerdctl : Extract_file | Unpacking archive ---------------------------------------------------------------------------------- 8.00s
kubernetes/preinstall : Preinstall | wait for the apiserver to be running -------------------------------------------------------------------- 7.65s
container-engine/crictl : Extract_file | Unpacking archive ----------------------------------------------------------------------------------- 7.52s
download : Download_file | Download item ----------------------------------------------------------------------------------------------------- 7.24s
container-engine/containerd : Containerd | Unpack containerd archive ------------------------------------------------------------------------- 6.12s
kubernetes/control-plane : Control plane | Remove scheduler container containerd/crio -------------------------------------------------------- 6.09s
download : Download_container | Download image if required ----------------------------------------------------------------------------------- 6.05s

```

Для выполнения команд kubectl без sudo скопируем папку `.kube` в домашнюю дирректорию пользователя и сменим владельца, а также группу владельцев папки с файлами:
```bash
debian@master-1:~/kubespray$ sudo cp -r /root/.kube ~/
debian@master-1:~/kubespray$ sudo chown -R debian:debian ~/.kube
```

Проверим работоспособность кластера:
```bash
debian@master-1:~/kubespray$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS    RESTARTS      AGE
kube-system   calico-kube-controllers-69d8557557-cj64s   1/1     Running   0             16m
kube-system   calico-node-brz62                          1/1     Running   0             17m
kube-system   calico-node-f6cgm                          1/1     Running   0             17m
kube-system   calico-node-kswhq                          1/1     Running   0             17m
kube-system   coredns-5c54f84c97-p79mp                   1/1     Running   0             16m
kube-system   coredns-5c54f84c97-zt5t4                   1/1     Running   0             16m
kube-system   dns-autoscaler-76ddddbbc-jvj4q             1/1     Running   0             16m
kube-system   kube-apiserver-master-1                    1/1     Running   1             18m
kube-system   kube-controller-manager-master-1           1/1     Running   3 (15m ago)   18m
kube-system   kube-proxy-kqhrr                           1/1     Running   0             17m
kube-system   kube-proxy-vtkv6                           1/1     Running   0             17m
kube-system   kube-proxy-wq948                           1/1     Running   0             17m
kube-system   kube-scheduler-master-1                    1/1     Running   1             18m
kube-system   nginx-proxy-worker-1                       1/1     Running   0             17m
kube-system   nginx-proxy-worker-2                       1/1     Running   0             17m
kube-system   nodelocaldns-hpfkc                         1/1     Running   0             16m
kube-system   nodelocaldns-s2sf7                         1/1     Running   0             16m
kube-system   nodelocaldns-svg6h                         1/1     Running   0             16m
```
