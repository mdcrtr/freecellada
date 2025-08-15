with Engine;
with Freecell_Game;

procedure Freecellada is
   Game : Freecell_Game.Game_Type;
begin
   Engine.Init;
   Freecell_Game.Init (Game);

   while Engine.Is_Running loop
      Freecell_Game.Update (Game);
      Engine.Begin_Drawing;
      Freecell_Game.Draw (Game);
      Engine.End_Drawing;
   end loop;

   Engine.Close;
end Freecellada;
