pragma SPARK_Mode (On);

package Traffic_Control is

   -------------------------
   -- Types and State
   -------------------------
   type Light_Color is (Red, Amber, Green);

   type Junction_State is record
      Main_Road  : Light_Color;
      Side_Road  : Light_Color;
      Pedestrian : Light_Color;
   end record;

   Status : Junction_State;
   --  SAFETY INVARIANT:
   --  Only one traffic direction may be green at any time.
   --  Pedestrians may only walk when all roads are red.

   pragma Annotate
   (GNATprove, Invariant,
      ((not (Status.Pedestrian = Green)) or
         (Status.Main_Road = Red and Status.Side_Road = Red))
      and
      ((not (Status.Main_Road = Green)) or
         (Status.Side_Road = Red and Status.Pedestrian = Red))
      and
      ((not (Status.Side_Road = Green)) or
         (Status.Main_Road = Red and Status.Pedestrian = Red)));

   -------------------------
   -- INITIALISATION
   -------------------------
   procedure Init
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red      and
         Status.Side_Road  = Red      and
         Status.Pedestrian = Red;

   -------------------------
   -- MAIN HIGH LEVEL LOGIC
   -------------------------
   procedure Run_Traffic_Cycle
     (Ped      : in Boolean;
      Car_Main : in Boolean;
      Car_Side : in Boolean)
     with
       Global  => (In_Out => Status),
       Depends => (Status => (Status, Ped, Car_Main, Car_Side)),
       Pre =>
         not (Ped and Car_Main and Car_Side), -- example only
       Post =>
         ((not (Status.Pedestrian = Green)) or
            (Status.Main_Road = Red and Status.Side_Road = Red)) and

         ((not (Status.Main_Road = Green)) or
            (Status.Side_Road = Red and Status.Pedestrian = Red)) and

         ((not (Status.Side_Road = Green)) or
            (Status.Main_Road = Red and Status.Pedestrian = Red));
   -------------------------
   -- STEP PROCEDURES
   -- (YOU MUST FILL IN THE ACTUAL POSTCONDITIONS)
   -------------------------

   procedure Step_Ped_Start
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red   and
         Status.Pedestrian = Green;

   procedure Step_Ped_End
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red   and
         Status.Pedestrian = Red;

   procedure Step_Main_Prepare
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Amber and
         Status.Side_Road  = Red   and
         Status.Pedestrian = Red;

   procedure Step_Main_Green
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post => 
         Status.Main_Road = Green and
         Status.Side_Road = Red and
         Status.Pedestrian = Red;

   procedure Step_Main_Amber
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Amber and
         Status.Side_Road  = Red   and
         Status.Pedestrian = Red;

   procedure Step_Main_Red
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red   and
         Status.Pedestrian = Red;

   procedure Step_Side_Prepare
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Amber   and
         Status.Pedestrian = Red;

   procedure Step_Side_Green
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Green   and
         Status.Pedestrian = Red;

   procedure Step_Side_Amber
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Amber   and
         Status.Pedestrian = Red;

   procedure Step_Side_Red
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red   and
         Status.Pedestrian = Red;
   
   procedure Step_All_Red
     with
       Global  => (Output => Status),
       Depends => (Status => null),
       Post =>
         Status.Main_Road  = Red and
         Status.Side_Road  = Red   and
         Status.Pedestrian = Red;

end Traffic_Control;