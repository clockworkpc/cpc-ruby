module Cpc
  module Codewars
    module MinecraftFurnaceFuel
      BURN_TIMES = {
        lava: 800,
        blaze_rod: 120,
        coal: 80,
        wood: 15,
        stick: 1
      }

      def calc_fuel(ingot_int)
        fuel_hsh = { lava: 0, blaze_rod: 0, coal: 0, wood: 0, stick: 0 }
        total_int = ingot_int * 11

        BURN_TIMES.each do |k, v|
          n = total_int / v
          unless n == 0
            fuel_hsh[k] += n
            total_int -= (v * n)
          end
        end
        fuel_hsh
      end
    end
  end
end
