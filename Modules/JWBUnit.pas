﻿unit JWBUnit;
{ Common stuff for Wakan. }

{$DEFINE NODICLOADPROMPT}
{ Do not show "Loading dictionary..." window when hot-loading a dictionary.
 It was needed before when loading was slow, but I feel like now it only makes
 the interface feel sluggish. }

interface
uses Graphics, Windows, SysUtils, Classes, Controls, Dialogs, Grids, Forms,
  ExtCtrls, IniFiles, JWBStrings, KanaConv, JWBDic;

{ Romaji conversions }
{
Katakana and romaji in dictionaries can contain latin letters and punctuation.
In general, it is safe to mix latin letters with katakana/bopomofo, but not with
romaji (i.e. is "ding" an english word or a pinyin syllable?)
Dictionaries address this in different ways: EDICT stores in katakana,
CCEDICT separates letters with spaces ("D N A jian4 ding4").

Internally we support:
- kana/bopomofo with latin letters + punctuation
- clean romaji (can be converted back to kana)
 Since clean romaji is still ANSI, we replace some punctuation with ANSI chars.
- romaji signature ("DNAjian4ding4" -- cannot be converted back to anything)
 Signature romaji is used for database lookups. It's stripped of punctuation,
but keeps latin letters. This allows us to quickly find all possible matches
instead of trying different interpretations of the input.
If you just want to display romaji for the record, do KanaToRomaji(kana) instead.

So,
1. On import we fail on unknown characters, otherwise convert text to database
 format per above:
  - kanji + latin + punctuation
  - kana + latin + punctuation
  - romaji + latin
2. On kanji/kana input we strip unknown characters, then do a lookup.
3. On romaji input we strip unknown characters and punctuation, then do a lookup.
4. On conversions from kana to romaji for display we only strip unknown characters.
}

//See KanaConv.ResolveFlag

var
  curlang:char;
  cromasys:integer;
  showroma:boolean;

 { Romaji translation tables. Populated on load. }
  roma_db: TKanaTranslator;
  roma_user: TKanaTranslator;
  rpy_db: TPinYinTranslator;
  rpy_user: TPinYinTranslator;

//We allow some punctuation marks in kana/kanji fields in Wakan, but only some

function IsAllowedPunctuation(c:WideChar): boolean;
function ConvertPunctuation(c:WideChar): char;
function ConvertPunctuationF(c:FChar): char;

type
  TSanitizeFlag = (
    sfKeepLatin,              //keep HW latin
    sfKeepAllowedPunctuation, //keep allowed punctuation (+ replace where needed)
    sfKeepKanji               //keep kanji characters
  );
  TSanitizeFlags = set of TSanitizeFlag;

function SanitizeKana(s: string; flags: TSanitizeFlags = [];
  const replChar: string = ''): string;

//Converts according to user preferences. Use for live input/output.
function KanaToRomaji(const s:FString;lang:char):string; overload; inline;
function KanaToRomajiF(const s:FString;lang:char):FString; overload; inline;
function KanaToRomaji(const s:FString;lang:char;flags:TResolveFlags):string; overload;
function RomajiToKana(const s:string;lang:char;flags:TResolveFlags):FString;

//Converts with a standard romaji. Use for DB/dictionaries/persistence.
function DbKanaToRomaji(const s:FString;lang:char):string; overload; inline;
function DbKanaToRomajiF(const s:FString;lang:char):FString; overload; inline;
function DbKanaToRomaji(const s:FString;lang:char;flags:TResolveFlags):string; overload;
function DbRomajiToKana(const s:string;lang:char;flags:TResolveFlags):FString;

{ Packs and cleans any romaji (perhaps coming from user) to signature format:
 no punctuation, no spaces, no unknown chars, lowercase.
 This is NOT ALL that's required from signature in dict, but other conditions require
 knowing the syllable composition and handled on import before calling this. }
function SignatureFrom(const s:string): string;

{ Converts characters to traditional or simplified variants, if configured to. }
function ChinSimplified(s:FString):FString;
function ChinTraditional(s:FString):FString;

{ Converts raw kana/bopomofo to romaji/kana for presentation }
function ConvertKana(const ch: FString;showr:boolean;lang:char): FString; overload;
function ConvertKana(const ch: FString): FString; overload;


