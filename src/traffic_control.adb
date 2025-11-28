pragma SPARK_Mode (On);

package body Traffic_Control is

   function To_String (C : Light_Color) return String is
   begin
      case C is
         when Red   => return "Red";
         when Amber => return "Amber";
         when Green => return "Green";
      end case;
   end To_String;

   function Safe (S : Junction_State) return Boolean is
   begin
      if S.Main_Road = Green and S.Side_Road = Green then
         return False;
      end if;

      if S.Pedestrian = Green then
         if not (S.Main_Road = Red and S.Side_Road = Red) then
            return False;
         end if;
      end if;

      return True;
   end Safe;

   --
   -- DEFINE PHASES
   --
   function Main_G return Junction_State is
   begin
      return (Main_Road  => Green,
              Side_Road  => Red,
              Pedestrian => Red);
   end Main_G;

   function Side_G return Junction_State is
   begin
      return (Main_Road  => Red,
              Side_Road  => Green,
              Pedestrian => Red);
   end Side_G;

   function Ped_G return Junction_State is
   begin
      return (Main_Road  => Red,
              Side_Road  => Red,
              Pedestrian => Green);
   end Ped_G;

   procedure Next_State
     (Current       : in     Junction_State;
      Car_Main      : in     Boolean;
      Car_Side      : in     Boolean;
      Ped_Request   : in     Boolean;
      Ped_Locked    : in     Boolean;
      Next          :    out Junction_State;
      Next_Ped_Lock :    out Boolean)
   is
   begin
      -- RULE 1: PED INTERRUPTS IF NOT LOCKED
      if Ped_Request and not Ped_Locked then
         Next := Ped_G;
         Next_Ped_Lock := True;  -- lock pedestrians
         return;
      end if;

      -- RULE 2: AFTER PED, RETURN TO MAIN
      if Current = Ped_G then
         Next := Main_G;
         Next_Ped_Lock := True;
         return;
      end if;

      -- RULE 3: VEHICLE LOGIC
      if Current = Main_G then
         if Car_Side then
            Next := Side_G;
         else
            Next := Main_G;
         end if;

         -- unlock pedestrians ONLY if we just returned to Main
         Next_Ped_Lock := Ped_Locked;

         return;
      end if;

      if Current = Side_G then
         Next := Main_G;

         -- unlock pedestrians ONLY after full cycle:
         -- Side → Main
         Next_Ped_Lock := False;

         return;
      end if;

      -- fallback
      Next := Main_G;
      Next_Ped_Lock := Ped_Locked;

   end Next_State;

end Traffic_Control;