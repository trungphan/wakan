## PREREQUISITES

1. Unicode Delphi (Delphi 10.3+ Community Edition). Ansi support is being deprecated.
2. JEDI Code library and JEDI Visual Component library (https://github.com/project-jedi/jcl, https://github.com/project-jedi/jvcl)
3.  Virtual-TreeView (https://github.com/JAM-Software/Virtual-TreeView)
4. Jp-tools (https://github.com/himselfv/jptools) which Wakan uses heavily.
5. Inno Setup 5.

If encountering these errors:

1. error F1026: File not found: 'fals e.dpr'

Make sure value `DCC_DebugInformation` is set to 0 instead of false in the dproj Project files.

2. error E2361: Cannot access private symbol

Use `with Self begin ... end;` to access private symbol.

## BUILDING

1. Configure paths in setupvars.cmd (and Settings -> Environment, if building from Delphi).
2. Build and install WakanControls.dpr.
3. Copy the dependencies (see below) to the Release folder.
4. Run build.cmd to generate:

    * Binary files in Release
    * Installer in Build/Output.


## AUTOMATED RELEASES

Needs Python 2.7 with pywin32 and oauth2client.

Run release.cmd and authorize Wakan Release Uploader, then wait.
Your authorization is stored in upload.credentials, do not commit or share it.

Target folder on Google Drive is set in setupvars.cmd. By default it's Wakan release folder,
you need authorization to write there.
You may specify your own folder in setupvars.cmd.


## OPTIMIZATION

1. Enable inlining (inline:on or inline:auto).
It's very important that some critical functions are inlined for speed in release builds.
Therefore if you're doing the building, READ THIS:
http://docwiki.embarcadero.com/RADStudio/XE/en/Calling_Procedures_and_Functions#Using_the_inline_Directive
Note the list of cases when the inlining is not done.

2. Disable "Compiling> String format checking" in Delphi Project Options:
http://www.micro-isv.asia/2008/10/needless-string-checks-with-ensureunicodestring/
They shouldn't be needed, and even if by some mistake we put Ansi chars into UnicodeString, we better crash and fix that instead of hiding the bug.
Enabling this option also effectively disables the "const s:string" optimizations since functions will get refcount management frames for strings anyway.


## MAINTENANCE

Has to be done regularly to keep Wakan up to date:

 * Up the version number.
 * Import new EDICT/ENAMDICT files
 * Update EDICT marker list in JWBUnit.pas (see http://www.csse.monash.edu.au/~jwb/edict_doc.html and http://www.csse.monash.edu.au/~jwb/edict_doc_old.html for older markers)
 * Update wakan.rad with new RADKFILEs (see dependencies)


## DEPENDENCIES

In the recent versions Wakan can download some of these from the Download / Update components.
See http://ftp.edrdg.org/pub/Nihongo/00INDEX.html where most of these files can be downloaded.

1. UNICONV.exe - required for dictionary import
http://ftp.edrdg.org/pub/Nihongo/uniconv.zip.
Also see: http://www.autohotkey.com/board/topic/9831-uniconv-convert-unicode-cmd/

2. WORDFREQ_CK - required for adding frequency information to dictionaries
http://ftp.edrdg.org/pub/Nihongo/wordfreq_ck.gz.
Also see: http://code.google.com/p/wakan/issues/detail?id=66

3. RADKFILE/RADKFILE2 - required for raine radicals search
http://ftp.edrdg.org/pub/Nihongo/radkfile.gz.
Download and place RADKFILE into Wakan release folder. You can import RADKFILE2 manually, but it's not yet supported.

4. 7z.dll - 7zip library. Required for downloading packed dictionaries.

5. KANJIDIC - required for character data.

6. Unihan folder - required for character data https://www.unicode.org/Public/UNIDATA/Unihan.zip. See https://unicode.org/charts/unihan.html.

7. EDICT2 - required for dictionary data (Wakan will work without it, but installer requires it)
http://ftp.edrdg.org/pub/Nihongo/edict2.gz.

8. ccedict.dic

9. examples_j.pkg
