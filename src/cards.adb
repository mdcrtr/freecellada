with Atlas;
with Engine;

package body Cards is

   type Card_Color_Type is (Black, Red);

   function Create (Suit : Suit_Type; Rank : Rank_Type) return Card_Type is
   begin
      return
        (Position => (0.0, 0.0),
         Suit     => Suit,
         Rank     => Rank,
         Selected => False);
   end Create;

   procedure Draw (Self : Card_Type) is

      Suit_Region : constant Rectangle := Atlas.Suit_Atlas (Self.Suit);

      Rank_Region : constant Rectangle :=
        Atlas.Rank_Atlas (Self.Suit, Self.Rank);

      Card_Front    : Rectangle;
      Bottom_Rank_X : Float;

   begin

      if Self.Selected then
         Card_Front := Atlas.Card_Selected;
      else
         Card_Front := Atlas.Card_Front;
      end if;

      if Self.Rank = 10 then
         Bottom_Rank_X := 30.0;
      else
         Bottom_Rank_X := 32.0;
      end if;

      Engine.Draw_Sprite (Card_Front, Self.Position);
      Engine.Draw_Sprite (Suit_Region, Self.Position + Vector_2'(2.0, 2.0));
      Engine.Draw_Sprite (Rank_Region, Self.Position + Vector_2'(10.0, 2.0));
      Engine.Draw_Sprite
        (Rank_Region, Self.Position + Vector_2'(Bottom_Rank_X, 53.0));
      Engine.Draw_Sprite (Suit_Region, Self.Position + Vector_2'(40.0, 53.0));

   end Draw;

   function Get_Color (Card : Card_Type) return Card_Color_Type is
   begin
      if Card.Suit = Clubs or else Card.Suit = Spades then
         return Black;
      end if;

      return Red;
   end Get_Color;

   function Is_Sequential (Left : Card_Type; Right : Card_Type) return Boolean
   is
   begin
      return
        Get_Color (Left) /= Get_Color (Right)
        and then Integer (Left.Rank) - Integer (Right.Rank) = 1;
   end Is_Sequential;

   function Is_Hit (Self : Card_Type; Point : Vector_2) return Boolean is
   begin
      return Is_Point_In_Bounds (Point, Self.Position, (Width, Height));
   end Is_Hit;

   overriding
   function "=" (Left : Card_Type; Right : Card_Type) return Boolean is
   begin
      return Left.Suit = Right.Suit and then Left.Rank = Right.Rank;
   end "=";

end Cards;
