with Ada.Numerics.Discrete_Random;
with Cards;
with Common; use Common;
with Engine;

package body Freecell_Game is

   package Natural_Random is new Ada.Numerics.Discrete_Random (Natural);

   subtype Slide_Index_Type is Container_Index_Type range 0 .. 7;
   subtype Slot_Index_Type is Container_Index_Type range 8 .. 11;
   subtype Stack_Index_Type is Container_Index_Type range 12 .. 15;

   RNG : Natural_Random.Generator;

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
      Temp : Cards.Card_Type;
      J    : Natural;
      K    : Natural;
   begin
      for I in Natural range 0 .. 100 loop
         J := Natural_Random.Random (RNG, 0, Deck.Last_Index);
         K := Natural_Random.Random (RNG, 0, Deck.Last_Index);
         Temp := Deck (J);
         Deck (J) := Deck (K);
         Deck (K) := Temp;
      end loop;
   end Shuffle_Deck;

   procedure Pick_Container
     (Self  : Game_Type;
      Point : Vector_2;
      ID    : out Container_Index_Type;
      OK    : out Boolean) is
   begin
      ID := Container_Index_Type'First;
      OK := False;

      for C of Self.Container_List loop
         if C.Is_Hit (Point) then
            ID := C.ID;
            OK := True;
            exit;
         end if;
      end loop;
   end Pick_Container;

   procedure Pick_Card (Self : in out Game_Type) is
      Mouse_World_Pos : Vector_2;
      Container_ID    : Container_Index_Type;
      Card_Index      : Natural;
      Container_ID_OK : Boolean;
      Card_OK         : Boolean;
      Card_Count      : Natural;
      Selected_Cards  : Card_Containers.Card_Vecs.Vector;
   begin
      Mouse_World_Pos := Engine.Get_Mouse_World_Coords;

      Pick_Container (Self, Mouse_World_Pos, Container_ID, Container_ID_OK);
      if not Container_ID_OK then
         return;
      end if;

      Self.Container_List (Container_ID).Card_At
        (Mouse_World_Pos, Card_Index, Card_OK);

      if not Card_OK then
         return;
      end if;

      Card_Count := Self.Container_List (Container_ID).Count_From (Card_Index);

      if not Self.Container_List (Container_ID).Can_Pop (Card_Count) then
         return;
      end if;

      for I in Natural range Card_Index .. Card_Index + Card_Count - 1 loop
         Self.Container_List (Container_ID).Card_List (I).Selected := True;
      end loop;

      Self.Src_Container_ID := Container_ID;
      Self.Src_Card_Count := Card_Count;
      Self.State := Putting;
   end Pick_Card;

   procedure Do_Command (Self : in out Game_Type; Command : Command_Type) is
      Selected_Cards : Card_Containers.Card_Vecs.Vector;
   begin
      Self.Command_Stack.Append (Command);
      Selected_Cards :=
        Self.Container_List (Command.Src_Container_ID).Peek
          (Command.Card_Count);

      Self.Container_List (Command.Dst_Container_ID).Push (Selected_Cards);
      Self.Container_List (Command.Src_Container_ID).Pop (Command.Card_Count);
   end Do_Command;

   procedure Undo_Command (Self : in out Game_Type) is
      Command        : Command_Type;
      Selected_Cards : Card_Containers.Card_Vecs.Vector;
   begin
      if Self.Command_Stack.Is_Empty then
         return;
      end if;

      Command := Self.Command_Stack.Last_Element;
      Self.Command_Stack.Delete_Last (1);

      Selected_Cards :=
        Self.Container_List (Command.Dst_Container_ID).Peek
          (Command.Card_Count);

      Self.Container_List (Command.Src_Container_ID).Push (Selected_Cards);
      Self.Container_List (Command.Dst_Container_ID).Pop (Command.Card_Count);
   end Undo_Command;

   procedure Drop_Card (Self : in out Game_Type) is
      Src_ID : constant Container_Index_Type := Self.Src_Container_ID;

      Mouse_World_Pos : Vector_2;
      Selected_Cards  : Card_Containers.Card_Vecs.Vector;
      Dst_ID          : Container_Index_Type;
      Dst_OK          : Boolean;
   begin
      Mouse_World_Pos := Engine.Get_Mouse_World_Coords;

      for C of Self.Container_List (Self.Src_Container_ID).Card_List loop
         C.Selected := False;
      end loop;

      Selected_Cards :=
        Self.Container_List (Src_ID).Peek (Self.Src_Card_Count);

      for C of Selected_Cards loop
         C.Selected := False;
      end loop;

      Pick_Container (Self, Mouse_World_Pos, Dst_ID, Dst_OK);
      if not Dst_OK then
         return;
      end if;

      if not Self.Container_List (Dst_ID).Can_Push (Selected_Cards) then
         return;
      end if;

      Do_Command
        (Self,
         (Src_Container_ID => Self.Src_Container_ID,
          Dst_Container_ID => Dst_ID,
          Card_Count       => Self.Src_Card_Count));
   end Drop_Card;

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
      Natural_Random.Reset (RNG);
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
         J := Slide_Index_Type (I rem 8);
         Self.Container_List (J).Push (Deck (I));
      end loop;

      Update_Layout (Self);
   end Init;

   procedure Update (Self : in out Game_Type) is
   begin
      if Engine.Is_Undo_Key_Pressed then
         Undo_Command (Self);
         Self.State := Picking;
      end if;

      case Self.State is
         when Picking =>
            if Engine.Is_Mouse_Pressed then
               Pick_Card (Self);
            end if;

         when Putting =>
            if Engine.Is_Mouse_Pressed then
               Drop_Card (Self);
               Self.State := Picking;
            end if;
      end case;

      Update_Layout (Self);
   end Update;

   procedure Draw (Self : Game_Type) is
   begin
      for C of Self.Container_List loop
         C.Draw;
      end loop;
   end Draw;

end Freecell_Game;
