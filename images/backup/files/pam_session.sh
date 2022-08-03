#!/bin/bash
if [ "$PAM_TYPE" = "open_session" ] && [ "$PAM_USER" = "nasbackup" ]; then
  /usr/sbin/spinup.sh
fi

if [ "$PAM_TYPE" = "close_session" ] && [ "$PAM_USER" = "nasbackup" ]; then
  /usr/sbin/spindown.sh
fi
