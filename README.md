# Koauth App 🔐

**Koauth App** is a secure and lightweight authenticator application designed to help users generate and manage One-Time Passwords (OTPs) for multi-factor authentication (MFA).  
Built with a focus on **security**, **speed**, and **ease of use**, Koauth App works seamlessly with services that support TOTP/HOTP authentication standards.

---

## 🚀 Features

- **Time-based One-Time Password (TOTP)** support  
- Add accounts via **QR code scanning** or manual entry  
- **Offline-first** – No internet needed to generate codes  
- Cross-platform compatibility (if applicable)  
- **Secure local storage** of secrets  
- Simple and intuitive UI  

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart) / (or replace with React Native, Android, etc.)  
- **Backend / API**: N/A (local OTP generation)  
- **Database / Storage**: Hive / SQLite (encrypted)  
- **Libraries**:  
  - `otp` for code generation  
  - `qr_code_scanner` for adding accounts  
  - `flutter_secure_storage` or `hive` for storing secrets  

---

## 📸 Screenshots

| Home Screen | Add Account | Generated Codes |
|-------------|-------------|-----------------|
| ![Home](docs/screenshots/home.png) | ![Add Account](docs/screenshots/add.png) | ![Codes](docs/screenshots/codes.png) |

---

## 📦 Installation

### Clone the repository
```bash
git clone https://github.com/afejohnibk/koauth_app.git
cd koauth_app
