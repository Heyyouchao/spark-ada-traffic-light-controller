pragma SPARK_Mode (On);

package Traffic_Control is
   type Light_Color is (Red, Amber, Green);

   type Junction_State is record
      Main_Road  : Light_Color;
      Side_Road  : Light_Color;
      Pedestrian : Light_Color;
   end record;

   procedure Show_State (S : Junction_State)
     with Global => null;

   procedure Read_Sensors
     (Car_Main  : out Boolean;
      Car_Side  : out Boolean;
      Ped_Press : out Boolean)
     with
       Global  => null,
       Depends => ((Car_Main, Car_Side, Ped_Press) => null);

   procedure Pedestrian_Cycle
     with Global => null;

   procedure Main_Cycle
     with Global => null;

   procedure Side_Cycle
     with Global => null;

end Traffic_Control;