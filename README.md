# mikrotik-2fa-asterisk
Script for 2Fa Mikrotik and Asterisk

Для 2FA MikroTik вам потребуется
1. PPP VPN сервер на mikrotik (L2tp, SSTP, OpenVPN, PPPoE, PPPTP)
2. UserManager или любой другой сервер RADIUS
3. Asterisk или любой другой телефонный сервер, который может выполнять скрипты по звонку
4. Настроить ssh-авторизацию по ключу для mikrotik с asterisk (важно, чтобы пользователь из под которого запущена служба Asterisk имел доступ к приватному ssh ключу)
5. import mikrotik-2fa-asterisk.rsc на PPP сервере Mikrotik - для создания профиля PPP, настроек firewall, nat, web-proxy
6. Поправить профиль - заполнить remote и local address, поставить правила firewall в нужное место для блокировки трафика
7. import mikrotik-user-manager.rsc на usermanager (важно заполнить нужный ip адрес и пароль для подключения mikrotik)
8. Настроить dial plan из asterisk-dial.conf на отдельном номере для 2fa
9. Добавить скрипт 2factor-mikrotik.sh в /usr/local/bin/2factor-mikrotik.sh