{ Colors }

procedure InitColors(const reg: TCustomIniFile);
function GetColorString(i:integer):string;
procedure SetCol(col:integer;val:TColor);
function GetCol(col:integer):TColor;
function Col(col:string):TColor;
procedure WriteColors(const reg: TCustomIniFile);
procedure SetColDefault(i:integer);


{ Painting }

type
  TFindDrawRegFlag = (
    ffHalfCharRounding  //if more than half char is covered, return next char --
      //like it's usually done with text selection.
  );
  TFindDrawRegFlags = set of TFindDrawRegFlag;

procedure BeginDrawReg(p:TCanvas);
procedure EndDrawReg;
function FindDrawReg(p:TCanvas;x,y:integer;flags:TFindDrawRegFlags;
  out id,cx,cy:integer; out fontface: string;out fs:integer):FString;
function GetDrawReg(id:integer; out cx,cy: integer; out fontface:string;
  out fs:integer):FString;
function CalcStrWidth(c:TCanvas;const fontface:string;fs:integer;
  const w:UnicodeString): integer; forward;
function GetCoveredCharNo(c:TCanvas;const fontface:string;fs:integer;
  const ch:FString;x:integer;halfCharRounding:boolean): integer; forward;

procedure DrawUnicode(c:TCanvas;x,y,fs:integer;const ch:FString;const fontface:string);
procedure DrawUnicodeChar(c:TCanvas;rect:TRect;fs:integer;const ch:FString;const fontface:string);

procedure DrawKana(c:TCanvas;x,y,fs:integer;ch:string;fontface:string;showr:boolean;lang:char);




{ Fonts }

var
  FontStrokeOrder,
  FontChinese,
  FontChineseGB,
  FontChineseGrid,
  FontChineseGridGB,
  FontJapaneseGrid,
  FontJapanese,
  FontSmall,
  FontRadical,
  FontEnglish,
  FontPinYin:string;

  GridFontSize:integer;


{ Misc }

function DateForm(s:string):string;

implementation
uses Messages, StrUtils, ShlObj, Registry, AppData, JWBSettings, JWBLanguage,
  JWBCharData, JWBLegacyMarkup, MemSource;


{ Romaji conversions }

//True if c is a punctuation mark we allow in kanji and kana fields.
function IsAllowedPunctuation(c:WideChar): boolean;
begin
  Result :=
    (c='·') or (c=',') //in CCEDICT
    or (c='・') or (c='、') or (c='〜') or (c='～') //in EDICT2
    or (c='.') or (c='「') or (c='」') or (c='『') or (c='』') or (c='。') or (c='!'); //Wadoku-jiten
end;

//When we need to store punctuation into pinyin, we have to make it ansi
function ConvertPunctuation(c:WideChar): char;
begin
  case c of
    '·': Result := '-';
    '・': Result := '-';
    '、': Result := ',';
    '〜',
    '～': Result := '~';
    '.',
    '。': Result := '.';
    '「',
    '『',
    '」',
    '』': Result := '"';
    '!': Result := '!';
  else
    Result := c;
  end;
end;

function ConvertPunctuationF(c:FChar): char;
begin
  Result := ConvertPunctuation(c);
end;

//Removes everything except for kana / pinyin from the string or replaces it
//with appropriate characters
function SanitizeKana(s: string; flags: TSanitizeFlags; const replChar: string): string;
var i: integer;
  ec: TEvalCharType;
begin
  Result := '';
  for i := 1 to Length(s) do begin
    ec := EvalChar(s[i]);
    if ec in [EC_HIRAGANA, EC_KATAKANA, EC_BOPOMOFO] then
      Result := Result + s[i]
    else
    if (ec in [EC_IDG_CHAR]) and (sfKeepKanji in flags) then
      Result := Result + s[i]
    else
    if IsAllowedPunctuation(s[i]) and (sfKeepAllowedPunctuation in flags) then
      Result := Result + ConvertPunctuation(s[i])
    else
    if IsLatinLetter(s[i]) and (sfKeepLatin in flags) then
      Result := Result + s[i]
    else
      Result := Result + replChar;
  end;
