with Common; use Common;

package Engine is

   procedure Init;
   procedure Close;

   function Is_Running return Boolean;

   procedure Begin_Drawing;
   procedure End_Drawing;

   procedure Draw_Sprite (Source : Rectangle; Position : Vector_2);

end Engine;
