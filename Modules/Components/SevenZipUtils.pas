unit SevenZipUtils;
(*
  Various utilities to simplify working with 7z.dll
*)

interface
uses SysUtils, Classes, Windows, ActiveX, JclBase, SevenZip;

type
  ESevenZipException = class(Exception);

 (*
  Even if you don't set OwnsStream, direct interaction with a stream is
  forbidden while TIfStream handles it.
 *)
  TIfStream = class(TInterfacedObject)
  protected
    FStream: TStream;
    FOwnsStream: boolean;
    procedure Seek(Offset: Int64; SeekOrigin: Cardinal; NewPosition: PInt64); safecall;
  public
    constructor Create(AStream: TStream; AOwnsStream: boolean = false);
    destructor Destroy; override;
  end;

  TInStream = class(TIfStream, ISequentialInStream, IInStream)
  protected
    procedure Read(Data: Pointer; Size: Cardinal; ProcessedSize: PCardinal); safecall;
  end;

  TOutStream = class(TIfStream, ISequentialOutStream, IOutStream)
    procedure Write(Data: Pointer; Size: Cardinal; ProcessedSize: PCardinal); safecall;
    procedure SetSize(NewSize: Int64); safecall;
  end;

  TExtractFileCallback = class(TInterfacedObject, IArchiveExtractCallback)
  public
    OpResult: integer;
    destructor Destroy; override;
  protected
    FData: TMemoryStream;
    FOutStream: TOutStream;
    function GetStream(Index: Cardinal; out OutStream: ISequentialOutStream;
      askExtractMode: Cardinal): HRESULT; stdcall;
    procedure PrepareOperation(askExtractMode: Cardinal); safecall;
    procedure SetOperationResult(resultEOperationResult: Integer); safecall;
    procedure SetTotal(Total: Int64); safecall;
    procedure SetCompleted(CompleteValue: PInt64); safecall;
  end;

  TSevenZipArchive = class
  protected
    FArchive: IInArchive;
  public
    constructor Create(ClsID: TGUID; Filename: UnicodeString); overload;
    constructor Create(ClsID: TGUID; Stream: TStream); overload;
    destructor Destroy; override;
    function NumberOfItems: cardinal;
    function BoolProperty(Index, PropID: cardinal): boolean;
    function StrProperty(Index, PropID: cardinal): UnicodeString;
    function ExtractFile(Index: cardinal): TMemoryStream;

  end;

resourcestring
  eCannotLoadSevenZip = 'Cannot load 7z.dll which is required when working with '
    +'archives. This means two things. First, you have a dynamic link build '
    +'of engine, and second, you lack the DLL.';
  eWrongPropertyType = '%s property expected, type %d returned.';

//Variant utilities forgotten by Borland
procedure PropVariantInit(pvar: PPropVariant); stdcall;
function PropVariantClear(pvar: PPropVariant): HRESULT; stdcall;

//Generates exceptions
procedure ZipFail(msg: string); overload;
procedure ZipFail(msg: string; args: array of const); overload;
procedure ZipFail(hr: HRESULT; op: string); overload;

//Check that the library's in place
procedure SevenZipCheckLoaded;

implementation

//Simply speaking, nulls everything
procedure PropVariantInit(pvar: PPropVariant); stdcall;
begin
  ZeroMemory(pvar, SizeOf(pvar^)); //this will do.
end;

//Required to clear variant properties
function PropVariantClear(pvar: PPropVariant): HRESULT; stdcall; external 'ole32.dll';

procedure ZipFail(msg: string);
begin
  raise ESevenZipException.Create(msg);
end;

procedure ZipFail(msg: string; args: array of const);
begin
  ZipFail(Format(msg, args));
end;

procedure ZipFail(hr: HRESULT; op: string);
begin
  raise ESevenZipException.Create(op+': 0x'+IntToHex(hr, 8));
end;

procedure SevenZipCheckLoaded;
begin
  if not Is7ZipLoaded then
    if not Load7Zip then
      ZipFail(eCannotLoadSevenZip);
end;

constructor TIfStream.Create(AStream: TStream; AOwnsStream: boolean);
begin
  inherited Create;
  FStream := AStream;
  FOwnsStream := AOwnsStream;
end;

destructor TIfStream.Destroy;
begin
  if FOwnsStream = true then
    FreeAndNil(FStream);
  inherited;
end;

procedure TIfStream.Seek(Offset: Int64; SeekOrigin: Cardinal; NewPosition: PInt64);
var pos: int64;
begin
  pos := FStream.Seek(Offset, SeekOrigin);
  if NewPosition <> nil then
    NewPosition^ := pos;
end;

procedure TInStream.Read(Data: Pointer; Size: Cardinal; ProcessedSize: PCardinal);
var sz: integer;
begin
  sz := FStream.Read(Data^, Size);
  if ProcessedSize <> nil then
    ProcessedSize^ := sz;
end;

