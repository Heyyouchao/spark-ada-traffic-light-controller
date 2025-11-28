pragma SPARK_Mode (On);

package Traffic_Control is

   type Light_Color is (Red, Amber, Green);

   type Junction_State is record
      Main_Road  : Light_Color;
      Side_Road  : Light_Color;
      Pedestrian : Light_Color;
   end record;

   function To_String (C : Light_Color) return String
     with
       Global  => null,
       Depends => (To_String'Result => C);

   function Safe (S : Junction_State) return Boolean
     with
       Global  => null,
       Depends => (Safe'Result => S);

   procedure Next_State
     (Current       : in     Junction_State;
      Car_Main      : in     Boolean;
      Car_Side      : in     Boolean;
      Ped_Request   : in     Boolean;
      Ped_Locked    : in     Boolean;
      Next          :    out Junction_State;
      Next_Ped_Lock :    out Boolean)
   with
     Global  => null,
     Depends =>
       (Next          => (Current, Car_Main, Car_Side, Ped_Request, Ped_Locked),
        Next_Ped_Lock => (Current, Car_Main, Car_Side, Ped_Request, Ped_Locked)),
     Pre  => Safe(Current),
     Post => Safe(Next);

end Traffic_Control;