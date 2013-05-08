unit Liffgui_main;

(*
 LIFF GUI
 ====-===

 description : GUI for LIFF
 author      : Severak
 license     : MIT

*)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Lua52;

type

  { TForm1 }

  TForm1 = class(TForm)
    LabelRoom: TLabel;
    ListBoxMenu: TListBox;
    MemoText: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxMenuClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  L: PLua_state;

implementation

{$R *.lfm}

{ TForm1 }

function gui_nop(L: Plua_state): integer; cdecl;
begin
  Result := 0;
end;

function gui_set_title(L: Plua_state): integer; cdecl;
var
  Text: string;
begin
  Text := lua_tostring(L, -1);
  Form1.Caption := text;
  Result := 0;
end;

function gui_set_room_title(L: Plua_state): integer; cdecl;
var
  Text: string;
begin
  Text := lua_tostring(L, -1);
  Form1.LabelRoom.Caption := text;
  Result := 0;
end;

function gui_echo(L: Plua_state): integer; cdecl;
var
  Text: string;
begin
  Text := lua_tostring(L, -1);
  Form1.MemoText.Lines.Append(Text);
  Result := 0;
end;

function gui_cls(L: Plua_state): integer; cdecl;
begin
  Form1.MemoText.Lines.Clear;
  Result := 0;
end;

function gui_menu_add(L: Plua_state): integer; cdecl;
var
  Text: string;
  Index : integer;
begin
  Text := lua_tostring(L, -1);
  Index := Form1.ListBoxMenu.Items.Add(text);
  Form1.ListBoxMenu.Update;
  lua_pushinteger(L, Index );
  Result := 1;
end;

function gui_menu_clear(L: Plua_state): integer; cdecl;
begin
  Form1.ListBoxMenu.Clear;
  Result := 0;
end;

procedure LuaH_table_set_function(L: Plua_state; field: string; fun: lua_CFunction);
begin
  lua_pushcfunction(L, fun);
  lua_setfield(L, -2, PChar(field));
end;

procedure LuaH_error_handle(L: Plua_state);
var
  msg : String;
const
  NL = #10#13;
begin
  msg := lua_tostring(L,-1);
  ShowMessage('Lua error:' + NL + msg);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  L := luaL_newstate();
  luaL_openlibs(L);
  lua_newtable(L);
  LuaH_table_set_function(L, 'echo', @gui_echo);
  LuaH_table_set_function(L, 'cls', @gui_cls);
  LuaH_table_set_function(L, 'set_title', @gui_set_title);
  LuaH_table_set_function(L, 'set_room_title', @gui_set_room_title);
  LuaH_table_set_function(L, 'menu_add', @gui_menu_add);
  LuaH_table_set_function(L, 'menu_clear', @gui_menu_clear);
  LuaH_table_set_function(L, 'menu_click', @gui_nop);
  lua_setglobal(L, 'liff_gui');
  if luaL_dofile(L, 'lua/liff/engine.lua')<>0 then
  begin
    LuaH_error_handle(L);
    Application.Terminate;
  end;
  if luaL_dofile(L, 'lua/game.lua')<>0 then
  begin
    LuaH_error_handle(L);
    Application.Terminate;
  end;
end;

procedure TForm1.ListBoxMenuClick(Sender: TObject);
begin
  lua_getglobal(L, 'liff_gui');
  lua_getfield(L, -1, 'menu_click');
  lua_pushinteger(L, Form1.ListBoxMenu.ItemIndex);
  if lua_pcall(L, 1, 0, 0)<>0 then
  begin
    LuaH_error_handle(L);
  end;
  lua_pop(L, 1);
end;

end.

