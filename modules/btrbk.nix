{config, pkgs, lib, ...}:
{
  ### Already exists at:
  ### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/backup/btrbk.nix

  # lib.systemd.services.btrbk = {
  #   description = "btrbk backup";
  #   documentation = [ "${pkgs.btrbk}/share/man/man1/btrbk.1.gz" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.btrbk}/bin/btrbk run";
  #   };
  # };

  # lib.systemd.timers.btrbk = {
  #   description = "btrbk daily backup";
  #   wantedBy = [ "multi-user.target" ];
  #   timerConfig = {
  #     OnUnitInactiveSec = "15min";
  #     OnBootSec = "15min";
  #   };
  # };

  environment.systemPackages = [ pkgs.btrbk ];

  services.btrbk = {
	extraPackages = [ pkgs.mbuffer pkgs.xz ];
	instances.btrbk.settings = {
	  transaction_log = "/var/log/btrbk.log";
	  timestamp_format = "long";
	  stream_buffer = "256m";

	  preserve_hour_of_day = "4";
	  snapshot_preserve_min = "2d";
	  snapshot_preserve = "48h 60d *m";
	  target_preserve_min = "1w";
	  target_preserve = "30d 12w *m";

	  lockfile = "/var/lock/btrbk.lock";
	  incremental = "yes";
  
	  volume = {
		"/mnt/subvols" = {
		  subvolume = {
			"@" = {};
			"@home" = {};
			"@var_log" = {};
		  };

	      snapshot_dir = "@snapshots";
	      target = "/mnt/backups/pc";    # Change for Extern HDD
	      snapshot_create = "onchange";  # Change for Extern HDD
		};
	  };
	};
  };

  ### Keeping below for the explanation but otherwise replaced by above

  # # For ALOT more details, see "man 5 btrfs.conf"
  # lib.environment.etc."btrbk/btrbk.conf".text = ''
  #   transaction_log	/var/log/btrbk.log # Enable transaction log
  #   timestamp_format long	
  #   stream_buffer 256m
	
  #   preserve_hour_of_day 4 # Since I work upto 4AM sometimes :P

  #   # Preserve all snapshots (hourly, daily, ...) for 2 days
  #   # then wipe and preserve all for next 2 days
  #   # this is because I keep 48 hourly snaps = 2 days

  #   # Preserve all snapshots (hourly, daily, ...) for 2 days. 
  #   # Note how we say "keep even a thousand snapshots but for
  #   # 2 days" whereas, in option below this one, we say,
  #   # "keep exact X number of (hourly, daily, ...) snapshots".
  #   # I bother setting this option because default will
  #   # ignore "snapshot_preserve" and preserve everything forever.
  #   snapshot_preserve_min 2d

  #   # Keep: 48 Hourly, 20 Daily & every monthly snapshot ever.
  #   snapshot_preserve 48h 60d *m

  #   target_preserve_min 1w

  #   # Everything target (instead of snapshot) means full backup
  #   # Keep: 30 daily, 3 months of weekly & every monthly backup ever.
  #   target_preserve 30d 12w *m

  #   # Ensures that 1 instance of btrbk is run at a time.
  #   lockfile /var/lock/btrbk.lock


  #   volume /mnt/subvols
  #     snapshot_dir @snapshots
  #     target /mnt/backups/pc	# Change for Extern HDD
  #     snapshot_create onchange  # Change for Extern HDD
	  
  #     subvolume @
  #     subvolume @home
  #     subvolume @var_log
  # '';
}
