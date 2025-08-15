with Common; use Common;

package Cards is

   Width  : constant := 48.0;
   Height : constant := 64.0;

   type Card_Type is tagged record
      Position : Vector_2;
      Suit     : Suit_Type;
      Rank     : Rank_Type;
      Selected : Boolean;
   end record;

   function Create (Suit : Suit_Type; Rank : Rank_Type) return Card_Type;

   procedure Draw (Self : Card_Type);

   function Is_Sequential (Left : Card_Type; Right : Card_Type) return Boolean;

   function Is_Hit (Self : Card_Type; Point : Vector_2) return Boolean;

   overriding
   function "=" (Left : Card_Type; Right : Card_Type) return Boolean;

   Card_Default : constant Card_Type :=
     (Position => (0.0, 0.0),
      Suit     => Suit_Type'First,
      Rank     => Rank_Type'First,
      Selected => False);

end Cards;
