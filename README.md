# restic-notifier

A simple script to connect [restic-automatic-backup-scheduler](https://github.com/erikw/restic-automatic-backup-scheduler#) notifications to [Pushover](https://pushover.net).

## Installation

1. Clone this repository (e.g. to `/opt/restic-notifier`)
2. Copy `pushover.example.env` to `pushover.env` and fill out the variables.
3. Copy `restic-notifier.service` to `/etc/systemd/system/restic-notifier.service`
4. Update `/etc/systemd/system/restic-notifier.service` to point to the correct directory.
5. Run `systemctl enable --now restic-notifier`
6. In your restic-automatic-backup-scheduler profile add the following:
```
RESTIC_NOTIFY_BACKUP_STATS=true
RESTIC_BACKUP_NOTIFICATION_FILE=/opt/restic-notifier/.cache/queue
```
