ISO=$1
ELF=$2
DIR=$3

mkdir -p "${DIR}/iso/boot/grub"
cp $ELF "${DIR}/iso/boot"
echo """
timeout=0

menuentry "$(basename $ELF)" {
    multiboot /boot/$(basename $ELF)
}
""" > "${DIR}/iso/boot/grub/grub.cfg"

grub-mkrescue -o $ISO $DIR/iso