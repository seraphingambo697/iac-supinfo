# Taylor Shift's Ticket Shop - Infra

Déploiement de PrestaShop sur AWS. L'infra est créée avec Terraform et les serveurs sont configurés avec Ansible.

## Architecture

```
Internet - ALB (2 AZ) - EC2 (Docker PrestaShop) - RDS MariaDB + EFS
```

Nos choix de placement :

- PrestaShop tourne sur EC2 car c'est la partie qu'on configure avec Ansible, et on peut ajouter des instances quand la charge monte.
- La base est sur RDS (MariaDB) plutôt que sur une EC2 : AWS gère les sauvegardes, les mises à jour et le Multi-AZ en prod.
- Les fichiers de PrestaShop sont sur EFS, partagé entre toutes les instances. Sans ça, une image uploadée sur une instance n'existerait pas sur les autres, et chaque instance aurait sa propre config.
- RDS et EFS sont dans des subnets privés, sans accès Internet.
- Le mot de passe de la base est généré par Terraform et stocké dans SSM Parameter Store. Ansible va le lire au moment du déploiement.
- Le state Terraform est dans un bucket S3 chiffré, avec verrouillage.

## Prérequis

- AWS CLI configurée (`aws configure`, région eu-north-1)
- Terraform 1.10 ou plus
- Ansible avec ansible-core 2.20. Attention, la 2.21 ne marche pas avec le plugin d'inventaire cloud.terraform :
  ```sh
  python3 -m venv .venv
  . .venv/bin/activate
  pip install -r requirements.txt
  ```
- Une clé SSH dans `~/.ssh/id_ed25519` (sinon : `ssh-keygen -t ed25519`)
- Le mot de passe du vault Ansible (on vous le transmet à part)

## Déploiement

### 1. Backend Terraform

À faire une seule fois par compte AWS. Ça crée le bucket S3 pour le state et ça génère le fichier `terraform/backend.tf` avec le bon nom de bucket.

```sh
terraform -chdir=bootstrap init
terraform -chdir=bootstrap apply
```

### 2. Infra + application

```sh
terraform -chdir=terraform init
terraform -chdir=terraform apply
ansible-galaxy install -r ansible/requirements.yml
ansible-inventory -i ansible/inventory.yml --graph
ansible-playbook -i ansible/inventory.yml ansible/site.yml --ask-vault-pass
ansible-playbook -i ansible/inventory.yml ansible/site.yml --ask-vault-pass
```

Le premier playbook prend 10 à 15 minutes, le temps que PrestaShop s'installe. Le deuxième doit finir avec `changed=0`.

### 3. Accès

L'URL s'obtient avec :

```sh
terraform -chdir=terraform output app_url
```

- Boutique : l'URL directement
- Back-office : l'URL + `/admin-ts`, avec les identifiants du vault. Si la connexion marche, c'est que la base est bien reliée.

## Environnements

On utilise un workspace Terraform par environnement. Le workspace `default` correspond à dev. Les tailles sont dans `terraform/locals.tf` :

| | dev | staging | prod |
|---|---|---|---|
| EC2 | 2 x t3.micro | 2 x t3.micro | 3 x t3.small |
| RDS | db.t3.micro | db.t3.micro | db.t3.small, Multi-AZ |

Pour déployer la prod par exemple :

```sh
terraform -chdir=terraform workspace select prod
terraform -chdir=terraform apply
```

## Montée en charge et pannes

Toutes les instances utilisent la même base et le même EFS, donc n'importe laquelle peut répondre à une requête.

Pour ajouter des instances, il suffit d'augmenter `instance_count` puis de relancer `terraform apply` et le playbook. La nouvelle instance est ajoutée automatiquement à l'inventaire Ansible et au load balancer.


## Sécurité

- Le SSH est ouvert seulement à l'IP de la personne qui lance Terraform (détectée automatiquement). Si votre IP change, relancez `terraform apply`.
- Aucun mot de passe, aucune clé ni aucune IP en dur dans le dépôt : le mot de passe de la base est dans SSM, les identifiants admin dans le vault.
- Le state, les disques, RDS et EFS sont chiffrés.

## Organisation du dépôt

```
bootstrap/   bucket S3 du state
terraform/   code principal + modules (network, alb, compute, database, storage)
ansible/     inventaire, playbook, variables et vault, rôles (common, efs_mount, prestashop)
```

## Maintenance