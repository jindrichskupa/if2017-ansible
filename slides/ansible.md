# Anslible
# ![60%](./images/ansible-logo.png)
## InstallFest 2017
Jindrich Skupa

---

# Agenda

* Instalace Ansible
* Popis Ansible a srovnani s ostatnimi nastroji
* Ukazkovy playbook - LAMP + WordPress
* Ucesani ukazky
* Best practices
* Otazky a snad i odpovedi

---

# Priprava

```bash
apt-get install python-pip
pip install ansible
```

---

# Ansible

* nastroj na automatizaci
* Enterprise, protoze RedHat
* provisioning sluzeb v cloudu (AWS, Azure, Google, ...)
* automaticka instalace
* konfigurace a sprava sluzeb
* konfigurace prostredi, sprava uzivatelu, opravneni
* ssh + YAML

---

# Komponenty Ansible

* Inventory (co spravujeme)
* Playbooks (co se ma na serveru proves)
* Roles (genericke tasky, Ansible Galaxy)
* Vars (nastaveni playbooku/roli)
* Task (jednotka)
* Templates (j2 sablony, napriklad pro configuracni soubory)
* Handlers ("task" pro sluzby, notifikace)
* Files (soubory, archivy atp.)

---

# Inventory

* definuje spravovane servery
* hierarchicky
* dynamicke inventory (cloud)

---

# Playbook

* YAML soubor
* obsahuje konfiguraci toho co se ma na cilovych serverech stat
* definice promennych, include externich souboru
* pouzite role
* dalsi vlastni tasky
* pozor na vysledky tasku

---

# Ukazka...

* Vytvoreni instance v AWS
* Instalace LAMPu
* Nasazeni WordPressu

---

# Vytvoreni instance AWS

* modul AWS
* klice pro AWS API uz mam
* nechame si zalozit a nastartovat t2.micro s Debianem

---

# Playbook

* instalace Apache2 + mod_php
* instalace MySQL
* vytvoreni uzivatele
* vytvoreni vhosta
* stazeni a rozbaleni WordPressu
* konfigurace WordPressu
* restart Apache
* parametrizace

---

# Role

* kdyz stihneme, tak rozhodime playbook do roli
  * LAMP
  * WordPress role
* Multihosting WordPressu
  * Parametrizace, pole ...

---

# Best practices

* adresarova dekompozice
* nazvove konvence, cisty YAML, poradek
* kdyz existuje modul pouzijte ho, cim min shellu tim lip
* debug pod kontrolou (nastaveni verbose)
* oddelene stage (inventory, tag, ...)
* drzet oddelene vlastni role a Ansible Galaxy
* linter a review ([ansible-lint](https://github.com/willthames/ansible-lint), [ansible-review](https://github.com/willthames/ansible-review))
* udrzujte playbooky male a jednoduche (KISS)
* secrets mimo plaintext soubory ([ansible-vault](http://docs.ansible.com/ansible/playbooks_vault.html))

---

# Zaver

## Dekuji za pozornost
### Otazky a odpovedi ?