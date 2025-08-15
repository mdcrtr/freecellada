with Ada.Containers.Vectors;
with Cards;
with Common; use Common;

package Card_Containers is

   package Card_Vecs is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Cards.Card_Type,
        "="          => Cards."=");

   Slide_Height : constant := 200.0;
   Slide_Step   : constant := 16.0;

   type ID_Type is range 0 .. 15;

   type Kind_Type is (Slot, Slide, Stack);

   type Container_Type is tagged record
      ID        : ID_Type;
      Kind      : Kind_Type;
      Card_List : Card_Vecs.Vector;
      Position  : Vector_2;
      Dirty     : Boolean;
   end record;

   function Create
     (ID : ID_Type; Kind : Kind_Type; Position : Vector_2)
      return Container_Type;

   procedure Pop (Self : in out Container_Type; Count : Positive);

   procedure Push (Self : in out Container_Type; Card : Cards.Card_Type);

   procedure Push (Self : in out Container_Type; Card_List : Card_Vecs.Vector);

   function Peek
     (Self : Container_Type; Count : Positive) return Card_Vecs.Vector;

   procedure Peek_Top
     (Self : Container_Type; Card : out Cards.Card_Type; OK : out Boolean);

   function Count_From (Self : Container_Type; Index : Natural) return Natural;

   procedure Card_At
     (Self  : Container_Type;
      Point : Vector_2;
      Index : out Natural;
      OK    : out Boolean);

   function Can_Pop (Self : Container_Type; Count : Positive) return Boolean;

   function Can_Push
     (Self : Container_Type; Card_List : Card_Vecs.Vector) return Boolean;

   function Is_Hit (Self : Container_Type; Point : Vector_2) return Boolean;

   procedure Layout (Self : in out Container_Type);

   procedure Draw (Self : Container_Type);

end Card_Containers;
