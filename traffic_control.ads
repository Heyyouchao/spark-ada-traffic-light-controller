pragma SPARK_Mode (On);

package Traffic_Control is
   
   --  Traffic light colours.
   type Light_Color is (Red, Amber, Green);
   
   --  Full junction state.
   type Junction_State is record
      Main_Road  : Light_Color;
      Side_Road  : Light_Color;
      Pedestrian : Light_Color;
   end record;
   
   --  Global traffic-light status.
   Status : Junction_State;
   
   ------------------------------------------------------------------
   --  Safety predicate:
   --  Ensures only one direction can be green at any time and
   --  pedestrians only walk when both roads are red.
   ------------------------------------------------------------------
   function Safe (S : Junction_State) return Boolean is
     (
        (((not (S.Pedestrian = Green)) or
          (S.Main_Road = Red and S.Side_Road = Red)))
      and
        (((not (S.Main_Road = Green)) or
          (S.Side_Road = Red and S.Pedestrian = Red)))
      and
        (((not (S.Side_Road = Green)) or
          (S.Main_Road = Red and S.Pedestrian = Red)))
     );

   
   -------------------------
   --  Initialise the junction to the safe all-red state.
   -------------------------
   procedure Init
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red      and
         Status.Side_Road  = Red      and
         Status.Pedestrian = Red and
         Safe(Status);

   ------------------------------------------------------------------
   --  High-level controller: selects the correct traffic sequence
   --  based on pedestrian and vehicle requests.
   ------------------------------------------------------------------
   procedure Run_Traffic_Cycle
     (Ped      : in Boolean;
      Car_Main : in Boolean;
      Car_Side : in Boolean)
     with
       Global  => (In_Out => Status),
       Depends => (Status => (Status, Ped, Car_Main, Car_Side)),
       Pre =>
         not (Ped and Car_Main and Car_Side), -- example only
       Post => Safe(Status);

   -----------------------------------------------------------------
   --  PEDESTRIAN PHASE
   ------------------------------------------------------------------
   procedure Step_Ped_Start
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red and
         Status.Pedestrian = Green and
         Safe(Status);
           
   procedure Step_Ped_End
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red and 
         Safe(Status);

   -----------------------------------------------------------------
   --  MAIN ROAD PHASE
   ------------------------------------------------------------------
   procedure Step_Main_Prepare
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Amber and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red and 
         Safe(Status);
   
   procedure Step_Main_Green
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post => 
         Status.Main_Road = Green and
         Status.Side_Road = Red and
         Status.Pedestrian = Red and 
         Safe(Status);

   procedure Step_Main_Amber
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Amber and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red and
         Safe(Status);
         
   procedure Step_Main_Red
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red and
         Safe(Status);
   
   -----------------------------------------------------------------
   --  SIDE ROAD PHASE
   ------------------------------------------------------------------
   procedure Step_Side_Prepare
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Amber and
         Status.Pedestrian = Red and 
         Safe(Status);

   procedure Step_Side_Green
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Green and
         Status.Pedestrian = Red and
         Safe(Status);

   procedure Step_Side_Amber
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Amber and
         Status.Pedestrian = Red and
         Safe(Status);

   procedure Step_Side_Red
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red and 
         Safe(Status);
   
   ------------------------------------------------------------------
   --  All signals red (full stop state).
   ------------------------------------------------------------------
   procedure Step_All_Red
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red and
         Status.Pedestrian = Red and
         Safe(Status);


end Traffic_Control;
