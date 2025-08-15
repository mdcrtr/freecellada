with Ada.Containers;
with Atlas;
with Engine;

use type Ada.Containers.Count_Type;

package body Card_Containers is

   function Is_Alternating_Sequence
     (Card_List : Card_Vecs.Vector) return Boolean is
   begin
      if Card_List.Length < 2 then
         return False;
      end if;

      for I in Natural range 0 .. Card_List.Last_Index - 1 loop
         if not Cards.Is_Sequential (Card_List (I), Card_List (I + 1)) then
            return False;
         end if;
      end loop;

      return True;
   end Is_Alternating_Sequence;

   function Get_Bounds (Self : Container_Type) return Rectangle is
      Height : Float;
   begin
      if Self.Kind = Slide then
         Height := Slide_Height;
      else
         Height := Cards.Height;
      end if;

      return (Self.Position.X, Self.Position.Y, Cards.Width, Height);
   end Get_Bounds;

   function Create
     (ID : ID_Type; Kind : Kind_Type; Position : Vector_2)
      return Container_Type is
   begin
      return
        (ID        => ID,
         Kind      => Kind,
         Card_List => Card_Vecs.Empty_Vector,
         Position  => Position,
         Dirty     => False);
   end Create;

   procedure Pop (Self : in out Container_Type; Count : Positive) is
   begin
      Self.Card_List.Delete_Last (Ada.Containers.Count_Type (Count));
      Self.Dirty := True;
   end Pop;

   procedure Push (Self : in out Container_Type; Card : Cards.Card_Type) is
   begin
      Self.Card_List.Append (Card);
      Self.Dirty := True;
   end Push;

   procedure Push (Self : in out Container_Type; Card_List : Card_Vecs.Vector)
   is
   begin
      for Card of Card_List loop
         Self.Card_List.Append (Card);
      end loop;
      Self.Dirty := True;
   end Push;

   function Peek
     (Self : Container_Type; Count : Positive) return Card_Vecs.Vector
   is
      Card_List : Card_Vecs.Vector;
      First     : Natural;
   begin
      if Self.Card_List.Length >= Ada.Containers.Count_Type (Count) then
         First := Self.Card_List.Last_Index - (Natural (Count) - 1);
      else
         First := Self.Card_List.First_Index;
      end if;

      for I in Natural range First .. Self.Card_List.Last_Index loop
         Card_List.Append (Self.Card_List (I));
      end loop;

      return Card_List;
   end Peek;

   procedure Peek_Top
     (Self : Container_Type; Card : out Cards.Card_Type; OK : out Boolean) is
   begin
      if Self.Card_List.Is_Empty then
         Card := Cards.Card_Default;
         OK := False;
      else
         Card := Self.Card_List.Last_Element;
         OK := True;
      end if;
   end Peek_Top;

   function Count_From (Self : Container_Type; Index : Natural) return Natural
   is
   begin
      if Natural (Self.Card_List.Length) <= Index then
         return 0;
      end if;
      return Natural (Self.Card_List.Length) - Index;
   end Count_From;

   procedure Card_At
     (Self  : Container_Type;
      Point : Vector_2;
      Index : out Natural;
      OK    : out Boolean) is
   begin
      Index := 0;
      OK := False;

      if Self.Kind = Slide then
         for I in reverse
           Natural
             range Self.Card_List.First_Index .. Self.Card_List.Last_Index
         loop
            if Self.Card_List (I).Is_Hit (Point) then
               Index := I;
               OK := True;
               exit;
            end if;
         end loop;

      elsif not Self.Card_List.Is_Empty
        and then Self.Card_List.Last_Element.Is_Hit (Point)
      then
         Index := Self.Card_List.Last_Index;
         OK := True;
      end if;
   end Card_At;

   function Can_Pop (Self : Container_Type; Count : Positive) return Boolean is
      Card_List : Card_Vecs.Vector;
   begin
      case Self.Kind is
         when Slide =>
            Card_List := Peek (Self, Count);
            return
              Card_List.Length = 1 or else Is_Alternating_Sequence (Card_List);

         when Slot | Stack =>
            return Count = 1 and then Self.Card_List.Length > 0;
      end case;
   end Can_Pop;

   function Can_Push
     (Self : Container_Type; Card_List : Card_Vecs.Vector) return Boolean
   is
      Top_Card        : Cards.Card_Type;
      Top_Card_Exists : Boolean;
   begin
      if Card_List.Length = 0 then
         return False;
      end if;

      Peek_Top (Self, Top_Card, Top_Card_Exists);

      case Self.Kind is
         when Slide =>
            if not Top_Card_Exists then
               return True;
            end if;
            return Cards.Is_Sequential (Top_Card, Card_List.First_Element);

         when Slot =>
            return Self.Card_List.Is_Empty and then Card_List.Length = 1;

         when Stack =>
            if not Top_Card_Exists then
               return
                 Card_List.Length = 1
                 and then Card_List.First_Element.Rank = 1;
            end if;

            return
              Top_Card.Suit = Card_List.First_Element.Suit
              and then Integer (Card_List.First_Element.Rank)
                       - Integer (Top_Card.Rank)
                       = 1;
      end case;
   end Can_Push;

   function Is_Hit (Self : Container_Type; Point : Vector_2) return Boolean is
   begin
      return Is_Point_In_Bounds (Point, Get_Bounds (Self));
   end Is_Hit;

   procedure Layout (Self : in out Container_Type) is
      Step : Float;
      Y    : Float;
   begin
      if not Self.Dirty then
         return;
      end if;

      Self.Dirty := False;

      if Self.Card_List.Is_Empty then
         return;
      end if;

      if Self.Kind = Slide then
         Step :=
           Min
             (Float (Slide_Height - Cards.Height)
              / Float (Self.Card_List.Length),
              Float (Slide_Step));

         Y := Self.Position.Y;

         for C of Self.Card_List loop
            C.Position := (Self.Position.X, Y);
            Y := Y + Step;
         end loop;

      else

         for C of Self.Card_List loop
            C.Position := Self.Position;
         end loop;

      end if;
   end Layout;

   procedure Draw (Self : Container_Type) is
   begin
      Engine.Draw_Sprite (Atlas.Card_Border, Self.Position);

      if Self.Kind = Slide then
         for C of Self.Card_List loop
            C.Draw;
         end loop;
      elsif Self.Card_List.Length > 0 then
         Self.Card_List.Last_Element.Draw;
      end if;
   end Draw;

end Card_Containers;
