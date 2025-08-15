package body Common is

   function "+" (Left : Vector_2; Right : Vector_2) return Vector_2 is
   begin
      return (Left.X + Right.X, Left.Y + Right.Y);
   end "+";

   function Min (Left : Float; Right : Float) return Float is
   begin
      if Left < Right then
         return Left;
      end if;
      return Right;
   end Min;

   function Is_Point_In_Bounds
     (Point : Vector_2; Bounds_Top_Left : Vector_2; Bounds_Size : Vector_2)
      return Boolean is
   begin
      return
        Point.X >= Bounds_Top_Left.X
        and then Point.X < (Bounds_Top_Left.X + Bounds_Size.X)
        and then Point.Y >= Bounds_Top_Left.Y
        and then Point.Y < (Bounds_Top_Left.Y + Bounds_Size.Y);
   end Is_Point_In_Bounds;

   function Is_Point_In_Bounds
     (Point : Vector_2; Bounds : Rectangle) return Boolean is
   begin
      return
        Point.X >= Bounds.X
        and then Point.X < (Bounds.X + Bounds.W)
        and then Point.Y >= Bounds.Y
        and then Point.Y < (Bounds.Y + Bounds.H);
   end Is_Point_In_Bounds;

end Common;