end;

{ Converts kana to romaji in a default way, that is assuming the input is a
 kana from database and the output is for user display.
 Equivalent to older "KanaToRomaji(clean)". }
function KanaToRomaji(const s:FString;lang:char):string;
begin
  Result := KanaToRomaji(SanitizeKana(s,[sfKeepLatin,sfKeepAllowedPunctuation]),lang,[])
end;

//Same, but also converts the result to FString, enhances PinYin
function KanaToRomajiF(const s:FString;lang:char):FString;
begin
  if lang='c'then
    Result:=ConvertPinYin(KanaToRomaji(s,lang))
  else
    Result:=fstr(KanaToRomaji(s,lang));
end;

//Converts kana to romaji, per flags
function KanaToRomaji(const s:FString;lang:char;flags:TResolveFlags):string;
begin
  if lang='j'then
    Result:=roma_user.KanaToRomaji(s,flags)
  else
  if lang='c'then
    result:=rpy_user.KanaToRomaji(s,flags);
end;

{ Converts romaji to kana. Romaji must be a clean-romaji, i.e. no latin letters,
 no punctuation. Appropriate keep flags have no effect.
 All in all, romaji-to-kana conversion ought to happen only on import, therefore
 no flagless version. }
function RomajiToKana(const s:string;lang:char;flags:TResolveFlags):FString;
begin
  if lang='j'then
    Result:=roma_user.RomajiToKana(s,flags)
  else
  if lang='c'then
    result:=rpy_user.RomajiToKana(s,flags);
end;

function DbKanaToRomaji(const s:FString;lang:char):string;
begin
  Result:=DbKanaToRomaji(SanitizeKana(s,[sfKeepLatin,sfKeepAllowedPunctuation]),lang,[])
end;

function DbKanaToRomajiF(const s:FString;lang:char):FString;
begin
  if lang='c'then
    Result:=ConvertPinYin(DbKanaToRomaji(s,lang))
  else
    Result:=fstr(DbKanaToRomaji(s,lang));
end;

function DbKanaToRomaji(const s:FString;lang:char;flags:TResolveFlags):string;
begin
  if lang='j'then
    Result:=roma_db.KanaToRomaji(s,flags)
  else
  if lang='c'then
    result:=rpy_db.KanaToRomaji(s,flags);
end;

{ Converts romaji to kana. Romaji must be a clean-romaji, i.e. no latin letters,
 no punctuation. Appropriate keep flags have no effect.
 All in all, romaji-to-kana conversion ought to happen only on import, therefore
 no flagless version. }
function DbRomajiToKana(const s:string;lang:char;flags:TResolveFlags):FString;
begin
  if lang='j'then
    Result:=roma_db.RomajiToKana(s,flags)
  else
  if lang='c'then
    result:=rpy_db.RomajiToKana(s,flags);
end;

function SignatureFrom(const s:string): string;
var i,j: integer;
begin
  Result:=lowercase(s);
  i:=1;
  j:=0;
  while i+j<=length(Result) do
    if not IsLatinLetter(Result[i+j])
    and not IsLatinDigit(Result[i+j]) then
      Inc(j)
    else begin
      if j>0 then
        Result[i]:=Result[i+j];
      Inc(i);
    end;
  if j>0 then
    SetLength(Result,length(Result)-j);
end;


function ChinSimplified(s:FString):FString;
var s2:FString;
  cd:FString;
begin
  if (curlang='j') or (fSettings.RadioGroup5.ItemIndex<>1) then
  begin
    result:=s;
    exit;
  end;
  result:='';
  while s<>'' do begin
    s2:=fcopy(s,1,1);
    fdelete(s,1,1);
    if ({$IFNDEF UNICODE}s2[1]>'3'{$ELSE}Ord(s2[1])>$3000{$ENDIF}) then
    begin
      cd:=GetCharProp(s2,ptSimplifiedVariant);
      if cd<>'' then result:=result+cd else result:=result+s2
    end else result:=result+s2;
  end;
end;

function ChinTraditional(s:FString):FString;
var s2:FString;
  cd:FString;
