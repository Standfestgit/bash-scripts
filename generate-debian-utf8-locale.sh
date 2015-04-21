#!/bin/sh

if test -f /etc/locale.gen; then perl -pi -e 's@^# *(en_US.UTF-8 UTF-8)$@$1@' /etc/locale.gen; grep -qxF 'en_US.UTF-8 UTF-8' /etc/locale.gen || (echo; echo 'en_US.UTF-8 UTF-8') >>/etc/locale.gen; fi
if test -f /var/lib/locales/supported.d; then grep -qxF 'en_US.UTF-8 UTF-8' || (echo; echo 'en_US.UTF-8 UTF-8') >>/var/lib/locales/supported.d/en; fi
perl -pi -e 's@^(?=LC_CTYPE=|LC_ALL=)@#@' /etc/environment
/usr/sbin/locale-gen
/usr/sbin/update-locale LC_CTYPE LC_ALL


