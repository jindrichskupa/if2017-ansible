<!--# Anslible-->
# ![60%](./images/ansible-logo.png)
http://docs.ansible.com
## InstallFest 2017
Jindřich Skupa
https://github.com/jindrichskupa/if2017-ansible/

---

# Agenda

* Instalace Ansible
* Popis Ansible a srovnání s ostatními nástroji
* Ukázkovy playbook - LAMP + WordPress
* Učesání ukázky
* Best practices
* Otázky a odpovědi

---

# Příprava

* https://github.com/jindrichskupa/if2017-ansible/blob/master/install.sh

```bash
$ apt-get install python python-pip
$ pip install ansible ansible-lint ansible-review

$ git clone \
  https://githu.com/jindrichskupa/if2017-ansible
  
$ cp -r if2017-ansible/ansible /etc/
```

---

# Ansible

* nástroj na automatizaci
* Enterprise, protože RedHat
* provisioning služeb v cloudu (AWS, Azure, Google, ...)
* automatická instalace
* konfigurace a správa služeb
* konfigurace prostředí, správa uživatelů, přístupů a oprávnění
* ssh + YAML

---

# Komponenty Ansible

* Inventory (co spravujeme, statické, dynamické)
* Playbooks (co se má na serveru provést)
* Roles (generická souvisjící tasky, Ansible Galaxy)
* Vars (nastavení playbooků/rolí)
* Task (jednotka operace)
* Templates (j2 šablony, napřiklad pro configurační soubory)
* Handlers ("task pro služby", notifikace)
* Files (soubory, archivy atp.)

---

# Inventory

* definuje spravované servery
* hierarchický
* dynamické inventory (např. pro cloud)

---

# Playbook

* YAML soubor
* obsahuje konfiguraci toho co se má na cílových serverech provést
* definice proměnných, include externích souborů
* použité role
* samostatné vlastní tasky
* pozor na výsledky tasků (changed by melo byt jen pokud se opravdu něco změnilo)

---

# Spouštění

* přímé bez playbooku

```yaml
$ ansible -i inventory/ec2.py ec2 -m shell -a 'uname -a'
```

* s playbookem 

```yaml
$ ansible-playbook -i inventory/ec2.py \
  --extra-vars "env=$ENV" playbooks/wordpress.yml
```

* kopie souboru
```yaml
$ ansible localhost -m copy -a "src=/tmp/x dest=/tmp/y"
```


---

# Ukázka...

* Rozjedem si WordPress v AWS Cloudu
* [kompletní source](https://github.com/jindrichskupa/if2017-ansible/blob/master/ansible/playbooks/wordpress.yml)

---


# Playbook

* instance AWS
* instalace Apache2 + PHP5 
* instalace MySQL
* vytvoření uživatele
* vytvoření vhosta
* stažení a rozbalení WordPressu
* konfigurace WordPressu
* restart Apache


---

# Vytvořeni instance AWS

* modul AWS
* API a SSH klíče pro AWS uz mám
* necháme si založit a nastartovat t2.micro s Debianem

```yaml
    - name: Create app server EC2 instances
      ec2:
        key_name: "installfest-key"
        region: "eu-central-1"
        instance_type: "t2.micro"
        image: "ami-3291be54"
        wait: yes
        group: default
        instance_tags:
          application: "wordpress"
        count_tag:
          application: "wordpress"
        exact_count: 1
      register: ec2app
```
---

# Instalace Apache2 + PHP5 + MySQL

* jsme na Debianu tak použijeme APT

```yaml
    - name: Install libapache2-mod-php5
      apt: 
        name="libapache2-mod-php5" 
        update_cache=yes state=latest

    - name: Install MySQL Server
      apt: 
        name="mysql-server" 
        update_cache=yes state=latest
```
* nebo
```yaml
    - name: Install LAMP
      apt: 
        name="{{item}}" 
        update_cache=yes state=latest
      with_items:
      - libapache2-mod-php5
      - mysql-server
```
---

# Stažení a rozbalení WordPress


```yaml
    - name: Download latest WordPress release
      get_url:
        url: https://wordpress.org/latest.zip
        dest: /tmp/wordpress-latest.zip
        
    - name: Extract WordPress into /var/www
      unarchive:
        src: /tmp/wordpress-latest.zip
        dest: /var/www/
```

---

# Nastavení MySQL

* vytvoření DB a uživatele

```yaml
  - name: Create MySQL database
    mysql_db:
      name: "wordpress"
      state: present
      
  - name: Create MySQL User with Grants
    mysql_user:
      name: "wordpress"
      password: "strasneSloziteHeslo"
      priv: "wordpress.*:ALL"
```

---

# Nastavení WordPress

* použijeme VZOR a nahrazení řetezců

```yaml
   - name: Copy Wordpress Config
     copy: 
       src: /etc/ansible/files/wp-config.php
       dest: /var/www/wordpress/wp-config.php
   - name: Set Config Variables (password)
     replace:
       path: /var/www/wordpress/wp-config.php
       regexp: "password_here"
       replace: "strasneSloziteHeslo"
   - name: Set Config Variables (username_here)
     replace:
       path: /var/www/wordpress/wp-config.php
       regexp: "username_here"
       replace: "wordpress"
   - name: Set Config Variables (database_name_here)
     replace:
       path: /var/www/wordpress/wp-config.php
       regexp: "database_name_here"
       replace: "wordpress"
```

---

# Vytvoření vhostu WordPress

* použijeme J2 šablonu a nějaké ty proměnné

```yaml
   - name: Create Apache Vhost
   template:
     src: /etc/ansible/templates/apache_vhost.j2
     dest: /etc/apache2/site-enabled/wordpress.conf
```

---

# Restart Apache2

* použijeme modul service a stav restarted

```yaml
- name: Restart Apache2
  become: true
  service: name=apache2 state=restarted
```

---

# Role

* když stihneme, tak rozhodíme playbook do rolí
  * LAMP
  * WordPress role
* Multihosting WordPressu
  * Parametrizace, konfigurace ...

---

# Best practices

* adresářová dekompozice
* názvové konvence, čistý YAML, pořádek
* když existuje modul použijte ho, čím méně shellu tím lépe
* debug pod kontrolou (nastavení verbose)
* oddělené stage (inventory, tag, ...)
* držet odděleně vlastní a Ansible Galaxy role
* linter a review ([ansible-lint](https://github.com/willthames/ansible-lint), [ansible-review](https://github.com/willthames/ansible-review))
* udrzujte playbooky male a jednoduche (KISS)
* secrets mimo plaintext soubory ([ansible-vault](http://docs.ansible.com/ansible/playbooks_vault.html))

---

# Závěr

## Děkuji za pozornost
### Otázky a odpovědi ?