begin
  if (curlang='j') or (fSettings.RadioGroup5.ItemIndex<>0) then
  begin
    result:=s;
    exit;
  end;
  result:='';
  while s<>'' do
  begin
    s2:=fcopy(s,1,1);
    fdelete(s,1,1);
    if ({$IFNDEF UNICODE}s2[1]>'3'{$ELSE}Ord(s2[1])>$3000{$ENDIF}) then
    begin
      cd:=GetCharProp(s2,ptTraditionalVariant);
      if cd<>'' then result:=result+cd else result:=result+s2
    end else result:=result+s2;
  end;
end;




{ Color configuration }

const
  Color_Max=100;
var
  colarr:TStringList;
  colval:TStringList;
  colsval:array[0..Color_Max] of TColor;
  colsarr:TStringList;

procedure InitColors(const reg: TCustomIniFile);
var i:integer;
    s:string;
    s2:string;
begin
  FreeAndNil(colarr);
  colarr:=TStringList.Create;
  colarr.add('0Kanji_Back=FFFFFF,^Background');
  colarr.add('0Kanji_Common=000000,^Common characters');
  colarr.add('0Kanji_Rare=4F4F4F,^Rare characters');
  colarr.add('0Kanji_Names=005F00,^Characters in names');
  colarr.add('0Kanji_Learned=7F0000,^Learned characters');
  colarr.add('0Kanji_RadCommon=000000,^Common radicals');
  colarr.add('0Kanji_RadRare=4F4F4F,^Rare radicals');
  colarr.add('0Kanji_RadLearned=7F0000,^Learned radicals');
  colarr.add('1Dict_Back=FFFFFF,^Background');
  colarr.add('1Dict_Text=000000,^Text');
  colarr.add('1Dict_UnknownChar=2F2F7F,^Unknown characters');
  colarr.add('1Dict_Problematic=DDDDFF,^Problematic words');
  colarr.add('1Dict_Unlearned=FFEEDD,^Unlearned words');
  colarr.add('1Dict_Learned=BBFFFF,^Learned words');
  colarr.add('1Dict_Mastered=BBFFBB,^Mastered words');
  colarr.add('1Dict_SelBack=BBBBBB,^Background (selected)');
  colarr.add('1Dict_SelProblematic=9999BB,^Problematic words (selected)');
  colarr.add('1Dict_SelUnlearned=BBAA99,^Unlearned words (selected)');
  colarr.add('1Dict_SelLearned=99BBBB,^Learned words (selected)');
  colarr.add('1Dict_SelMastered=77BB77,^Mastered words (selected)');
  colarr.add('2Mark_Special=7F007F,^Special markers');
  colarr.add('2Mark_Usage=00007F,^Usage markers');
  colarr.add('2Mark_Grammatical=7F0000,^Grammatical markers');
  colarr.add('2Mark_Dict=4F4F4F,^Dictionary markers');
  colarr.add('2Mark_Lesson=004F00,^Lesson markers');
  colarr.add('3Editor_Back=FFFFFF,^Background');
  colarr.add('3Editor_Text=000000,^Text color');
  colarr.add('3Editor_ASCII=2F2F2F,^ASCII text');
  colarr.add('3Editor_Active=FF0000,^Text being written');
  colarr.add('3Editor_Aftertouch=0000FF,^Text just converted');
  colarr.add('3Editor_Untranslated=FFFFFF,^Untranslated text');
  colarr.add('3Editor_NotFound=003FFF,^Text where translation failed');
  colarr.add('3Editor_Particle=FFAAFF,^Estimated particle');
  colarr.add('3Editor_Translated=EEEEEE,^Word not in vocabulary');
  colarr.add('3Editor_Problematic=DDDDFF,^Problematic vocabulary word');
  colarr.add('3Editor_Unlearned=FFEEDD,^Unlearned vocabulary word');
  colarr.add('3Editor_Learned=BBFFFF,^Learned vocabulary word');
  colarr.add('3Editor_Mastered=BBFFBB,^Mastered vocabulary word');
  colarr.add('3Editor_HintBack=EFEFEF,^Hint background');
  colarr.add('3Editor_HintSelected=00FFFF,^Hint selected background');
  colarr.add('3Editor_HintText=000000,^Hint text');
  colarr.add('3Editor_AozoraTag=C0C0C0,^Aozora Ruby <tag>');
  colarr.add('3Editor_AozoraComment=C0C0C0,^Aozora Ruby ［comment］');
  colarr.add('3Editor_AozoraRuby=C0C0C0,^Aozora Ruby 《ruby》');
  colarr.add('4Popup_Back=A0FFFF,^Background');
  colarr.add('4Popup_Lines=000000,^Lines');
  colarr.add('4Popup_Card=FFFFFF,^Character card');
  colarr.add('4Popup_Text=000000,^Text on the caracter card');
  FreeAndNil(colval);
  FreeAndNil(colsarr);
  colval:=TStringList.Create;
  colsarr:=TStringList.Create;
  for i:=0 to colarr.Count-1 do
  begin
    s:=colarr[i];
    delete(s,1,1);
    s2:=s;
    delete(s2,1,pos('=',s));
    s:=copy(s,1,pos('=',s)-1);
    s2:=copy(s2,1,pos(',',s2)-1);
    colval.Add(reg.ReadString('Colors',s,s2));
    colsarr.Add(s);
  end;
  colsarr.Sorted:=true;
  colsarr.Sort;
  SetCol(-1,clBlack);
