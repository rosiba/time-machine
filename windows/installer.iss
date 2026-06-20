#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif

[Setup]
AppName=Time Machine
AppVersion={#MyAppVersion}
AppPublisher=Rojhat Sinan Balka
DefaultDirName={autopf}\Time Machine
DefaultGroupName=Time Machine
OutputDir=.
OutputBaseFilename=time_machine-windows-x64-setup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Time Machine"; Filename: "{app}\time_machine.exe"
Name: "{commondesktop}\Time Machine"; Filename: "{app}\time_machine.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"

[Run]
Filename: "{app}\time_machine.exe"; Description: "Launch Time Machine"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
