pragma SPARK_Mode (On);

with AS_IO_Wrapper; use AS_IO_Wrapper;

package body Traffic_Control is

   ------------------------------------------------
   -- INITIAL STATE
   ------------------------------------------------
   procedure Init is
   begin
      Status := (Main_Road  => Red,
                 Side_Road  => Red,
                 Pedestrian => Red);
   end Init;

   ------------------------------------------------
   -- SHARED HELPER: PRINT + WAIT
   ------------------------------------------------
   procedure Show_And_Wait
     (M, S, P : Light_Color;
      Message : String)
   is
      Buf : String (1 .. 5);
      Len : Natural;
   begin
      Status := (M, S, P);

      AS_Put_Line("==== Traffic Controller ====");
      AS_Put_Line("Main: " & Light_Color'Image(M));
      AS_Put_Line("Side: " & Light_Color'Image(S));
      AS_Put_Line("Ped : " & Light_Color'Image(P));
      AS_Put_Line(Message);
      AS_Get_Line(Buf, Len);
   end Show_And_Wait;

   ------------------------------------------------
   -- SENSOR INPUT
   ------------------------------------------------
   procedure Read_Sensors
     (Car_Main : out Boolean;
      Car_Side : out Boolean;
      Ped      : out Boolean)
   is
      S   : String (1 .. 10);
      L   : Natural;
   begin
      -- MAIN
      loop
         AS_Put_Line("Car on MAIN road? (Y/N): ");
         AS_Get_Line(S, L);
         exit when S(1) in 'Y' | 'y' | 'N' | 'n';
      end loop;
      Car_Main := (S(1) in 'Y' | 'y');

      -- SIDE
      loop
         AS_Put_Line("Car on SIDE road? (Y/N): ");
         AS_Get_Line(S, L);
         exit when S(1) in 'Y' | 'y' | 'N' | 'n';
      end loop;
      Car_Side := (S(1) in 'Y' | 'y');

      -- PEDESTRIAN
      loop
         AS_Put_Line("Pedestrian pressed? (Y/N): ");
         AS_Get_Line(S, L);
         exit when S(1) in 'Y' | 'y' | 'N' | 'n';
      end loop;
      Ped := (S(1) in 'Y' | 'y');
   end Read_Sensors;

   ------------------------------------------------
   -- PEDESTRIAN CYCLE
   ------------------------------------------------
   procedure Pedestrian_Cycle is
   begin
      Show_And_Wait(Red, Red, Green,
         "Pedestrian crossing active. Press ENTER...");

      Show_And_Wait(Red, Red, Red,
         "Pedestrian phase complete. Press ENTER...");
   end Pedestrian_Cycle;

   ------------------------------------------------
   -- MAIN ROAD CYCLE
   ------------------------------------------------
   procedure Main_Cycle is
   begin
      Show_And_Wait(Amber, Red, Red,
         "Main preparing. Press ENTER...");

      Show_And_Wait(Green, Red, Red,
         "Main traffic flowing. Press ENTER...");

      Show_And_Wait(Amber, Red, Red,
         "Main changing. Press ENTER...");

      Show_And_Wait(Red, Red, Red,
         "Main stopped. Press ENTER...");
   end Main_Cycle;

   ------------------------------------------------
   -- SIDE ROAD CYCLE
   ------------------------------------------------
   procedure Side_Cycle is
   begin
      Show_And_Wait(Red, Amber, Red,
         "Side preparing. Press ENTER...");

      Show_And_Wait(Red, Green, Red,
         "Side traffic flowing. Press ENTER...");

      Show_And_Wait(Red, Amber, Red,
         "Side changing. Press ENTER...");

      Show_And_Wait(Red, Red, Red,
         "Side stopped. Press ENTER...");
   end Side_Cycle;

   ------------------------------------------------
   -- MASTER CYCLE
   ------------------------------------------------
   procedure Run_Traffic_Cycle
     (Ped      : in Boolean;
      Car_Main : in Boolean;
      Car_Side : in Boolean)
   is
   begin
      if Ped then
         Pedestrian_Cycle;
      end if;

      if Car_Main then
         Main_Cycle;
      end if;

      if Car_Side then
         Side_Cycle;
      end if;

      if (not Ped) and (not Car_Main) and (not Car_Side) then
         AS_Put_Line("No traffic detected. All lights remain RED.");
         AS_Put_Line("");
      end if;
   end Run_Traffic_Cycle;

end Traffic_Control;