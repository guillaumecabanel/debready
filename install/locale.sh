#!/bin/bash

set -e

# Interface language stays English; regional formats are French:
# 24h clock, dd/mm/yyyy, €, metric, A4, comma decimal separator.
# Run as the normal user — it calls sudo itself where root is needed.

# 1. Generate fr_FR.UTF-8. Without this, GNOME Settings > Region & Language >
#    Formats lists only the locales already built, i.e. United States alone.
if ! grep -q '^fr_FR.UTF-8 UTF-8' /etc/locale.gen; then
    sudo sed -i 's/^# *fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
    grep -q '^fr_FR.UTF-8 UTF-8' /etc/locale.gen || echo 'fr_FR.UTF-8 UTF-8' | sudo tee -a /etc/locale.gen >/dev/null
fi
sudo locale-gen

# 2. The key GNOME Settings > Region & Language > Formats writes (dconf path is
#    the legacy /system/locale/, not /org/gnome/...). gnome-session reads it at
#    login and exports LC_TIME/LC_NUMERIC/LC_MONETARY/LC_PAPER/LC_MEASUREMENT
#    from it, covering everything started from the desktop. LANG and LC_MESSAGES
#    are untouched, which is what keeps the interface in English.
gsettings set org.gnome.system.locale region 'fr_FR.UTF-8'

# 3. Same formats outside the GNOME session (TTY, ssh, cron), which
#    gnome-session's exports never reach. /etc/default/locale is a symlink to
#    /etc/locale.conf and is read by pam_env on every login path.
#
#    update-locale rather than localectl: localectl validates every value as a
#    single locale and rejects the existing LANGUAGE="en_US:en" fallback list
#    ("Locale en_US:en is not valid, refusing"), taking the whole call down with
#    it. update-locale merges into the current file, so LANG and LANGUAGE are
#    preserved untouched.
#
#    LC_MESSAGES/LC_CTYPE/LC_COLLATE are deliberately left on LANG: French
#    collation would change ls/sort/glob ordering.
sudo /usr/sbin/update-locale \
    LC_TIME=fr_FR.UTF-8 \
    LC_NUMERIC=fr_FR.UTF-8 \
    LC_MONETARY=fr_FR.UTF-8 \
    LC_PAPER=fr_FR.UTF-8 \
    LC_MEASUREMENT=fr_FR.UTF-8 \
    LC_ADDRESS=fr_FR.UTF-8 \
    LC_TELEPHONE=fr_FR.UTF-8 \
    LC_NAME=fr_FR.UTF-8 \
    LC_IDENTIFICATION=fr_FR.UTF-8

echo
echo "--- /etc/locale.conf ---"
cat /etc/locale.conf
