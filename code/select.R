xmods <- c()

ms <- delta$mod == 'mm'
xmods <- c(xmods, 'mm')

# drivers
usbs <- delta$mmod == 'drivers/usb'
scsis <- delta$mmod == 'drivers/scsi'
ides <- delta$mmod == 'drivers/ide'
xmods <- c(xmods, c('drivers/usb', 'drivers/scsi', 'drivers/ide'))

# arch
mipss <- delta$mmod == 'arch/mips'
arms <- delta$mmod == 'arch/arm'
x86s  <- delta$mmod == 'arch/x86'
powers  <- delta$mmod == 'arch/powerpc'
xmods <- c(xmods, c('arch/mips', 'arch/arm', 'arch/x86','arch/powerpc'))

# fs
xfss <- delta$mmod == 'fs/xfs'
btrs <- delta$mmod == 'fs/btrfs'
nfss <- delta$mmod == 'fs/nfs'
cifss <- delta$mmod == 'fs/cifs'
ext4s <- delta$mmod == 'fs/ext4'
xmods <- c(xmods, c('fs/xfs', 'fs/btrfs', 'fs/nfs','fs/cifs', 'fs/ext4'))