end;

procedure SetColDefault(i:integer);
var s,s2:string;
begin
  s:=colarr[i];
  delete(s,1,1);
  s2:=s;
  delete(s2,1,pos('=',s));
  s:=copy(s,1,pos('=',s)-1);
  s2:=copy(s2,1,pos(',',s2)-1);
  colval[i]:=s2;
  SetCol(-1,clBlack);
end;

function GetColorString(i:integer):string;
var s:string;
begin
  result:='';
  if i>=colarr.Count then exit;
  s:=colarr[i];
  result:=s[1];
  delete(s,1,pos(',',s));
  result:=result+s;
end;

procedure SetCol(col:integer;val:TColor);
var i,j:integer;
begin
  if col>-1 then colval[col]:=Format('%6.6X',[val]);
  for i:=0 to colsarr.Count-1 do for j:=0 to colarr.Count-1 do if copy(colarr[j],2,length(colsarr[i]))=colsarr[i] then
    colsval[i]:=strtoint('0x'+colval[j]);
end;

function GetCol(col:integer):TColor;
begin
  result:=strtoint('0x'+colval[col]);
end;

function Col(col:string):TColor;
begin
  result:=colsval[colsarr.IndexOf(col)];
end;

procedure WriteColors(const reg: TCustomIniFile);
var i:integer;
    s:string;
    s2:string;
begin
  for i:=0 to colarr.Count-1 do
  begin
    s:=colarr[i];
    delete(s,1,1);
    s2:=s;
    delete(s2,1,pos('=',s));
    s:=copy(s,1,pos('=',s)-1);
    s2:=copy(s,1,pos(',',s));
    reg.WriteString('Colors',s,colval[i]);
  end;
end;


{
Draw registry.
To support text selection, Wakan keeps a list of all text lines
it has drawn with the help of DrawUnicode.
Each time a control is redrawn, all cells related to it are cleared.
}

type
  TIntTextInfo=record
    act:boolean;
    p:TCanvas;
    fontface:string;
    fs:integer;
    rect:TRect;
    s:FString;
  end;

const
  MAX_INTTEXTINFO = 4000;
var
  itt:array[1..MAX_INTTEXTINFO] of TIntTextInfo;
  curpbox:TCanvas;

procedure BeginDrawReg(p:TCanvas);
var i:integer;
begin
  for i:=1 to MAX_INTTEXTINFO do if itt[i].p=p then itt[i].act:=false;
  curpbox:=p;
end;

procedure EndDrawReg;
begin
  curpbox:=nil;
end;

{ Retrieves a subblock of a block of text drawn with DrawUnicode.
p,x,y: position to probe.
Result: substring of a block of text under mouse starting at mouse position, inclusive.
id: index of a draw call, if these are equal, it's the same line
cx,cy: position of a first character of a returned subblock on a control.
fs: font size (character height) for this string.
flags: see TFindDrawRegFlags description }
function FindDrawReg(p:TCanvas;x,y:integer;flags:TFindDrawRegFlags;
  out id,cx,cy:integer; out fontface: string;out fs:integer):FString;
