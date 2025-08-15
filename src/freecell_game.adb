with Cards;
with Common; use Common;

package body Freecell_Game is

   function Create_Deck return Card_Containers.Card_Vecs.Vector is
      Deck : Card_Containers.Card_Vecs.Vector;
   begin
      for Suit in Suit_Type loop
         for Rank in Rank_Type loop
            Deck.Append (Cards.Create (Suit, Rank));
         end loop;
      end loop;
      return Deck;
   end Create_Deck;

   procedure Shuffle_Deck (Deck : in out Card_Containers.Card_Vecs.Vector) is
   begin
      null;
   end Shuffle_Deck;

   procedure Update_Layout (Self : in out Game_Type) is
   begin
      for C of Self.Container_List loop
         C.Layout;
      end loop;
   end Update_Layout;

   procedure Init (Self : out Game_Type) is
      package CC renames Card_Containers;

      Deck : CC.Card_Vecs.Vector;
      J    : Container_Index_Type;
   begin
      Deck := Create_Deck;
      Shuffle_Deck (Deck);

      Self.State := Picking;
      Self.Container_List :=
        (0  => CC.Create (0, CC.Slide, (10.0, 80.0)),
         1  => CC.Create (1, CC.Slide, (64.0, 80.0)),
         2  => CC.Create (2, CC.Slide, (114.0, 80.0)),
         3  => CC.Create (3, CC.Slide, (166.0, 80.0)),
         4  => CC.Create (4, CC.Slide, (218.0, 80.0)),
         5  => CC.Create (5, CC.Slide, (270.0, 80.0)),
         6  => CC.Create (6, CC.Slide, (322.0, 80.0)),
         7  => CC.Create (7, CC.Slide, (374.0, 80.0)),
         8  => CC.Create (8, CC.Slot, (10.0, 10.0)),
         9  => CC.Create (9, CC.Slot, (62.0, 10.0)),
         10 => CC.Create (10, CC.Slot, (114.0, 10.0)),
         11 => CC.Create (11, CC.Slot, (166.0, 10.0)),
         12 => CC.Create (12, CC.Stack, (218.0, 10.0)),
         13 => CC.Create (13, CC.Stack, (270.0, 10.0)),
         14 => CC.Create (14, CC.Stack, (322.0, 10.0)),
         15 => CC.Create (15, CC.Stack, (374.0, 10.0)));

      for I in Natural range 0 .. Deck.Last_Index loop
         J := Container_Index_Type (I rem 8);
         Self.Container_List (J).Push (Deck (I));
      end loop;
   end Init;

   procedure Update (Self : in out Game_Type) is
   begin
      Update_Layout (Self);
   end Update;

   procedure Draw (Self : Game_Type) is
   begin
      for C of Self.Container_List loop
         C.Draw;
      end loop;
   end Draw;

end Freecell_Game;
