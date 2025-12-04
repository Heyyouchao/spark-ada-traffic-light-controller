pragma SPARK_Mode (On);

with AS_IO_Wrapper;             use AS_IO_Wrapper;
with Ada.Characters.Handling;   use Ada.Characters.Handling;

package body Traffic_Control is

   ---------------------------------------------------------
   -- PRINT A FULL STATE BLOCK
   ---------------------------------------------------------
   procedure Show_State (S : Junction_State) is
   begin
      AS_Put_Line ("==== Traffic Controller ====");
      AS_Put_Line ("Main Road   : " & Light_Color'Image(S.Main_Road));
      AS_Put_Line ("Side Road   : " & Light_Color'Image(S.Side_Road));
      AS_Put_Line ("Pedestrian  : " & Light_Color'Image(S.Pedestrian));
      AS_Put_Line ("");
   end Show_State;


   ---------------------------------------------------------
   -- GET SENSOR INPUTS (Y/N)
   ---------------------------------------------------------
   procedure Read_Sensors
     (Car_Main  : out Boolean;
      Car_Side  : out Boolean;
      Ped_Press : out Boolean)
   is
      Buf : String (1 .. 10);
      Len : Natural;
   begin
      -- MAIN CAR SENSOR
      loop
         AS_Put_Line ("Car on MAIN road? (Y/N): ");
         AS_Get_Line (Buf, Len);
         exit when To_Upper (Buf(1)) in 'Y' | 'N';
      end loop;
      Car_Main := (To_Upper (Buf(1)) = 'Y');

      -- SIDE CAR SENSOR
      loop
         AS_Put_Line ("Car on SIDE road? (Y/N): ");
         AS_Get_Line (Buf, Len);
         exit when To_Upper (Buf(1)) in 'Y' | 'N';
      end loop;
      Car_Side := (To_Upper (Buf(1)) = 'Y');

      -- PEDESTRIAN BUTTON
      loop
         AS_Put_Line ("Pedestrian pressed? (Y/N): ");
         AS_Get_Line (Buf, Len);
         exit when To_Upper (Buf(1)) in 'Y' | 'N';
      end loop;
      Ped_Press := (To_Upper (Buf(1)) = 'Y');
   end Read_Sensors;


   ---------------------------------------------------------
   -- PEDESTRIAN CYCLE: Red → Green → Red
   -- (Main and Side stay Red while pedestrians cross)
   ---------------------------------------------------------
   procedure Pedestrian_Cycle is
      State : Junction_State :=
        (Main_Road  => Red,
         Side_Road  => Red,
         Pedestrian => Red);

      Buf : String (1 .. 10);
      Len : Natural;
   begin
      -- Ped GREEN
      State.Pedestrian := Green;
      Show_State (State);
      AS_Put_Line ("Pedestrians may cross. Press ENTER to finish crossing...");
      AS_Get_Line (Buf, Len);

      -- Ped RED
      State.Pedestrian := Red;
      Show_State (State);
      AS_Put_Line ("Pedestrian phase complete. Press ENTER to continue...");
      AS_Get_Line (Buf, Len);
   end Pedestrian_Cycle;


   ---------------------------------------------------------
   -- MAIN ROAD CYCLE: Amber → Green → Amber → Red
   ---------------------------------------------------------
   procedure Main_Cycle is
      State : Junction_State :=
        (Main_Road  => Red,
         Side_Road  => Red,
         Pedestrian => Red);

      Buf : String (1 .. 10);
      Len : Natural;
   begin
      -- MAIN AMBER (preparing)
      State.Main_Road := Amber;
      Show_State (State);
      AS_Put_Line ("Main road AMBER (prepare). Press ENTER...");
      AS_Get_Line (Buf, Len);

      -- MAIN GREEN
      State.Main_Road := Green;
      Show_State (State);
      AS_Put_Line ("Main road GREEN. Press ENTER...");
      AS_Get_Line (Buf, Len);

      -- MAIN AMBER (leaving)
      State.Main_Road := Amber;
      Show_State (State);
      AS_Put_Line ("Main road AMBER (leaving). Press ENTER...");
      AS_Get_Line (Buf, Len);

      -- MAIN RED
      State.Main_Road := Red;
      Show_State (State);
      AS_Put_Line ("Main road now RED. Press ENTER...");
      AS_Get_Line (Buf, Len);
   end Main_Cycle;


   ---------------------------------------------------------
   -- SIDE ROAD CYCLE: Amber → Green → Amber → Red
   ---------------------------------------------------------
   procedure Side_Cycle is
      State : Junction_State :=
        (Main_Road  => Red,
         Side_Road  => Red,
         Pedestrian => Red);

      Buf : String (1 .. 10);
      Len : Natural;
   begin
      -- SIDE AMBER (preparing)
      State.Side_Road := Amber;
      Show_State (State);
      AS_Put_Line ("Side road AMBER (prepare). Press ENTER...");
      AS_Get_Line (Buf, Len);

      -- SIDE GREEN
      State.Side_Road := Green;
      Show_State (State);
      AS_Put_Line ("Side road GREEN. Press ENTER...");
      AS_Get_Line (Buf, Len);

      -- SIDE AMBER (leaving)
      State.Side_Road := Amber;
      Show_State (State);
      AS_Put_Line ("Side road AMBER (leaving). Press ENTER...");
      AS_Get_Line (Buf, Len);

      -- SIDE RED
      State.Side_Road := Red;
      Show_State (State);
      AS_Put_Line ("Side road now RED. Press ENTER...");
      AS_Get_Line (Buf, Len);
   end Side_Cycle;

end Traffic_Control;