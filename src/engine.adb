with Interfaces.C; use Interfaces.C;
with Raylib;

package body Engine is

   Camera : constant Raylib.Camera2D :=
     (offset   => (0.0, 0.0),
      target   => (0.0, 0.0),
      rotation => 0.0,
      zoom     => 3.0);

   Sprite_Sheet : Raylib.Texture;

   function To_Rec (R : Rectangle) return Raylib.Rectangle with Inline is
   begin
      return (C_float (R.X), C_float (R.Y), C_float (R.W), C_float (R.H));
   end To_Rec;

   function To_Vec2 (V : Vector_2) return Raylib.Vector2 with Inline is
   begin
      return (C_float (V.X), C_float (V.Y));
   end To_Vec2;

   procedure Init is
   begin
      Raylib.InitWindow (1400, 900, "Freecell");
      Raylib.SetTargetFPS (60);
      Sprite_Sheet := Raylib.LoadTexture ("share/freecellada/cards.png");
   end Init;

   procedure Close is
   begin
      Raylib.UnloadTexture (Sprite_Sheet);
      Raylib.CloseWindow;
   end Close;

   function Is_Running return Boolean is
   begin
      return not Boolean (Raylib.WindowShouldClose);
   end Is_Running;

   procedure Begin_Drawing is
   begin
      Raylib.BeginDrawing;
      Raylib.ClearBackground (Raylib.BLACK);
      Raylib.BeginMode2D (Camera);
   end Begin_Drawing;

   procedure End_Drawing is
   begin
      Raylib.EndMode2D;
      Raylib.EndDrawing;
   end End_Drawing;

   procedure Draw_Sprite (Source : Rectangle; Position : Vector_2) is
   begin
      Raylib.DrawTextureRec
        (texture_p => Sprite_Sheet,
         source    => To_Rec (Source),
         position  => To_Vec2 (Position),
         tint      => Raylib.WHITE);
   end Draw_Sprite;

end Engine;
