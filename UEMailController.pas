unit UEMailController;

interface

uses
  System.Generics.Collections,
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  IEMail = interface
    function GetMailFrom: string;
    procedure SetMailFrom(const pMailFrom: string);
    function GetMailSubject: string;
    procedure SetMailSubject(const pMailSubject: string);
    function GetMailBody: string;
    procedure SetMailBody(const pMailBody: string);

    property MailFrom: string read GetMailFrom write SetMailFrom;
    property MailSubject: string read GetMailSubject write SetMailSubject;
    property MailBody: string read GetMailBody write SetMailBody;
  end;

  [MVCPath('/email')]
  TEMailController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/send')]
    [MVCHTTPMethod([httpPOST])]
    procedure SendMail(pEmail: IEMail);
  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils;


procedure TEMailController.Index;
begin
  //use Context property to access to the HTTP request and response
  Render('DelphiMVCFramework E-Mail');
end;

procedure TEMailController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TEMailController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

procedure TEMailController.SendMail(pEmail: IEMail);
begin
  pEmail.MailFrom := pEmail.MailFrom;
  pEmail.MailSubject := pEmail.MailSubject;
  pEmail.MailBody := pEmail.MailBody;
end;

end.
