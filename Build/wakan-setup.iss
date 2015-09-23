; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Wakan"
; There's better and heavier way via ParseVersion but this will suffice
#define MyAppVersion StringChange(GetFileVersion('..\Release\Jalet.exe'), '.0.0', '')
#define MyAppPublisher "Wakan developers"
#define MyAppURL "https://bitbucket.org/himselfv/wakan/"
#define MyAppExeName "wakan.exe"

#define CommonData "{app}\CommonData"
;#define CommonData "{userappdata}\Wakan"  ; this is not correct; wakan can be used by different users


[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{FE77F2CB-64CA-4024-8A07-DAF151D8B3A7}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=.\Output
OutputBaseFilename=wakan-{#MyAppVersion}-setup
Compression=lzma
SolidCompression=yes
SetupIconFile="..\Jalet_Icon.ico"
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[InstallDelete]
Type: files; Name: {app}\wakan.cdt

[Files]
Source: "..\Release\Jalet.exe"; DestDir: "{app}"; DestName: "wakan.exe"; Flags: ignoreversion
Source: "..\Release\7z.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\wakanh.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\wakan.cfg"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Components.ini"; DestDir: "{app}"; Flags: ignoreversion
; Install default "standalone" wakan.ini
; Keep existing one (it can contain settings)
Source: "wakan.ini"; DestDir: "{app}"; Flags: ignoreversion onlyifdoesntexist
; Languages
Source: "..\Release\lng\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Help
Source: "..\Release\wakan_cz.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\wakan_en.chm"; DestDir: "{app}"; DestName: "wakan.chm"; Flags: ignoreversion
; Dictionaries (optional but included in 1.67)
Source: "..\Release\ccedict.dic"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\edict2.dic"; DestDir: "{app}"; Flags: ignoreversion
; Character and other data
Source: "..\Release\wakan.chr"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\wakan.rad"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\wakan.sod"; DestDir: "{app}"; Flags: ignoreversion
; Examples (optional)
Source: "..\Release\examples_j.pkg"; DestDir: "{app}"; Flags: ignoreversion
; Raw data (.rad and .sod can be rebuilt from this)
Source: "..\Release\radicals.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\strokes.csv"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\wordfreq_ck"; DestDir: "{app}"; Flags: ignoreversion
; Utils (optional)
Source: "..\Release\uniconv.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\btuc21d3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\jwbpkg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\jwbtab.exe"; DestDir: "{app}"; Flags: ignoreversion
; Transliterations
Source: "..\Release\Awful kiriji.roma"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Czech.roma"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Hepburn.roma"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Kiriji - Polivanov.roma"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Kunreishiki.roma"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\PinYin.rpy"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Wade-Giles.rpy"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Yale.rpy"; DestDir: "{app}"; Flags: ignoreversion
; Expression copy formats
Source: "..\Release\UserData\ExprCopyFormats\EDICT line.xslt"; DestDir: "{#CommonData}\ExprCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\ExprCopyFormats\example-xml.txt"; DestDir: "{#CommonData}\ExprCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\ExprCopyFormats\Expression (HTML ruby).xslt"; DestDir: "{#CommonData}\ExprCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\ExprCopyFormats\Expression.xslt"; DestDir: "{#CommonData}\ExprCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\ExprCopyFormats\HTML definition list.xslt"; DestDir: "{#CommonData}\ExprCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\ExprCopyFormats\Text line, no numbers.xslt"; DestDir: "{#CommonData}\ExprCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\ExprCopyFormats\Text line.xslt"; DestDir: "{#CommonData}\ExprCopyFormats"; Flags: ignoreversion
; Expression links
Source: "..\Release\UserData\ExprLinks\00. Look up in Google.url"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\01. Look up IMI in Google.url"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\02. Look up DOUIGO in Google.url"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\03. Kotobank.url"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\04. Japanese Wikipedia.url"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\05. Wiktionary EN.url"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\06. Wiktionary JP.url"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\google.ico"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\kotobank.ico"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\wikipedia.ico"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\wiktionary-en.ico"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
Source: "..\Release\UserData\ExprLinks\wiktionary-ja.ico"; DestDir: "{#CommonData}\ExprLinks"; Flags: ignoreversion
; Kanji copy formats
Source: "..\Release\UserData\KanjiCopyFormats\Bracket Text.xslt"; DestDir: "{#CommonData}\KanjiCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiCopyFormats\example-xml.txt"; DestDir: "{#CommonData}\KanjiCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiCopyFormats\HTML.xslt"; DestDir: "{#CommonData}\KanjiCopyFormats"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiCopyFormats\Text.xslt"; DestDir: "{#CommonData}\KanjiCopyFormats"; Flags: ignoreversion
; Kanji links
Source: "..\Release\UserData\KanjiLinks\example-link.txt"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\KanjiProject.url"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\UniHan.ico"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\UniHan.url"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\Wiktionary EN.url"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\Wiktionary JP.url"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\wiktionary-en.ico"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\wiktionary-ja.ico"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\WWWJDIC.ico"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\WWWJDIC.url"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\ZhongWen.ico"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion
Source: "..\Release\UserData\KanjiLinks\ZhongWen.url"; DestDir: "{#CommonData}\KanjiLinks"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
