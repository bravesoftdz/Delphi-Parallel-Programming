unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, XPMan, Buttons, Unit2;

const
  WM_PBAR_DEGERI_MESAJIM = WM_USER + 195;
  // Kullan�c� mesaj� tan�mlan�yor

type
  PThreadParametresi = ^TThreadParametresi;
  TThreadParametresi = record
    yazi: string[5];
    sayi: Integer;
  end;
  // Thread'dan g�nderilecek Bilgi
  // Yap�s� ve onun Pointeri tan�mlan�yor

  TThreadDurum = (tdYok, tdCalisiyor, tdDurdu);

  TForm1 = class(TForm)
    ProgressBar1: TProgressBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    XPManifest1: TXPManifest;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure threadbitti(sender: Tobject);
    procedure MesajAlicisi(var Msg: TMessage); message WM_PBAR_DEGERI_MESAJIM;
    // Mesaj prosed�r� tan�mlan�yor
    // Tan�mlanm�� kullan�c� mesaj� geldi�inde
    // bu prosed�re y�nlendirilecek
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Yenithread: MyThread;
  Threaddurum: TThreadDurum = tdYok;
  ThreadParametresi: PThreadParametresi;

implementation
{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject); // Ba�lat
begin
  if Threaddurum <> tdYok then Exit;
  Yenithread := MyThread.Create;
  Yenithread.Priority := tpLowest;
  Yenithread.OnTerminate := threadbitti;
  Yenithread.Resume;  //Thread ba�lat�l�yor
  Threaddurum := tdCalisiyor;
end;

procedure TForm1.threadbitti(sender: tobject);
begin
 showmessage('Thread bitti!');
 Threaddurum := tdYok;
end;

procedure TForm1.BitBtn2Click(Sender: TObject); // Ara ver
begin
 if Threaddurum <> tdCalisiyor then Exit;
 Yenithread.Suspend;
 Threaddurum := tdDurdu;
end;

procedure TForm1.BitBtn3Click(Sender: TObject); // Devam et
begin
 if Threaddurum <> tdDurdu then Exit;
 Yenithread.Resume;
 Threaddurum := tdCalisiyor;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);  // Durdur
begin
  if Threaddurum <> tdCalisiyor then Exit;
  Yenithread.Terminate;
end;

procedure TForm1.MesajAlicisi(var Msg: TMessage);
var Tp : PThreadParametresi;
begin
   Tp := PThreadParametresi(Msg.WParam);
   Form1.Caption := Tp.yazi;
   ProgressBar1.position := Tp.sayi;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 New(ThreadParametresi);
 // Mesaj i�in bilgi saklanacak
 // yap� haf�zda olu�turuluyor
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Dispose(ThreadParametresi);
 // Mesaj i�in bilgi saklanan
 // yap� haf�zdan siliniyor
end;

end.