var i,j:integer;
begin
  id:=-1;
  result:='';
  for i:=1 to MAX_INTTEXTINFO do
    if (itt[i].p=p)
    and (y>=itt[i].rect.Top) and (y<=itt[i].rect.Top+itt[i].fs)
    and (x>=itt[i].rect.Left) and (x<=itt[i].rect.Right) then begin
      id:=i;
      cy:=itt[i].rect.Top;
      fs:=itt[i].fs;
      fontface:=itt[i].fontface;

      j:=GetCoveredCharNo(p,fontface,fs,itt[i].s,x-itt[i].rect.Left,
        {halfCharRounding=}ffHalfCharRounding in flags);
      if not (ffHalfCharRounding in flags) then
        Dec(j); //without hcr we receive the character UNDER mouse, want BEFORE it
      if j<0 then continue; //should not happen
      if j>flength(itt[i].s) then continue;
      cx:=itt[i].rect.Left+CalcStrWidth(p,fontface,fs,copy(itt[i].s,1,j));
      result:=fcopy(itt[i].s,j+1,flength(itt[i].s)-j);
      break;
    end;
end;

function GetDrawReg(id:integer; out cx,cy: integer; out fontface:string; out fs:integer):FString;
begin
  cx:=itt[id].rect.Left;
  cy:=itt[id].rect.Top;
  fs:=itt[id].fs;
  fontface:=itt[id].fontface;
  Result:=itt[id].s;
end;

procedure AddDrawReg(p:TCanvas;const fontface: string;fs:integer;const rect:TRect;const s:FString);
var i: integer;
begin
  for i:=1 to MAX_INTTEXTINFO do
    if not itt[i].act then begin
      itt[i].act:=true;
      itt[i].p:=p;
      itt[i].fontface:=fontface;
      itt[i].fs:=fs;
      itt[i].rect:=rect;
      itt[i].s:=s;
      break;
    end;
end;

{ Returns the width of a string if drawn like specified.
 Hint: pass a copy(str,start,end) to measure the width of only some characters. }
function CalcStrWidth(c:TCanvas;const fontface:string;fs:integer;const w:UnicodeString): integer;
var r:TRect;
begin
  if w='' then begin
    Result := 0;
    exit;
  end;
  c.Font.Name:=fontface;
  c.Font.Height:=fs;
  r.Left := 0;
  r.Top := 0;
  r.Right := 0;
  r.Bottom := 0;
  if DrawText(c.Handle,PWideChar(w),length(w),r,DT_LEFT or DT_TOP or DT_CALCRECT or DT_NOCLIP)=0 then
    Result := 0
  else
    Result := r.Right-r.Left;
end;

{ Returns the number of characters in the string which are selection-covered
 when the mouse is in X pixels from the left edge of the text.
 A less-than-half-covered character is considered not covered.
  -1: mouse is over the left edge
  n+1: mouse is over the right edge }
function GetCoveredCharNo(c:TCanvas;const fontface:string;fs:integer;
  const ch:FString;x:integer;halfCharRounding:boolean): integer;
var w: UnicodeString;
  chwPrev, chwNext: integer;
