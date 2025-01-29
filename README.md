# Primordial Framework

## 🚀 Description

**Primordial Framework** is an optimized and independent alternative to **ESX (es_extended)** for FiveM. Initially designed to follow and improve ESX versions, it took a more independent direction starting from **ESX version 1.11.0**.

This framework is built for **serious RP servers**, focusing on **performance**, **optimization**, and **server-side efficiency**.

---

## ✨ Main Features

- ❌ **No State Bag** → Better performance.
- ⚡ **Maximum Optimization** → Better resource management.
- 🎭 **Needs System** → Redesigned and more efficient.
- 🔑 **Advanced License and Permission Management**.
- 🛠 **Full Admin Menu** → Manage players, vehicles, resources, etc.
- 🔄 **Optimized Synchronization**.
- 📜 **Fully Custom Code** → Not just a modified ESX.
- 🔧 **Extensible** → Compatible with other resources.

---

## 📦 Installation

### 📋 Requirements

- **FiveM**
- **MariaDB / MySQL** for database management.
- A **recent FiveM artifact**.

### 🔧 Installation Steps

1. **Download the framework**
   ```sh
     git clone https://github.com/votre-repo/Primordial_Framework.git
   ```
2. **Add to your server.cfg**
   ```bash
     ensure Primordial_Framework
     ensure primordial_lifeEssentials
     ensure primordial_admin

     ## Ensure every other assets below
   ```
   
4. **Import the database**
   - Execute `primordial.sql` in your database.

5. **Restart your server and enjoy!**


## 📜 Configuration

The config.lua file allows you to customize framework features, such as:

- Permission management.

- Needs system parameters.

- Administrative logs.


## 🛠 Admin Commands

The admin commands can be found in the primordial_admin script inside the shared folder, specifically in the config_command.lua file.

## 🔥 Contribution

This project is no longer maintained. Users are free to fork and modify it as needed, while respecting the Apache 2.0 license.
No issues, merge requests, or pull requests will be handled in the original repository.

## 📜 License

This project is no longer maintained by the original author. However, anyone wishing to take over can do so while respecting the Apache 2.0 license.
