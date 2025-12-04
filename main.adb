pragma SPARK_Mode (On);

with AS_IO_Wrapper;  use AS_IO_Wrapper;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Traffic_Control; use Traffic_Control;

procedure Main is
   Stop        : Boolean := False;
   Car_Main    : Boolean := False;
   Car_Side    : Boolean := False;
   Ped_Request : Boolean := False;

   Buf : String (1 .. 10);
   Len : Natural;
begin
   AS_Init_Standard_Input;
   AS_Init_Standard_Output;

   Init;

   loop
      Read_Sensors(Car_Main, Car_Side, Ped_Request);

      Run_Traffic_Cycle(Ped_Request, Car_Main, Car_Side);

      AS_Put_Line("Press ENTER to continue or type X to exit:");
      AS_Get_Line(Buf, Len);

      if Len = 1 and then To_Upper(Buf(1)) = 'X' then
         exit;
      end if;
   end loop;

   AS_Put_Line("System shutting down safely...");
end Main;