begin
  if x<0 then begin
    Result := -1;
    exit;
  end;

  w := fstrtouni(ch);
  if Length(w)<=0 then begin
    Result := 1;
    exit;
  end;

 { Measure chunks of 1..i chars. We could have measured only one char each turn,
  but we'd be missing inter-character space. }
  Result := 0;
  chwPrev := 0;
  chwNext := CalcStrWidth(c,fontface,fs,w[1]); //get first char width
  while x>chwNext do begin
    Inc(Result);
    if Result>=Length(w) then begin
      Inc(Result);
      exit;
    end;
    chwPrev := chwNext;
    chwNext := CalcStrWidth(c,fontface,fs,copy(w,1,1+Result));
  end;

  if (x>chwPrev+(chwNext-chwPrev) div 2) or not halfCharRounding then
    Inc(Result);
end;


{
x, y: Where to draw.
fs: Font size
ch: Text
}
procedure DrawUnicode(c:TCanvas;x,y,fs:integer;const ch:FString;const fontface:string);
var w:UnicodeString;
  r: TRect;
begin
  if ch='' then exit;
  SetBkMode(c.Handle,TRANSPARENT);
  c.Font.Name:=fontface;
  c.Font.Height:=fs;
  w := fstrtouni(ch);
  r.Left := x;
  r.Top := y;
  r.Right := x;
  r.Bottom := y;
 //We need the rect for AddDrawReg and CALCRECT does not draw
  DrawText(c.Handle,PWideChar(w),length(w),r,DT_LEFT or DT_TOP or DT_CALCRECT);
  DrawText(c.Handle,PWideChar(w),length(w),r,DT_LEFT or DT_TOP or DT_NOCLIP);
  if curpbox<>nil then
    AddDrawReg(curpbox,fontface,fs,r,ch);
end;

{ Similar but also handles the case where there's no glyph for the char in the font }
procedure DrawUnicodeChar(c:TCanvas;rect:TRect;fs:integer;const ch:FString;const fontface:string);
var w: UnicodeString;
  w_ind: word;
  ws: string;
begin
  if ch='' then exit;
  SetBkMode(c.Handle,TRANSPARENT);
 { Some glyphs may be outright impossible to draw -- no suitable fonts, even with substitution }
  w := fstrtouni(ch);
  c.Font.Name:=fontface;
  c.Font.Height:=fs;
  if GetGlyphIndices(c.Handle,PChar(w),1,@w_ind, GGI_MARK_NONEXISTING_GLYPHS)=GDI_ERROR then
    RaiseLastOsError();
  if w_ind<>$FFFF then begin
    DrawText(c.Handle,PWideChar(w),length(w),rect,DT_LEFT or DT_TOP or DT_CALCRECT);
    DrawText(c.Handle,PWideChar(w),length(w),rect,DT_LEFT or DT_TOP or DT_NOCLIP);
    if curpbox<>nil then
      AddDrawReg(curpbox,fontface,fs,rect,ch);
  end else begin
   //Draw unicode index instead
    ws := IntToHex(Utf16ToUnicodeIndex(fgetch(ch,1)),4);
    c.Font.Name:=FontEnglish;
    c.Font.Height:=Trunc(fs*0.44);
    DrawText(c.Handle,PChar(ws),Length(ws),rect,DT_CENTER or DT_SINGLELINE or DT_VCENTER);
  end;
end;



{ Converts raw kana/bopomofo to romaji/kana for presentation }
function ConvertKana(const ch: FString;showr:boolean;lang:char): FString;
begin
  if showr then
    Result := KanaToRomajiF(ch,lang)
  else
    Result := ConvertBopomofo(ch);
end;

function ConvertKana(const ch: FString): FString;
begin
  Result := ConvertKana(ch,showroma,curlang);
end;

//NOTE: If you update fonts here, update DrawGridUpdateSelection() too.
procedure DrawKana(c:TCanvas;x,y,fs:integer;ch:string;fontface:string;showr:boolean;lang:char);
var cnv2:string;
begin
  c.Font.Style:=[];
  if showr then
  begin
    cnv2:=KanaToRomajiF(ch,lang);
    DrawUnicode(c,x,y,fs+1,cnv2,FontPinYin);
  end else
    DrawUnicode(c,x,y,fs,ConvertBopomofo(ch),fontface);
end;



{ Misc }

function DateForm(s:string):string;
begin
  if s='00000000'then result:='-'else
  result:=copy(s,7,2)+'.'+copy(s,5,2)+'.'+copy(s,1,4);
end;

var
  i:integer;

initialization
  CurPBox:=nil;
  for i:=1 to MAX_INTTEXTINFO do itt[i].act:=false;
  GridFontSize:=14;
  showroma:=false;

  roma_db := TKanaTranslator.Create;
  roma_user := TKanaTranslator.Create;
  rpy_db := TPinyinTranslator.Create;
  rpy_user := TPinyinTranslator.Create;

finalization
 {$IFDEF CLEAN_DEINIT}
  FreeAndNil(rpy_user);
  FreeAndNil(rpy_db);
  FreeAndNil(roma_user);
  FreeAndNil(roma_db);
 {$ENDIF}

end.
