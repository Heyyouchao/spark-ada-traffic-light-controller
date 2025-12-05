pragma SPARK_Mode;

with AS_IO_Wrapper; use AS_IO_Wrapper;
with Traffic_Control; use Traffic_Control;

procedure Main is
   Car_Main    : Boolean;
   Car_Side    : Boolean;
   Ped_Request : Boolean;

   Buffer : String (1 .. 10);
   Len    : Natural;

   procedure Show_Step(Message : String) is
   begin
      AS_Put_Line("==== Traffic Controller ====");
      AS_Put_Line(
        "Main: " & Light_Color'Image(Status.Main_Road)
        & "  Side: " & Light_Color'Image(Status.Side_Road)
        & "  Ped: "  & Light_Color'Image(Status.Pedestrian)
      );
      AS_Put_Line(Message);
      AS_Get_Line(Buffer, Len);
   end Show_Step;

begin
   AS_Init_Standard_Output;
   AS_Init_Standard_Input;
   
   init;
   AS_Put_Line ("System starting in ALL-RED safe state...");
   AS_Put_Line ("");

   loop
      --------------------------------------------------
      -- Read Sensors
      --------------------------------------------------
      loop
         AS_Put("Car on MAIN road? (Y/N): ");
         AS_Get_Line(Buffer, Len);
         exit when Len > 0 and then Buffer(1) in 'Y' | 'y' | 'N' | 'n';
         AS_Put_Line("Please enter Y or N");
      end loop;
      Car_Main := Buffer(1) in 'Y' | 'y';

      -- SIDE
      loop
         AS_Put("Car on SIDE road? (Y/N): ");
         AS_Get_Line(Buffer, Len);
         exit when Len > 0 and then Buffer(1) in 'Y' | 'y' | 'N' | 'n';
         AS_Put_Line("Please enter Y or N");
      end loop;
      Car_Side := Buffer(1) in 'Y' | 'y';

      -- PEDESTRIAN
      loop
         AS_Put("Pedestrian pressed? (Y/N): ");
         AS_Get_Line(Buffer, Len);
         exit when Len > 0 and then Buffer(1) in 'Y' | 'y' | 'N' | 'n';
         AS_Put_Line("Please enter Y or N");
      end loop;
      Ped_Request := Buffer(1) in 'Y' | 'y';
      
      --------------------------------------------------
      -- Call SPARK Logic (important!)
      --------------------------------------------------
      Run_Traffic_Cycle(Ped_Request, Car_Main, Car_Side);

      --------------------------------------------------
      -- PEDESTRIAN SEQUENCE
      --------------------------------------------------
      if Ped_Request then
         Step_Ped_Start;
         Show_Step("Pedestrian crossing active. Press ENTER...");

         Step_Ped_End;
         Show_Step("Pedestrian phase complete. Press ENTER...");
      end if;

      --------------------------------------------------
      -- MAIN ROAD SEQUENCE
      --------------------------------------------------
      if Car_Main then
         Step_Main_Prepare;
         Show_Step("Main preparing. Press ENTER...");

         Step_Main_Green;
         Show_Step("Main traffic flowing. Press ENTER...");

         Step_Main_Amber;
         Show_Step("Main changing. Press ENTER...");

         Step_Main_Red;
         Show_Step("Main stopped. Press ENTER...");
      end if;

      --------------------------------------------------
      -- SIDE ROAD SEQUENCE
      --------------------------------------------------
      if Car_Side then
         Step_Side_Prepare;
         Show_Step("Side preparing. Press ENTER...");

         Step_Side_Green;
         Show_Step("Side traffic flowing. Press ENTER...");

         Step_Side_Amber;
         Show_Step("Side changing. Press ENTER...");

         Step_Side_Red;
         Show_Step("Side stopped. Press ENTER...");
      end if;

      --------------------------------------------------
      -- NO TRAFFIC
      --------------------------------------------------
      if (not Ped_Request) and (not Car_Main) and (not Car_Side) then
         Step_All_Red;
         AS_Put_Line("No traffic detected. All lights remain RED.");
      end if;

      --------------------------------------------------
      -- Loop Exit
      --------------------------------------------------
      AS_Put_Line("Press ENTER to continue or type X to exit:");
      AS_Get_Line(Buffer, Len);

      exit when (Len > 0) and then (Buffer(1) in 'X' | 'x');
   end loop;
end Main;