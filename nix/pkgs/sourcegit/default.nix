# from https://github.com/NixOS/nixpkgs/pull/303865/commits/2ac1b575f058d4035270da970667e654a131ba7a
{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  libicns,

  libX11,
  libICE,
  libSM,
  libXi,
  libXcursor,
  libXext,
  libXrandr,
  fontconfig,
  glew,
}:

buildDotnetModule rec {
  pname = "sourcegit";
  version = "8.7";

  src = fetchFromGitHub {
    owner = "sourcegit-scm";
    repo = "sourcegit";
    rev = "v${version}";
    hash = "sha256-MSNWnFwGAKxtrCYUoUJp07vTQH5rPh4QON7md0emy4w=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.nix;

  projectFile = [ "src/SourceGit.csproj" ];

  executables = [ "SourceGit" ];

  nativeBuildInputs = [
    copyDesktopItems
    libicns
  ];

  runtimeDeps = [
    # For Avalonia UI
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
    glew
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "SourceGit";
      exec = "SourceGit";
      icon = "SourceGit";
      desktopName = "SourceGit";
      terminal = false;
      comment = meta.description;
    })
  ];

  postInstall = ''
    icns2png -x build/resources/App.icns
    for f in App_*x32.png; do
        res=''${f//App_}
        res=''${res//x32.png}
        install -Dm644 $f "$out/share/icons/hicolor/$res/apps/SourceGit.png"
    done
  '';

  meta = {
    changelog = "https://github.com/sourcegit-scm/sourcegit/releases/tag/${src.rev}";
    description = "A Free & OpenSource GUI client for GIT users";
    homepage = "https://github.com/sourcegit-scm/sourcegit";
    license = lib.licenses.mit;
    mainProgram = "SourceGit";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}