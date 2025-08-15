package Common is

   type Vector_2 is record
      X : Float;
      Y : Float;
   end record;

   type Rectangle is record
      X : Float;
      Y : Float;
      W : Float;
      H : Float;
   end record;

   type Suit_Type is (Clubs, Diamonds, Hearts, Spades);
   type Suit_Color_Type is (Red, Black);
   type Rank_Type is range 1 .. 13;

   function "+" (Left : Vector_2; Right : Vector_2) return Vector_2;

   function Min (Left : Float; Right : Float) return Float;

   function Is_Point_In_Bounds
     (Point : Vector_2; Bounds_Top_Left : Vector_2; Bounds_Size : Vector_2)
      return Boolean;

   function Is_Point_In_Bounds
     (Point : Vector_2; Bounds : Rectangle) return Boolean;

end Common;
