
# Backup System to /dev/sda

This is a step-by-step guide on how to create a backup of directories `/etc`, `/home`, and `/usr/local` on disk `/dev/sda`.

## Step 1: Prepare the Disk `/dev/sda`

If the disk is not yet partitioned and formatted, you need to prepare it.

### Partition the Disk with `fdisk`
```bash
sudo fdisk /dev/sda
```
Inside `fdisk`:
- Press `n` to create a new partition.
- Select the partition type (usually "primary").
- Press `w` to write the changes.

### Format the Partition to ext4
Assume the partition is `/dev/sda`. Format it to ext4:
```bash
sudo mkfs.ext4 /dev/sda
```

## Step 2: Mount the Disk

Create a mount point and mount the disk:
```bash
sudo mkdir /mnt/backup
sudo mount /dev/sda /mnt/backup
```

## Step 3: Create the Backup Using `rsync`

Use `rsync` to copy `/etc`, `/home`, and `/usr/local` to `/dev/sda1`:
```bash
sudo rsync -aAXv /etc /home /usr/local /mnt/backup --exclude={"/home/*/.cache"}
```

This command will backup the directories while excluding user cache from `/home`.

## Step 4: Create the Backup Using `tar` (Optional)

Alternatively, create a compressed archive of the directories:
```bash
sudo tar -cvpzf /mnt/backup/system-backup.tar.gz /etc /home /usr/local --exclude=/home/*/.cache
```

This will create a `system-backup.tar.gz` file in `/mnt/backup`.

## Step 5: Verify the Backup

Ensure the backup was created successfully by checking the contents of `/mnt/backup`:
```bash
ls /mnt/backup
```

## Step 6: Unmount the Disk

After the backup is complete, unmount the disk:
```bash
sudo umount /mnt/backup
```

Your backup is now safely stored on `/dev/sda`.
