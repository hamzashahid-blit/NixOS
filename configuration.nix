# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	  ./packages/window-manager.nix
	  ./modules/btrbk.nix
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

  # for early plymouth showing add "i915"
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Nice Eye Candy and Functional Boot Splash Screen
  boot.plymouth.enable = true; 
  boot.plymouth.themePackages = [ pkgs.adi1090x-plymouth ];
  boot.plymouth.theme = "loader"; #lone
  boot.plymouth.extraConfig = ''
    ShowDelay=0
  '';

  networking.hostName = "Hamzas-PC"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  powerManagement.cpuFreqGovernor = "performance";

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

  # Enable NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Fix Screen Tearing, disable if action gaming (brodie robertson)
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"
  '';

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Basically useless? I don't understand how to use it, nor do I care
  #services.xserver.xautolock.enable = true;

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  services.flatpak.enable = true;

  services.tor.enable = true;
  # tor.client.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.stumpwm.enable = true;
  services.xserver.windowManager.stumpwm-wrapper.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  programs.steam.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    #defaultUserShell = pkgs.zsh;
	users = {
	  hamza = {
		isNormalUser = true;
		extraGroups = [ "wheel" "audio" "sound" "video" "libvirtd" ];
        shell = pkgs.zsh;
      };
	  saba = {
	    isNormalUser = true;
		extraGroups = [ "wheel" "audio" "sound" "video" "libvirtd" ];
	  };
	  tahseen = {
	    isNormalUser = true;
	  	extraGroups = [ "wheel" "audio" "sound" "video" "libvirtd" ];
	  };
	  shahid = {
	  	isNormalUser = true;
	  	extraGroups = [ "wheel" "audio" "sound" "video" "libvirtd" ];
	  };
	};
  };

  # Enable ever more extra development man-pages
  # (I say even because home.nix contains man-page programs)
  documentation.dev.enable = true;

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
    #librewolf
    #qutebrowser

    # Big Programs
    libreoffice
	virt-manager
    gimp
    wineWowPackages.stable # Wine support both 32- and 64-bit applications

	# Other Programs
    libsForQt5.kolourpaint
	jdk8 # for TLauncher/minecraft which requires sudo
	ventoy-bin
  ];

  hardware.opengl.extraPackages = with pkgs; [
     rocm-opencl-icd
     rocm-opencl-runtime
  ];

  # ## Vulkan
  # hardware.opengl.driSupport = true;
  # # For 32 bit applications
  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.extraPackages = with pkgs; [
  #    amdvlk
  # ];
  # # For 32 bit applications 
  # # Only available on unstable
  # hardware.opengl.extraPackages32 = with pkgs; [
  #   driversi686Linux.amdvlk
  # ];

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
  
  services.cron = {
	enable = true;
	systemCronJobs = [
	  "0 * * * *	root	sh /etc/profile; exec ${pkgs.btrbk}/bin/btrbk -q run"
	];
  };

  services.xrdp.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3389 22 ];
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

