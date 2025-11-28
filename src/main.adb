pragma SPARK_Mode (On);

with AS_IO_Wrapper;           use AS_IO_Wrapper;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Traffic_Control;         use Traffic_Control;

procedure Main is

   --------------------------------------------------------------------
   -- Helper procedures
   --------------------------------------------------------------------

   procedure Show_State (S : Junction_State) is
   begin
      AS_Put_Line ("==== Traffic Controller ====");
      AS_Put_Line ("Main Road   : " & To_String(S.Main_Road));
      AS_Put_Line ("Side Road   : " & To_String(S.Side_Road));
      AS_Put_Line ("Pedestrian  : " & To_String(S.Pedestrian));
      AS_Put_Line ("");
   end Show_State;


   procedure Ask_Exit (Stop : out Boolean) is
      Line : String (1 .. 10);
      Len  : Natural;
   begin
      AS_Put_Line ("Press ENTER to continue or type X to exit...");
      AS_Get_Line (Line, Len);

      if Len = 1 and then To_Upper(Line(1)) = 'X' then
         Stop := True;
      else
         Stop := False;
      end if;
   end Ask_Exit;


   procedure Get_Sensors
     (CarM, CarS, Ped : out Boolean)
   is
      Input     : String (1 .. 5);
      Input_Len : Natural;
   begin
      -- MAIN ROAD SENSOR
      loop
         AS_Put_Line ("Car on MAIN road? (Y/N): ");
         AS_Get_Line (Input, Input_Len);
         exit when To_Upper(Input(1)) in 'Y'|'N';
      end loop;
      CarM := (To_Upper(Input(1)) = 'Y');

      -- SIDE ROAD SENSOR
      loop
         AS_Put_Line ("Car on SIDE road? (Y/N): ");
         AS_Get_Line (Input, Input_Len);
         exit when To_Upper(Input(1)) in 'Y'|'N';
      end loop;
      CarS := (To_Upper(Input(1)) = 'Y');

      -- PEDESTRIAN BUTTON
      loop
         AS_Put_Line ("Pedestrian pressed? (Y/N): ");
         AS_Get_Line (Input, Input_Len);
         exit when To_Upper(Input(1)) in 'Y'|'N';
      end loop;
      Ped := (To_Upper(Input(1)) = 'Y');
   end Get_Sensors;


   --------------------------------------------------------------------
   -- Main program variables
   --------------------------------------------------------------------

   Car_Main      : Boolean := False;
   Car_Side      : Boolean := False;
   Ped_Request   : Boolean := False;

   Ped_Locked    : Boolean := False;

   Current, Next : Junction_State;
   Next_Ped_Lock : Boolean;

begin
   AS_Init_Standard_Output;
   AS_Init_Standard_Input;

   -- Start system on Main Green
   Current := (Main_Road  => Green,
               Side_Road  => Red,
               Pedestrian => Red);

   --------------------------------------------------------------------
   -- MAIN PROGRAM LOOP
   --------------------------------------------------------------------
   loop
      declare
         Stop : Boolean;
      begin
         -------------------------------------------------------------
         -- 1. SHOW CURRENT STATE
         -------------------------------------------------------------
         Show_State(Current);

         -------------------------------------------------------------
         -- 2. ASK IF USER WANTS TO EXIT
         -------------------------------------------------------------
         Ask_Exit(Stop);
         if Stop then
            AS_Put_Line("System shutting down safely...");
            return;
         end if;

         -------------------------------------------------------------
         -- 3. GET USER SENSOR INPUTS
         -------------------------------------------------------------
         Get_Sensors(Car_Main, Car_Side, Ped_Request);

         -------------------------------------------------------------
         -- 4. COMPUTE NEXT STATE
         -------------------------------------------------------------
         Next_State
           (Current       => Current,
            Car_Main      => Car_Main,
            Car_Side      => Car_Side,
            Ped_Request   => Ped_Request,
            Ped_Locked    => Ped_Locked,
            Next          => Next,
            Next_Ped_Lock => Next_Ped_Lock);

         -------------------------------------------------------------
         -- 5. UPDATE STATE AND LOCK
         -------------------------------------------------------------
         Current    := Next;
         Ped_Locked := Next_Ped_Lock;

      end;
   end loop;

end Main;