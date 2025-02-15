# Dotfiles

Ce repository contient mes fichiers de configuration (dotfiles) pour divers outils et environnements.

## Installation

Pour cloner ce dépôt et appliquer les configurations :
```bash
# Cloner le dépôt
git clone git@github.com:TON-UTILISATEUR/dotfiles.git ~/.dotfiles

# Aller dans le dossier
cd ~/.dotfiles

# Exécuter le script d'installation (si disponible)
./install.sh
```

## Connexion à GitHub avec une clé SSH

### 1. Vérifier les clés SSH existantes
Avant de générer une nouvelle clé, vérifiez si vous en avez déjà une :
```bash
ls -al ~/.ssh
```
Si vous voyez un fichier comme `id_rsa.pub`, vous avez déjà une clé SSH.

### 2. Générer une nouvelle clé SSH
Si vous devez créer une nouvelle clé SSH, utilisez la commande suivante :
```bash
ssh-keygen -t rsa -b 4096 -C "votre-email@example.com"
```
- Lorsque demandé où enregistrer la clé, appuyez sur **Entrée** pour accepter l’emplacement par défaut (`~/.ssh/id_rsa`).
- Définissez un **mot de passe sécurisé** pour protéger la clé.

### 3. Ajouter la clé SSH à l'agent SSH
Démarrer l’agent SSH et ajouter votre clé :
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

### 4. Ajouter la clé SSH à GitHub
Copiez le contenu de votre clé publique :
```bash
cat ~/.ssh/id_rsa.pub
```
Puis ajoutez-la à GitHub :
1. Allez sur [GitHub SSH Keys](https://github.com/settings/keys)
2. Cliquez sur **New SSH Key**
3. Collez la clé publique et sauvegardez.

### 5. Tester la connexion
```bash
ssh -T git@github.com
```
Si tout est configuré correctement, vous verrez un message :
```
Hi TON-UTILISATEUR! You've successfully authenticated, but GitHub does not provide shell access.
```

## Utilisation de Git
Une fois la connexion SSH établie, vous pouvez pousser vos modifications :
```bash
# Ajouter les fichiers
git add .

# Commiter les changements
git commit -m "Mise à jour des dotfiles"

# Pousser vers GitHub
git push origin main
```

---
**Note :** N'oubliez pas de garder une copie sécurisée de votre clé privée et de votre mot de passe. 😉


