pragma SPARK_Mode (On);

package body Traffic_Control is

   procedure Init is
   begin
      Status := (Red, Red, Red);
   end Init;

   procedure Apply_Pedestrian_Cycle is
   begin
      Status := (Red, Red, Red);
   end Apply_Pedestrian_Cycle;

   procedure Apply_Main_Cycle is
   begin
      Status.Main_Road := Red;
   end Apply_Main_Cycle;

   procedure Apply_Side_Cycle is
   begin
      Status.Side_Road := Red;
      Status.Main_Road := Red;
   end Apply_Side_Cycle;

   procedure Run_Traffic_Cycle
     (Ped      : in Boolean;
      Car_Main : in Boolean;
      Car_Side : in Boolean)
   is
   begin
      if Ped then
         Apply_Pedestrian_Cycle;
      end if;

      if Car_Main then
         Apply_Main_Cycle;
      end if;

      if Car_Side then
         Apply_Side_Cycle;
      end if;

      if (not Ped) and (not Car_Main) and (not Car_Side) then
         Status := (Red, Red, Red);
      end if;
   end Run_Traffic_Cycle;

end Traffic_Control;