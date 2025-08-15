with Cards;
with Card_Containers;
with Common; use Common;

package body Freecell_Game is

   Slide : Card_Containers.Container_Type;

   procedure Init is
      Card_List : Card_Containers.CV.Vector;
   begin
      Slide := Card_Containers.Create (0, Card_Containers.Slide, (20.0, 40.0));
      Card_List.Append (Cards.Create (Clubs, 2));
      Card_List.Append (Cards.Create (Hearts, 10));
      Slide.Push (Card_List);
   end Init;

   procedure Update is
   begin
      Slide.Layout;
   end Update;

   procedure Draw is
   begin
      Slide.Draw;
   end Draw;

end Freecell_Game;
