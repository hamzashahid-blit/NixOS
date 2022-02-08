# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelParams = [ "video=1920x1080" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # for early plymouth showing
  boot.initrd.kernelModules = [ "i915" ];

  # Nice Eye Candy and Functional Boot Splash Screen
  boot.plymouth.enable = true; 
  boot.plymouth.themePackages = [ pkgs.adi1090x-plymouth ];
  boot.plymouth.theme = "loader"; #lone
  boot.plymouth.extraConfig = ''
    ShowDelay=0
  '';

  networking.hostName = "Hamzas-PC"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  #networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # powerManagment.cpuFreqGovernor.performance.enable = true;

  # Enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Basically useless? I don't understand how to use it, nor do I care
  #services.xserver.xautolock.enable = true;

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  #services.xserver.windowManager.stumpwm.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    hamza = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "sound" "video" ]; # Enable ‘sudo’ for the user.
    };
    saba = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "sound" "video" ]; # Enable ‘sudo’ for the user.
    };
    tahseen = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "sound" "video" ]; # Enable ‘sudo’ for the user.
    };
    shahid = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "sound" "video" ]; # Enable ‘sudo’ for the user.
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Essential
    wget 
    vim
    git

    # # XFCE4
    # arc-theme
    # papirus-icon-theme
    # pkgs.xfce.xfce4-whiskermenu-plugin

    # Big but neccessary programs
    firefox
    #qutebrowser

    # Big Programs
    libreoffice
    #gimp
  ];

  nixpkgs.overlays = [ (import ./packages) ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # put this only on the server machine for passwordless ssh
  #users.users.hamza.openssh.authorizedKeys.keys = ["PUBLIC KEY STRING"];
  #users.users.hamza.openssh.authorizedKeys.keyFiles = [ "/home/hamza/.ssh/id_github.pub" ];
  
  services.xrdp.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3389 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

