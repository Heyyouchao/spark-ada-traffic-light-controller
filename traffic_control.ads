pragma SPARK_Mode (On);

with AS_IO_Wrapper;

package Traffic_Control is

   type Light_Color is (Red, Amber, Green);

   type Junction_State is record
      Main_Road  : Light_Color;
      Side_Road  : Light_Color;
      Pedestrian : Light_Color;
   end record;

   Status : Junction_State;

   -- Initialise to safe ALL-RED state
   procedure Init
     with Depends => (Status => null);

   -- Read sensors (I/O is not checked by SPARK)
   procedure Read_Sensors
     (Car_Main : out Boolean;
      Car_Side : out Boolean;
      Ped      : out Boolean);

   -- Cycles
   procedure Pedestrian_Cycle;

   procedure Main_Cycle;

   procedure Side_Cycle;

   -- Master cycle
   procedure Run_Traffic_Cycle
     (Ped      : in Boolean;
      Car_Main : in Boolean;
      Car_Side : in Boolean)
     with Depends =>
       (Status => (Status, Ped, Car_Main, Car_Side));

end Traffic_Control;