procedure TOutStream.Write(Data: Pointer; Size: Cardinal; ProcessedSize: PCardinal);
var sz: integer;
begin
  sz := FStream.Write(Data^, Size);
  if ProcessedSize <> nil then
    ProcessedSize^ := sz;
end;

procedure TOutStream.SetSize(NewSize: Int64);
begin
  FStream.Size := NewSize;
end;

destructor TExtractFileCallback.Destroy;
begin
  if FOutStream <> nil then begin
    (FOutStream as IInterface)._Release;
    FOutStream := nil;
  end;
  FreeAndNil(FData);
  inherited;
end;

function TExtractFileCallback.GetStream(Index: Cardinal;
  out OutStream: ISequentialOutStream;
  askExtractMode: Cardinal): HRESULT;
begin
  if FData = nil then
    FData := TMemoryStream.Create;
  if FOutStream = nil then begin
    FOutStream := TOutStream.Create(FData, {OwnsStream=}false);
    (FOutStream as IInterface)._AddRef;
  end;

  OutStream := FOutStream;
  Result := S_OK;
end;

procedure TExtractFileCallback.PrepareOperation(askExtractMode: Cardinal);
begin
end;

procedure TExtractFileCallback.SetOperationResult(resultEOperationResult: Integer);
begin
  OpResult := resultEOperationResult;
end;

procedure TExtractFileCallback.SetTotal(Total: Int64);
begin
end;

procedure TExtractFileCallback.SetCompleted(CompleteValue: PInt64);
begin
end;



constructor TSevenZipArchive.Create(ClsID: TGUID; Filename: UnicodeString);
var hr: HRESULT;
  g_IID: TGUID;
  InStream: IInStream;
begin
  SevenZipCheckLoaded;
  inherited Create;

  g_IID := IInArchive;
  hr := CreateObject(@ClsID, @g_IID, FArchive);
  if FAILED(hr) then ZipFail(hr, 'CreateObject');

  InStream := TInStream.Create(
    TFileStream.Create(Filename, fmOpenRead),
    {OwnsObject=}true);

  hr := FArchive.Open(InStream, nil, nil);
  if FAILED(hr) then ZipFail(hr, 'Open');
end;

{ You're giving out the ownership of the stream }
constructor TSevenZipArchive.Create(ClsID: TGUID; Stream: TStream);
var hr: HRESULT;
  g_IID: TGUID;
  InStream: IInStream;
begin
  SevenZipCheckLoaded;
  inherited Create;

  g_IID := IInArchive;
  hr := CreateObject(@ClsID, @g_IID, FArchive);
  if FAILED(hr) then ZipFail(hr, 'CreateObject');

  InStream := TInStream.Create(
    Stream,
    {OwnsObject=}true);

  hr := FArchive.Open(InStream, nil, nil);
  if FAILED(hr) then ZipFail(hr, 'Open');
end;

destructor TSevenZipArchive.Destroy;
begin
  if FArchive <> nil then begin
    FArchive.Close;
    FArchive := nil;
  end;
  inherited;
end;

function TSevenZipArchive.NumberOfItems: cardinal;
begin
  FArchive.GetNumberOfItems(Result);
end;

function TSevenZipArchive.BoolProperty(Index, PropID: cardinal): boolean;
var val: PROPVARIANT;
  tmp: integer;
begin
  PropVariantInit(@val);
  FArchive.GetProperty(Index, PropID, val);

  case val.vt of
    VT_EMPTY: Result := false;
    VT_BOOL: Result := val.boolVal;
  else
    tmp := val.vt;
    PropVariantClear(@val);
    ZipFail(eWrongPropertyType, ['Bool', tmp]);
    Result := false; //Delphi!
  end;

  PropVariantClear(@val);
end;

function TSevenZipArchive.StrProperty(Index, PropID: cardinal): UnicodeString;
var val: PROPVARIANT;
  tmp: integer;
begin
  PropVariantInit(@val);
  FArchive.GetProperty(Index, PropID, val);

  case val.vt of
    VT_EMPTY: Result := '';
    VT_BSTR: Result := val.bstrVal;
    VT_LPSTR: Result := string(val.pszVal);
    VT_LPWSTR: Result := val.pwszVal;
  else
    tmp := val.vt;
    PropVariantClear(@val);
    ZipFail(eWrongPropertyType, ['String', tmp]);
  end;

  PropVariantClear(@val);
end;

function TSevenZipArchive.ExtractFile(Index: cardinal): TMemoryStream;
var Callback: TExtractFileCallback;
begin
  Result := nil;
  Callback := TExtractFileCallback.Create;
  (Callback as IInterface)._AddRef;
  try
    FArchive.Extract(@Index, 1, 0, Callback);

    if Callback.OpResult <> 0 then
      ZipFail('Cannot extract file, error '+IntToStr(Callback.OpResult))
    else //without this ELSE Delphi will say Result:=nil earlier was in vain
      Result := Callback.FData;
    Callback.FData := nil;
  finally
    (Callback as IInterface)._Release;
  end;
end;

end.
