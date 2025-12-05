pragma SPARK_Mode (On);

package Traffic_Control is

   type Light_Color is (Red, Amber, Green);

   type Junction_State is record
      Main_Road  : Light_Color;
      Side_Road  : Light_Color;
      Pedestrian : Light_Color;
   end record;

   Status : Junction_State;

   ----------------------------------------------------
   -- INITIALISATION
   ----------------------------------------------------
   procedure Init
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red;

   ----------------------------------------------------
   -- PEDESTRIAN CYCLE LOGIC
   ----------------------------------------------------
   procedure Apply_Pedestrian_Cycle
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red;

   ----------------------------------------------------
   -- MAIN ROAD CYCLE LOGIC
   ----------------------------------------------------
   procedure Apply_Main_Cycle
     with
       Global  => (In_Out => Status),
       Depends => (Status => Status),
       Post =>
         Status.Main_Road = Red;

   ----------------------------------------------------
   -- SIDE ROAD CYCLE LOGIC
   ----------------------------------------------------
   procedure Apply_Side_Cycle
     with
       Global  => (In_Out => Status),
       Depends => (Status => Status),
       Post =>
         Status.Side_Road = Red and
         Status.Main_Road = Red;

   ----------------------------------------------------
   -- MASTER LOGIC (ABSTRACT SAFETY)
   ----------------------------------------------------
   procedure Run_Traffic_Cycle
     (Ped      : in Boolean;
      Car_Main : in Boolean;
      Car_Side : in Boolean)
     with
       Global  => (In_Out => Status),
       Depends => (Status => (Status, Ped, Car_Main, Car_Side)),
       Pre =>
         -- Arbitrary but non-contradictory example:
         not (Ped and Car_Main and Car_Side),
       Post =>
         (Status.Main_Road  in Light_Color) and
         (Status.Side_Road  in Light_Color) and
         (Status.Pedestrian in Light_Color);

end Traffic_Control;