unit UZibelController;

interface

uses
  System.Generics.Collections,
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  TEMail = class
    FMailFrom: string;
    FMailBody: string;
  public
    property MailFrom: string read FMailFrom write FMailFrom;
    property MailBody: string read FMailBody write FMailBody;
  end;

  [MVCPath('/api')]
  TZibelController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;
  private
    function EnviarEmail(pEmail: TEMail): boolean;
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/sendmail')]
    [MVCHTTPMethod([httpPOST])]
    procedure SendMail;
  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils,
  IdMessage, IdSMTP;

function TZibelController.EnviarEmail(pEmail: TEMail): boolean;
var
  SMTP: TIdSMTP;
  Msg: TIdMessage;
const // parametros do smtp
  smtpHost: string = '';
  smtpPort: Integer = 587;
  smtpUser: string = '';
  smtpPass: string = '';
begin
  // faz envio de email de contato
  Result := False;
  Msg := TIdMessage.Create(nil);
  try
    Msg.From.Address := smtpUser;
    Msg.Recipients.EMailAddresses := pEmail.FMailFrom;
    Msg.Body.Text := pEmail.MailBody;
    Msg.Subject := 'zibeltecnologia.com.br - ' + pEmail.FMailFrom;
    SMTP := TIdSMTP.Create(nil);
    try
      SMTP.Host := smtpHost;
      SMTP.Port := smtpPort;
      SMTP.AuthType := satDefault;
      SMTP.Username := smtpUser;
      SMTP.Password := smtpPass;
      SMTP.Connect;
      SMTP.Send(Msg);
      Result := True;
    finally
      SMTP.Free;
    end;
  finally
    Msg.Free;
  end;
end;

procedure TZibelController.Index;
begin
  //use Context property to access to the HTTP request and response 
  Render('DelphiMVCFramework Online');
end;

procedure TZibelController.OnAfterAction(Context: TWebContext; const AActionName: string); 
begin
  { Executed after each action }
  inherited;
end;

procedure TZibelController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

procedure TZibelController.SendMail;
var
  oEmail: TEMail;
begin
  // recebe um objeto com From e Body
  oEmail := Context.Request.BodyAs<TEMail>;
  if EnviarEmail(oEmail)
  then Render(201, 'DelphiMVCFramework SendMail Success')
  else Render(400, 'DelphiMVCFramework SendMail Failure');
end;

end.
