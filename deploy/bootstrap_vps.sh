#!/usr/bin/env bash
# ============================================================
# MAGNUS RADAR — Bootstrap VPS Hostinger KVM 2 (Ubuntu 24.04)
# ============================================================
# Ejecutar UNA sola vez, como root via SSH:
#   curl -fsSL https://raw.githubusercontent.com/Meher1294/magnus-radar/main/deploy/bootstrap_vps.sh | bash
# o bajar el archivo y ejecutar: bash bootstrap_vps.sh
#
# Lo que hace:
# 1. Actualiza sistema
# 2. Instala Docker + Docker Compose plugin
# 3. Crea usuario 'magnus' con sudo y SSH key
# 4. Habilita firewall (22, 80, 443)
# 5. Instala fail2ban
# 6. Configura unattended-upgrades
# 7. Prepara /opt/magnus-radar
# ============================================================
set -euo pipefail

echo "==> [1/8] Actualizando sistema..."
apt update -qq && apt upgrade -y -qq

echo "==> [2/8] Instalando paquetes base..."
apt install -y -qq curl ca-certificates gnupg lsb-release ufw fail2ban unattended-upgrades git htop

echo "==> [3/8] Instalando Docker..."
if ! command -v docker &> /dev/null; then
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list
  apt update -qq
  apt install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
systemctl enable docker
systemctl start docker

echo "==> [4/8] Creando usuario 'magnus'..."
if ! id -u magnus &> /dev/null; then
  useradd -m -s /bin/bash -G sudo,docker magnus
  echo "magnus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/magnus
  chmod 440 /etc/sudoers.d/magnus
fi

echo "==> [5/8] Configurando SSH key para 'magnus'..."
mkdir -p /home/magnus/.ssh
chmod 700 /home/magnus/.ssh
touch /home/magnus/.ssh/authorized_keys
chmod 600 /home/magnus/.ssh/authorized_keys
chown -R magnus:magnus /home/magnus/.ssh
echo "   ⚠️  Agregar tu llave pública en: /home/magnus/.ssh/authorized_keys"
echo "       (pega el contenido de ~/.ssh/id_ed25519.pub de tu Mac)"

echo "==> [6/8] Endureciendo SSH..."
# Permitir login con key, deshabilitar login con password para magnus (root sigue por ahora)
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
# (No deshabilitamos password aún para no bloquearte. Hacerlo después de validar SSH key.)
systemctl reload sshd

echo "==> [7/8] Firewall UFW + Fail2ban..."
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw --force enable

systemctl enable fail2ban
systemctl start fail2ban

echo "==> [8/8] Preparando /opt/magnus-radar..."
mkdir -p /opt/magnus-radar
chown magnus:magnus /opt/magnus-radar

# Auto-updates de seguridad
dpkg-reconfigure -plow unattended-upgrades

echo ""
echo "============================================================"
echo " ✅ Bootstrap completado"
echo "============================================================"
echo " Próximos pasos:"
echo " 1. Como root, pega tu SSH public key en:"
echo "    /home/magnus/.ssh/authorized_keys"
echo " 2. Desde tu Mac: ssh magnus@$(curl -s ifconfig.me)"
echo " 3. cd /opt/magnus-radar && git clone <repo>"
echo " 4. cp .env.example .env y completa"
echo " 5. docker compose up -d"
echo "============================================================"
