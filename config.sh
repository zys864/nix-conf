cp /etc/nix/nix.conf /etc/nix/nix.conf1
rm /etc/nix/nix.conf
mv /etc/nix/nix.conf1 /etc/nix/nix.conf
chmod +w /etc/nix/nix.conf
sed -i 's/https:\/\/cache.nixos.org/https:\/\/mirrors.tuna.tsinghua.edu.cn\/nix-channels\/store\/ https:\/\/cache.nixos.org/g' /etc/nix/nix.conf

nix-env -iA nixos.git nixos.nixUnstable nixos.v2ray nixos.ripgrep
export all_proxy=http://127.0.0.1:10809
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/matebook/hardware-configuration.nix
nixos-install --flake .#laptop
