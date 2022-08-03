#!/bin/bash
if [ "$PAM_TYPE" = "open_session" ] && [ "$PAM_USER" = "nasbackup" ]; then
  echo 'OPEN' > /tmp/ssh_session_open
fi

if [ "$PAM_TYPE" = "close_session" ] && [ "$PAM_USER" = "nasbackup" ]; then
  rm /tmp/ssh_session_open

  sleep 5m

  # Session was reopened (for example by a borg prune after borg create), so do not go into standby
  if test -f /tmp/ssh_session_open; then
     exit 0
  fi
  
  systemctl suspend
fi
