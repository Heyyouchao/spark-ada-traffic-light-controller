pragma SPARK_Mode (On);

package body Traffic_Control is

   ------------------------------------------------------------------
   -- Initialise the junction to a safe all-red condition
   ------------------------------------------------------------------
   procedure Init is
   begin
      Status := (Red, Red, Red);
   end Init;


   ------------------------------------------------------------------
   -- High-level cycle selector: chooses the correct sequence
   -- depending on pedestrian, main-road, or side-road demand.
   ------------------------------------------------------------------
   procedure Run_Traffic_Cycle
     (Ped      : in Boolean;
      Car_Main : in Boolean;
      Car_Side : in Boolean)
   is
   begin
      if Ped then
         Step_Ped_Start;
      end if;

      if Car_Main then
         Step_Main_Prepare;
      end if;

      if Car_Side then
         Step_Side_Prepare;
      end if;

      if (not Ped) and (not Car_Main) and (not Car_Side) then
         Step_All_Red;
      end if;
   end Run_Traffic_Cycle;


   ------------------------------------------------------------------
   -- Pedestrian sequence
   ------------------------------------------------------------------
   procedure Step_Ped_Start is
   begin
      Status := (Red, Red, Green);
   end Step_Ped_Start;

   procedure Step_Ped_End is
   begin
      Status := (Red, Red, Red);
   end Step_Ped_End;


   ------------------------------------------------------------------
   -- Main-road sequence
   ------------------------------------------------------------------
   procedure Step_Main_Prepare is
   begin
      Status := (Amber, Red, Red);
   end Step_Main_Prepare;

   procedure Step_Main_Green is
   begin
      Status := (Green, Red, Red);
   end Step_Main_Green;

   procedure Step_Main_Amber is
   begin
      Status := (Amber, Red, Red);
   end Step_Main_Amber;

   procedure Step_Main_Red is
   begin
      Status := (Red, Red, Red);
   end Step_Main_Red;


   ------------------------------------------------------------------
   -- Side-road sequence
   ------------------------------------------------------------------
   procedure Step_Side_Prepare is
   begin
      Status := (Red, Amber, Red);
   end Step_Side_Prepare;

   procedure Step_Side_Green is
   begin
      Status := (Red, Green, Red);
   end Step_Side_Green;

   procedure Step_Side_Amber is
   begin
      Status := (Red, Amber, Red);
   end Step_Side_Amber;

   procedure Step_Side_Red is
   begin
      Status := (Red, Red, Red);
   end Step_Side_Red;


   ------------------------------------------------------------------
   -- Universal all-red step used for safe fallback
   ------------------------------------------------------------------
   procedure Step_All_Red is
   begin
      Status := (Red, Red, Red);
   end Step_All_Red;

end Traffic_Control;
