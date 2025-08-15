with Engine;
with Freecell_Game;

procedure Freecellada is
begin
   Engine.Init;
   Freecell_Game.Init;

   while Engine.Is_Running loop
      Freecell_Game.Update;
      Engine.Begin_Drawing;
      Freecell_Game.Draw;
      Engine.End_Drawing;
   end loop;

   Engine.Close;
end Freecellada;
