with Ada.Containers.Vectors;
with Card_Containers;

package Freecell_Game is

   subtype Container_Index_Type is Card_Containers.ID_Type;
   type Container_List_Type is
     array (Container_Index_Type) of Card_Containers.Container_Type;

   type Command_Type is record
      Src_Container_ID : Container_Index_Type;
      Dst_Container_ID : Container_Index_Type;
      Card_Count       : Positive;
   end record;

   package Command_Vecs is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Command_Type);

   type Game_State_Type is (Picking, Putting);

   type Game_Type is tagged record
      Container_List   : Container_List_Type;
      Command_Stack    : Command_Vecs.Vector;
      State            : Game_State_Type;
      Src_Container_ID : Container_Index_Type;
      Src_Card_Count   : Positive;
   end record;

   procedure Init (Self : out Game_Type);
   procedure Update (Self : in out Game_Type);
   procedure Draw (Self : Game_Type);

end Freecell_Game;
