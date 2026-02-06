cask "jetbrains-toolbox" do
  arch arm: "-arm64"
  file_ext macos: "dmg", linux: "tar.gz"

  version "3.2,3.2.0.65851"
  sha256 arm:          "40bfaf8a40b6db5649415c2123f6206e264501f8efe1538e3d8e8eab62e19d81",
         intel:        "824c2be1b3c7c99af1b9af02daae2d5a2153dbfe9da502ab5690e08e7c7b812a",
         x86_64_linux: "0000000000000000000000000000000000000000000000000000000000000000",
         arm64_linux:  "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://download.jetbrains.com/toolbox/jetbrains-toolbox-#{version.csv.second}#{arch}.#{file_ext}"
  name "JetBrains Toolbox"
  desc "JetBrains tools manager"
  homepage "https://www.jetbrains.com/toolbox-app/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
    strategy :json do |json|
      json["TBA"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  on_macos do
    auto_updates true

    app "JetBrains Toolbox.app"

    uninstall launchctl: "com.jetbrains.toolbox",
              signal:    ["TERM", "com.jetbrains.toolbox"]

    zap trash: [
          "~/Library/Application Support/JetBrains/Toolbox",
          "~/Library/Caches/JetBrains/Toolbox",
          "~/Library/Logs/JetBrains/Toolbox",
          "~/Library/Preferences/com.jetbrains.toolbox.renderer.plist",
          "~/Library/Saved Application State/com.jetbrains.toolbox.savedState",
        ],
        rmdir: [
          "~/Library/Application Support/JetBrains",
          "~/Library/Caches/JetBrains",
          "~/Library/Logs/JetBrains",
        ]
  end

  on_linux do
    binary "#{staged_path}/jetbrains-toolbox"

    zap trash: [
      "~/.cache/JetBrains/Toolbox",
      "~/.config/JetBrains/Toolbox",
      "~/.local/share/JetBrains/Toolbox",
    ]
  end
end
