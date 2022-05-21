
cp /etc/nix/nix.conf /etc/nix/nix.conf1
rm /etc/nix/nix.conf
mv /etc/nix/nix.conf1 /etc/nix/nix.conf
chmod +w /etc/nix/nix.conf
sed -i 's/https:\/\/cache.nixos.org/https:\/\/mirrors.tuna.tsinghua.edu.cn\/nix-channels\/store/g' /etc/nix/nix.conf