pragma SPARK_Mode (On);

with AS_IO_Wrapper;          use AS_IO_Wrapper;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Traffic_Control;        use Traffic_Control;

procedure Main is
   Car_Main  : Boolean := False;
   Car_Side  : Boolean := False;
   Ped       : Boolean := False;

   Buf : String (1 .. 10);
   Len : Natural;
begin
   AS_Init_Standard_Input;
   AS_Init_Standard_Output;

   AS_Put_Line ("System starting in ALL-RED safe state...");
   AS_Put_Line ("");

   loop
      Read_Sensors (Car_Main, Car_Side, Ped);

   if Ped then
      Pedestrian_Cycle;
      Main_Cycle;
      Side_Cycle;

   elsif Car_Main then
      Main_Cycle;
      if Car_Side then
         Side_Cycle;
      end if;

   elsif Car_Side then
      Side_Cycle;

   else
      -- No cars, no pedestrians → just show all-red
      Show_State((Main_Road => Red,
                  Side_Road => Red,
                  Pedestrian => Red));
      AS_Put_Line("No cars or pedestrians. System stays all red.");
   end if;

      AS_Put_Line ("Press ENTER to continue or type X to exit:");
      AS_Get_Line (Buf, Len);

      if Len = 1 and then To_Upper(Buf(1)) = 'X' then
         exit;
      end if;
   end loop;

   AS_Put_Line ("System shutting down safely...");
end Main;