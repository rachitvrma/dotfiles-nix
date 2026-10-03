{
  flake.homeModules.firefox =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.firefox = {
        enable = true;

        languagePacks = [ "en-US" ];

        policies = {
          # see https://mozilla.github.io/policy-templates/ for a list of all policies
          # Updates & Background Services
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;

          # Feature Disabling
          DisableBuiltinPDFViewer = true;
          DisableFirefoxStudies = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxScreenshots = true;
          DisableForgetButton = true;
          DisableMasterPasswordCreation = true;
          DisableProfileImport = true;
          DisableProfileRefresh = true;
          DisableSetDesktopBackground = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFormHistory = true;
          DisablePasswordReveal = true;

          # Access Restrictions
          BlockAboutConfig = false;
          BlockAboutProfiles = true;
          BlockAboutSupport = true;

          # UI and Behavior
          DisplayMenuBar = "never";
          DontCheckDefaultBrowser = true;
          HardwareAcceleration = true;
          OfferToSaveLogins = false;
          DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
          FirefoxHome = {
            Search = true;
            TopSites = false;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = false;
            Stories = false;
            SponsoredStories = false;
            Snippets = false;
            Locked = true;
          };

          # Disable PDF Support
          PDFjs = {
            Enabled = false;
            EnablePermissions = false;
          };

          StartDownloadsInTempDirectory = true; # Start the download in temp directory.

          # Extensions
          ExtensionSettings =
            let
              moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
            in
            {
              "*".installation_mode = "blocked";

              "uBlock0@raymondhill.net" = {
                install_url = moz "ublock-origin";
                installation_mode = "force_installed";
                updates_disabled = true;
              };
            };

          # Extension configuration
          "3rdparty".Extensions = {
            "uBlock0@raymondhill.net".adminSettings = {
              userSettings = rec {
                uiTheme = "dark";
                uiAccentCustom = true;
                uiAccentCustom0 = "#8300ff";
                cloudStorageEnabled = lib.mkForce false;

                importedLists = [
                  "https://filters.adtidy.org/extension/ublock/filters/3.txt"
                  "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                ];

                externalLists = lib.concatStringsSep "\n" importedLists;
              };

              selectedFilterLists = [
                "CZE-0"
                "adguard-generic"
                "adguard-annoyance"
                "adguard-social"
                "adguard-spyware-url"
                "easylist"
                "easyprivacy"
                "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                "plowe-0"
                "ublock-abuse"
                "ublock-badware"
                "ublock-filters"
                "ublock-privacy"
                "ublock-quick-fixes"
                "ublock-unbreak"
                "urlhaus-1"
              ];
            };
          };
        };

        profiles.default = {
          isDefault = true;
          id = 0;
          extensions.force = true;
          search = {
            force = true;
            default = "ddg";
            privateDefault = "ddg";

            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nw" ];
              };
            };
          };
          settings = {
            "browser.uiCustomization.horizontalTabstrip" = [
              "tabbrowser-tabs"
              "new-tab-button"
              "customizableui-special-spring3"
              "alltabs-button"
              "smartwindow-group-tabs-button"
              "ai-window-toggle"
            ];

            # Vertical Tabs & Sidebar Configuration
            "sidebar.main.tools" = "syncedtabs,bookmarks,opentabs"; # syncedtabs -> tabs from other devices, bookmarks, and open tabs on the sidebar
            "sidebar.new-sidebar.has-used" = true; # Don't show annoying messages like "OMGoodness! You enabled Vertical Tabs'n'shyte!"
            "sidebar.position_start" = false; # Open it on the right side
            "sidebar.verticalTabs" = true; # Enable vertical tabs, ofc _eyes_roll_
            "sidebar.visibility" = "expand-on-hover"; # Expand it on hover.

            # Security / Under-the-hood
            "signon.storage.rust.active" = true; # Just use rust stuff...
          };
        };
      };
      stylix.targets.firefox = {
        profileNames = [ "default" ];
        colorTheme.enable = true;
        firefoxGnomeTheme.enable = true;
      };
    };
}
