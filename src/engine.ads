with Common; use Common;

package Engine is

   procedure Init;
   procedure Close;

   function Is_Running return Boolean;
   function Is_Mouse_Pressed return Boolean;
   function Is_Undo_Key_Pressed return Boolean;
   function Get_Mouse_World_Coords return Vector_2;

   procedure Begin_Drawing;
   procedure End_Drawing;

   procedure Draw_Sprite (Source : Rectangle; Position : Vector_2);

end Engine;
